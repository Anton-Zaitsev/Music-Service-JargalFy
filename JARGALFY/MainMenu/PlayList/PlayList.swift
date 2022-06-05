//
//  PlayList.swift
//  JARGALFY
//
//  Created by Антон Зайцев on 10.11.2020.
//

import SwiftUI
import RemoteImage
import Firebase
struct PlayList: View {
    @ObservedObject  var DataBasePlayList = PlayListData()
    @EnvironmentObject  var DataBasePlayListClick : PlayListDataClick
    @State var searchPlaylist: String = ""
    @State var createshowPlayList: Bool = false
    @State var namecreatePlayList: String = "Введите название"
    @State var seePlayListTab : Bool = false
    @Binding var seeTabBar : Bool
    @State var iNamePlayList : String = ""
    
    @State var ImageTrack : Array<String> = Array<String>()
    @State var NameArtist : Array<String> = Array<String>()
    @State var NamePlayList : String = ""
    @State var NameTrack: Array<String> = Array<String>()
    @State var TextTrack: Array<String> = Array<String>()
    @State var ssilka: Array<String> = Array<String>()
    
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
    func OpenPlayList(index: Int ){
        if let user = user {
            let uid = user.uid
            db.collection("users").document(uid).collection("usersList").addSnapshotListener { (snap, err) in
                
                if err != nil{
                    
                    print((err?.localizedDescription)!)
                    print("Ошибка")
                    return
                }
                for i in snap!.documentChanges{
                    if i.type == .added{
                        let Playlist = i.document.get("MassPlayList") as! Array<String>
                        DataBasePlayListClick.NamePlayList = Playlist[index]
                        iNamePlayList = (Playlist[index] != "MyLoveTrack" ? Playlist[index] : "Любимые треки")
                        DataBasePlayListClick.UPDATE(NamePlayList: Playlist[index])
                    }
                }
            }
            let data = DataBasePlayListClick.NamePlayList
            db.collection("users").document(uid).collection("PlaylistUser").document(data).collection(data).addSnapshotListener { (snap, err) in
                
                if err != nil{
                    
                    print((err?.localizedDescription)!)
                    return
                }
                for i in snap!.documentChanges{
                    if i.type == .added{
                        let Image = i.document.get("Image") as! Array<String>
                        ImageTrack = Image
                        let NameArtistdata = i.document.get("NameArtist") as! Array<String>
                        NameArtist = NameArtistdata
                        let NamePlayListdata = i.document.get("NamePlayList") as! String
                        NamePlayList = NamePlayListdata
                        let NameTrackdata = i.document.get("NameTrack") as! Array<String>
                        NameTrack = NameTrackdata
                        let TextTrackdata = i.document.get("TextTrack") as! Array<String>
                        TextTrack = TextTrackdata
                        let ssilkadata = i.document.get("ssilka") as! Array<String>
                        ssilka = ssilkadata
                        
                    }
                }
            }
            seePlayListTab.toggle()
        }
    }
    var body: some View {
        ZStack{
            ZStack (alignment: . top){
                // Color(red: 18.0/255.0, green: 18.0/255.0, blue: 18.0/255.0).edgesIgnoringSafeArea(.all)
                VStack{
                    HStack{
                        Text("Музыка").fontWeight(.bold).font(.system(size:UIScreen.main.bounds.width/12)).foregroundColor(.white).padding(.leading).padding(.top,10)
                        Spacer()
                    }
                    HStack{
                        Text("Плейлисты").fontWeight(.bold).font(.system(size:UIScreen.main.bounds.width/20)).foregroundColor(.white).padding(.leading).padding(.top,10)
                        Spacer()
                    }
                    HStack{
                        HStack{
                            HStack {
                                Image(systemName: "magnifyingglass").font(.system(size: UIScreen.main.bounds.width/14, weight: .regular)).foregroundColor(Color(red: 179.0/255.0, green: 179.0/255.0, blue: 179.0/255.0))
                                Button(action: {seeTabBar.toggle()}){
                                    ZStack(alignment: .leading) {
                                        
                                        if searchPlaylist.isEmpty {
                                            Text("Поиск по плейлистам")
                                                .foregroundColor(.white).multilineTextAlignment(.leading).foregroundColor(.black).font(.system(size: UIScreen.main.bounds.width/23, weight: .regular))
                                        }
                                        TextField("", text: $searchPlaylist).multilineTextAlignment(.leading).foregroundColor(.white).font(.system(size: UIScreen.main.bounds.width/23, weight: .regular))
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
                        Button(action: {createshowPlayList.toggle()
                            seeTabBar.toggle()
                        })
                        {
                            HStack{
                                HStack{
                                    Text("+").fontWeight(.ultraLight).padding(.init(top: 20, leading: 30, bottom: 20, trailing: 30)).font(.system(size:UIScreen.main.bounds.width/10)).foregroundColor(.white).background(Rectangle().fill(Color(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0)).frame(width: 70, height: 70))
                                }.padding(.leading).padding(.top,10)
                                Text("Создать плейлист").fontWeight(.bold).font(.system(size:UIScreen.main.bounds.width/23)).foregroundColor(.white)
                                Spacer()
                            }
                        }
                        if searchPlaylist.isEmpty {
                            if self.DataBasePlayList.DataPlayList.count != 0{
                                ForEach(self.DataBasePlayList.DataPlayList){ i in
                                    ForEach(0..<i.MassPlayList.count, id: \.self) { index in
                                        Button(action: {
                                            OpenPlayList(index: index)
                                        }) {
                                            HStack{
                                                HStack{
                                                    Image(systemName: index == 0 ? "heart.fill" : "iphone.badge.play" ).padding(.init(top: 20, leading: 28, bottom: 20, trailing: 28)).font(.system(size:UIScreen.main.bounds.width/15)).foregroundColor(index == 0 ? .white : .purple).background(Rectangle().fill(RadialGradient(gradient: Gradient(colors: [index == 0 ? .green : .black, index == 0 ? .black : .gray]), center: .center, startRadius: 0, endRadius: 85)).frame(width: 70, height: 70))
                                                }.padding(.leading, index == 0 ? 15 : 19).padding(.top,10)
                                                VStack (alignment: .leading){
                                                    Text(i.MassPlayList[index] != "MyLoveTrack" ? i.MassPlayList[index] : "Мои любимые треки").fontWeight(.bold).font(.system(size:UIScreen.main.bounds.width/23)).foregroundColor(.white)
                                                    Text("\(i.countTrack[index]) треков").font(.system(size:UIScreen.main.bounds.width/28)).foregroundColor(Color(red: 150.0/255.0, green: 150.0/255.0, blue: 150.0/255.0))
                                                }
                                                Spacer()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else {
                            ForEach(self.DataBasePlayList.DataPlayList){ i in
                                ForEach(i.MassPlayList.filter{$0.hasPrefix(searchPlaylist) || searchPlaylist == ""} , id: \.self) { resultpoisk in
                                    ForEach(i.MassPlayList.indices,id: \.self){
                                        index in
                                        if (i.MassPlayList[index] != "MyLoveTrack" ? i.MassPlayList[index] : "Мои любимые треки").uppercased() == resultpoisk.uppercased() {
                                            Button(action: {
                                                OpenPlayList(index: index)
                                            }) {
                                                HStack{
                                                    HStack{
                                                        Image(systemName: index == 0 ? "heart.fill" : "person" ).padding(.init(top: 20, leading: 28, bottom: 20, trailing: 28)).font(.system(size:UIScreen.main.bounds.width/15)).foregroundColor(.white).background(Rectangle().fill(RadialGradient(gradient: Gradient(colors: [.green, .black]), center: .center, startRadius: 0, endRadius: 85)).frame(width: 70, height: 70))
                                                    }.padding(.leading).padding(.bottom,10)
                                                    VStack (alignment: .leading){
                                                        Text(i.MassPlayList[index] != "MyLoveTrack" ? i.MassPlayList[index] : "Мои любимые треки").fontWeight(.bold).font(.system(size:UIScreen.main.bounds.width/23)).foregroundColor(.white)
                                                        Text("\(i.countTrack[index]) треков").font(.system(size:UIScreen.main.bounds.width/28)).foregroundColor(Color(red: 150.0/255.0, green: 150.0/255.0, blue: 150.0/255.0))
                                                    }
                                                    Spacer()
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                }
                
                Spacer()
            }
            
            ZStack{
                PlayListNew(createshowPlayList: $createshowPlayList, namecreatePlayList: $namecreatePlayList, seeTabBar: $seeTabBar)
            }
            ZStack{
                if seePlayListTab == true{
                    PlayListTab(seePlayListTab: $seePlayListTab, seeTabBar: $seeTabBar, iNamePlayList: $iNamePlayList, ImageTrack: $ImageTrack, NameArtist: $NameArtist, NamePlayList: $NamePlayList, NameTrack: $NameTrack, TextTrack: $TextTrack, ssilka: $ssilka, loveTrack: $loveTrack, audioPlay: $audioPlay, progress: $progress, boolNextAuido: $boolNextAuido, countMusik: $countMusik, seeAudioplay: $seeAudioplay, isDownloading: $isDownloading, safeURL: $safeURL, playAndpausetogle: $playAndpausetogle, indexAlbom: $indexAlbom, IndexMusik: $IndexMusik, opacity: $opacity, indexPlayer: $indexPlayer).environmentObject(DataBasePlayListClick)
                }
            }
        }
        
    }
    
}
struct PlayListNew: View {
    @Binding var createshowPlayList: Bool
    @Binding var namecreatePlayList: String
    @Binding var seeTabBar : Bool
    @State var offset: CGFloat = 0
    @State var index : Int = 0
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    func CreateNewPlayList(namecreatePlay: String ){
        if let user = user {
            let uid = user.uid
            let ratingDictionary = [
                "NamePlayList": namecreatePlay,
                "Image" : Array<String>(),
                "NameArtist" : Array<String>(),
                "NameTrack" : Array<String>(),
                "TextTrack" : Array<String>(),
                "ssilka" : Array<String>()
            ] as [String : Any]
            let docRef = Firestore.firestore().document("users/\(uid)/PlaylistUser/\(namecreatePlay)/\(namecreatePlay)/\(namecreatePlay)")
            
            docRef.setData(ratingDictionary){ (error) in
                if let error = error {
                    print("error = \(error)")
                } else {
                    print("data uploaded successfully")
                    
                }
            }
            let docList = Firestore.firestore().document("users/\(uid)/usersList/PlayListUserArray")
            db.collection("users").document(uid).collection("usersList").addSnapshotListener { (snap, err) in
                
                if err != nil{
                    
                    print((err?.localizedDescription)!)
                    print("Ошибка")
                    return
                }
                for i in snap!.documentChanges{
                    if i.type == .added{
                        var Playlist = i.document.get("MassPlayList") as! Array<String>
                        var CountTrack = i.document.get("CountTrack") as! Array<Int>
                        Playlist.append(namecreatePlay)
                        CountTrack.append(0)
                        let NewData = [
                            "MassPlayList": Playlist,
                            "CountTrack" : CountTrack
                        ] as [String : Any]
                        docList.setData(NewData){ (error) in
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
        createshowPlayList.toggle()
        seeTabBar.toggle()
        namecreatePlayList = "Введите название"
    }
    let spacing: CGFloat = 10
    let withScreen  = UIScreen.main.bounds.width-30
    var body: some View {
        if createshowPlayList == true {
            ZStack{
                VStack{
                    HStack{
                        Spacer()
                        Button(action: {withAnimation(Animation.default){
                            createshowPlayList.toggle()
                            seeTabBar.toggle()
                        }
                            
                        }) {
                            Image(systemName: "xmark").font(.system(size: 18, weight: .regular)).foregroundColor(.gray)
                        }.padding()
                    }
                    Spacer()
                }
                HStack{
                    VStack{
                        Text("Придумай название плейлиста").foregroundColor(.white).font(.system(size: UIScreen.main.bounds.width/20, weight: .bold)).padding().padding(.bottom,60)
                        ZStack(alignment: .center) {
                            Button(action: {namecreatePlayList = ""
                            }) {
                                TextField("", text: $namecreatePlayList).multilineTextAlignment(.center).foregroundColor(.white).font(.system(size: UIScreen.main.bounds.width/12, weight: .bold)).padding(.bottom,5)
                            }.border(width: 1.5, edges: [.bottom], color: .gray).padding(.horizontal,30)
                        }
                        Button(action: {CreateNewPlayList(namecreatePlay: namecreatePlayList)}) {
                            Text("СОЗДАТЬ").foregroundColor(.black).font(.system(size: UIScreen.main.bounds.width/23, weight: .bold)).padding(.horizontal,40).padding(.vertical,15)
                        }.background( RoundedRectangle( cornerRadius: 35).fill(Color.white)).padding(.top,35)
                    }
                }
            }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 65, alignment: .center).background( RoundedRectangle( cornerRadius: 20).fill(LinearGradient(gradient: Gradient(colors: [Color.init(red: 35.0/255.0, green: 37.0/255.0, blue: 38.0/255.0),Color.init(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0)]), startPoint: .center, endPoint:.bottomTrailing)))
                .gesture(
                    DragGesture()
                        .onEnded({ value in
                            if value.translation.height > 0 && value.translation.width < 150 && value.translation.width > -150 {
                                withAnimation {
                                    self.offset = -(UIScreen.main.bounds.height * self.spacing) * CGFloat(self.index)
                                    createshowPlayList.toggle()
                                    seeTabBar.toggle()
                                }
                            }
                            
                        })
                )
        }
    }
}

extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}
struct EdgeBorder: Shape {
    
    var width: CGFloat
    var edges: [Edge]
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }
            
            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }
            
            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return self.width
                }
            }
            
            var h: CGFloat {
                switch edge {
                case .top, .bottom: return self.width
                case .leading, .trailing: return rect.height
                }
            }
            path.addPath(Path(CGRect(x: x, y: y, width: w, height: h)))
        }
        return path
    }
}
