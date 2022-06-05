//
//  MainMenu.swift
//  JARGALFY
//
//  Created by Антон Зайцев on 05.06.2022.
//
import SwiftUI
import CoreData
import Firebase
import RemoteImage

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
