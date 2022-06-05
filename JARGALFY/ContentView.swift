//
//  ContentView.swift
//  JARGALFY
//
//  Created by Антон Зайцев on 22.09.2020.
//
//


import SwiftUI
import Firebase
struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home : View {
    //false
    
    @State var show = false
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    
    var body: some View{
        
        NavigationView{
            
            VStack{
                
                if self.status{
                    
                    MainMenuSwiftUI()
                }
                else{
                    
                    ZStack (){
                        
                        NavigationLink(destination: Registration(show: self.$show), isActive: self.$show) {
                            
                        }.hidden()
                        Login(show: self.$show)
                    }
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
                    
                    self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                }
            }
        }
    }
}

struct Homescreen : View {
    
    var body: some View{
        VStack (alignment: .leading){
            Button(action: {
                
                try! Auth.auth().signOut()
                UserDefaults.standard.set(false, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                
            }) {
                Image(systemName: "person.crop.circle.fill.badge.minus").font(.system(size: UIScreen.main.bounds.width/14, weight: .regular)) .padding(.horizontal,15).foregroundColor(.white)
            }
        }
        
    }
}

struct Login : View {
    let db = Firestore.firestore()
    @State var email = ""
    @State var pass = ""
    @State var visible = false
    @Binding var show : Bool
    @State var alert = false
    @State var error = ""
    
