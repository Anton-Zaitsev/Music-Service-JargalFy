//
//  ImagePicker.swift
//  JARGALFY
//
//  Created by Антон Зайцев on 17.12.2020.
//
import SwiftUI
import FirebaseStorage
import Combine

struct imagePicker: UIViewControllerRepresentable {
    @Binding var shown: Bool
    @Binding var imageURL:String
    @Binding var psevdomin : String
    func makeCoordinator() -> imagePicker.Coordinator {
        return imagePicker.Coordinator(parent: self)
    }
    
    class Coordinator: NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
        var parent: imagePicker
        let storage = Storage.storage().reference()
        init(parent: imagePicker) {
            self.parent = parent
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.shown.toggle()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = info[.originalImage] as! UIImage
            uploadImageToFireBase(image: image)
        }
        
        func uploadImageToFireBase(image: UIImage) {
            // Create the file metadata
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            // Upload the file to the path FILE_NAME
            storage.child("Image").child("AvatarsArtist").child("\(parent.psevdomin)_avatar").putData(image.jpegData(compressionQuality: 0.42)!, metadata: metadata) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    print((error?.localizedDescription)!)
                    return
                }
                // Metadata contains file metadata such as size, content-type.
                let size = metadata.size
                
                print("Upload size is \(size)")
                print("Upload success")
                self.downloadImageFromFirebase()
            }
        }
        
        func downloadImageFromFirebase() {
            // Create a reference to the file you want to download
            storage.child("Image").child("AvatarsArtist").child("\(parent.psevdomin)_avatar").downloadURL { (url, error) in
                if error != nil {
                    // Handle any errors
                    print((error?.localizedDescription)!)
                    return
                }
                print("Download success")
                self.parent.imageURL = "\(url!)"
                self.parent.shown.toggle()
                
                self.listOfImageFile()
            }
        }
        
        func listOfImageFile() {
            let storageReference = Storage.storage().reference().child("Image").child("AvatarsArtist").child("\(parent.psevdomin)_avatar")
            storageReference.listAll { (result, error) in
                if error != nil {
                    // Handle any errors
                    print((error?.localizedDescription)!)
                    return
                }
            }
        }
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<imagePicker>) -> UIImagePickerController {
        let imagepic = UIImagePickerController()
        imagepic.sourceType = .photoLibrary
        imagepic.delegate = context.coordinator
        return imagepic
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<imagePicker>) {
    }
}
