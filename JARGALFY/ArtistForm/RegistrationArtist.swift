//
//  RegistrationArtist.swift
//  JARGALFY
//
//  Created by Антон Зайцев on 16.12.2020.
//

import SwiftUI
import FirebaseStorage
import Firebase
import Combine
struct RegistrationArtist: View {
    @State var showRegistrArtist : Bool = false
    @Binding var seeRegistrArtist: Bool
    @Binding var ArtistMode: Bool
    @Binding var NameArtist: String
    @Binding var NickName: String
    @Binding var urlImageArtist: String
    @Binding var Sity: String
    @EnvironmentObject var lolsongs : NewSong
    var body: some View {
        if ArtistMode == false {
        ZStack{
            if showRegistrArtist == false {
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 224.0/255.0, green: 128.0/255.0, blue: 26.0/255.0),Color.init(red: 44.0/255.0, green: 26.0/255.0, blue: 8.0/255.0)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
                    VStack{
                        HStack{
                            Button(action: {withAnimation {seeRegistrArtist.toggle()}}) {
                    Image(systemName: "chevron.left").foregroundColor(Color(red: 179.0/255.0, green: 179.0/255.0, blue: 179.0/255.0)).font(.system(size: UIScreen.main.bounds.width/15)).padding()
                        }
                            Spacer()
                        }
                    Spacer()
                }
            VStack{
            HStack{
                Image("LogoType")
                VStack{
                Text("JargalFy").fontWeight(.heavy).foregroundColor(.black)
                    .kerning(1.5).multilineTextAlignment(.center).font(.system(size: UIScreen.main.bounds.width/8, weight: .bold))
                Text("Для Артистов").fontWeight(.heavy).foregroundColor(.black)
                    .kerning(1.5).multilineTextAlignment(.center).font(.system(size: UIScreen.main.bounds.width/18, weight: .bold))
                }
            }
                VStack{
                Text("Ты в деле.").fontWeight(.heavy).foregroundColor(.white)
                    .kerning(1.5).multilineTextAlignment(.center).font(.system(size: UIScreen.main.bounds.width/8, weight: .bold))
                    Text("Присоединись к нашему сервису Артистом.").fontWeight(.bold).foregroundColor(.white)
                        .kerning(1.5).multilineTextAlignment(.center).font(.system(size: UIScreen.main.bounds.width/15, weight: .bold))
                }
                HStack{
                    Button(action: {
                        withAnimation{showRegistrArtist.toggle()}
                    }) {

                        Text("Присоединиться").foregroundColor(.black).padding(.horizontal,UIScreen.main.bounds.width/6).padding(.vertical,16).background(Color.init(red: 27.0/255.0, green: 155.0/255.0, blue: 0.0/255.0)).cornerRadius(20).font(.system(size: UIScreen.main.bounds.width/20, weight: .bold))
                    }
                }.padding(.top,20)
            }
            }
            else {
                RegistrationArtistNew(showRegistrArtist: $showRegistrArtist, NameArtist: $NameArtist, psevdomin: $NickName, Sity: $Sity, imageURL: $urlImageArtist, ArtistMode: $ArtistMode)
            }
        }
        }
        else {
            ArtistForm(seeRegistrArtist: $seeRegistrArtist,NameArtist: $NameArtist,NickName: $NickName, urlImageArtist: $urlImageArtist,Sity: $Sity).environmentObject(lolsongs)
        }
    }
}
struct RegistrationArtistNew: View {
    @ObservedObject var search = SearchMusikJargalFy()
    @Binding var showRegistrArtist : Bool
    @Binding var NameArtist : String
    @Binding var psevdomin : String
    @Binding var Sity : String
    @Binding var imageURL: String
    @Binding var ArtistMode: Bool
    @State var shown: Bool = false
    @State var showNick : Bool = false
    
