//
//  MainMenuSwiftUI.swift
//  JARGALFY
//
//  Created by Антон Зайцев on 25.09.2020.
//


import SwiftUI
import CoreData
import Firebase
import RemoteImage
struct MainMenuSwiftUI: View {
    @State var index = 0
    @State var indexAlbom = 0
    @ObservedObject  var database = DataMainMenu()
    @ObservedObject var lolsongs = NewSong(collection1: "Music", documents1: "MusikIDpCdpftx2bNjgq0eQOzJY", collection2: "LSP", documents2: "LSP", collection3: "One more City")
    @ObservedObject var search = SearchMusikJargalFy()
    @ObservedObject  var DataBasePlayListClick = PlayListDataClick()
    @State var audioPlay : Bool = true
    @State var progress : Float = 0.0
    @State var duration: Double = 0.0
    @State var position: CGFloat = 0.0
    @State var boolNextAuido : Bool = false
    @State var time : String = "0:00:00"
    @State var lastTime : String = "0:00:00"
    @State var with : Double = 0.0
    @State var countMusik : Int = 0
    @State var countMusik2 : Int = 0
    @State var countMusik3 : Int = 0
    @State var countMusik4 : Int = 0
    @State var Timer : Double = 0.0
    @State var seeAudioplay : Bool = false
    @State var TextTrack : String = ""
    @State var isDownloading : Bool = false
    @State var safeURL : Array<String> = Array<String>(repeating: "", count: 20)
    @State var playAndpausetogle : Bool = false
    @State var show : Bool = false
    @State var offset: CGFloat = 0
    @State var Index : Int = 0
    @State var stop :Bool = false
    @State var showTextTrack : Bool = false
    @State var togleBar: Bool = false
    @State var nameArtistSearch : Array<String> = Array<String>()
    @State var NameTrackSearch : Array<String> = Array<String>()
    @State var indexPlayer : Int = 0
    @State var opacity : Double = 0
    @State var seeTabBar: Bool = true
    @State var loveTrack: Array<Int> = Array<Int>()
    @State var loveTrackAudio: Array<Int> = Array<Int>()
    
