//
//  AddMusikPlayList.swift
//  JARGALFY
//
//  Created by Антон Зайцев on 25.11.2020.
//

import SwiftUI
import Firebase
import RemoteImage
struct AddMusikPlayList: View {
    @EnvironmentObject  var DataBasePlayListClick : PlayListDataClick
    @ObservedObject var SearchDataList = SearchMusikJargalFy()
    @State var poisk : String = ""
    @State var offset: CGFloat = 0
    @State var Index : Int = 0
    @Binding var seeTabBar : Bool
    @Binding var addMusik : Bool
    @Binding var addMusikLike : Array<Int>
    @Binding var iNamePlayList : String
    let spacing: CGFloat = 10
    let withScreen  = UIScreen.main.bounds.width-30
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    func AddSongsinPlayList(ImageDrop: String, NameArtistDrop: String, NameTrackDrop: String, TextTrackDrop: String, ssilkaDrop: String,countMusik: Int ){
        if let user = user {
            //let dataPath = DataBasePlayListClick.NamePlayList
            let dataPath = (iNamePlayList != "Любимые треки" ? iNamePlayList : "MyLoveTrack")
            print(dataPath)
            let uid = user.uid
            if addMusikLike[countMusik] == 0 {
            addMusikLike[countMusik] = 1
            let docRef = Firestore.firestore().document("users/\(uid)/PlaylistUser/\(dataPath)/\(dataPath)/\(dataPath)")
            db.collection("users").document(uid).collection("PlaylistUser").document(dataPath).collection(dataPath).addSnapshotListener { (snap, err) in
                
                if err != nil{
                    
                    print((err?.localizedDescription)!)
                    print("Ошибка")
                    return
                }
                for i in snap!.documentChanges{
                    if i.type == .added{
                        var Image = i.document.get("Image") as! Array<String>
                        var NameArtist = i.document.get("NameArtist") as! Array<String>
                        let NamePlayList = i.document.get("NamePlayList") as! String
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
                            "NamePlayList": NamePlayList,
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
        }
            else{
                addMusikLike[countMusik] = 0
                let docRef = Firestore.firestore().document("users/\(uid)/PlaylistUser/\(dataPath)/\(dataPath)/\(dataPath)")
                db.collection("users").document(uid).collection("PlaylistUser").document(dataPath).collection(dataPath).addSnapshotListener { (snap, err) in
                    
                    if err != nil{
                        
                        print((err?.localizedDescription)!)
                        print("Ошибка")
                        return
                    }
                    for i in snap!.documentChanges{
                        if i.type == .added{
                            var Image = i.document.get("Image") as! Array<String>
                            var NameArtist = i.document.get("NameArtist") as! Array<String>
                            let NamePlayList = i.document.get("NamePlayList") as! String
                            var NameTrack = i.document.get("NameTrack") as! Array<String>
                            var TextTrack = i.document.get("TextTrack") as! Array<String>
                            var ssilka = i.document.get("ssilka") as! Array<String>
                                for index in 0..<NameArtist.count {
                                    if NameArtist[index] == NameArtistDrop && NameTrack[index] == NameTrackDrop{
                                        Image.remove(at: index)
                                        NameArtist.remove(at: index)
                                        NameTrack.remove(at: index)
                                        TextTrack.remove(at: index)
                                        ssilka.remove(at: index)
                                        let ratingDictionary = [
                                            "NamePlayList": NamePlayList,
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
                        }
            }
        }
    }
    
    var body: some View {
        ZStack (alignment: . top){
            Color(red: 18.0/255.0, green: 18.0/255.0, blue: 18.0/255.0).edgesIgnoringSafeArea(.all)
            VStack{
                ZStack{
                HStack{
                    Button(action: {
                        seeTabBar.toggle()
                        addMusik.toggle()
                        let dataPath = DataBasePlayListClick.NamePlayList
                        print(dataPath)
                    }) {
                    Image(systemName: "xmark").font(.system(size: 18, weight: .regular)).foregroundColor(.gray).padding()
                    }
                  Spacer()
                }
                    ZStack (alignment: .center){
                        Text("Добавить треки").foregroundColor(.white).font(.title3).fontWeight(.bold)
                    }
                }
                HStack{
                    HStack {
                        Image(systemName: "magnifyingglass").font(.system(size: UIScreen.main.bounds.width/16, weight: .regular)).foregroundColor(Color(red: 179.0/255.0, green: 179.0/255.0, blue: 179.0/255.0))
                        ZStack(alignment: .leading) {
                                if poisk.isEmpty {
                                    Text("Поиск")
                                        .foregroundColor(.white).multilineTextAlignment(.leading).foregroundColor(.black).font(.system(size: UIScreen.main.bounds.width/25, weight: .regular))
                                }
                            TextField("", text: $poisk).multilineTextAlignment(.leading).foregroundColor(.white).font(.system(size: UIScreen.main.bounds.width/25, weight: .regular))
                            }
                    }.padding(.horizontal).padding(.vertical,5)
                }.background( RoundedRectangle( cornerRadius: 10).fill(Color(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0))).padding(.horizontal)
                ZStack{
                VStack{
                    HStack{
                        Text("Рекомендации").foregroundColor(.white).fontWeight(.bold).font(.system(size: UIScreen.main.bounds.width/25)).padding(.horizontal).padding(.top,8)
                        Spacer()
                    }.padding(.bottom,10)
                        if poisk.isEmpty{
                    MusikNoAlbom()
                        }
                        else{
                            SearchMusikforPlayList()
                        }
                        
                }
                }.background( RoundedRectangle( cornerRadius: 10).fill(Color(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0))).padding(.horizontal).padding(.bottom, -50)
            }
        }.gesture(
            DragGesture()
            .onEnded({ value in
            if value.translation.height > 0 && value.translation.width < 150 && value.translation.width > -150 {
            withAnimation {
            self.offset = -(UIScreen.main.bounds.height * self.spacing) * CGFloat(self.Index)
                seeTabBar.toggle()
                addMusik.toggle()
                        }
                }
                
                    })
           )
    }
    private func SearchMusikforPlayList() -> some View {
        return VStack{
            if self.SearchDataList.Search.count != 0{
                ForEach(self.SearchDataList.Search){i in
                    ScrollView(.vertical, showsIndicators: true) {
                    VStack{
                        ForEach(i.NameTrack.filter{$0.hasPrefix(poisk) || poisk == ""} , id: \.self) { resultpoisk in
                            ForEach(i.NameTrack.indices,id: \.self){
                                index in
                                if (i.NameTrack[index]).uppercased() == resultpoisk.uppercased() {
                                    VStack{
                                        HStack{
                                            RemoteImage(type: .url(URL(string: i.Image.count == 1 ? i.Image [0] : i.Image [index])!), errorView: { error in
                                                Text(error.localizedDescription)
                                            }, imageView: { image in
                                                image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                            }, loadingView: {
                                                ProgressView()
                                            }).frame(width: 55, height: 55)
                                            VStack (alignment: .leading){
                                                Text(i.NameTrack[index]).fontWeight(.bold).tag(index).foregroundColor(.white).padding(.leading,10).font(.system(size: UIScreen.main.bounds.width/25))
                                                Text(i.NameArtist[index]).foregroundColor(.gray).padding(.leading,10).font(.system(size: UIScreen.main.bounds.width/28))
                                            }
                                            Spacer()
                                            Button(action: {AddSongsinPlayList(ImageDrop: i.Image[index], NameArtistDrop: i.NameArtist[index], NameTrackDrop: i.NameTrack[index], TextTrackDrop: i.TextTrack[index], ssilkaDrop: i.ssilka[index],countMusik: index)
                                            }) {
                                                Image(systemName: addMusikLike [index] == 1 ? "suit.heart.fill" : "suit.heart").font(.system(size: 20, weight: .regular)).foregroundColor(addMusikLike [index] == 1 ? .green : .gray).padding()
                                                
                                            
                                            }
                                        }
                                    }
//                                    .onTapGesture{
//                                    self.seeAudioplay = false
//                                    self.countMusik = index
//                                        boolNextAuido = true
//                                        playAndpausetogle = true
//                                    self.seeAudioplay = true
//                                        indexPlayer = 2
//                                        for i in search.Search {
//                                            RecordHistorySearch( nameArtist: i.NameArtist[index], NameTrack: i.NameTrack[index])
//                                        }
//                                    }
//                                    .onChange(of: index, perform: { value in
//                                        self.countMusik = index
//                                    })
                                    
                                }
                            
                            }
                           
                    
                }
                    }
                    }.padding(.horizontal).padding(.bottom, 30)
                }
            }
        }
    }
    private func MusikNoAlbom() -> some View {
        return
            VStack{
                if self.SearchDataList.Search.count != 0{
                    ForEach(self.SearchDataList.Search){i in
                        ScrollView(.vertical, showsIndicators: true) {
                            ForEach(i.NameTrack.indices,id: \.self){
                                index in
                            VStack{
                                HStack{
                                    RemoteImage(type: .url(URL(string: i.Image.count == 1 ? i.Image [0] : i.Image [index])!), errorView: { error in
                                        Text(error.localizedDescription)
                                    }, imageView: { image in
                                        image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                    }, loadingView: {
                                        ProgressView()
                                    }).frame(width: 55, height: 55)
                                    VStack (alignment: .leading){
                                        Text(i.NameTrack[index]).fontWeight(.bold).tag(index).foregroundColor(.white).padding(.leading,10).font(.system(size: UIScreen.main.bounds.width/25))
                                        Text(i.NameArtist[index]).foregroundColor(.gray).padding(.leading,10).font(.system(size: UIScreen.main.bounds.width/28))
                                    }
                                    Spacer()
                                    Button(action: {AddSongsinPlayList(ImageDrop: i.Image[index], NameArtistDrop: i.NameArtist[index], NameTrackDrop: i.NameTrack[index], TextTrackDrop: i.TextTrack[index], ssilkaDrop: i.ssilka[index],countMusik: index)
                                    }) {
                                        Image(systemName: addMusikLike [index] == 1 ? "suit.heart.fill" : "suit.heart").font(.system(size: 20, weight: .regular)).foregroundColor(addMusikLike [index] == 1 ? .green : .gray).padding()
                                    
                                    }
                                
                            }
                            }
                            }
                        }.padding(.horizontal).padding(.bottom, 30)
                
                }
                }
            }
    }
}
