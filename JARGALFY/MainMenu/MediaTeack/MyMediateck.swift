//
//  MyMediateck.swift
//  JARGALFY
//
//  Created by Антон Зайцев on 28.11.2020.
//

import SwiftUI
import RemoteImage
import Firebase
struct MyMediateck: View {
    @Binding var seeTabBar : Bool
    @State var searchPlaylist = ""
    @ObservedObject  var DataMedia = MyLoveMedia()
    @Binding var loveTrack: Array<Int>
    @Binding var audioPlay : Bool
    @Binding var progress : Float
    @Binding var boolNextAuido : Bool
    @Binding var countMusik : Int
    @Binding var seeAudioplay : Bool
    @Binding var isDownloading : Bool
    @Binding var safeURL : Array<String>
    @Binding var playAndpausetogle : Bool
    @Binding var indexAlbom: Int
    @Binding var IndexMusik : Int
    @Binding var opacity : Double
    @Binding var indexPlayer : Int
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    func DeledeAndAddMusik(ImageDrop: String, NameArtistDrop: String, NameTrackDrop: String, TextTrackDrop: String, ssilkaDrop: String,countMusik: Int ){
        if let user = user {
            let uid = user.uid
            if loveTrack[countMusik] == 0 {
                let docRef = Firestore.firestore().document("users/\(uid)/MyMusik/MyMusik")
                db.collection("users").document(uid).collection("MyMusik").addSnapshotListener { (snap, err) in
                
                if err != nil{
                    
                    print((err?.localizedDescription)!)
                    print("Ошибка")
                    return
                }
                for i in snap!.documentChanges{
                    if i.type == .added{
                        var Image = i.document.get("Image") as! Array<String>
                        var NameArtist = i.document.get("NameArtist") as! Array<String>
                        var NameTrack = i.document.get("NameTrack") as! Array<String>
                        var TextTrack = i.document.get("TextTrack") as! Array<String>
                        var ssilka = i.document.get("ssilka") as! Array<String>
                        var check = 0
                        for index in NameTrack.indices{
                            if NameTrack[index] == NameTrackDrop && NameArtist[index] == NameArtistDrop{
                                check += 1
                            }
                        }
                        if check == 0{
                        Image.append(ImageDrop)
                        NameArtist.append(NameArtistDrop)
                        NameTrack.append(NameTrackDrop)
                        TextTrack.append(TextTrackDrop)
                        ssilka.append(ssilkaDrop)
                        let ratingDictionary = [
                            "Image" : Image,
                            "NameArtist" : NameArtist,
                            "NameTrack" : NameTrack,
                            "TextTrack" : TextTrack,
                            "ssilka" : ssilka
                        ] as [String : Any]
                        docRef.setData(ratingDictionary){ (error) in
                            if let error = error {
                                print("error = \(error)")
                            } else {
                                print("data uploaded successfully")

                            }
                        }
                        }
                    }
                }
            }
                loveTrack[countMusik] = 1
        }
           else {
                let docRef = Firestore.firestore().document("users/\(uid)/MyMusik/MyMusik")
                db.collection("users").document(uid).collection("MyMusik").addSnapshotListener { (snap, err) in
                    
                    if err != nil{
                        
                        print((err?.localizedDescription)!)
                        print("Ошибка")
                        return
                    }
                    for i in snap!.documentChanges{
                        if i.type == .added{
                            var Image = i.document.get("Image") as! Array<String>
                            var NameArtist = i.document.get("NameArtist") as! Array<String>
                            var NameTrack = i.document.get("NameTrack") as! Array<String>
                            var TextTrack = i.document.get("TextTrack") as! Array<String>
                            var ssilka = i.document.get("ssilka") as! Array<String>
                            print(NameArtist[countMusik])
                            print(TextTrack[countMusik])
                                
                                        Image.remove(at: countMusik)
                                        NameArtist.remove(at: countMusik)
                                        NameTrack.remove(at: countMusik)
                                        TextTrack.remove(at: countMusik)
                                        ssilka.remove(at: countMusik)
                                        let ratingDictionary = [
                                            "Image" : Image,
                                            "NameArtist" : NameArtist,
                                            "NameTrack" : NameTrack,
                                            "TextTrack" : TextTrack,
                                            "ssilka" : ssilka
                                        ] as [String : Any]
                                        docRef.setData(ratingDictionary){ (error) in
                                            if let error = error {
                                                print("error = \(error)")
                                            } else {
                                                print("data uploaded successfully")

                                            }
                                   
                                }
                            
                        }
                    }
                        }
                loveTrack[countMusik] = 0
            }
            
        }
    }
    var body: some View {
        ZStack{
        ZStack (alignment: . top){
        VStack{
            HStack{
                Text("Моя музыка").fontWeight(.bold).font(.system(size:UIScreen.main.bounds.width/12)).foregroundColor(.white).padding(.leading).padding(.top,10)
                Spacer()
            }
            HStack{
                Text("Моя любимая музыка").fontWeight(.bold).font(.system(size:UIScreen.main.bounds.width/20)).foregroundColor(.white).padding(.leading).padding(.top,10)
                Spacer()
            }
            HStack{
            HStack{
                HStack {
                    Image(systemName: "magnifyingglass").font(.system(size: UIScreen.main.bounds.width/14, weight: .regular)).foregroundColor(Color(red: 179.0/255.0, green: 179.0/255.0, blue: 179.0/255.0))
                    Button(action: {seeTabBar.toggle()}){
                    ZStack(alignment: .leading) {
                        
                            if searchPlaylist.isEmpty {
                                Text("Поиск по трекам")
                                    .foregroundColor(.white).multilineTextAlignment(.leading).foregroundColor(.black).font(.system(size: UIScreen.main.bounds.width/25, weight: .regular))
                            }
                        TextField("", text: $searchPlaylist).multilineTextAlignment(.leading).foregroundColor(.white).font(.system(size: UIScreen.main.bounds.width/25, weight: .regular))
                    }
                    }
                }.padding(.horizontal).padding(.vertical,6)
            }.background( RoundedRectangle( cornerRadius: 10).fill(Color(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0))).padding(.leading)
            .padding(.vertical,10)
                Button(action: {
                    if searchPlaylist != "" {
                        searchPlaylist = ""
                        seeTabBar.toggle()
                    }
                    else{
                        searchPlaylist = ""
                    }
                    if seeTabBar == false {
                        seeTabBar = true
                    }
                }) {
                    HStack{
                        Text("Отмена").foregroundColor(.white).font(.system(size: UIScreen.main.bounds.width/23, weight: .regular)).padding(.horizontal).padding(.vertical,9)
                    }.background( RoundedRectangle( cornerRadius: 10).fill(Color(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0))).padding(.trailing)
                    .padding(.vertical,10)
                }
            }
            ScrollView(.vertical, showsIndicators: true) {
            VStack{
                ForEach(self.DataMedia.MediaData){ i in
                ForEach(i.NameTrack.filter{$0.hasPrefix(searchPlaylist) || searchPlaylist == ""} , id: \.self) { resultpoisk in
                    ForEach(i.NameTrack.indices,id: \.self){
                        index in
                        if (i.NameTrack[index].uppercased() == resultpoisk.uppercased()) {
                            HStack{
                                RemoteImage(type: .url(URL(string: i.Image.count == 1 ? i.Image [0] : i.Image [index])!), errorView: { error in
                                    Text(error.localizedDescription)
                                }, imageView: { image in
                                    image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                }, loadingView: {
                                    ProgressView()
                                }).frame(width: 60, height: 60)
                                VStack (alignment: .leading){
                                    Text(i.NameTrack[index]).fontWeight(.bold).foregroundColor(.white).padding(.leading,10).font(.system(size: UIScreen.main.bounds.width/23))
                                    Text(i.NameArtist[index]).foregroundColor(.gray).padding(.leading,10)
                                }
                                Spacer()
                                Button(action: {DeledeAndAddMusik(ImageDrop: i.Image[index], NameArtistDrop: i.NameArtist[index], NameTrackDrop: i.NameTrack[index], TextTrackDrop: i.TextTrack[index], ssilkaDrop: i.ssilka[index],countMusik: index)}) {
                                    Image(systemName: loveTrack [index] == 1 ? "suit.heart.fill" : "suit.heart").font(.system(size: 20, weight: .regular)).foregroundColor(loveTrack [index] == 1 ? .green : .gray).padding()
                                    
                                }
                            }.padding(.leading,20).padding(.bottom,5)
                            .onTapGesture{
                            self.seeAudioplay = false
                            self.countMusik = index
                                boolNextAuido = true
                                playAndpausetogle = true
                            self.seeAudioplay = true
                                indexPlayer = 4
                            }
                            .onChange(of: index, perform: { value in
                                self.countMusik = index
                                
                            })
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

//struct MyMediateck_Previews: PreviewProvider {
//    static var previews: some View {
//        MyMediateck()
//    }
//}
