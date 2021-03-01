import SwiftUI
import FirebaseStorage
import Combine

struct imagePickerSongs: UIViewControllerRepresentable {
    
    @Binding var showImagePicker: Bool
    @Binding var imageURL: Array<String>
    @Binding var NickName: String
    @Binding var nameAlbom: String
    @Binding var checkImage : Bool
    func makeCoordinator() -> imagePickerSongs.Coordinator {
        return imagePickerSongs.Coordinator(parent: self)
    }
    
    class Coordinator: NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
        var parent: imagePickerSongs
        init(parent: imagePickerSongs) {
            self.parent = parent
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.showImagePicker.toggle()
            parent.checkImage = false
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = info[.originalImage] as! UIImage
            uploadImageToFireBase(image: image)
        }
        
        func uploadImageToFireBase(image: UIImage) {
            // Create the file metadata
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            let  storage  = Storage.storage().reference().child("Musik").child(self.parent.NickName).child(self.parent.nameAlbom).child("Image")
            // Upload the file to the path FILE_NAME
            storage.putData(image.jpegData(compressionQuality: 0.42)!, metadata: metadata) { (metadata, error) in
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
            let  storage  = Storage.storage().reference().child("Musik").child(self.parent.NickName).child(self.parent.nameAlbom).child("Image")
            storage.downloadURL { (url, error) in
                if error != nil {
                    // Handle any errors
                    print((error?.localizedDescription)!)
                    return
                }
                print("Download success")
                self.parent.imageURL[0] = "\(url!)"
                self.parent.showImagePicker.toggle()
                self.parent.checkImage = true
                self.listOfImageFile()
            }
        }
        
        func listOfImageFile() {
            let  storageReference  = Storage.storage().reference().child("Musik").child(self.parent.NickName).child(self.parent.nameAlbom).child("Image")
            storageReference.listAll { (result, error) in
              if error != nil {
                  // Handle any errors
                  print((error?.localizedDescription)!)
                  return
              }
              for prefix in result.prefixes {
                // The prefixes under storageReference.
                // You may call listAll(completion:) recursively on them.
                print("prefix is \(prefix)")
              }
              for item in result.items {
                // The items under storageReference.
                print("items is \(item)")
              }
            }
        }
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<imagePickerSongs>) -> UIImagePickerController {
        let imagepic = UIImagePickerController()
        imagepic.sourceType = .photoLibrary
        imagepic.delegate = context.coordinator
        return imagepic
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<imagePickerSongs>) {
    }
}