    @State var seeRegistrArtist: Bool = false
    @State var ArtistMode: Bool = false
    @State var NameArtist: String = ""
    @State var NickName: String = ""
    @State var urlImageArtist: String = ""
    @State var Sity: String = ""
    var body: some View {
        if seeRegistrArtist == false {
        ZStack {
            if self.database.datas.count != 0{
            ForEach(self.database.datas){i in
            Color(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0).edgesIgnoringSafeArea(.all)
        VStack{
            ZStack (alignment: .top){
            if self.index == 0{
                
                LinearGradient(gradient: Gradient(colors: [Color.init(red: 0.0/255.0, green: 54.0/255.0, blue: 0.0/255.0),Color.init(red: 18.0/255.0, green: 18.0/255.0, blue: 18.0/255.0)]), startPoint: .top, endPoint:.center).edgesIgnoringSafeArea(.all)
                
                VStack{
                    MainMenu(index: $indexAlbom, Index: $Index,opacity: $opacity,loveTrackAudio: $loveTrackAudio,seeRegistrArtist: $seeRegistrArtist,ArtistMode: $ArtistMode,NameArtist: $NameArtist,NickName: $NickName,urlImageArtist: $urlImageArtist,Sity: $Sity).environmentObject(lolsongs)
                }
                if self.indexAlbom == 1 {
                    UpdateMusikRecomendMenu(audioPlay: $audioPlay, progress: $progress, boolNextAuido: $boolNextAuido, countMusik: $countMusik, seeAudioplay: $seeAudioplay, isDownloading: $isDownloading, safeURL: $safeURL, playAndpausetogle: $playAndpausetogle, indexAlbom: $indexAlbom, IndexMusik: $Index, opacity: $opacity, indexPlayer: $indexPlayer).environmentObject(lolsongs)
                }
                else if self.indexAlbom == 2{
                    UpdateMusikRecomendMenu(audioPlay: $audioPlay, progress: $progress, boolNextAuido: $boolNextAuido, countMusik: $countMusik, seeAudioplay: $seeAudioplay, isDownloading: $isDownloading, safeURL: $safeURL, playAndpausetogle: $playAndpausetogle, indexAlbom: $indexAlbom, IndexMusik: $Index, opacity: $opacity, indexPlayer: $indexPlayer).environmentObject(lolsongs)
                }
                else if self.indexAlbom == 3{
                    UpdateMusikRecomendMenu(audioPlay: $audioPlay, progress: $progress, boolNextAuido: $boolNextAuido, countMusik: $countMusik, seeAudioplay: $seeAudioplay, isDownloading: $isDownloading, safeURL: $safeURL, playAndpausetogle: $playAndpausetogle, indexAlbom: $indexAlbom, IndexMusik: $Index, opacity: $opacity, indexPlayer: $indexPlayer).environmentObject(lolsongs)
                }
                else if self.indexAlbom == 4{
                    UpdateMusikRecomendMenu(audioPlay: $audioPlay, progress: $progress, boolNextAuido: $boolNextAuido, countMusik: $countMusik, seeAudioplay: $seeAudioplay, isDownloading: $isDownloading, safeURL: $safeURL, playAndpausetogle: $playAndpausetogle, indexAlbom: $indexAlbom, IndexMusik: $Index, opacity: $opacity, indexPlayer: $indexPlayer).environmentObject(lolsongs)
                }
                else if self.indexAlbom == 5{
                    UpdateMusikRecomendMenu(audioPlay: $audioPlay, progress: $progress, boolNextAuido: $boolNextAuido, countMusik: $countMusik, seeAudioplay: $seeAudioplay, isDownloading: $isDownloading, safeURL: $safeURL, playAndpausetogle: $playAndpausetogle, indexAlbom: $indexAlbom, IndexMusik: $Index, opacity: $opacity, indexPlayer: $indexPlayer).environmentObject(lolsongs)
                }
                else if self.indexAlbom == 6{
                    UpdateMusikRecomendMenu(audioPlay: $audioPlay, progress: $progress, boolNextAuido: $boolNextAuido, countMusik: $countMusik, seeAudioplay: $seeAudioplay, isDownloading: $isDownloading, safeURL: $safeURL, playAndpausetogle: $playAndpausetogle, indexAlbom: $indexAlbom, IndexMusik: $Index, opacity: $opacity, indexPlayer: $indexPlayer).environmentObject(lolsongs)
                }
            }
            else if self.index == 1{
                LinearGradient(gradient: Gradient(colors: [Color.init(red: 34.0/255.0, green: 1.0/255.0, blue: 37.0/255.0),Color.init(red: 18.0/255.0, green: 18.0/255.0, blue: 18.0/255.0)]), startPoint: .top, endPoint:.bottom).edgesIgnoringSafeArea(.all)
                SearchMusik(togleBar: $togleBar,boolNextAuido: $boolNextAuido, countMusik: $countMusik2, seeAudioplay: $seeAudioplay, isDownloading: $isDownloading, safeURL: $safeURL, playAndpausetogle: $playAndpausetogle, nameArtistSearch:$nameArtistSearch,NameTrackSearch:$NameTrackSearch,seeTabBar: $seeTabBar, indexPlayer: $indexPlayer).environmentObject(search)
            }
            else if self.index == 2{
                LinearGradient(gradient: Gradient(colors: [Color.init(red: 2.0/255.0, green: 1.0/255.0, blue: 29.0/255.0),Color.init(red: 18.0/255.0, green: 18.0/255.0, blue: 18.0/255.0)]), startPoint: .top, endPoint:.bottom).edgesIgnoringSafeArea(.all)
                PlayList(seeTabBar: $seeTabBar,loveTrack: $loveTrack,audioPlay: $audioPlay, progress: $progress, boolNextAuido: $boolNextAuido, countMusik: $countMusik3, seeAudioplay: $seeAudioplay, isDownloading: $isDownloading, safeURL: $safeURL, playAndpausetogle: $playAndpausetogle, indexAlbom: $indexAlbom, IndexMusik: $Index, opacity: $opacity, indexPlayer: $indexPlayer).environmentObject(DataBasePlayListClick)
            }
            else {
                LinearGradient(gradient: Gradient(colors: [Color.init(red: 51.0/255.0, green: 0.0/255.0, blue: 1.0/255.0),Color.init(red: 18.0/255.0, green: 18.0/255.0, blue: 18.0/255.0)]), startPoint: .top, endPoint:.bottom).edgesIgnoringSafeArea(.all)
                MyMediateck(seeTabBar: $seeTabBar,loveTrack: $loveTrack,audioPlay: $audioPlay, progress: $progress, boolNextAuido: $boolNextAuido, countMusik: $countMusik4, seeAudioplay: $seeAudioplay, isDownloading: $isDownloading, safeURL: $safeURL, playAndpausetogle: $playAndpausetogle, indexAlbom: $indexAlbom, IndexMusik: $Index, opacity: $opacity, indexPlayer: $indexPlayer)
                
            }
            
            
        }.animation(.spring())
            if seeAudioplay {
                if self.indexPlayer == 1{
                StreamingPlayerAudio(audioPlay: $audioPlay,progress: $progress,duration: $duration,position: $position,time: $time,lastTime: $lastTime,with: $with,boolNextAuido: $boolNextAuido,countMusik: $countMusik,Timer: $Timer,isDownloading: $isDownloading,safeURL: $safeURL,playAndpausetogle: $playAndpausetogle,show: $show,offset: $offset,index: $index,stop: $stop,seeAudioplay: $seeAudioplay,TextTrack: $TextTrack,showTextTrack: $showTextTrack,loveTrack: $loveTrackAudio).environmentObject(lolsongs)
                }
                else if self.indexPlayer == 2{
                StreamingPlayerAudioSearch(audioPlay: $audioPlay,progress: $progress,duration: $duration,position: $position,time: $time,lastTime: $lastTime,with: $with,boolNextAuido: $boolNextAuido,countMusik: $countMusik2,Timer: $Timer,isDownloading: $isDownloading,safeURL: $safeURL,playAndpausetogle: $playAndpausetogle,show: $show,offset: $offset,index: $index,stop: $stop,seeAudioplay: $seeAudioplay,TextTrack: $TextTrack,showTextTrack: $showTextTrack).environmentObject(search)
                }
                else if self.indexPlayer == 3{
                    StreamingAudioforPlayList(audioPlay: $audioPlay, progress: $progress, duration: $duration, position: $position, time: $time, lastTime: $lastTime, with: $with, boolNextAuido: $boolNextAuido, countMusik: $countMusik3, Timer: $Timer, isDownloading: $isDownloading, safeURL: $safeURL, playAndpausetogle: $playAndpausetogle, show: $show, offset: $offset, index: $index, stop: $stop, seeAudioplay: $seeAudioplay, TextTrack: $TextTrack, showTextTrack: $showTextTrack).environmentObject(DataBasePlayListClick)
                }
                else if self.indexPlayer == 4 {
                    StreamingAudioforMedia(audioPlay: $audioPlay,progress: $progress,duration: $duration,position: $position,time: $time,lastTime: $lastTime,with: $with,boolNextAuido: $boolNextAuido,countMusik: $countMusik4,Timer: $Timer,isDownloading: $isDownloading,safeURL: $safeURL,playAndpausetogle: $playAndpausetogle,show: $show,offset: $offset,index: $index,stop: $stop,seeAudioplay: $seeAudioplay,TextTrack: $TextTrack,showTextTrack: $showTextTrack)
                }
                }
            if self.seeTabBar == true {
                TabBar(index: $index,nameArtistSearch: $nameArtistSearch,NameTrackSearch: $NameTrackSearch,loveTrack: $loveTrack,loveTrackAudio: $loveTrackAudio)
            }
            }
            
        }
            }
    }
        }
        else {
            RegistrationArtist(seeRegistrArtist: $seeRegistrArtist,ArtistMode: $ArtistMode,NameArtist: $NameArtist,NickName: $NickName,urlImageArtist: $urlImageArtist,Sity: $Sity).environmentObject(lolsongs)
        }
    }
    }


