//
//  SearchBar.swift
//  JARGALFY
//
//  Created by Антон Зайцев on 03.11.2020.
//

import SwiftUI
import RemoteImage
import Firebase
struct SearchBar: View {
    @EnvironmentObject var search : SearchMusikJargalFy
    @Binding var togleBar: Bool
    @State var poisk : String = ""
    @Binding var boolNextAuido : Bool
    @Binding var countMusik : Int
    @Binding var seeAudioplay : Bool
    @Binding var isDownloading : Bool
    @Binding var safeURL : Array<String>
    @Binding var playAndpausetogle : Bool
    @Binding var nameArtistSearch: Array<String>
    @Binding var NameTrackSearch: Array<String>
    @Binding var seeTabBar : Bool
    @Binding var indexPlayer : Int
    let user = Auth.auth().currentUser
    func RecordHistorySearch(nameArtist : String,NameTrack : String){
        var count = 0
        for i in 0..<nameArtistSearch.count{
            if (nameArtistSearch[i] == nameArtist && NameTrackSearch[i] == NameTrack){
                count += 1
            }
        }
        if count == 0 {
            nameArtistSearch.append(nameArtist)
            NameTrackSearch.append(NameTrack)
            if let user = user {
                let uid = user.uid
                let ratingDictionary = [
                    "nameArtist": nameArtistSearch,
                    "NameTrack" : NameTrackSearch,
                ] as [String : Any]
                let docRef = Firestore.firestore().document("users/\(uid)/Search/Search")
                
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
    func DeleteHistorySearch(nameArtist : String,NameTrack : String){
        if let indexArtist = nameArtistSearch.firstIndex(of: nameArtist) {
            if let indexTrack = NameTrackSearch.firstIndex(of: NameTrack) {
                nameArtistSearch.remove(at: indexArtist )
                NameTrackSearch.remove(at: indexTrack )
            }
        }
        if let user = user {
            let uid = user.uid
            let ratingDictionary = [
                "nameArtist": nameArtistSearch,
                "NameTrack" : NameTrackSearch,
            ] as [String : Any]
            let docRef = Firestore.firestore().document("users/\(uid)/Search/Search")
            
            docRef.setData(ratingDictionary){ (error) in
                if let error = error {
                    print("error = \(error)")
                } else {
                    print("data uploaded successfully")
                    
                }
            }
        }
    }
    func ClearHistorySearch(){
        nameArtistSearch.removeAll()
        NameTrackSearch.removeAll()
        if let user = user {
            let uid = user.uid
            let ratingDictionary = [
                "nameArtist": nameArtistSearch,
                "NameTrack" : NameTrackSearch,
            ] as [String : Any]
            let docRef = Firestore.firestore().document("users/\(uid)/Search/Search")
            
            docRef.setData(ratingDictionary){ (error) in
                if let error = error {
                    print("error = \(error)")
                } else {
                    print("data uploaded successfully")
                    
                }
            }
        }
    }
    var body: some View {
        ZStack (alignment: . top){
            Color(red: 18.0/255.0, green: 18.0/255.0, blue: 18.0/255.0).edgesIgnoringSafeArea(.all)
            VStack{
                VStack{
                    HStack{
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
                            .padding(.vertical,7)
                        Button(action: {
                            if poisk.isEmpty {
                                togleBar = false
                                seeTabBar.toggle()
                                poisk = ""
                            }
                            else{
                                poisk = ""
                            }
                        }) {
                            Text("Отмена").padding(.trailing,20).foregroundColor(.white).font(.system(size: UIScreen.main.bounds.width/27, weight: .regular))
                        }
                    }
                }.background(Color(red: 24.0/255.0, green: 24.0/255.0, blue: 24.0/255.0).edgesIgnoringSafeArea(.all))
                if self.search.Search.count != 0{
                    ForEach(self.search.Search){i in
                        ScrollView(.vertical, showsIndicators: true) {
                            if poisk.isEmpty {
                                VStack{
                                    HStack{
                                        Text("История поиска").fontWeight(.bold).font(.system(size:UIScreen.main.bounds.width/23)).foregroundColor(.white).padding(.leading,20)
                                        Spacer()
                                    }
                                    ForEach(i.NameTrack.indices,id: \.self){
                                        index in
                                        ForEach(NameTrackSearch.indices,id: \.self){
                                            indexHistory in
                                            if (i.NameTrack[index] == NameTrackSearch[indexHistory] ){
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
                                                        Text(i.NameTrack[index]).fontWeight(.bold).foregroundColor(.white).padding(.leading,10).font(.system(size: UIScreen.main.bounds.width/24))
                                                        Text(i.NameArtist[index]).foregroundColor(.gray).padding(.leading,10).font(.system(size: UIScreen.main.bounds.width/29))
                                                    }
                                                    Spacer()
                                                    Button(action: {
                                                        withAnimation(.easeIn){DeleteHistorySearch(nameArtist: i.NameArtist[index], NameTrack: i.NameTrack[index])}
                                                    }) {
                                                        Image(systemName: "xmark").font(.system(size: UIScreen.main.bounds.width/27)).foregroundColor(.gray)
                                                    }.padding(.trailing,15)
                                                }.padding(.leading,20).padding(.bottom,5)
                                                    .onTapGesture{
                                                        seeAudioplay = false
                                                        indexPlayer = 2
                                                        boolNextAuido = true
                                                        playAndpausetogle = true
                                                        countMusik = index
                                                        seeAudioplay = true
                                                    }
                                                    .onChange(of: index, perform: { value in
                                                        countMusik = index
                                                    })
                                                
                                                
                                            }
                                            
                                            
                                        }
                                    }
                                    if NameTrackSearch.count != 0 {
                                        HStack{
                                            Button(action: { withAnimation(.easeIn){ClearHistorySearch()}
                                            }) {
                                                Text("ОЧИСТИТЬ ИСТОРИЮ ПОИСКА").fontWeight(.bold).foregroundColor(.white).padding(.vertical,6).font(.system(size: UIScreen.main.bounds.width/35))
                                            }.padding(.horizontal).overlay(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(Color.gray, lineWidth: 1)
                                            )
                                        }.padding(.top,5)
                                        
                                    }
                                }
                            }
                            else {
                                VStack{
                                    ForEach(i.NameTrack.filter{$0.hasPrefix(poisk) || poisk == ""} , id: \.self) { resultpoisk in
                                        ForEach(i.NameTrack.indices,id: \.self){
                                            index in
                                            if (i.NameTrack[index]).uppercased() == resultpoisk.uppercased() {
                                                HStack{
                                                    RemoteImage(type: .url(URL(string: i.Image.count == 1 ? i.Image [0] : i.Image [index])!), errorView: { error in
                                                        Text(error.localizedDescription)
                                                    }, imageView: { image in
                                                        image
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                    }, loadingView: {
                                                        ProgressView()
                                                    }).frame(width: 60, height: 60)
                                                    VStack (alignment: .leading){
                                                        Text(i.NameTrack[index]).fontWeight(.bold).foregroundColor(.white).padding(.leading,10).font(.system(size: UIScreen.main.bounds.width/23))
                                                        Text(i.NameArtist[index]).foregroundColor(.gray).padding(.leading,10)
                                                    }
                                                    Spacer()
                                                }.padding(.leading,20).padding(.bottom,5)
                                                
                                                    .onTapGesture{
                                                        countMusik = index
                                                        self.seeAudioplay = false
                                                        boolNextAuido = true
                                                        playAndpausetogle = true
                                                        self.seeAudioplay = true
                                                        indexPlayer = 2
                                                        for i in search.Search {
                                                            RecordHistorySearch( nameArtist: i.NameArtist[index], NameTrack: i.NameTrack[index])
                                                        }
                                                    }
                                                    .onChange(of: index, perform: { value in
                                                        countMusik = index
                                                        
                                                    })
                                                
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
}

