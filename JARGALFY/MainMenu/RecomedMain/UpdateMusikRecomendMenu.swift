//
//  UpdateMusikRecomendMenu.swift
//  JARGALFY
//
//  Created by Антон Зайцев on 09.11.2020.
//
import SwiftUI
import RemoteImage
import Firebase

struct UpdateMusikRecomendMenu: View {
    var edges = UIApplication.shared.windows.first?.safeAreaInsets
    @EnvironmentObject var datasongsAlbom : NewSong
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
    var body: some View{
        if self.datasongsAlbom.datas.count != 0{
            ForEach(self.datasongsAlbom.datas){ i in
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                    if  i.NewColorList.count != 0 {
                        LinearGradient(gradient: Gradient(colors: [Color.init(red: Double(i.NewColorList[0])/255.0, green: Double(i.NewColorList[1])/255.0, blue: Double(i.NewColorList[2])/255.0),Color.init(red: Double(i.NewColorList[3])/255.0, green: Double(i.NewColorList[4])/255.0, blue: Double(i.NewColorList[5])/255.0)]), startPoint: .top, endPoint:.center).edgesIgnoringSafeArea(.all)
                    }
                    else {
                        LinearGradient(gradient: Gradient(colors: [Color.init(red: 5.0/255.0, green: 127.0/255.0, blue: 242.0/255.0),Color.init(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0)]), startPoint: .top, endPoint: .center).edgesIgnoringSafeArea(.all)
                    }
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        VStack{
                            GeometryReader{reader in
                                
                                VStack{
                                    
                                    RemoteImage(type: .url(URL(string: i.NameAlbom != "Новая Музыка" ? i.Image[0] : i.Image[(i.Image.count - 1)])!), errorView: { error in
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
                            if i.NameAlbom != "Новая Музыка"{
                                AlbomMusik()
                            }
                            else {
                                NewMusik()
                            }
                        }
                        
                    }
                    ForEach(self.datasongsAlbom.datas){ i in
                        HStack{
                            ZStack{
                                Button(action: {withAnimation{self.indexAlbom = 0}}) {
                                    
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
                                        if  i.NameAlbom.count <= 12 {
                                            Text(i.NameAlbom).fontWeight(.bold).foregroundColor(i.NewColorList.count != 0 ? .white : .black).font(.title2)
                                        }
                                        else {
                                            Text(i.NameAlbom).fontWeight(.bold).foregroundColor(i.NewColorList.count != 0 ? .white : .black).font(.title3).padding(.leading,15)
                                        }
                                    }
                                }
                            }
                            Spacer()
                        }
                        .padding()
                        .foregroundColor(opacity > 0.6 ? .black : .white)
                        .padding(.top,edges!.top)
                        .background( i.NewColorList.count != 0 ? Color.init(red: Double(i.NewColorList[0])/255.0, green: Double(i.NewColorList[1])/255.0, blue: Double(i.NewColorList[2])/255.0).opacity(opacity) : Color.white.opacity(opacity))
                        .shadow(color: Color.black.opacity(opacity > 0.8 ? 0.1 : 0), radius: 5, x: 0, y: 5)
                    }
                }.ignoresSafeArea(.all, edges: .top)
            }
        }
    }
    private func AlbomMusik() -> some View {
        return VStack{
            ForEach(self.datasongsAlbom.datas){ i in
                VStack{
                    HStack{
                        VStack (alignment: .leading){
                            Text(i.NameAlbom).fontWeight(.bold).padding(.leading,20).foregroundColor(.white).font(.title)
                            Text(i.NameTrack.count == 1 ? "2020, \(i.NameTrack.count) трек." :"2020, \(i.NameTrack.count) треков.").padding(.leading,20).foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    VStack{
                        ForEach(0..<i.NameTrack.count, id: \.self) { index in
                            HStack{
                                RemoteImage(type: .url(URL(string: i.Image.count == 1 ? i.Image[0] : i.Image[index])!), errorView: { error in
                                    Text(error.localizedDescription)
                                }, imageView: { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                }, loadingView: {
                                    ProgressView()
                                }).frame(width: 60, height: 60)
                                VStack (alignment: .leading){
                                    Text(i.NameTrack[index]).fontWeight(.bold).tag(index).foregroundColor(countMusik == index && seeAudioplay == true  ? .green : .white).padding(.leading,10).font(.system(size: UIScreen.main.bounds.width/23))
                                    Text(i.NameArtist[index]).foregroundColor(.gray).padding(.leading,10)
                                }
                                Spacer()
                                
                            }.padding(.leading,20).padding(.bottom,5)
                            
                                .onTapGesture{
                                    self.seeAudioplay = false
                                    self.countMusik = index
                                    boolNextAuido = true
                                    playAndpausetogle = true
                                    self.seeAudioplay = true
                                    indexPlayer = 1
                                }
                                .onChange(of: index, perform: { value in
                                    self.countMusik = index
                                    
                                })
                            
                        }
                    }
                }
                .padding(.top,5).padding(.bottom,10)
                .background(i.NewColorList.count != 0 ? LinearGradient(gradient: Gradient(colors: [Color.init(red: Double(i.NewColorList[0])/255.0, green: Double(i.NewColorList[1])/255.0, blue: Double(i.NewColorList[2])/255.0),Color.init(red: Double(i.NewColorList[3])/255.0, green: Double(i.NewColorList[4])/255.0, blue: Double(i.NewColorList[5])/255.0)]), startPoint: .top, endPoint:.center).edgesIgnoringSafeArea(.all) : LinearGradient(gradient: Gradient(colors: [Color.init(red: 5.0/255.0, green: 127.0/255.0, blue: 242.0/255.0),Color.init(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0)]), startPoint: .top, endPoint: .center).edgesIgnoringSafeArea(.all))
            }
        }
        
    }
    private func NewMusik() -> some View {
        return
        VStack{
            ForEach(self.datasongsAlbom.datas){ i in
                VStack{
                    HStack{
                        VStack (alignment: .leading){
                            Text(i.NameAlbom).fontWeight(.bold).padding(.leading,20).foregroundColor(.white).font(.title)
                            Text(i.NameTrack.count == 1 ? "2020, \(i.NameTrack.count) трек." :"2020, \(i.NameTrack.count) треков.").padding(.leading,20).foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    ForEach((0..<i.NameTrack.count).reversed(), id: \.self) { index in
                        HStack{
                            RemoteImage(type: .url(URL(string: i.Image.count == 1 ? i.Image[0] : i.Image[index])!), errorView: { error in
                                Text(error.localizedDescription)
                            }, imageView: { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }, loadingView: {
                                ProgressView()
                            }).frame(width: 60, height: 60)
                            VStack (alignment: .leading){
                                Text(i.NameTrack[index]).fontWeight(.bold).tag(index).foregroundColor(countMusik == index && seeAudioplay == true  ? .green : .white).padding(.leading,10).font(.system(size: UIScreen.main.bounds.width/23))
                                Text(i.NameArtist[index]).foregroundColor(.gray).padding(.leading,10)
                            }
                            Spacer()
                        }.padding(.leading,20).padding(.bottom,5)
                        
                            .onTapGesture{
                                self.seeAudioplay = false
                                self.countMusik = index
                                boolNextAuido = true
                                playAndpausetogle = true
                                self.seeAudioplay = true
                                indexPlayer = 1
                            }
                            .onChange(of: index, perform: { value in
                                self.countMusik = index
                                
                            })
                        
                        
                    }
                    
                }
                .padding(.top,5).padding(.bottom,10)
                .background(i.NewColorList.count != 0 ? LinearGradient(gradient: Gradient(colors: [Color.init(red: Double(i.NewColorList[0])/255.0, green: Double(i.NewColorList[1])/255.0, blue: Double(i.NewColorList[2])/255.0),Color.init(red: Double(i.NewColorList[3])/255.0, green: Double(i.NewColorList[4])/255.0, blue: Double(i.NewColorList[5])/255.0)]), startPoint: .top, endPoint:.center).edgesIgnoringSafeArea(.all) : LinearGradient(gradient: Gradient(colors: [Color.init(red: 5.0/255.0, green: 127.0/255.0, blue: 242.0/255.0),Color.init(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0)]), startPoint: .top, endPoint: .center).edgesIgnoringSafeArea(.all))
            }
        }
    }
}


