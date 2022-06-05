//
//  ArtistForm.swift
//  JARGALFY
//
//  Created by Антон Зайцев on 19.12.2020.
//

import SwiftUI
import RemoteImage
import Firebase
import Combine
struct ArtistForm: View {
    var edges = UIApplication.shared.windows.first?.safeAreaInsets
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    @EnvironmentObject var lolsongs : NewSong
    @Binding var seeRegistrArtist : Bool
    @Binding var NameArtist: String
    @Binding var NickName: String
    @Binding var urlImageArtist: String
    @Binding var Sity: String
    @State var opacity : Double = 0.0
    @State var indexTouch : [Int] = [1,0,0]
    @State var about : String = ""
    @State var AboutSee : Bool = false
    @State var NickNameInstagram : String = ""
    
    @State var AudioPlay : Bool = false
    @State var progress : Float = 0.0
    @State var duration: Double = 0.0
    @State var position: CGFloat = 0.0
    @State var boolNextAuido : Bool = false
    @State var time : String = "0:00:00"
    @State var lastTime : String = "0:00:00"
    @State var with : Double = 0.0
    @State var countMusik : Int = 0
    @State var Timer : Double = 0.0
    @State var playAndpausetogle : Bool = false
    @State var show : Bool = false
    @State var offset: CGFloat = 0
    @State var stop :Bool = false
    @State var TextTrack : String = ""
    @State var showTextTrack : Bool = false
    @State var index :Int = 0
    var body: some View {
        ZStack (alignment: Alignment(horizontal: .center, vertical: .top)){
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 5.0/255.0, green: 127.0/255.0, blue: 242.0/255.0),Color.init(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0)]), startPoint: .top, endPoint: .center).edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack{
                    GeometryReader{reader in
                        
                        VStack{
                            
                            RemoteImage(type: .url(URL(string: urlImageArtist)!), errorView: { error in
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
                                        
                                        self.opacity = Double(opacity_value)
                                        
                                        return
                                    }
                                    
                                    self.opacity = 1
                                }
                                else{
                                    
                                    self.opacity = 0
                                }
                            }
                        }
                        
                    }
                    
                    .frame(height: UIScreen.main.bounds.height / 2.3)
                    ZStack{
                        Color.black
                        VStack{
                            HStack{
                                Button(action: {
                                    withAnimation{
                                        indexTouch = [Int] (repeating: 0, count: 3)
                                        indexTouch[0] = 1
                                    }
                                }) {
                                    VStack{
                                        Text("Релизы").foregroundColor(.white).font(.system(size: UIScreen.main.bounds.height/60, weight: .semibold, design: .rounded)).kerning(1.5).textCase(.uppercase)
                                        Rectangle().frame(height: 1.0, alignment: .bottom).foregroundColor( indexTouch[0] == 1 ? Color.green : Color.black)
                                    }
                                }
                                Button(action: {
                                    withAnimation{
                                        AboutArtistForDataBase()
                                        indexTouch = [Int] (repeating: 0, count: 3)
                                        indexTouch[1] = 1
                                    }}) {
                                        VStack{
                                            Text("Артист").foregroundColor(.white).font(.system(size: UIScreen.main.bounds.height/60, weight: .semibold, design: .rounded)).kerning(1.5).textCase(.uppercase).padding(.horizontal,5)
                                            Rectangle().frame(height: 1.0, alignment: .bottom).foregroundColor( indexTouch[1] == 1 ? Color.green : Color.black)
                                        }
                                        
                                    }
                                Button(action: {
                                    withAnimation{
                                        indexTouch = [Int] (repeating: 0, count: 3)
                                        indexTouch[2] = 1
                                    }}) {
                                        VStack{
                                            Text("Концерты").foregroundColor(.white).font(.system(size: UIScreen.main.bounds.height/60, weight: .semibold, design: .rounded)).kerning(1.5).textCase(.uppercase).padding(.trailing,5)
                                            Rectangle().frame(height: 1.0, alignment: .bottom).foregroundColor( indexTouch[2] == 1 ? Color.green : Color.black)
                                        }
                                    }
                            }.padding(.top,30)
                            if indexTouch[0] == 1 {
                                ReleaseArtist(NickName: $NickName, audioPlay: $AudioPlay, progress: $progress, boolNextAuido: $boolNextAuido, countMusik: $countMusik, playAndpausetogle: $playAndpausetogle, opacity: $opacity).environmentObject(lolsongs)
                            }
                            else if indexTouch[1] == 1 {
                                AboutArtist(NickName: $NickName, about: $about, urlImageArtist: $urlImageArtist, AboutSee: $AboutSee, NickNameInstagram: $NickNameInstagram)
                            }
                        }
                        
                    }
                }
                
            }
            HStack{
                ZStack{
                    Button(action: {seeRegistrArtist.toggle()
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
                        if opacity > 0.6 {
                            if  NickName.count <= 12 {
                                Text(NickName).fontWeight(.bold).foregroundColor(.white).font(.title2)
                            }
                            else {
                                Text(NickName).fontWeight(.bold).foregroundColor(.white).font(.title2).padding(.leading,15)
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding()
            .foregroundColor(opacity > 0.6 ? .white : .white)
            .padding(.top,edges!.top)
            .background(Color.black.opacity(opacity))
            .shadow(color: Color.black.opacity(opacity > 0.8 ? 0.1 : 0), radius: 5, x: 0, y: 5)
            
        }.ignoresSafeArea(.all, edges: .top)
        if AudioPlay == true {
            HStack{
                AudioPlayForArtist(AudioPlay: $AudioPlay, progress: $progress, duration: $duration, position: $position, time: $time, lastTime: $lastTime, with: $with, boolNextAuido: $boolNextAuido, countMusik: $countMusik, Timer: $Timer, playAndpausetogle: $playAndpausetogle, show: $show, offset: $offset, index: $index, stop: $stop, TextTrack: $TextTrack, showTextTrack: $showTextTrack)
                    .environmentObject(lolsongs)
            }.background(Color(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0).edgesIgnoringSafeArea(.all)).animation(.default)
        }
    }
    func AboutArtistForDataBase () {
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
                        let About = i.document.get("AboutArtist") as! String
                        let instagram = i.document.get("Instagram") as! String
                        about = About
                        NickNameInstagram = instagram
                        if About != "" {
                            AboutSee = true
                        }
                        else {
                            AboutSee = false
                        }
                    }
                }
            }
        }
    }
}
struct AboutArtist: View {
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    @Binding var NickName: String
    @Binding var about : String
    @Binding var urlImageArtist: String
    @State var addAbout : String = ""
    @State var boolAddAbout : Bool = false
    @Binding var AboutSee : Bool
    @Binding var NickNameInstagram : String
    @State var addInsta : String = ""
    @State var proverka : Bool = false
    var body: some View {
        VStack{
            if AboutSee == false{
                HStack{
                    Button(action: {
                        if boolAddAbout == false {
                            withAnimation(.easeIn){boolAddAbout.toggle()}
                        }
                        else {
                            withAnimation(.easeIn){addAboutArtistText(AboutText: addAbout, nickName: addInsta)}
                        }
                    }) {
                        Text(boolAddAbout == false ? "Добавить на страницу" : "Добавить о себе").fontWeight(.bold).foregroundColor(.white).padding(.vertical,6).font(.system(size: UIScreen.main.bounds.width/30)).textCase(.uppercase)
                    }.padding(.horizontal).overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                }.padding(.vertical,5)
                if proverka == true {
                    HStack{
                        Image(systemName: "highlighter").font(.system(size: UIScreen.main.bounds.width/25, weight: .regular)).foregroundColor(Color(.systemPink))
                        Text("Вы не заполнили информацию о себе").foregroundColor(.red).foregroundColor(.black).font(.system(size: UIScreen.main.bounds.width/28, weight: .bold)).textCase(.uppercase)
                    }.padding(.horizontal,7).padding(.vertical,2).background(Color.black).font(.system(size: UIScreen.main.bounds.width/20)).cornerRadius(20)
                }
                if boolAddAbout == true && AboutSee == false {
                    ZStack{
                        VStack{
                            HStack{
                                HStack {
                                    ZStack(alignment: .leading) {
                                        if addAbout.isEmpty {
                                            Text("Довабьте о себе").foregroundColor(.white).multilineTextAlignment(.leading).foregroundColor(.black).font(.system(size: UIScreen.main.bounds.width/23, weight: .bold)).textCase(.uppercase)
                                        }
                                        TextEditor(text: $addAbout).foregroundColor(.white).multilineTextAlignment(.leading).foregroundColor(.black).font(.system(size: UIScreen.main.bounds.width/23, weight: .bold)).onTapGesture {
                                            withAnimation{proverka = false}
                                        }
                                    }
                                    
                                }.padding(.horizontal).padding(.vertical,6)
                            }.background( RoundedRectangle( cornerRadius: 10).fill(Color(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0))).padding(.horizontal).padding(.bottom,10)
                            HStack{
                                HStack {
                                    Image("insta").resizable().aspectRatio(contentMode: .fit)
                                        .cornerRadius(UIScreen.main.bounds.width/14).frame(width:UIScreen.main.bounds.width/14, height:  UIScreen.main.bounds.width/14)
                                    ZStack(alignment: .leading) {
                                        
                                        if addInsta.isEmpty {
                                            Text("Ник в Instagram")
                                                .foregroundColor(.white).multilineTextAlignment(.leading).foregroundColor(.black).font(.system(size: UIScreen.main.bounds.width/25, weight: .bold)).textCase(.uppercase)
                                        }
                                        TextField("", text: $addInsta).multilineTextAlignment(.leading).foregroundColor(.white).font(.system(size: UIScreen.main.bounds.width/25, weight: .bold))
                                    }
                                    
                                }.padding(.horizontal).padding(.vertical,4)
                            }.background( RoundedRectangle( cornerRadius: 10).fill(Color(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0))).padding(.horizontal).padding(.bottom,10)
                            
                        }
                    }
                }
            }
            else {
                HStack{
                    VStack (alignment: .leading){
                        Text("228").foregroundColor(.white).font(.system(size: UIScreen.main.bounds.width/12, weight: .bold)).kerning(2)
                        Text("СЛУШАТЕЛЕЙ ЗА МЕСЯЦ").foregroundColor(.white).font(.system(size: UIScreen.main.bounds.width/35, weight: .light)).padding(.bottom,6).textCase(.uppercase)
                        Text(about).foregroundColor(.gray).padding(.bottom,15)
                        HStack{
                            RemoteImage(type: .url(URL(string: urlImageArtist)!), errorView: { error in
                                Text(error.localizedDescription)
                            }, imageView: { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(UIScreen.main.bounds.width/15)
                            }, loadingView: {
                                ProgressView()
                            }).frame(width:UIScreen.main.bounds.width/15, height:  UIScreen.main.bounds.width/15)
                            Text("Кто опубликовал: \(NickName)").foregroundColor(.gray).font(.system(size: UIScreen.main.bounds.width/25))
                        }.padding(.bottom,3)
                        if NickNameInstagram != "" {
                            HStack{
                                Button(action: {
                                    withAnimation(.easeIn){
                                        openInstagram(instagramHandle: "\(NickNameInstagram)")
                                        print(NickNameInstagram)
                                    }
                                }) {
                                    Image("insta").resizable().aspectRatio(contentMode: .fit)
                                        .cornerRadius(UIScreen.main.bounds.width/14).frame(width:UIScreen.main.bounds.width/14, height:  UIScreen.main.bounds.width/14)
                                    Text("INSTAGRAM").foregroundColor(.white).foregroundColor(.white).font(.system(size: UIScreen.main.bounds.width/25, weight: .bold)).textCase(.uppercase)
                                }
                            }.padding(.bottom,10)
                        }
                    }.padding(.horizontal,15)
                    Spacer()
                }
            }
        }
    }
    func openInstagram(instagramHandle: String) {
        guard let url = URL(string: "https://instagram.com/\(instagramHandle)")  else { return }
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    func addAboutArtistText (AboutText: String,nickName : String) {
        if AboutText.trimmingCharacters(in: NSCharacterSet.whitespaces) != "" {
            proverka = false
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
                            let NicknameArtist = i.document.get("NickName") as! String
                            let Name = i.document.get("RealName") as! String
                            let Gorod = i.document.get("Sity") as! String
                            let UrlImage = i.document.get("ssilkaUrl") as! String
                            let Albums = i.document.get("Albums") as! Array<String>
                            let ratingDictionary = [
                                "NickName": NicknameArtist,
                                "RealName": Name,
                                "Sity": Gorod,
                                "Artist": Artist,
                                "ssilkaUrl" : UrlImage,
                                "AboutArtist" : AboutText,
                                "Instagram" : nickName,
                                "Albums" : Albums
                            ] as [String : Any]
                            let docRef = Firestore.firestore().document("users/\(uid)/ArtistMode/\(uid)")
                            
                            docRef.setData(ratingDictionary){ (error) in
                                if let error = error {
                                    print("error = \(error)")
                                } else {
                                    print("data uploaded successfully")
                                    AboutSee.toggle()
                                    about = AboutText
                                    NickNameInstagram = nickName
                                }
                            }
                            
                        }
                    }
                    
                }
            }
        }
        else {
            proverka = true
        }
    }
}