struct MainMenu: View {
    @ObservedObject var database = DataMainMenu()
    @EnvironmentObject var lolsongs : NewSong
    @Binding var index : Int
    @Binding var Index : Int
    @Binding var opacity : Double
    @Binding var loveTrackAudio : Array<Int>
    @ObservedObject  var DataMedia = MyLoveMedia()
    @Binding var seeRegistrArtist: Bool
    @Binding var ArtistMode: Bool
    @Binding var NameArtist: String
    @Binding var NickName: String
    @Binding var urlImageArtist: String
    @Binding var Sity: String
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    func ArtistModeOnOff()  {
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
                        let Artist = i.document.get("Artist") as! Bool
                        if Artist == true {
                            lolsongs.collection2 = "LSP"
                            lolsongs.documents2 = "LSP"
                            lolsongs.collection3 = "One more City"
                        let NicknameArtist = i.document.get("NickName") as! String
                        let Name = i.document.get("RealName") as! String
                        let Gorod = i.document.get("Sity") as! String
                        let UrlImage = i.document.get("ssilkaUrl") as! String
                        let Albums = i.document.get("Albums") as! Array<String>
                            ArtistMode = Artist
                            NameArtist = Name
                            NickName = NicknameArtist
                            urlImageArtist = UrlImage
                            Sity = Gorod
                            if Albums.count != 0 {
                            lolsongs.collection2 = NicknameArtist
                            lolsongs.documents2 = NicknameArtist
                            lolsongs.collection3 = Albums[Albums.count - 1 ]
                            lolsongs.UPDATE(collection1: lolsongs.collection1!, documents1: lolsongs.documents1!,collection2: lolsongs.collection2!,documents2: lolsongs.documents2!, collection3: lolsongs.collection3!)
                            }
                           
                    }
                }
                }
            }
        }
    }
    var body: some View {
        if self.database.datas.count != 0{
            ForEach(self.database.datas){i in
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: Double(i.NewColorList[0])/255.0, green: Double(i.NewColorList[1])/255.0, blue: Double(i.NewColorList[2])/255.0),Color.init(red: Double(i.NewColorList[3])/255.0, green: Double(i.NewColorList[4])/255.0, blue: Double(i.NewColorList[5])/255.0)]), startPoint: .top, endPoint:.center).edgesIgnoringSafeArea(.all)
        ScrollView (.vertical){
        VStack (alignment: .leading){
            HStack{
                Spacer()
                Button(action: {
                    withAnimation{
                        ArtistModeOnOff()
                        seeRegistrArtist.toggle()}
                }) {
                    Image(systemName: "music.mic").font(.system(size: UIScreen.main.bounds.width/14, weight: .regular)).foregroundColor(Color(.green))
                }
                Homescreen()
            }
            HStack{
                Text("Главная").fontWeight(.bold).font(.system(size:UIScreen.main.bounds.width/10)).foregroundColor(.white).padding(.leading,15).padding(.bottom,15)
 
            }
            HStack{
                Text("Рекомендации для вас").fontWeight(.bold).font(.system(size:UIScreen.main.bounds.width/15)).foregroundColor(.white).padding(.leading,15)
            }
            VStack{
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                        ForEach(0..<2) { index in
                            Button(action: {
                                Update(index: index)
                                self.index = 0
                                self.index = i.Index[index]
                                Index =  i.Index[index] - 1
                            }) {
                                VStack (alignment: .center){
                                    RemoteImage(type: .url(URL(string: i.ImageArray[index])!), errorView: { error in
                                        Text(error.localizedDescription)
                                    }, imageView: { image in
                                        image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                    }, loadingView: {
                                        ProgressView()
                                    }).frame(width: 180, height: 180)
                                    Text(i.NamePlayList[index]).foregroundColor(.white).padding(.top,3).font(.system(size: UIScreen.main.bounds.width/20,weight: .bold))
                                   
                                    Text(i.CommentPlayList[index]).foregroundColor( Color(red: 179.0/255.0, green: 179.0/255.0, blue: 179.0/255.0)).multilineTextAlignment(.center).font(.system(size: UIScreen.main.bounds.width/25))
                                }
                            }.padding(.leading,12).frame(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height/3.5)
                        
                            
                }
            }
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                ForEach(2..<4) { index in
                    Button(action: {
                        Update(index: index)
                        self.index = 0
                        self.index = i.Index[index]
                        Index =  i.Index[index] - 1
                    }) {
                        VStack (alignment: .center){
                            RemoteImage(type: .url(URL(string: i.ImageArray[index])!), errorView: { error in
                                Text(error.localizedDescription)
                            }, imageView: { image in
                                image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            }, loadingView: {
                                ProgressView()
                            }).frame(width: 180, height: 180)
                            Text(i.NamePlayList[index]).foregroundColor(.white).padding(.top,3).font(.system(size: UIScreen.main.bounds.width/20,weight: .bold))
                           
                            Text(i.CommentPlayList[index]).foregroundColor( Color(red: 179.0/255.0, green: 179.0/255.0, blue: 179.0/255.0)).multilineTextAlignment(.center).font(.system(size: UIScreen.main.bounds.width/25))
                        }
                    }.padding(.leading,12).frame(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height/3.5)
                }
                
            }
            }
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                    ForEach(4..<6) { index in
                        Button(action: {
                            Update(index: index)
                            self.index = 0
                            self.index = i.Index[index]
                            Index =  i.Index[index] - 1
                        }) {
                            VStack (alignment: .center){
                                RemoteImage(type: .url(URL(string: i.ImageArray[index])!), errorView: { error in
                                    Text(error.localizedDescription)
                                }, imageView: { image in
                                    image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                }, loadingView: {
                                    ProgressView()
                                }).frame(width: 180, height: 180)
                                Text(i.NamePlayList[index]).foregroundColor(.white).padding(.top,3).font(.system(size: UIScreen.main.bounds.width/20,weight: .bold))
                               
                                Text(i.CommentPlayList[index]).foregroundColor( Color(red: 179.0/255.0, green: 179.0/255.0, blue: 179.0/255.0)).multilineTextAlignment(.center).font(.system(size: UIScreen.main.bounds.width/25))
                            }
                        }.padding(.leading,12).frame(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height/3.5)
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
    func Update(index : Int){
        for data in database.datas {
        if index == 0 {
            lolsongs.collection2 = data.PATH[index]
        lolsongs.documents2 = data.PATH[index]
            lolsongs.collection3 = data.NamePlayList[index]
        //update()
        }
        else if index == 1 {
            lolsongs.collection2 = data.PATH[index]
        lolsongs.documents2 = data.PATH[index]
            lolsongs.collection3 = data.NamePlayList[index]
            //update()
        }
        else if index == 2 {
            lolsongs.collection2 = data.PATH[index]
            if data.PATH[index] == "New_Update"{
            lolsongs.documents2 = "New_Musik"
            lolsongs.collection3 = "New_Musik"
            }
            else {
                lolsongs.documents2 = data.PATH[index]
                lolsongs.collection3 = data.NamePlayList[index]
            }
            //update()
        }
        else if index == 3 {
            lolsongs.collection2 = data.PATH[index]
        lolsongs.documents2 = data.PATH[index]
            lolsongs.collection3 = data.NamePlayList[index]
        }
        else if index == 4 {
            lolsongs.collection2 = data.PATH[index]
        lolsongs.documents2 = data.PATH[index]
            lolsongs.collection3 = data.NamePlayList[index]
        }
        else if index == 5 {
            lolsongs.collection2 = data.PATH[index]
        lolsongs.documents2 = data.PATH[index]
            lolsongs.collection3 = data.NamePlayList[index]
        }
        lolsongs.UPDATE(collection1: lolsongs.collection1!, documents1: lolsongs.documents1!,collection2: lolsongs.collection2!,documents2: lolsongs.documents2!, collection3: lolsongs.collection3!)
        
        for i in lolsongs.datas {
            for g in DataMedia.MediaData {
                loveTrackAudio = Array<Int>(repeating: 0, count: i.NameArtist.count)
                for indexG in 0..<g.NameTrack.count{
                if let index = i.NameTrack.firstIndex(of: g.NameTrack[indexG]) {
                    print("Найдено!!")
                    loveTrackAudio[index] = 1
                }
                else {
                    loveTrackAudio[index] =  0
                    print("Нет такого")
                }
                }

            }
        }
        opacity = 0
    }
    }
}
struct TabBar: View {
    @Binding var index : Int
    @Binding var nameArtistSearch: Array<String>
    @Binding var NameTrackSearch: Array<String>
    @Binding var loveTrack: Array<Int>
    @Binding var loveTrackAudio : Array<Int>
    @ObservedObject  var DataMedia = MyLoveMedia()
    @ObservedObject  var searchhistory = Searchhistory()
    func updateSearch(){
        for i in searchhistory.Search {
            for _ in i.NameArtist {
                nameArtistSearch = i.NameArtist
                NameTrackSearch = i.NameTrack
            }
        }
    }
    func updateMediaLove(){
        for i in DataMedia.MediaData {
            loveTrack = Array<Int>(repeating: 1, count: i.NameTrack.count + 1)
           // loveTrackAudio = Array<Int>(repeating: 0, count: i.NameTrack.count)
        }
    }
    var body: some View {
        
        HStack{
            HStack{
                Image(systemName: "music.house.fill").resizable().frame(width: UIScreen.main.bounds.width/14, height: UIScreen.main.bounds.width/14, alignment: .center).foregroundColor(.green)
                Text(self.index == 0 ? "Главная" : "").fontWeight(.bold).font(.system(size:UIScreen.main.bounds.width/27)).foregroundColor(.white)
            }.padding(15)
            .background(self.index == 0 ? Color.green.opacity(0.5): Color.clear)
            .clipShape(Capsule())
            .onTapGesture{
                self.index = 0
                
            }
            
            HStack{
                Image(systemName: "magnifyingglass").resizable().frame(width: UIScreen.main.bounds.width/14, height: UIScreen.main.bounds.width/14, alignment: .center).foregroundColor(.gray)
                Text(self.index == 1 ? "Поиск" : "").fontWeight(.bold).font(.system(size:UIScreen.main.bounds.width/27)).foregroundColor(.white)
            }.padding(15)
            .background(self.index == 1 ? Color.purple.opacity(0.5): Color.clear)
            .clipShape(Capsule())
            .onTapGesture{
                updateSearch()
                self.index = 1
            }
            if(UIScreen.main.bounds.width == 375){
                HStack{
                    Image(systemName: "music.note.list").resizable().frame(width: UIScreen.main.bounds.width/14, height: UIScreen.main.bounds.width/14, alignment: .center).foregroundColor(.gray)
                    Text(self.index == 2 ? "Плейлисты" : "").fontWeight(.bold).font(.system(size:UIScreen.main.bounds.width/30)).foregroundColor(.white)
                }.padding(15)
                .background(self.index == 2 ? Color.blue.opacity(0.5): Color.clear)
                .clipShape(Capsule())
                .onTapGesture{
                    self.index = 2
                }
                HStack{
                    Image(systemName: "square.fill.and.line.vertical.and.square").resizable().frame(width: UIScreen.main.bounds.width/14, height: UIScreen.main.bounds.width/14, alignment: .center).foregroundColor(.gray)
                    Text(self.index == 3 ? "Медиатека" : "").fontWeight(.bold).font(.system(size: UIScreen.main.bounds.width/30)).foregroundColor(.white)
                }.padding(15)
                .background(self.index == 3 ? Color.red.opacity(0.5): Color.clear)
                .clipShape(Capsule())
                .onTapGesture{
                    updateMediaLove()
                    self.index = 3
                }
            }
            else{
            
            HStack{
                Image(systemName: "music.note.list").resizable().frame(width: UIScreen.main.bounds.width/14, height: UIScreen.main.bounds.width/14, alignment: .center).foregroundColor(.gray)
                Text(self.index == 2 ? "Плейлисты" : "").fontWeight(.bold).font(.system(size:UIScreen.main.bounds.width/30)).foregroundColor(.white)
            }.padding(15)
            .background(self.index == 2 ? Color.blue.opacity(0.5): Color.clear)
            .clipShape(Capsule())
            .onTapGesture{
                self.index = 2
            }
            HStack{
                Image(systemName: "square.fill.and.line.vertical.and.square").resizable().frame(width: UIScreen.main.bounds.width/14, height: UIScreen.main.bounds.width/14, alignment: .center).foregroundColor(.gray)
                Text(self.index == 3 ? "Медиатека" : "").fontWeight(.bold).font(.system(size: UIScreen.main.bounds.width/30)).foregroundColor(.white)
            }.padding(15)
            .background(self.index == 3 ? Color.red.opacity(0.5): Color.clear)
            .clipShape(Capsule())
            .onTapGesture{
                updateMediaLove()
                self.index = 3
            }
            }
        }.padding(.top,1).background(Color(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0)).animation(.default)
    }
}

//struct MainMenuSwiftUI_Previews: PreviewProvider {
//    static var previews: some View {
//        MainMenuSwiftUI()
//    }
//}