    var body: some View{
        
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 57.0/255.0, green: 0.0/255.0, blue: 54.0/255.0),Color.init(red: 10.0/255.0, green: 98.0/255.0, blue: 31.0/255.0)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            VStack{
                HStack{
                    Image("LogoType")
                    Text("JargalFy").fontWeight(.heavy).foregroundColor(.white)
                        .kerning(1.5).multilineTextAlignment(.center).font(.system(size: UIScreen.main.bounds.width/9, weight: .bold))
                }
                HStack{
                    VStack{
                        Text("Миллионы треков.").fontWeight(.heavy).foregroundColor(.white)
                            .multilineTextAlignment(.center).font(.system(size: UIScreen.main.bounds.width/12, weight: .bold)).padding(.bottom,1.5)
                        Text("Бесплатно в JargalFy.").fontWeight(.heavy).foregroundColor(.white)
                            .multilineTextAlignment(.center).font(.system(size: UIScreen.main.bounds.width/12, weight: .bold))
                    }.padding(.horizontal)
                }.padding(.top,UIScreen.main.bounds.height/8)
                HStack{
                    if self.show == false {
                        VStack{
                            HStack{
                                Image(systemName: "person.crop.circle.fill").font(.system(size: UIScreen.main.bounds.width/10, weight: .regular)).padding(.leading,10).foregroundColor(.white)
                                TextField("Почта", text: self.$email).multilineTextAlignment(.leading).padding().foregroundColor(.white).font(.system(size: UIScreen.main.bounds.width/20, weight: .regular)).textContentType(.emailAddress)
                            }.background(Color.black)
                                .cornerRadius(20).padding(.horizontal).padding(.top,30)
                            HStack{
                                Image(systemName: "lock.fill").font(.system(size: UIScreen.main.bounds.width/10, weight: .regular)).padding(.leading,16).foregroundColor(.white)
                                if self.visible{
                                    
                                    TextField("Пароль", text: self.$pass)
                                        .multilineTextAlignment(.leading).padding().foregroundColor(.white).font(.system(size: UIScreen.main.bounds.width/20, weight: .regular))
                                }
                                else{
                                    
                                    SecureField("Пароль", text: self.$pass)
                                        .multilineTextAlignment(.leading).padding().foregroundColor(.white).font(.system(size: UIScreen.main.bounds.width/20, weight: .regular))
                                }
                                
                                Button(action: {
                                    
                                    self.visible.toggle()
                                    
                                }) {
                                    
                                    Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(Color.white.opacity(0.7))
                                }.padding(.trailing,15)
                            }.background(Color.black)
                                .cornerRadius(20).padding(.horizontal).padding(.top,5)
                            HStack{
                                Spacer()
                                
                                Button(action: {
                                    
                                    self.resetPassword()
                                    
                                }) {
                                    
                                    Text("Забыли пароль?")
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.black)
                                }
                            }.padding(.top,3).padding(.trailing,20).padding(.bottom,5)
                            HStack{
                                if self.alert{
                                    
                                    ErrorView(alert: self.$alert, error: self.$error)
                                }
                            }
                            HStack{
                                Button(action: {
                                    
                                    self.show.toggle()
                                    
                                }) {
                                    
                                    Text("Зарегистрироваться").foregroundColor(.white).padding(.horizontal,UIScreen.main.bounds.width/6).padding(.vertical,16).background(Color.init(red: 27.0/255.0, green: 155.0/255.0, blue: 0.0/255.0)).cornerRadius(20).font(.system(size: UIScreen.main.bounds.width/20, weight: .bold))
                                }
                            }.padding(.top,5)
                            HStack{
                                Button(action: {
                                    self.verify()
                                    
                                }) {
                                    
                                    Text("Войти").foregroundColor(.white).padding(.horizontal,UIScreen.main.bounds.width/2.9).padding(.vertical,16).background(Color.black).cornerRadius(20).font(.system(size: UIScreen.main.bounds.width/20, weight: .bold))
                                }.padding(.top,5).padding(.bottom,5)
                            }
                            
                        }
                    }
                }
            }
        }
        
        
    }
    
    private func verify(){
        
        if self.email != "" && self.pass != ""{
            
            Auth.auth().signIn(withEmail: self.email, password: self.pass) { (res, err) in
                if err != nil{
                    
                    self.error = err!.localizedDescription
                    self.error = "Не правильные данные!"
                    self.alert.toggle()
                    return
                }
                print("success")
                UserDefaults.standard.set(true, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                
            }
        }
        else{
            
            self.error = "Пожалуйста введите свою почту и пароль"
            self.alert.toggle()
        }
    }
    
    func resetPassword(){
        
        if self.email != ""{
            
            Auth.auth().sendPasswordReset(withEmail: self.email) { (err) in
                
                if err != nil{
                    
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                
                self.error = "Паспорт обнулен"
                self.alert.toggle()
            }
        }
        else{
            
            self.error = "Почта не найдена! Введите другую почту!"
            self.alert.toggle()
        }
    }
}

struct Registration : View {
    let currentDateTime = Date()
    @State var email = ""
    @State var pass = ""
    @State var repass = ""
    @State var visible = false
    @State var revisible = false
    @Binding var show : Bool
    @State var alert = false
    @State var error = ""
    
    var body: some View{
        if show == true {
            ZStack (alignment : .center){
                Color(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0).edgesIgnoringSafeArea(.all)
                VStack{
                    
                    HStack {
                        Text("Зарегистрируйте свой новый аккаунт в JargalFy").fontWeight(.heavy).foregroundColor(.white)
                            .multilineTextAlignment(.center).font(.system(size: UIScreen.main.bounds.width/16, weight: .bold)).padding(.horizontal).multilineTextAlignment(.center)
                    }.padding(.horizontal)
                    
                    HStack{
                        Image(systemName: "person.crop.circle.fill").font(.system(size: UIScreen.main.bounds.width/10, weight: .regular)).padding(.leading,10).foregroundColor(.white)
                        TextField("Почта", text: self.$email).multilineTextAlignment(.leading).padding().foregroundColor(.red).font(.system(size: UIScreen.main.bounds.width/20, weight: .regular)).textContentType(.emailAddress)
                    }.background(Color.black)
                        .cornerRadius(20).padding(.horizontal).padding(.top,20)
                    HStack{
                        Image(systemName: "lock.fill").font(.system(size: UIScreen.main.bounds.width/10, weight: .regular)).padding(.leading,10).foregroundColor(.white)
                        if self.visible{
                            
                            TextField("Пароль", text: self.$pass)
                                .multilineTextAlignment(.leading).padding().padding(.leading,5).foregroundColor(.red).font(.system(size: UIScreen.main.bounds.width/20, weight: .regular))
                        }
                        else{
                            
                            SecureField("Пароль", text: self.$pass)
                                .multilineTextAlignment(.leading).padding().padding(.leading,5).foregroundColor(.red).font(.system(size: UIScreen.main.bounds.width/20, weight: .regular))
                        }
                        
                        Button(action: {
                            
                            self.visible.toggle()
                            
                        }) {
                            
                            Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(Color.white.opacity(0.7))
                        }.padding(.trailing,15)
                    }.background(Color.black)
                        .cornerRadius(20).padding(.horizontal).padding(.top,5)
                    
                    HStack{
                        Image(systemName: "checkmark.circle.fill").font(.system(size: UIScreen.main.bounds.width/11, weight: .regular)).padding(.leading,10).foregroundColor(.white)
                        if self.revisible{
                            
                            TextField("Повторите пароль", text: self.$repass)
                                .multilineTextAlignment(.leading).padding().padding(.leading,5).foregroundColor(.red).font(.system(size: UIScreen.main.bounds.width/20, weight: .regular))
                        }
                        else{
                            
                            SecureField("Повторите пароль", text: self.$repass)
                                .multilineTextAlignment(.leading).padding().padding(.leading,5).foregroundColor(.red).font(.system(size: UIScreen.main.bounds.width/20, weight: .regular))
                        }
                        
                        Button(action: {
                            
                            self.revisible.toggle()
                            
                        }) {
                            
                            Image(systemName: self.revisible ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(Color.white.opacity(0.7))
                        }.padding(.trailing,15)
                    }.background(Color.black)
                        .cornerRadius(20).padding(.horizontal).padding(.top,5)
                    HStack{
                        if self.alert{
                            
                            ErrorView(alert: self.$alert, error: self.$error).padding(.vertical,5)
                        }
                    }
                    HStack{
                        Button(action: {
                            
                            self.register()
                        }) {
                            
                            Text("Зарегистироваться")
                                .foregroundColor(.white).padding(.horizontal,UIScreen.main.bounds.width/6).padding(.vertical,16).background(Color.init(red: 27.0/255.0, green: 155.0/255.0, blue: 0.0/255.0)).cornerRadius(20).font(.system(size: UIScreen.main.bounds.width/20, weight: .bold))
                        }
                    }.padding(.top,20)
                }
            }.navigationBarBackButtonHidden(false).frame(height: UIScreen.main.bounds.height, alignment: .center)
        }
    }
    
    func register(){
        
        if self.email != ""{
            
            if self.pass == self.repass{
                
                Auth.auth().createUser(withEmail: self.email, password: self.pass) { (res, err) in
                    guard let user = res?.user else { return }
                    if err != nil{
                        
                        self.error = err!.localizedDescription
                        self.alert.toggle()
                        return
                    }
                    let uid = user.uid
                    let ratingDictionary = [
                        "Login": email,
                        "Password": pass,
                        "Data Registration" : currentDateTime
                        
                    ] as [String : Any]
                    let docRef = Firestore.firestore().document("users/\(uid)")
                    print("setting data")
                    docRef.setData(ratingDictionary){ (error) in
                        if let error = error {
                            print("error = \(error)")
                        } else {
                            print("data uploaded successfully")
                            
                        }
                    }
                    
                    let ArtistMode = Firestore.firestore().document("users/\(uid)/ArtistMode/\(uid)")
                    let ArtistOptions = [
                        "Artist": false
                    ] as [String : Any]
                    ArtistMode.setData(ArtistOptions){ (error) in
                        if let error = error {
                            print("error = \(error)")
                        } else {
                            print("data uploaded successfully")
                            
                        }
                    }
                    
                    let lovePlayList = Firestore.firestore().document("users/\(uid)/PlaylistUser/MyLoveTrack/MyLoveTrack/MyLoveTrack")
                    let MyLoveTrack = [
                        "NamePlayList": "Любимые треки",
                        "Image" : Array<String>(),
                        "NameArtist" : Array<String>(),
                        "NameTrack" : Array<String>(),
                        "TextTrack" : Array<String>(),
                        "ssilka" : Array<String>()
                    ] as [String : Any]
                    lovePlayList.setData(MyLoveTrack){ (error) in
                        if let error = error {
                            print("error = \(error)")
                        } else {
                            print("data uploaded successfully")
                            
                        }
                    }
                    
                    let docList = Firestore.firestore().document("users/\(uid)/usersList/PlayListUserArray")
                    let SetData = [
                        "MassPlayList": ["MyLoveTrack"],
                        "CountTrack" : [0]
                    ] as [String : Any]
                    docList.setData(SetData){ (error) in
                        if let error = error {
                            print("error = \(error)")
                        } else {
                            print("data uploaded successfully")
                            
                        }
                    }
                    let docSearch = Firestore.firestore().document("users/\(uid)/Search/Search")
                    let SearchData = [
                        "NameTrack": Array<String>(),
                        "nameArtist": Array<String>()
                    ] as [String : Any]
                    docSearch.setData(SearchData){ (error) in
                        if let error = error {
                            print("error = \(error)")
                        } else {
                            print("data uploaded successfully")
                            
                        }
                    }
                    let MyMusik = Firestore.firestore().document("users/\(uid)/MyMusik/MyMusik")
                    let MusikMy = [
                        "Image" : Array<String>(),
                        "NameArtist" : Array<String>(),
                        "NameTrack" : Array<String>(),
                        "TextTrack" : Array<String>(),
                        "ssilka" : Array<String>()
                    ] as [String : Any]
                    MyMusik.setData(MusikMy){ (error) in
                        if let error = error {
                            print("error = \(error)")
                        } else {
                            print("data uploaded successfully")
                            
                        }
                    }
                    print("success")
                    
                    UserDefaults.standard.set(true, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                }
            }
            else{
                
                self.error = "Пароль неправильный!"
                self.alert.toggle()
            }
        }
        else{
            
            self.error = "Пожалуйста введите свою почту и пароль!"
            self.alert.toggle()
        }
    }
}


struct ErrorView : View {
    @Binding var alert : Bool
    @Binding var error : String
    var body: some View{
        ZStack{
            HStack{
                
                if self.error == "ResetPassword" || self.error == "Паспорт обнулен"{
                    if self.error == "Паспорт обнулен"{
                        HStack{
                            
                            Text("На вашей почте ссылка на восстановление пароля").foregroundColor(.black).font(.system(size: UIScreen.main.bounds.width/24, weight: .bold)).padding(.leading,UIScreen.main.bounds.width/24)
                            Button(action: {
                                
                                self.alert.toggle()
                                
                            }) {
                                Text("Скрыть").foregroundColor(.white).font(.system(size: UIScreen.main.bounds.width/28, weight: .bold)).padding(.horizontal,3)
                            }
                        }.frame(width: UIScreen.main.bounds.width-60,height: UIScreen.main.bounds.width/20+40, alignment: .center).background(Color.init(red: 27.0/255.0, green: 155.0/255.0, blue: 0.0/255.0)).font(.system(size: UIScreen.main.bounds.width/20)).cornerRadius(20).padding(.top,3)
                    }
                    
                }
                else{
                    
                    HStack{
                        
                        Text(self.error).foregroundColor(.black).font(.system(size: UIScreen.main.bounds.width/24, weight: .bold)).padding(.leading,UIScreen.main.bounds.width/24)
                        Button(action: {
                            
                            self.alert.toggle()
                            
                        }) {
                            Text("Скрыть").foregroundColor(.white).font(.system(size: UIScreen.main.bounds.width/28, weight: .bold)).padding(.horizontal,3)
                        }
                    }.frame(width: UIScreen.main.bounds.width-60,height: UIScreen.main.bounds.width/20+40, alignment: .center).background(Color(red: 204.0/255.0, green: 25.0/255.0, blue: 42.0/255.0)).font(.system(size: UIScreen.main.bounds.width/20)).cornerRadius(20).padding(.top,3)
                    
                }
                
            }
        }
        
    }
}

