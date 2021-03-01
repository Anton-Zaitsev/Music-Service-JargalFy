//
//  StreamingPlayerAudio.swift
//  JARGALFY
//
//  Created by Антон Зайцев on 09.11.2020.
//

import SwiftUI
import UIKit
import SwiftAudioPlayer
import AVFoundation
import RemoteImage
import Firebase
struct StreamingPlayerAudio: View {
    @EnvironmentObject var datasongsAlbom : NewSong
    @Binding var audioPlay: Bool
    @Binding var progress : Float
    @Binding var duration: Double
    @Binding var position: CGFloat
    @Binding var time : String
    @Binding var lastTime : String
    @Binding var with : Double
    @Binding var boolNextAuido : Bool
    @Binding var countMusik : Int
    @Binding var Timer : Double
    @Binding var isDownloading : Bool
    @Binding var safeURL : Array<String>
    @Binding var playAndpausetogle : Bool
    @Binding var show : Bool
    @Binding var offset: CGFloat
    @Binding var index :Int
    @Binding var stop : Bool
    @Binding var seeAudioplay : Bool
    @Binding var TextTrack : String
    @Binding var showTextTrack : Bool
    @Binding var loveTrack: Array<Int>
    @State var valueSpeed : CGFloat = 0
    @State var valueSpeed2 : CGFloat = 0
    @State var valueSpeed3 : CGFloat = 0
    @State var visibleModify : Bool = false
    @State var visibleModifyEclavaizer : Bool = false
    let spacing: CGFloat = 10
    let withScreen  = UIScreen.main.bounds.width-30
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
                            print(NameArtist[0])
                            print(TextTrack[0])
                                for index in 0..<NameArtist.count {
                                    if NameArtist[index] == NameArtistDrop && NameTrack[index] == NameTrackDrop{
                                        Image.remove(at: index)
                                        NameArtist.remove(at: index)
                                        NameTrack.remove(at: index)
                                        TextTrack.remove(at: index)
                                        ssilka.remove(at: index)
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
                        }
                loveTrack[countMusik] = 0
            }
            
        }
    }
    var body: some View {
        if self.datasongsAlbom.datas.count != 0{
            VStack{
                HStack{
                    if !self.show {
                        ForEach(self.datasongsAlbom.datas){ i in
                        VStack{
                            ZStack(alignment: .leading){
                                Capsule().fill(Color(red: 64.0/255.0, green: 64.0/255.0, blue: 64.0/255.0)).frame(height: 6)
                                Capsule().fill(Color.red).frame(width: CGFloat(withScreen+30) * CGFloat(position), height: 6)
                                    .gesture(DragGesture()
                                 .onChanged({ (value) in
                                 SAPlayer.shared.pause()
                                 let x = value.location.x
                                  position = CGFloat(Float(x)/Float(UIScreen.main.bounds.width - 30))
                                   if duration - with <= 1 && with != 0{next()}
                                    })
                                  .onEnded({ (value) in
                                  Timer =  Double(position) * Double(duration)
                                  SAPlayer.shared.seekTo(seconds: Timer)
                                  SAPlayer.shared.play()
                                   }))
                            }
                            HStack (spacing: 15){
                                RemoteImage(type: .url(URL(string: i.Image.count == 1 ? i.Image[0] : i.Image[countMusik])!), errorView: { error in
                                    Text(error.localizedDescription)
                                }, imageView: { image in
                                    image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                }, loadingView: {
                                    ProgressView()
                                }).frame(width:65,height:  65)
                        VStack(alignment: .leading, spacing:3){
                            Text(i.NameTrack[countMusik]).foregroundColor(.white).font(.system(size: UIScreen.main.bounds.width/26))
                            Text(i.NameArtist[countMusik]).foregroundColor(Color(red: 179.0/255.0, green: 179.0/255.0, blue: 179.0/255.0))
                                .font(.system(size: UIScreen.main.bounds.width/28))
                        }
                        Spacer()
                                Button(action: {DeledeAndAddMusik(ImageDrop: (i.Image.count != 1 ? i.Image[countMusik] : i.Image[0]), NameArtistDrop: i.NameArtist[countMusik], NameTrackDrop: i.NameTrack[countMusik], TextTrackDrop: i.TextTrack[countMusik], ssilkaDrop: i.ssilka[countMusik],countMusik: countMusik)
                                }) {
                                    Image(systemName: loveTrack [countMusik] == 1 ? "suit.heart.fill" : "suit.heart").font(.system(size: 20, weight: .regular)).foregroundColor(loveTrack [countMusik] == 1 ? .green : .gray).padding(.trailing,5)
                                    
                                
                                }
                                Button(action: {
                                    seeAudioplay = false
                                    SAPlayer.shared.clear()
                                }) {
                                    Image(systemName: "delete.right.fill").font(.title).foregroundColor(.white).padding(.trailing,5)
                                }
                        Button(action: {
                            stopORpause()
                            
                        }) {
                            Image(systemName: self.playAndpausetogle ? "pause.fill" : "play.fill").font(.title).foregroundColor(.white).padding(.trailing,20)
                        }
                                
                        }
                        }
                        }
                    }
                    if self.show{
                        if self.showTextTrack{
                            ForEach(self.datasongsAlbom.datas){ i in
                            ZStack (alignment: .top){
                                if  i.NewColorList.count != 0 {
                                    LinearGradient(gradient: Gradient(colors: [Color.init(red: Double(i.NewColorList[0])/255.0, green: Double(i.NewColorList[1])/255.0, blue: Double(i.NewColorList[2])/255.0),Color.init(red: Double(i.NewColorList[3])/255.0, green: Double(i.NewColorList[4])/255.0, blue: Double(i.NewColorList[5])/255.0)]), startPoint: .top, endPoint:.center).edgesIgnoringSafeArea(.all)
                                }
                                else {
                                LinearGradient(gradient: Gradient(colors: [Color.init(red: 5.0/255.0, green: 127.0/255.0, blue: 242.0/255.0),Color.init(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0)]), startPoint: .top, endPoint: .center).edgesIgnoringSafeArea(.all)
                                }
                                VStack{
                                ZStack{
                                    Button(action: {withAnimation{self.showTextTrack = false}}) {
                                        Image(systemName: "chevron.left").foregroundColor(Color(red: 179.0/255.0, green: 179.0/255.0, blue: 179.0/255.0)).font(.system(size: UIScreen.main.bounds.width/18)).padding()
                                        Spacer()
                                    }
                                    HStack{
                                        RemoteImage(type: .url(URL(string: i.Image.count == 1 ? i.Image[0] : i.Image[countMusik])!), errorView: { error in
                                            Text(error.localizedDescription)
                                        }, imageView: { image in
                                            image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .cornerRadius(7)
                                        }, loadingView: {
                                            ProgressView()
                                        }).frame(width:UIScreen.main.bounds.width/6, height:  UIScreen.main.bounds.width/6)
                                        VStack (alignment: .leading){
                                            Text(i.NameTrack[countMusik]).fontWeight(.bold).tag(index).foregroundColor(.white).padding(.leading,10).font(.system(size: UIScreen.main.bounds.width/23))
                                            Text(i.NameArtist[countMusik]).foregroundColor(.gray).padding(.leading,10)
                                        }
                                    }
                                }.padding(.top,50)
                            ScrollView(.vertical, showsIndicators: false){
                                Text(TextTrack).foregroundColor(.white).fontWeight(.bold).font(.title).padding(.horizontal,20).padding(.bottom,20)
                            }.padding(.bottom,UIScreen.main.bounds.height/15).padding(.top,5)
                            }
                            }.frame(width:UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 50, alignment: .center)
                        
                                
                        }
                        }
                        else{
                            ForEach(self.datasongsAlbom.datas){ i in
                        ZStack (alignment: .bottom){
                            if  i.NewColorList.count != 0 {
                                LinearGradient(gradient: Gradient(colors: [Color.init(red: Double(i.NewColorList[0])/255.0, green: Double(i.NewColorList[1])/255.0, blue: Double(i.NewColorList[2])/255.0),Color.init(red: Double(i.NewColorList[3])/255.0, green: Double(i.NewColorList[4])/255.0, blue: Double(i.NewColorList[5])/255.0)]), startPoint: .top, endPoint:.center).edgesIgnoringSafeArea(.all)
                            }
                            else {
                            LinearGradient(gradient: Gradient(colors: [Color.init(red: 5.0/255.0, green: 127.0/255.0, blue: 242.0/255.0),Color.init(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0)]), startPoint: .top, endPoint: .center).edgesIgnoringSafeArea(.all)
                            }
                            VStack{
                                HStack {
                                    Button(action: {withAnimation{self.show = false}}) {
                                        Image(systemName: "chevron.down").foregroundColor(Color(red: 179.0/255.0, green: 179.0/255.0, blue: 179.0/255.0)).font(.system(size: UIScreen.main.bounds.width/20))
                                    }
                                    Spacer()
                                    Text(i.NameAlbom == "" ? i.NameTrack[countMusik] : i.NameAlbom).fontWeight(.bold).foregroundColor(Color(red: 179.0/255.0, green: 179.0/255.0, blue: 179.0/255.0)).font(.system(size: UIScreen.main.bounds.width/23))
                                    Spacer()
                                    Button(action: {withAnimation{self.showTextTrack = true
                                        textMusik(text: i.TextTrack[countMusik], countTrack: countMusik)}
                                    }) {
                                        Image(systemName: "ellipsis.bubble").foregroundColor(Color(red: 179.0/255.0, green: 179.0/255.0, blue: 179.0/255.0)).font(.system(size: UIScreen.main.bounds.width/20))
                                    }
                                }.padding(.bottom,20).padding(.horizontal,25)
                                
                                HStack{
                                    RemoteImage(type: .url(URL(string: i.Image.count == 1 ? i.Image[0] : i.Image[countMusik])!), errorView: { error in
                                        Text(error.localizedDescription)
                                    }, imageView: { image in
                                        image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                    }, loadingView: {
                                        ProgressView()
                                    }).frame(width:UIScreen.main.bounds.width-40, height:  UIScreen.main.bounds.width-40).padding(.bottom,5)
                            .gesture(
                            DragGesture()
                            .onEnded({ value in
                                if value.translation.width < 0 && value.translation.height > -30 && value.translation.height < 30 {
                                        //print("left swipe")
                                       next()
                                    }
                                    else if value.translation.width > 0 && value.translation.height > -30 && value.translation.height < 30 {
                                        //print("right swipe")
                                        previos()
                                    }
                                else if value.translation.height > 0 && value.translation.width < 150 && value.translation.width > -150 {
                                        //print("down swipe")
                            self.show.toggle()
                            withAnimation {
                            self.offset = -(UIScreen.main.bounds.height * self.spacing) * CGFloat(self.index)
                                        }
                                }
                                
                                    })
                           )
                                }
                                VStack (alignment: .leading, spacing:5 ){
                                    HStack{
                                        Text(i.NameTrack[countMusik]).fontWeight(.bold).foregroundColor(.white).font(.system(size: UIScreen.main.bounds.width/16)).padding(.leading,20)
                                        Spacer()
                                        Button(action: {DeledeAndAddMusik(ImageDrop: (i.Image.count != 1 ? i.Image[countMusik] : i.Image[0]), NameArtistDrop: i.NameArtist[countMusik], NameTrackDrop: i.NameTrack[countMusik], TextTrackDrop: i.TextTrack[countMusik], ssilkaDrop: i.ssilka[countMusik],countMusik: countMusik)
                                        }) {
                                            Image(systemName: loveTrack [countMusik] == 1 ? "suit.heart.fill" : "suit.heart").font(.system(size: 23, weight: .regular)).foregroundColor(loveTrack [countMusik] == 1 ? .green : .gray).padding(.trailing,20)
                                        }
                                    }
                                    HStack{
                                        Text(i.NameArtist[countMusik]).fontWeight(.medium).foregroundColor(Color(red: 179.0/255.0, green: 179.0/255.0, blue: 179.0/255.0))
                                        .font(.system(size: UIScreen.main.bounds.width/20)).padding(.leading,20)
                                        Spacer()
                                    }
                                }
                                ZStack(alignment: .leading) {
                                    Capsule().fill(Color(red: 64.0/255.0, green: 64.0/255.0, blue: 64.0/255.0)).frame(height: 8)
                                    
                                    Capsule().fill(Color.red).frame(width: CGFloat(withScreen) * CGFloat(position), height: 8)
                                    
                                        .gesture(DragGesture()
                                            .onChanged({ (value) in
                                                SAPlayer.shared.pause()
                                                let x = value.location.x
                                                
                                                position = CGFloat(Float(x)/Float(UIScreen.main.bounds.width - 30))
                                                if duration - with <= 1 && with != 0{
                                                    next()
                                                }
                                                
                                                
                                            })
                                            .onEnded({ (value) in
                                                
                                                Timer =  Double(position) * Double(duration)
                                                SAPlayer.shared.seekTo(seconds: Timer)
                                                SAPlayer.shared.play()
                                            }))
                                }.padding(.top,5).padding(.horizontal,20)
                                HStack{
                                    Text(time.dropFirst(2)).foregroundColor(Color(red: 179.0/255.0, green: 179.0/255.0, blue: 179.0/255.0)).font(.system(size: UIScreen.main.bounds.width/27)).padding(.leading,20)
                                    Spacer()
                                    Text(lastTime.dropFirst(2)).foregroundColor(Color(red: 179.0/255.0, green: 179.0/255.0, blue: 179.0/255.0)).font(.system(size: UIScreen.main.bounds.width/27)).padding(.trailing,20)
                                }
                                HStack(){
                                    Button(action: {
                                       previos()
                                    }) {
                                        Image(systemName: "backward.end.fill").foregroundColor(.white).font(.system(size: UIScreen.main.bounds.width/11))
                                    }
                                    Button(action: {
                                        stopORpause()
                                    }) {
                                        Image(systemName: self.playAndpausetogle ? "pause.circle.fill" : "play.circle.fill").foregroundColor(.white).padding().padding(.horizontal,10).font(.system(size: UIScreen.main.bounds.width/7))
                                    }
                                    Button(action: {
                                       next()
                                    }) {
                                        Image(systemName: "forward.end.fill").foregroundColor(.white).font(.system(size: UIScreen.main.bounds.width/11))
                                    }
                                }
                                HStack{
                                Button(action: {
                                    withAnimation{
                                    visibleModifyEclavaizer = false
                                    visibleModify.toggle()
                                    }
                                }) {
                                    Image(systemName: "slider.vertical.3").foregroundColor(visibleModify == false ? .white : .green).font(.system(size: UIScreen.main.bounds.width/15)).padding(.leading,20)
                                }
                                Spacer()
                                    Button(action: {
                                        withAnimation{
                                        visibleModify = false
                                        visibleModifyEclavaizer.toggle()
                                        }
                                    }) {
                                        Image(systemName: "hifispeaker.2.fill").foregroundColor(visibleModifyEclavaizer == false ? .white : .green).font(.system(size: UIScreen.main.bounds.width/15)).padding(.trailing,20)
                                    }
                                }
                                if visibleModify == true {
                                VStack{
                                    HStack{
                                        Text("Ускорить аудио").fontWeight(.medium).foregroundColor(.white).font(.system(size: UIScreen.main.bounds.width/25)).padding(.leading,20).padding(.top,3)
                                        Spacer()
                                    }
                                    Slider(value: $valueSpeed).padding(.horizontal).foregroundColor(.red).onChange(of: valueSpeed, perform: { value in
                                    valueSpeed2 = 0
                                    let speed = valueSpeed + 1
                                    if let node = SAPlayer.shared.audioModifiers[0] as? AVAudioUnitTimePitch {
                                        node.rate = Float(speed)
                                        SAPlayer.shared.playbackRateOfAudioChanged(rate: Float(speed))
                                    }
                                })
                                    HStack{
                                        Text("Замедлить аудио").fontWeight(.medium).foregroundColor(.white).font(.system(size: UIScreen.main.bounds.width/25)).padding(.leading,20).padding(.top,3)
                                        Spacer()
                                    }
                                    Slider(value: $valueSpeed2).padding(.horizontal).foregroundColor(.red).onChange(of: valueSpeed2, perform: { value in
                                        valueSpeed = 0
                                        let speed = 1 - valueSpeed2
                                        if let node = SAPlayer.shared.audioModifiers[0] as? AVAudioUnitTimePitch {
                                            node.rate = Float(speed)
                                            SAPlayer.shared.playbackRateOfAudioChanged(rate: Float(speed))
                                        }
                                    })
                                }
                                }
                                if visibleModifyEclavaizer == true {
                                VStack{
                                    HStack{
                                        Text("Эквалайзер").fontWeight(.medium).foregroundColor(.white).font(.system(size: UIScreen.main.bounds.width/25)).padding(.leading,20).padding(.top,3)
                                        Spacer()
                                    }
                                    Slider(value: $valueSpeed3).padding(.horizontal).foregroundColor(.red).onChange(of: valueSpeed3, perform: { value in
                                        let reverb = valueSpeed3 * 500
                                        if let node = SAPlayer.shared.audioModifiers[1] as? AVAudioUnitReverb {
                                            node.wetDryMix = Float(reverb)
                                        }
                                    })
                                }
                                }
                            }.padding(.bottom,UIScreen.main.bounds.height/6)
                            
                        }.frame(width:UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 30, alignment: .center)
                        }
                        }
                    }
                        
                }.background(Color(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0)).edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation(Animation.default){
                        if !self.show{
                            visibleModifyEclavaizer = false
                            visibleModify = false
                        self.show.toggle()
                        }
                    }
                }
                .gesture(
                DragGesture()
                .onEnded({ value in
                    
                    if self.show{
                        if value.translation.height > 0 && value.translation.width < 100 && value.translation.width > -100 {
                                //print("down swipe")
                            
                    self.show.toggle()
                    withAnimation {
                    self.offset = -(UIScreen.main.bounds.height * self.spacing) * CGFloat(self.index)
                                }
                        }
                    }
                    if !self.show{
                        if value.translation.width < 0 && value.translation.height > -30 && value.translation.height < 30 {
                                //print("left swipe")
                               next()
                            }
                            else if value.translation.width > 0 && value.translation.height > -30 && value.translation.height < 30 {
                                //print("right swipe")
                                previos()
                            }
                    }
                        })
               )
                    
                
            }.onAppear{
            SAPlayer.shared.DEBUG_MODE = true
//            let infoMation = SALockScreenInfo(title: NameTrack[countMusik], artist: nameArtist[countMusik], artwork: UIImage(), releaseDate: 2020)
//                SAPlayer.shared.mediaInfo = infoMation
                addRandomModifiers()
                for i in datasongsAlbom.datas {
            if boolNextAuido{
                SAPlayer.shared.stopStreamingRemoteAudio()
                SAPlayer.shared.startRemoteAudio(withRemoteUrl: URL(string: i.ssilka[countMusik])!)
                SAPlayer.shared.play()
                boolNextAuido = false
            }
            _ = SAPlayer.Updates.Duration.subscribe({ (url, duration) in
                guard url == URL(string: i.ssilka[countMusik])! else { return }
                self.lastTime = SAPlayer.prettifyTimestamp(duration)
                self.duration = duration
            })
            _ = SAPlayer.Updates.ElapsedTime.subscribe({ (url, position) in
                guard url == URL(string: i.ssilka[countMusik])!  else { return }
                guard self.duration != 0 else { return }
                self.time = SAPlayer.prettifyTimestamp(position)
                self.position = CGFloat(Float(position / self.duration))
                self.with = Double(position)
            })
            _ = SAPlayer.Updates.StreamingBuffer.subscribe({(url, playing) in
                guard url == URL(string: i.ssilka[countMusik])! else { return }
                if self.duration == 0.0 { return }
                self.progress = Float(playing.bufferingProgress)
            })
                }
        }
        .onChange(of: boolNextAuido, perform: { value in
            if boolNextAuido {
                SAPlayer.shared.stopStreamingRemoteAudio()
                for i in datasongsAlbom.datas {
                SAPlayer.shared.startRemoteAudio(withRemoteUrl: URL(string: i.ssilka[countMusik])!)
                }
                SAPlayer.shared.play()
                boolNextAuido = false
            }
        })
    }
    }
    func addRandomModifiers() {
        let node = AVAudioUnitReverb()
        SAPlayer.shared.audioModifiers.append(node)
        node.wetDryMix = 0
    }
    func next(){
        for i in datasongsAlbom.datas {
        if countMusik < i.ssilka.count-1{
        SAPlayer.shared.stopStreamingRemoteAudio()
        countMusik += 1
        
        SAPlayer.shared.startRemoteAudio(withRemoteUrl: URL(string:  i.ssilka[countMusik])!)
        SAPlayer.shared.play()
            self.playAndpausetogle = true
            
        }
        }
    }
    func previos(){
        for i in datasongsAlbom.datas {
            if i.ssilka.count == 1 {
                SAPlayer.shared.stopStreamingRemoteAudio()
                SAPlayer.shared.startRemoteAudio(withRemoteUrl: URL(string:  i.ssilka[0])!)
                SAPlayer.shared.play()
            }
            else {
        if countMusik > 0 {
            SAPlayer.shared.stopStreamingRemoteAudio()
            if  with <= 3.0  {
        countMusik -= 1
            self.playAndpausetogle = true
        }
            SAPlayer.shared.startRemoteAudio(withRemoteUrl: URL(string: i.ssilka[countMusik])!)
            SAPlayer.shared.play()
        }
        }
        }
    }
    func stopORpause(){
        if !playAndpausetogle{
        if !stop{
            SAPlayer.shared.stopStreamingRemoteAudio()
            for i in datasongsAlbom.datas {
            SAPlayer.shared.startRemoteAudio(withRemoteUrl: URL(string: i.ssilka[countMusik])!)
            }
            stop = true
        }
            SAPlayer.shared.play()
            playAndpausetogle = true
        }
        else
        {
            playAndpausetogle = false
            stop = true
            SAPlayer.shared.pause()
        }
    }
    func download(){
        for i in datasongsAlbom.datas {
        if !isDownloading {
           if let savedUrl = SAPlayer.Downloader.getSavedUrl(forRemoteUrl: URL(string: i.ssilka[countMusik])!) {
                SAPlayer.Downloader.deleteDownloaded(withSavedUrl: savedUrl)
                isDownloading = false
            } else {
                isDownloading = true
                SAPlayer.Downloader.downloadAudio(withRemoteUrl: URL(string: i.ssilka[countMusik])!, completion: {  url in
                    DispatchQueue.main.async {
                        //self.currentUrlLocationLabel.text = "saved to: \(url.lastPathComponent)"
                        try! safeURL[countMusik] = String(contentsOf: url)
                        
                        SAPlayer.shared.startSavedAudio(withSavedUrl: url)
                    }
                })
            }
        } else {
            SAPlayer.Downloader.cancelDownload(withRemoteUrl: URL(string: i.ssilka[countMusik])!)
            isDownloading = false
        }
        }
    }
    func textMusik(text : String, countTrack: Int){
        if text.first != "\n"{
        var items = text.components(separatedBy: " ")
        var stroka = ""
        items[0] += "\n"
        for i in 0..<items.count{
            if (items[i].firstIndex(of: "[") != nil && items[i+1].lastIndex(of: "]") != nil){
                items[i] = "\n" + items[i] + items[i+1]
                items[i+1] = ""
            }
            else if  (items[i].firstIndex(of: "\"") != nil){
                if (items[i].lastIndex(of: "\"") != nil){
                    items[i] = ""
                }
                else {
                for g in i..<items.count{
                    if items[g].lastIndex(of:  "\"") != nil
                    {
                        items[i] = ""
                    }
                    else {
                        items[i] += items[g]
                    }
                }
                }
            }
           else if (items[i] == items[i].capitalized && items[i] != "—" && i != 0){
                items[i] =  "\n" + "\n" +  items[i] + " "
            }
            else {
                if items[i] != ""{
                items[i] += " "
                }
            }
            stroka += items[i]
        }
        TextTrack = stroka
    }
    }
}

