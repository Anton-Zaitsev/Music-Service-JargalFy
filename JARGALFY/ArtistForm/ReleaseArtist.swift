//
//  ReleaseArtist.swift
//  JARGALFY
//
//  Created by Антон Зайцев on 24.12.2020.
//
//NameArtist.removeAll()
//NameTrack.removeAll()
//TextTrack.removeAll()
//songsURL.removeAll()
//imageURL.removeAll()
//NameArtist = Array<String>(repeating: "", count: 1)
//NameTrack  = Array<String>(repeating: "", count: 1)
//TextTrack = Array<String>(repeating: "Введите текст песни, нажав на этот текст:", count: 1)
//nameAlbom = ""
//songsURL = Array<String>(repeating: "", count: 1)
//imageURL = Array<String>(repeating: "", count: 1)
import SwiftUI
import RemoteImage
import Firebase
import Combine
import MobileCoreServices
import UniformTypeIdentifiers
struct ReleaseArtist: View {
    @EnvironmentObject var lolsongs : NewSong
    @Binding var NickName: String
    @Binding var audioPlay : Bool
    @Binding var progress : Float
    @Binding var boolNextAuido : Bool
    @Binding var countMusik : Int
    @Binding var playAndpausetogle : Bool
    @Binding var opacity : Double
    @State var addAlbom : Bool = false
    @State var track : Bool = false
    @State var show: Bool = false
    var body: some View {
        VStack{
        HStack{
            if addAlbom == false && track == false {
                VStack{
                    HStack{
            Button(action: {
                withAnimation(.easeIn){
                addAlbom = true
                track = false
                }
        }) {
                Text("Добавить Альбом").fontWeight(.bold).foregroundColor(.white).padding(.vertical,6).font(.system(size: UIScreen.main.bounds.width/30)).textCase(.uppercase)
        }.padding(.horizontal).overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray, lineWidth: 1)
        ).padding(.horizontal,5)
                Button(action: {
                    withAnimation(.easeIn){
                    addAlbom = false
                    track = true
                    }
            }) {
                    Text("Добавить трек").fontWeight(.bold).foregroundColor(.white).padding(.vertical,6).font(.system(size: UIScreen.main.bounds.width/30)).textCase(.uppercase)
            }.padding(.horizontal).overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray, lineWidth: 1)
            )
                }
                    HStack{
                        Text("Последний релиз: ").fontWeight(.bold).foregroundColor(.white).padding(.vertical,3).font(.system(size: UIScreen.main.bounds.width/25)).textCase(.uppercase).padding(.horizontal)
                        Spacer()
                    }
                    if lolsongs.collection2 != "LSP" && lolsongs.collection3 != "One more City" {
                    VStack{
                        ForEach(self.lolsongs.datas){ i in
                        VStack{
                            HStack{
                                VStack (alignment: .leading){
                                    Text(i.NameAlbom).fontWeight(.bold).padding(.leading,20).foregroundColor(.white).font(.title)
                                    Text(i.NameTrack.count == 1 ? "2020, \(i.NameTrack.count) трек." :"2020, \(i.NameTrack.count) треков.").padding(.leading,20).foregroundColor(.gray)
                                }
                                Spacer()
                            }
                            VStack{
                            ForEach(0..<i.NameTrack.count, id: \.self) { index in
                            HStack{
                                RemoteImage(type: .url(URL(string: i.Image.count == 1 ? i.Image[0] : i.Image[index])!), errorView: { error in
                                    Text(error.localizedDescription)
                                }, imageView: { image in
                                    image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                }, loadingView: {
                                    ProgressView()
                                }).frame(width: 60, height: 60)
                                VStack (alignment: .leading){
                                    Text(i.NameTrack[index]).fontWeight(.bold).tag(index).foregroundColor( .white).padding(.leading,10).font(.system(size: UIScreen.main.bounds.width/23))
                                    Text(i.NameArtist[index]).foregroundColor(.gray).padding(.leading,10)
                                }
                                Spacer()
                                
                            }.padding(.leading,20).padding(.bottom,5).onTapGesture{
                                audioPlay = false
                                audioPlay = true
                                self.countMusik = index
                                    boolNextAuido = true
                                    playAndpausetogle = true
                                }
                                .onChange(of: index, perform: { value in
                                    self.countMusik = index
                                    
                                })


                            }
                            }
                        }
                        .padding(.top,5).padding(.bottom,10)
                    }
                    }
                    }else {
                        HStack{
                            Text("У вас не было релизов, но вы можете их добавить ").fontWeight(.bold).foregroundColor(.white).font(.system(size: UIScreen.main.bounds.width/30)).textCase(.uppercase).padding(.horizontal)
                            Spacer()
                        }
                    }
                }
            }
            else if addAlbom == true && track == false {
                VStack{
                    HStack{
                Button(action: {
                    withAnimation(.easeIn){
                    addAlbom = true
                    track = false
                    }
            }) {
                    Text("Добавить Альбом").fontWeight(.bold).foregroundColor(.white).padding(.vertical,6).font(.system(size: UIScreen.main.bounds.width/30)).textCase(.uppercase)
            }.padding(.horizontal).overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray, lineWidth: 1)
            ).padding(.horizontal,5)
                Button(action: {
                    withAnimation{
                    addAlbom = false
                    track = false
                    }
            }) {
                    Text("Назад").fontWeight(.bold).foregroundColor(.white).padding(.vertical,6).font(.system(size: UIScreen.main.bounds.width/30)).textCase(.uppercase)
            }.padding(.horizontal).overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray, lineWidth: 1)
            )
                        
            }
                AddAlbomView(addAlbom: $addAlbom,track: $track,NickName: $NickName).environmentObject(lolsongs)
                }
            }
            else if addAlbom == false && track == true {
                VStack{
                    HStack{
                Button(action: {
                    withAnimation(.easeIn){
                    addAlbom = false
                    track = true
                    }
            }) {
                    Text("Добавить трек").fontWeight(.bold).foregroundColor(.white).padding(.vertical,6).font(.system(size: UIScreen.main.bounds.width/30)).textCase(.uppercase)
            }.padding(.horizontal).overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray, lineWidth: 1)
            ).padding(.horizontal,5)
                Button(action: {
                    withAnimation{
                    addAlbom = false
                    track = false
                    }
            }) {
                    Text("Назад").fontWeight(.bold).foregroundColor(.white).padding(.vertical,6).font(.system(size: UIScreen.main.bounds.width/30)).textCase(.uppercase)
            }.padding(.horizontal).overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray, lineWidth: 1)
            )
                    }
                    SoloTrack(addAlbom: $addAlbom,track: $track,NickName: $NickName ).environmentObject(lolsongs)
            }
            }
        }.padding(.vertical,5)

        }
    }
}

