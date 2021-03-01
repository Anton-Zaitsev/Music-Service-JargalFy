//
//  SoloTrack.swift
//  JARGALFY
//
//  Created by Антон Зайцев on 28.12.2020.
//

import SwiftUI
import RemoteImage
import Firebase

struct SoloTrack: View {
    @EnvironmentObject var lolsongs : NewSong
    @Binding var addAlbom : Bool
    @Binding var track : Bool
    @Binding var NickName: String
    @State var NameArtist: Array<String> = Array<String>(repeating: "", count: 1)
    @State var NameTrack: Array<String> = Array<String>(repeating: "", count: 1)
    @State var TextTrack : Array<String> = Array<String>(repeating: "Введите текст песни, нажав на этот текст:", count: 1)
    @State var songsURL: Array<String> = Array<String>(repeating: "", count: 1)
    @State var showImagePicker: Bool = false
    @State var imageURL: Array<String> = Array<String>(repeating: "", count: 1)
    @State var show: Bool = false
    @State var checkNameAlbom: Bool = false
    @State var checkImage : Bool = false
    @State var info : Bool = false
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
                    
                        if NameTrack[0].isEmpty {
                            Text("Название вашей песни")
                                .foregroundColor(.white).multilineTextAlignment(.leading).foregroundColor(.black).font(.system(size: UIScreen.main.bounds.width/25, weight: .bold)).textCase(.uppercase)
                        }
                    
                    TextField("", text: $NameTrack[0]).multilineTextAlignment(.leading).foregroundColor(.white).font(.system(size: UIScreen.main.bounds.width/25, weight: .bold))
                    
                }
                
            }.padding(.horizontal).padding(.vertical,4)
            }.background( RoundedRectangle( cornerRadius: 10).fill(Color(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0))).padding(.trailing).padding(.bottom,10)
            }
                Button(action: {
                    withAnimation(.easeIn){
                        if NameTrack[0].trimmingCharacters(in: NSCharacterSet.whitespaces) != ""{
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
                    Text(NameTrack[0])
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
                    imagePickerSongs(showImagePicker: self.$showImagePicker,imageURL: self.$imageURL, NickName: self.$NickName,nameAlbom: self.$NameTrack[0],checkImage: self.$checkImage)
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

                            VStack{
                                VStack (alignment: .leading) {
                                    Text("Название песни:").foregroundColor(.white).font(.system(size: UIScreen.main.bounds.width/25, weight: .bold)).textCase(.uppercase)
                                TextField("Вы можете редактировать название", text: $NameTrack[0]).multilineTextAlignment(.leading).foregroundColor(.green).font(.system(size: UIScreen.main.bounds.width/25, weight: .bold))
                                    Text("FEAT Артист, если нет, то пропустите:").foregroundColor(.white).font(.system(size: UIScreen.main.bounds.width/25, weight: .bold)).textCase(.uppercase)
                                TextField("FEAT Артист:", text: $NameArtist[0]).multilineTextAlignment(.leading).foregroundColor(.green).font(.system(size: UIScreen.main.bounds.width/25, weight: .bold))
                                    Text("Текст песни:").foregroundColor(.white).font(.system(size: UIScreen.main.bounds.width/25, weight: .bold)).textCase(.uppercase)
                                    TextEditor(text: $TextTrack[0]).multilineTextAlignment(.leading).foregroundColor((tabTextEditor == false && TextTrack[0] == "Введите текст песни, нажав на этот текст:") ? Color(red: 60.0/255.0, green: 60.0/255.0, blue: 60.0/255.0) : .green).font(.system(size: UIScreen.main.bounds.width/25, weight: .bold)).frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 150).disableAutocorrection(true).onTapGesture{
                                        tabTextEditor = true
                                        TextTrack[0] = ""
                                        }
                                    if (songsURL[0] == "") {
                                    Button(action: {
                                        withAnimation(.easeIn){
                                            show.toggle()
                                        }
                                }) {
                                        Text("Загрузить песню").foregroundColor(.white).font(.system(size: UIScreen.main.bounds.width/25, weight: .bold)).textCase(.uppercase).padding(.horizontal).padding(.vertical,3)
                                    }.sheet(isPresented: $show){
                                        DocumentPicker(songsURL: $songsURL, NickName: $NickName, nameAlbom: $NameTrack[0],downloadTrack: $downloadTrack)
                                        
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
                            
                        
                        if boolError == true {
                            HStack{
                                Image(systemName: "exclamationmark.triangle.fill").font(.system(size: UIScreen.main.bounds.width/23, weight: .regular)).foregroundColor(.yellow)
                                
                            Text("Заполните пожалуйста данные и загрузите песню").foregroundColor(.red).foregroundColor(.black).font(.system(size: UIScreen.main.bounds.width/23, weight: .bold)).multilineTextAlignment(.center).padding(.trailing,3)
                            }.padding(.horizontal,7).padding(.vertical,2).background(Color(red: 56.0/255.0, green: 56.0/255.0, blue: 56.0/255.0)).font(.system(size: UIScreen.main.bounds.width/20)).cornerRadius(20)
                        }
                        if (NameTrack[0] != "" && TextTrack[0] != "" && songsURL[0] != "") {
                        HStack{
                            Spacer()
                        Button(action: {
                            withAnimation(.easeIn){
                                uploadData()
                            }
                    }) {
                            Text("Загрузить трек на площадку").fontWeight(.bold).foregroundColor(.green).padding(.vertical,6).font(.system(size: UIScreen.main.bounds.width/25)).textCase(.uppercase)
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

        let  storage  = Storage.storage().reference().child("Musik").child(self.NickName).child(self.NameTrack[0]).child("Image")
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
        let  storage  = Storage.storage().reference().child("Musik").child(self.NickName).child(self.NameTrack[0]).child("Image")
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
        if (NameTrack[0] != "" && TextTrack[0] != "" && songsURL[0] != "") {
            if let index = TextTrack.firstIndex(of: "Введите текст песни, нажав на этот текст:") {
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
        let docRef = Firestore.firestore().document("Music/MusikIDpCdpftx2bNjgq0eQOzJY/\(NickName)/\(NickName)/\(NameTrack[0])/\(NameTrack[0])")
                let ratingDictionary = [
                    "Image": imageURL,
                    "NameAlbom": NameTrack[0],
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
                        lolsongs.collection3 = NameTrack[0]
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
                var Albums = i.document.get("Albums") as! Array<String>
                Albums.append(NameTrack[0])
                let docRef = Firestore.firestore().document("users/\(uid)/ArtistMode/\(uid)")
                let ratingDictionary = [
                  "NickName": NickName,
                    "RealName": RealName,
                   "Sity": Sity,
                    "Artist": Artist,
                    "ssilkaUrl" : ssilkaUrl,
                    "AboutArtist" : AboutArtist,
                    "Instagram" : Instagram,
                    "Albums" : Albums
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
