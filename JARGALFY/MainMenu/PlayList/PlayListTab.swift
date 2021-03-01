//
//  PlayListTab.swift
//  JARGALFY
//
//  Created by Антон Зайцев on 14.11.2020.
//

import SwiftUI
import RemoteImage
import Firebase
struct PlayListTab: View {
    @EnvironmentObject  var DataBasePlayListClick : PlayListDataClick
    @ObservedObject var SearchDataList = SearchMusikJargalFy()
    var iImage = "https://sun9-15.userapi.com/impg/aYH6Qq0HL995D-NrtOzbr_IRNaQf9l6YhSJLxA/W5c250O0l3g.jpg?size=1280x1280&quality=96&proxy=1&sign=6f94362311b4016ceb5448066892d09b"
    @Binding var seePlayListTab : Bool
    @Binding var seeTabBar : Bool
    @State var opacitys: Double = 0.0
    @State var addMusik: Bool = false
    @State var addMusikLike : Array<Int> = Array<Int>(repeating: 0, count: 150)
    @Binding var iNamePlayList : String
    
    @Binding var ImageTrack : Array<String>
    @Binding var NameArtist : Array<String> 
    @Binding var NamePlayList : String
    @Binding var NameTrack: Array<String>
    @Binding var TextTrack: Array<String>
    @Binding var ssilka: Array<String>
    
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
    var edges = UIApplication.shared.windows.first?.safeAreaInsets
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    func likeMusik(){
        let data = (NamePlayList != "Любимые треки" ? NamePlayList : "MyLoveTrack")
        if let user = user {
          let uid = user.uid
        db.collection("users").document(uid).collection("PlaylistUser").document(data).collection(data).addSnapshotListener { (snap, err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
            for i in snap!.documentChanges{
                if i.type == .added{
                    let NameArtist = i.document.get("NameArtist") as! Array<String>
                    let NameTrack = i.document.get("NameTrack") as! Array<String>
                    for g in SearchDataList.Search {
                    addMusikLike =  Array (repeating: 0, count: g.NameArtist.count)
                        if NameArtist.count != 0 {
                        for index in 0..<g.NameArtist.count {
                            for indexLike in 0..<NameTrack.count {
                            if NameArtist[indexLike] == g.NameArtist[index] && NameTrack[indexLike] == g.NameTrack[index]{
                                addMusikLike[index] = 1
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
    func updateBack(){

        if let user = user {
          let uid = user.uid
            let docList = Firestore.firestore().document("users/\(uid)/usersList/PlayListUserArray")
            db.collection("users").document(uid).collection("usersList").addSnapshotListener { (snap, err) in
            if err != nil{
                
                print((err?.localizedDescription)!)
                print("Ошибка")
                return
            }
            for i in snap!.documentChanges{
                if i.type == .added{
                    let Playlist = i.document.get("MassPlayList") as! Array<String>
                    var CountTrack = i.document.get("CountTrack") as! Array<Int>
                    for g in DataBasePlayListClick.DataPlayListClick {
                        for index in 0..<Playlist.count{
                            if Playlist[index] == (g.NamePlayList != "Любимые треки" ? g.NamePlayList : "MyLoveTrack"){
                                CountTrack[index] = g.NameTrack.count
                                print("Выполнено")
                            }
                            else{
                                print("Не найдено")
                            }
                        }
                        }
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
    }
    var body: some View {
        if addMusik == false {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
            RadialGradient(gradient: Gradient(colors: [Color(red: 74.0/255.0, green: 0.0/255.0, blue: 224.0/255.0), Color(red: 142.0/255.0, green: 45.0/255.0, blue: 226.0/255.0)]), center: .center, startRadius: 0, endRadius: UIScreen.main.bounds.height).edgesIgnoringSafeArea(.all)
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack{
                    GeometryReader{reader in
                        
                        VStack{
                            RemoteImage(type: .url(URL(string: iImage)!), errorView: { error in
                                Text(error.localizedDescription)
                            }, imageView: { image in
                                image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                            }, loadingView: {
                                ProgressView()
                            })
                                .frame(width: UIScreen.main.bounds.width, height: reader.frame(in: .global).minY > 0 ? reader.frame(in: .global).minY + (UIScreen.main.bounds.height / 2.2) : UIScreen.main.bounds.height / 2.2)
                                .offset(y: -reader.frame(in: .global).minY)

                                .onChange(of: reader.frame(in: .global).minY){value in
                         
                                    let offset = value + (UIScreen.main.bounds.height / 2.2)
                                    
                                    if offset < 80{
                                       
                                        if offset > 0{
                                            
                                            let opacity_value = (80 - offset) / 80
                                            
                                            self.opacitys = Double(opacity_value)
                                            
                                            return
                                        }
                                       
                                        self.opacitys = 1
                                    }
                                    else{
                                        
                                        self.opacitys = 0
                                    }
                                }
                        }
                        
                    }
                 
                    .frame(height: UIScreen.main.bounds.height / 2.3)
                    AlbomMusik()
                }
                
            }
            HStack{
                ZStack{
                    Button(action: {seePlayListTab.toggle()
                        updateBack()
                        print(DataBasePlayListClick.DataPlayListClick)
                    }) {
                    
                    HStack{
                        
                        Image(systemName: "chevron.left")
                            .font(.system(size: 22, weight: .bold))
                        
                        Text("Назад")
                            .fontWeight(.semibold)
                    }
                    Spacer()
                }
                HStack{
                    if opacitys > 0.6 {
                        if  iNamePlayList.count <= 12 {
                        Text(iNamePlayList).fontWeight(.bold).foregroundColor(.white).font(.title2)
                        }
                        else {
                            Text(iNamePlayList).fontWeight(.bold).foregroundColor(.white).font(.title2).padding(.leading,15)
                        }
                        }
                }
                }
                Spacer()
            }
            .padding()
            .foregroundColor(opacitys > 0.6 ? .white : .white)
            .padding(.top,edges!.top)
            .background(Color.black.opacity(opacitys))
            .shadow(color: Color.black.opacity(opacitys > 0.8 ? 0.1 : 0), radius: 5, x: 0, y: 5)
        
        }.ignoresSafeArea(.all, edges: .top)
        }
        else {
                //    Добавим searchbar
            AddMusikPlayList(seeTabBar: $seeTabBar, addMusik: $addMusik, addMusikLike: $addMusikLike,iNamePlayList: $iNamePlayList).environmentObject(DataBasePlayListClick)
        }
        }
    private func AlbomMusik() -> some View {
        return VStack{
            VStack{
                HStack{
                    VStack (alignment: .leading){
                        Text(NamePlayList).fontWeight(.bold).padding(.leading,20).foregroundColor(.white).font(.title)
                        Text(NameTrack.count == 1 ? "2020, \(NameTrack.count) трек." :"2020, \(NameTrack.count) треков.").padding(.leading,20).foregroundColor(.gray)
                    }
                    Spacer()
                   
                }
                HStack{
                    Spacer()
                    Button(action: {addMusik.toggle()
                        seeTabBar.toggle()
                        likeMusik()
                        print(DataBasePlayListClick.NamePlayList)
                    }) {
                        Text("ДОБАВИТЬ МУЗЫКУ").fontWeight(.bold).foregroundColor(.white).padding(.vertical,6).font(.system(size: UIScreen.main.bounds.width/30))
                    }.padding(.horizontal).overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    Spacer()
                }
                if NameTrack.count != 0 {
                ForEach((0..<NameTrack.count).reversed(), id: \.self) { index in
                HStack{
                    RemoteImage(type: .url(URL(string: ImageTrack.count == 1 ? ImageTrack[0] : ImageTrack[index])!), errorView: { error in
                        Text(error.localizedDescription)
                    }, imageView: { image in
                        image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    }, loadingView: {
                        ProgressView()
                    }).frame(width: 60, height: 60)
                    VStack (alignment: .leading){
                        Text(NameTrack[index]).fontWeight(.bold).foregroundColor(.white).padding(.leading,10).font(.system(size: UIScreen.main.bounds.width/23))
                        Text(NameArtist[index]).foregroundColor(.gray).padding(.leading,10)
                    }
                    Spacer()
                }.padding(.leading,20).padding(.bottom,5)
                
                .onTapGesture{
                    self.indexPlayer = 3
                self.seeAudioplay = false
                self.countMusik = index
                    boolNextAuido = true
                    playAndpausetogle = true
                self.seeAudioplay = true
                }
                .onChange(of: index, perform: { value in
                    self.countMusik = index

                })

                }
            }
                
            }
            .padding(.top,5).padding(.bottom,10)
            .background(RadialGradient(gradient: Gradient(colors: [Color(red: 74.0/255.0, green: 0.0/255.0, blue: 224.0/255.0), Color(red: 142.0/255.0, green: 45.0/255.0, blue: 226.0/255.0)]), center: .center, startRadius: 0, endRadius: UIScreen.main.bounds.height).edgesIgnoringSafeArea(.all))
    
            

        }

    }
}