struct AddAlbomView: View {
    @EnvironmentObject var lolsongs : NewSong
    @Binding var addAlbom : Bool
    @Binding var track : Bool
    @Binding var NickName: String
    @State var NameArtist: Array<String> = Array<String>(repeating: "", count: 1)
    @State var NameTrack: Array<String> = Array<String>(repeating: "", count: 1)
    @State var TextTrack : Array<String> = Array<String>(repeating: "Введите текст песни, нажав на этот текст:", count: 1)
    @State var nameAlbom : String = ""
    @State var songsURL: Array<String> = Array<String>(repeating: "", count: 1)
    @State var showImagePicker: Bool = false
    @State var imageURL: Array<String> = Array<String>(repeating: "", count: 1)
    @State var show: Bool = false
    @State var checkNameAlbom: Bool = false
    @State var checkImage : Bool = false
    @State var info : Bool = false
    @State var count: Int = 0
    @State var boolError : Bool = false
    @State var tabTextEditor = false
    @State var downloadTrack: Bool = false
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    var body: some View {
        VStack{
            if checkNameAlbom == false {
            HStack{
                Text("Шаг 1:").foregroundColor(.white).fontWeight(.bold).padding(.leading)
            HStack{
            HStack {
                ZStack(alignment: .leading) {
                    
                        if nameAlbom.isEmpty {
                            Text("Название вашего альбома")
                                .foregroundColor(.white).multilineTextAlignment(.leading).foregroundColor(.black).font(.system(size: UIScreen.main.bounds.width/25, weight: .bold)).textCase(.uppercase)
                        }
                    
                    TextField("", text: $nameAlbom).multilineTextAlignment(.leading).foregroundColor(.white).font(.system(size: UIScreen.main.bounds.width/25, weight: .bold))
                    
                }
                
            }.padding(.horizontal).padding(.vertical,4)
            }.background( RoundedRectangle( cornerRadius: 10).fill(Color(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0))).padding(.trailing).padding(.bottom,10)
            }
                Button(action: {
                    withAnimation(.easeIn){
                        if nameAlbom.trimmingCharacters(in: NSCharacterSet.whitespaces) != ""{
                        checkNameAlbom.toggle()
                        }
                    }
            }) {
                    Text("Подтвердить название").fontWeight(.bold).foregroundColor(.white).padding(.vertical,6).font(.system(size: UIScreen.main.bounds.width/30)).textCase(.uppercase)
            }.padding(.horizontal).overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray, lineWidth: 1)
            ).padding(.horizontal,5)
            }
            else {
                HStack{
                    Image(systemName: "checkmark.circle.fill").foregroundColor(.green).font(.system(size: UIScreen.main.bounds.width/23, weight: .regular)).padding(.leading)
                    Text("Название вашего альбома: ").foregroundColor(.white).font(.system(size: UIScreen.main.bounds.width/25, weight: .bold)).padding(.trailing,1)
                    Text(nameAlbom)
                        .foregroundColor(.white).multilineTextAlignment(.leading).foregroundColor(.black).font(.system(size: UIScreen.main.bounds.width/25, weight: .bold))
                    Spacer()
                }
            }
            if checkImage == false && checkNameAlbom == true{
                HStack{
                HStack{
                    Text("Шаг 2:").foregroundColor(.white).fontWeight(.bold).padding(.leading)
                    Button(action: {
                        withAnimation(.easeIn){
                            self.showImagePicker.toggle()
                        }
                }) {
                        Text("Загрузить обложку альбома").fontWeight(.bold).foregroundColor(.white).padding(.vertical,6).font(.system(size: UIScreen.main.bounds.width/25)).textCase(.uppercase).padding(.horizontal)
                }.sheet(isPresented: $showImagePicker) {
                    imagePickerSongs(showImagePicker: self.$showImagePicker,imageURL: self.$imageURL, NickName: self.$NickName,nameAlbom: self.$nameAlbom,checkImage: self.$checkImage)
                }.overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray, lineWidth: 1))
                    }.onAppear(perform: loadImageFromFirebase).animation(.spring()).padding(.vertical,6)
                Spacer()
                }
            }
            if checkImage == true && checkNameAlbom == true {
               
                HStack{
                    Image(systemName: "checkmark.circle.fill").foregroundColor(.green).font(.system(size: UIScreen.main.bounds.width/23, weight: .regular)).padding(.leading)
                    HStack{
                        Button(action: {
                            withAnimation(.easeIn){
                                deleteImageAlbom()
                            }
                    }) {
                            Text("Удалить обложку альбома").fontWeight(.bold).foregroundColor(.red).padding(.vertical,6).font(.system(size: UIScreen.main.bounds.width/25)).textCase(.uppercase)
                    }.padding(.horizontal).overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray, lineWidth: 1))
                    }.padding(.vertical,6)
                    Spacer()
                }
            }
            if info == false && checkImage == true {
                HStack{
                    VStack{
                HStack{
                    Text("Шаг 3:").foregroundColor(.white).fontWeight(.bold).padding(.leading)
                Text("Треки и их содержание ").fontWeight(.bold).foregroundColor(.white).padding(.vertical,6).font(.system(size: UIScreen.main.bounds.width/25)).textCase(.uppercase).padding(.horizontal)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray, lineWidth: 1))
                    Spacer()
                    }.padding(.vertical,6)
                        ForEach(0..<NameTrack.count, id: \ .self) { index in
                            HStack{
                                Spacer()
                        Text("\(index + 1) Песня").foregroundColor(.white).multilineTextAlignment(.leading).foregroundColor(.black).font(.system(size: UIScreen.main.bounds.width/25, weight: .bold)).textCase(.uppercase)
                                Spacer()
                            }
                            VStack{
                             
                                VStack (alignment: .leading) {
                                    Text("Название песни:").foregroundColor(.white).font(.system(size: UIScreen.main.bounds.width/25, weight: .bold)).textCase(.uppercase)
                                TextField("Название песни:", text: $NameTrack[index]).multilineTextAlignment(.leading).foregroundColor(.green).font(.system(size: UIScreen.main.bounds.width/25, weight: .bold))
                                    Text("FEAT Артист, если нет, то пропустите:").foregroundColor(.white).font(.system(size: UIScreen.main.bounds.width/25, weight: .bold)).textCase(.uppercase)
                                TextField("FEAT Артист:", text: $NameArtist[index]).multilineTextAlignment(.leading).foregroundColor(.green).font(.system(size: UIScreen.main.bounds.width/25, weight: .bold))
                                    Text("Текст песни:").foregroundColor(.white).font(.system(size: UIScreen.main.bounds.width/25, weight: .bold)).textCase(.uppercase)
                                    TextEditor(text: $TextTrack[index]).multilineTextAlignment(.leading).foregroundColor((tabTextEditor == false && TextTrack[index] == "Введите текст песни, нажав на этот текст:") ? Color(red: 60.0/255.0, green: 60.0/255.0, blue: 60.0/255.0) : .green).font(.system(size: UIScreen.main.bounds.width/25, weight: .bold)).frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 150).disableAutocorrection(true).onTapGesture{
                                        tabTextEditor = true
                                        TextTrack[index] = ""
                                        }
                                    if (songsURL[index] == "") {
                                    Button(action: {
                                        withAnimation(.easeIn){
                                            show.toggle()
                                        }
                                }) {
                                        Text("Загрузить песню").foregroundColor(.white).font(.system(size: UIScreen.main.bounds.width/25, weight: .bold)).textCase(.uppercase).padding(.horizontal).padding(.vertical,3)
                                    }.sheet(isPresented: $show){
                                        DocumentPicker(songsURL: $songsURL, NickName: $NickName, nameAlbom: $nameAlbom,downloadTrack: $downloadTrack)
                                        
                                    }.overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.gray, lineWidth: 1))
                                    }
                                    else {
                                        HStack{
                                            Image(systemName: "checkmark.circle.fill").foregroundColor(.green).font(.system(size: UIScreen.main.bounds.width/23, weight: .regular))
                                            HStack{
                                                Text("Трек загружен").foregroundColor(.green).font(.system(size: UIScreen.main.bounds.width/25, weight: .bold)).textCase(.uppercase).padding(.horizontal).padding(.vertical,3)
                                            }.overlay(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(Color.gray, lineWidth: 1))
                                            Spacer()
                                        }
                                       
                                    }
                                }.padding(.horizontal).padding(.vertical,3)
                            }
                            
                        }
                        if boolError == true {
                            HStack{
                                Image(systemName: "exclamationmark.triangle.fill").font(.system(size: UIScreen.main.bounds.width/23, weight: .regular)).foregroundColor(.yellow)
                                
                            Text("Заполните пожалуйста данные и загрузите песню").foregroundColor(.red).foregroundColor(.black).font(.system(size: UIScreen.main.bounds.width/23, weight: .bold)).multilineTextAlignment(.center).padding(.trailing,3)
                            }.padding(.horizontal,7).padding(.vertical,2).background(Color(red: 56.0/255.0, green: 56.0/255.0, blue: 56.0/255.0)).font(.system(size: UIScreen.main.bounds.width/20)).cornerRadius(20)
                        }
                        HStack{
                            Spacer()
                        Button(action: {
                            withAnimation(.easeIn){
                                if (NameTrack[count] != "" && TextTrack[count] != "" && songsURL[count] != "") {
                                NameTrack.append("")
                                NameArtist.append("")
                                TextTrack.append("Введите текст песни, нажав на этот текст:")
                                songsURL.append("")
                                count += 1
                                boolError = false
                                tabTextEditor.toggle()
                                }
                                else {
                                    boolError = true
                                }
                            }
                    }) {
                            Text("Добавить трек").fontWeight(.bold).foregroundColor(.green).padding(.vertical,6).font(.system(size: UIScreen.main.bounds.width/25)).textCase(.uppercase)
                    }.padding(.horizontal).overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray, lineWidth: 1))
                            Spacer()
                    }
                        if NameTrack.count >= 3 {
                        HStack{
                            Spacer()
                        Button(action: {
                            withAnimation(.easeIn){
                                uploadData()
                            }
                    }) {
                            Text("Загрузить альбом на площадку").fontWeight(.bold).foregroundColor(.green).padding(.vertical,6).font(.system(size: UIScreen.main.bounds.width/25)).textCase(.uppercase)
                    }.padding(.horizontal).overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray, lineWidth: 1))
                            Spacer()
                        }.padding(.vertical,5)
                        }
                        
                    }
                Spacer()
                }
            }
            

        }
    }
    func deleteImageAlbom()  {

        let  storage  = Storage.storage().reference().child("Musik").child(self.NickName).child(self.nameAlbom).child("Image")
        //Removes image from storage
        storage.delete { error in
            if let error = error {
                print(error)
            } else {
                print("Файл удален")
                imageURL[0] = ""
                checkImage = false
                // File deleted successfully
            }
        }
    }
    func loadImageFromFirebase() {
        let  storage  = Storage.storage().reference().child("Musik").child(self.NickName).child(self.nameAlbom).child("Image")
        storage.downloadURL { (url, error) in
            if error != nil {
                print((error?.localizedDescription)!)
                return
            }
            print("Загрузка завершена")
            self.imageURL[0] = "\(url!)"
            checkImage = true
        }
    }
    func uploadData()  {
        boolError = false
        if (NameTrack[count] != "" && TextTrack[count] != "" && songsURL[count] != "") {
            if let index = NameTrack.firstIndex(of: "") {
                NameTrack.remove(at: index)
            }
            if let index = TextTrack.firstIndex(of: "Введите текст песни, нажав на этот текст:") {
                TextTrack.remove(at: index)
            }
            if let index = TextTrack.firstIndex(of: "") {
                TextTrack.remove(at: index)
            }
            if let index = songsURL.firstIndex(of: "") {
                songsURL.remove(at: index)
            }
            for i in 0..<NameArtist.count {
                if NameArtist[i] != "" {
                NameArtist[i] = NickName + " feat. " + NameArtist[i]
                }
                else {
                    NameArtist[i] = NickName
                }
            }
            if ( NameTrack.count == TextTrack.count && NameTrack.count == songsURL.count && NameTrack.count == NameArtist.count ) {
                var NewColorList : Array<Int> = Array<Int>(repeating: 0, count: 6)
                NewColorList[0] = Int.random(in: 0...255)
                NewColorList[1] = Int.random(in: 0...255)
                NewColorList[2] = Int.random(in: 0...255)
        let docRef = Firestore.firestore().document("Music/MusikIDpCdpftx2bNjgq0eQOzJY/\(NickName)/\(NickName)/\(nameAlbom)/\(nameAlbom)")
                let ratingDictionary = [
                    "Image": imageURL,
                    "NameAlbom": nameAlbom,
                    "NameArtist": NameArtist,
                    "NameTrack": NameTrack,
                    "Ссылки" : songsURL,
                    "NewColorList" : NewColorList,
                    "TextTrack" : TextTrack
                ] as [String : Any]
                docRef.setData(ratingDictionary){ (error) in
                    if let error = error {
                        print("error = \(error)")
                        boolError = true
                    } else {
                        lolsongs.collection2 = NickName
                        lolsongs.documents2 = NickName
                        lolsongs.collection3 = nameAlbom
                        lolsongs.UPDATE(collection1: lolsongs.collection1!, documents1: lolsongs.documents1!,collection2: lolsongs.collection2!,documents2: lolsongs.documents2!, collection3: lolsongs.collection3!)
                        NewAlbom()
                        print("data uploaded successfully")
                        
                    }
                }
        }
        }
        else {
            boolError = true
        }
       
    }
    func NewAlbom()  {
        if let user = user {
            let uid = user.uid
            db.collection("users").document(uid).collection("ArtistMode").addSnapshotListener { (snap, err) in
        
        if err != nil{
            
            print((err?.localizedDescription)!)
            print("Ошибка")
            return
        }
        for i in snap!.documentChanges{
            if i.type == .added{
                let NickName = i.document.get("NickName") as! String
                let RealName = i.document.get("RealName") as! String
                let Sity = i.document.get("Sity") as! String
                let Artist = i.document.get("Artist") as! Bool
                let ssilkaUrl = i.document.get("ssilkaUrl") as! String
                let AboutArtist = i.document.get("AboutArtist") as! String
                let Instagram = i.document.get("Instagram") as! String
                var AlbumsName = i.document.get("Albums") as! Array<String>
                AlbumsName.append(nameAlbom)
                let docRef = Firestore.firestore().document("users/\(uid)/ArtistMode/\(uid)")
                let ratingDictionary = [
                  "NickName": NickName,
                    "RealName": RealName,
                   "Sity": Sity,
                    "Artist": Artist,
                    "ssilkaUrl" : ssilkaUrl,
                    "AboutArtist" : AboutArtist,
                    "Instagram" : Instagram,
                    "Albums" : AlbumsName
                    ] as [String : Any]
                    docRef.setData(ratingDictionary){ (error) in
                    if let error = error {
                    print("error = \(error)")
                    } else {
                    print("data uploaded successfully")
                        db.collection("Search").addSnapshotListener { (snap, err) in
                        if err != nil{
                            
                            print((err?.localizedDescription)!)
                            print("Ошибка")
                            return
                        }
                        for i in snap!.documentChanges{
                            if i.type == .added{
                                for i in snap!.documentChanges{
                                    if i.type == .added{
                                        var Image = i.document.get("Image") as! Array<String>
                                        var NameArtistData = i.document.get("NameArtist") as! Array<String>
                                        var NameTrackData = i.document.get("NameTrack") as! Array<String>
                                        var ssilka = i.document.get("ssilka") as! Array<String>
                                        var TextTrackData = i.document.get("TextTrack") as! Array<String>
                                        imageURL = Array<String>(repeating: imageURL[0], count: NameTrack.count )
                                        if (imageURL.count == NameArtist.count && imageURL.count == TextTrack.count && imageURL.count == songsURL.count && NameTrack.count == imageURL.count) {
                                        Image = Image + imageURL
                                        NameArtistData = NameArtistData + NameArtist
                                        NameTrackData = NameTrackData + NameTrack
                                        ssilka = ssilka + songsURL
                                        TextTrackData = TextTrackData + TextTrack
                                        let docRef = Firestore.firestore().document("Search/Search")
                                        let ratingDictionary = [
                                            "Image": Image,
                                            "NameArtist": NameArtistData,
                                            "NameTrack": NameTrackData,
                                            "ssilka": ssilka,
                                            "TextTrack" : TextTrackData
                                            ] as [String : Any]
                                            docRef.setData(ratingDictionary){ (error) in
                                            if let error = error {
                                            print("error = \(error)")
                                            } else {
                                            print("data uploaded successfully")
                                                info.toggle()
                                                checkNameAlbom = false
                                                checkImage = false
                                                count = 0
                                                boolError = false
                                                tabTextEditor = false
                                                downloadTrack = false
                                                addAlbom = false
                                                track = false
                                            }
                                            }
                                        }
                                    }
                                }
                        }
                        }
                    }
                        
                    }
            }
        }
        }
    }
    }
    }
}
struct DocumentPicker : UIViewControllerRepresentable {
    @Binding var songsURL : Array<String>
    @Binding var NickName: String
    @Binding var nameAlbom : String
    @Binding var downloadTrack: Bool
    func makeCoordinator() -> DocumentPicker.Coordinator {
        return DocumentPicker.Coordinator(parentCheck: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeMP3)], in: .import)
            picker.allowsMultipleSelection = false
            picker.delegate = context.coordinator
            return picker
    }
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext <DocumentPicker>  ) {
    }
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent : DocumentPicker
        init(parentCheck: DocumentPicker) {
            parent = parentCheck
        }
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls : [URL])  {
            //print(urls)
            let urlsPhone = (urls.first?.deletingPathExtension().lastPathComponent)!
            let  bucket  = Storage.storage().reference().child("Musik").child(self.parent.NickName).child(self.parent.nameAlbom).child("Tracks")
            bucket.child(urlsPhone).putFile(from: urls.first!, metadata: nil) {_,error in
                if error != nil {
                    print("Ошибка")
                    return
                }
                print("Загружено")
                bucket.child("\(urlsPhone)").downloadURL { (urlMusikFile, error) in
                    if error != nil {
                        // Handle any errors
                        self.parent.downloadTrack = false
                        print("Ошибка")
                        return
                    }
                    self.parent.songsURL.removeLast()
                    self.parent.songsURL.append("\(urlMusikFile!)")
                    self.parent.downloadTrack = true
                }
            }
            
            
        }
    }
}