    func CheackNickName(NewNick : String){
        var count = 0
        let NewNickReplace = NewNick.trimmingCharacters(in: NSCharacterSet.whitespaces)
        for i in search.Search{
            for g in 0..<i.NameArtist.count {
                if NewNickReplace.lowercased() == i.NameArtist[g].lowercased(){
                count += 1
                }
            }
        }
        if count != 0 {
            showNick = true
        }
        else {
            showNick = false
        }
    }
    func RegistrationArtist( Nickname : String, Name: String, Gorod: String, UrlImage: String){
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
                let docRef = Firestore.firestore().document("users/\(uid)/ArtistMode/\(uid)")
                        let ratingDictionary = [
                            "NickName": Nickname,
                            "RealName": Name,
                            "Sity": Gorod,
                            "Artist": true,
                            "ssilkaUrl" : UrlImage,
                            "AboutArtist" : "",
                            "Instagram" : "",
                            "Albums" : Array<String>()
                        ] as [String : Any]
                        docRef.setData(ratingDictionary){ (error) in
                            if let error = error {
                                print("error = \(error)")
                            } else {
                                print("data uploaded successfully")

                            }
                        }
            ArtistMode.toggle()
            }
        }
    
    var body: some View {
        ZStack{
            Color(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0).edgesIgnoringSafeArea(.all)
            VStack{
                HStack{
                    Button(action: {withAnimation {showRegistrArtist.toggle()}}) {
            Image(systemName: "chevron.left").foregroundColor(Color(red: 179.0/255.0, green: 179.0/255.0, blue: 179.0/255.0)).font(.system(size: UIScreen.main.bounds.width/15)).padding()
                }
                    Spacer()
                }
            Spacer()
        }
            VStack{
            Text("Придумай свой псевдоним").fontWeight(.heavy).foregroundColor(.white)
                .kerning(1.5).multilineTextAlignment(.center).font(.system(size: UIScreen.main.bounds.width/18)).padding(.bottom,30)
                HStack{
                HStack {
                    Image(systemName: "face.smiling.fill").font(.system(size: UIScreen.main.bounds.width/14, weight: .regular)).foregroundColor(Color.green)
                    
                    ZStack(alignment: .leading) {
                        
                            if psevdomin.isEmpty {
                                Text("Ваш псевдоним")
                                    .foregroundColor(.white).multilineTextAlignment(.leading).foregroundColor(.black).font(.system(size: UIScreen.main.bounds.width/23, weight: .bold))
                            }
                        TextField("", text: $psevdomin).multilineTextAlignment(.leading).foregroundColor(.white).font(.system(size: UIScreen.main.bounds.width/23, weight: .bold)).onChange(of: psevdomin, perform: { value in
                            withAnimation{CheackNickName(NewNick: psevdomin)}
                        })
                    }
                    
                }.padding(.horizontal).padding(.vertical,6)
                }.background( RoundedRectangle( cornerRadius: 10).fill(Color(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0))).padding(.horizontal).padding(.bottom,(showNick == false ? 10 : 0))
                if showNick == true {
                    HStack{
                    Image(systemName: "person.2.circle.fill").font(.system(size: UIScreen.main.bounds.width/23, weight: .regular)).foregroundColor(Color(.systemPink))
                    Text("Этот псевдоним занят").foregroundColor(.red).foregroundColor(.black).font(.system(size: UIScreen.main.bounds.width/23, weight: .bold))
                    }.padding(.horizontal,7).padding(.vertical,2).background(Color.black).font(.system(size: UIScreen.main.bounds.width/20)).cornerRadius(20)
                }
                HStack{
                HStack {
                    Image(systemName: "person.crop.circle.badge.checkmark").font(.system(size: UIScreen.main.bounds.width/14, weight: .regular)).foregroundColor(Color.green)
                    
                    ZStack(alignment: .leading) {
                        
                            if NameArtist.isEmpty {
                                Text("Ваше настоящее имя")
                                    .foregroundColor(.white).multilineTextAlignment(.leading).foregroundColor(.black).font(.system(size: UIScreen.main.bounds.width/23, weight: .bold))
                            }
                        TextField("", text: $NameArtist).multilineTextAlignment(.leading).foregroundColor(.white).font(.system(size: UIScreen.main.bounds.width/23, weight: .bold))
                    }
                    
                }.padding(.horizontal).padding(.vertical,6)
                }.background( RoundedRectangle( cornerRadius: 10).fill(Color(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0))).padding(.horizontal).padding(.bottom,10)
                HStack{
                HStack {
                    Image(systemName: "house.circle.fill").font(.system(size: UIScreen.main.bounds.width/14, weight: .regular)).foregroundColor(Color.green)
                    
                    ZStack(alignment: .leading) {
                        
                            if Sity.isEmpty {
                                Text("Ваша страна или регион")
                                    .foregroundColor(.white).multilineTextAlignment(.leading).foregroundColor(.black).font(.system(size: UIScreen.main.bounds.width/23, weight: .bold))
                            }
                        TextField("", text: $Sity).multilineTextAlignment(.leading).foregroundColor(.white).font(.system(size: UIScreen.main.bounds.width/23, weight: .bold))
                    }
                    
                }.padding(.horizontal).padding(.vertical,6)
                }.background( RoundedRectangle( cornerRadius: 10).fill(Color(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0))).padding(.horizontal).padding(.bottom,(showNick == false ? 10 : 0))
                if (NameArtist != "" && psevdomin != "" && showNick == false && Sity != "") {
                HStack{
                    VStack {
                        if imageURL != "" {
                            VStack{
                                Text("Профиль в JargalFy").fontWeight(.heavy).foregroundColor(.white).multilineTextAlignment(.center).font(.system(size: UIScreen.main.bounds.width/18)).padding(.bottom,10)
                                FirebaseImageView(imageURL: imageURL).padding(.bottom,2)
                            HStack{
                                VStack (alignment: .leading){
                                    HStack{
                                        Text("Имя артиста").foregroundColor(.gray).multilineTextAlignment(.leading).font(.system(size: UIScreen.main.bounds.width/25, weight: .bold)).padding(.trailing,5)
                                    Text(NameArtist).foregroundColor(.green).multilineTextAlignment(.leading).font(.system(size: UIScreen.main.bounds.width/25, weight: .bold))
                                    }.padding(.bottom,1)
                                    HStack{
                                        Text("Псевдоним/название группы").foregroundColor(.gray).multilineTextAlignment(.leading).font(.system(size: UIScreen.main.bounds.width/25, weight: .bold)).padding(.trailing,5)
                                    Text(psevdomin).foregroundColor(.green).multilineTextAlignment(.leading).font(.system(size: UIScreen.main.bounds.width/25, weight: .bold))
                                    }.padding(.bottom,1)
                                    HStack{
                                        Text("Страна или регион").foregroundColor(.gray).multilineTextAlignment(.leading).font(.system(size: UIScreen.main.bounds.width/25, weight: .bold)).padding(.trailing,5)
                                    Text(Sity).foregroundColor(.green).multilineTextAlignment(.leading).font(.system(size: UIScreen.main.bounds.width/25, weight: .bold))
                                    }
                                }
                            }
                            }
                        }
                        Button(action: {
                            if imageURL == "" {
                            withAnimation{self.shown.toggle()}
                            }
                            else {
                                withAnimation{deleteAvatars(childName: psevdomin)}
                            }
                        }) {

                            Text(imageURL == "" ? "ЗАГРУЗИТЬ ФОТО" : "УДАЛИТЬ ФОТО").foregroundColor(imageURL == "" ? .white : .red).padding(.horizontal,UIScreen.main.bounds.width/5).padding(.vertical,12).background(Color(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0)).cornerRadius(20).font(.system(size:  UIScreen.main.bounds.width/25, weight: .bold))
                        }.sheet(isPresented: $shown) {
                            imagePicker(shown: self.$shown,imageURL: self.$imageURL,psevdomin: self.$psevdomin)
                            }
                    }.onAppear(perform: loadImageFromFirebase).animation(.spring())
                }
                }
                if imageURL != "" {
                HStack{
                    Button(action: {
                        withAnimation{
                            RegistrationArtist(Nickname: psevdomin, Name: NameArtist, Gorod: Sity, UrlImage: imageURL)
                        }
                    }) {

                        Text("ПРИСОЕДИНИТЬСЯ К АРТИСТАМ").foregroundColor(.black).padding(.horizontal,UIScreen.main.bounds.width/6).padding(.vertical,16).background(Color.init(red: 27.0/255.0, green: 155.0/255.0, blue: 0.0/255.0)).cornerRadius(20).font(.system(size: UIScreen.main.bounds.width/28, weight: .bold))
                    }
                }.padding(.top,20)
                }
            }
        }
    }
    func loadImageFromFirebase() {
        let storage = Storage.storage().reference(withPath: "Image/AvatarsArtist/\(psevdomin)_avatar")
        storage.downloadURL { (url, error) in
            if error != nil {
                print((error?.localizedDescription)!)
                return
            }
            print("Download success")
            self.imageURL = "\(url!)"
        }
    }
    func deleteAvatars(childName : String)  {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let desertRef = storageRef.child("Image").child("AvatarsArtist").child("\(childName)_avatar")

        //Removes image from storage
        desertRef.delete { error in
            if let error = error {
                print(error)
            } else {
                imageURL = ""
                // File deleted successfully
            }
        }
    }
}
//struct RegistrationArtist_Previews: PreviewProvider {
//    static var previews: some View {
//        RegistrationArtist()
//    }
//}
