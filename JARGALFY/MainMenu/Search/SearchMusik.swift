//
//  SearchMusik.swift
//  JARGALFY
//
//  Created by Антон Зайцев on 02.11.2020.
//

import SwiftUI

struct SearchMusik: View {
    @EnvironmentObject var search : SearchMusikJargalFy
    @Binding var togleBar: Bool
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
    var body: some View {
        if !togleBar{
        ZStack{
            VStack{
                HStack{
                    Text("Поиск").fontWeight(.bold).font(.system(size:UIScreen.main.bounds.width/12)).foregroundColor(.white).padding(.leading).padding(.top,10)
                    Spacer()
                }
                HStack{
                    Button(action: {togleBar = true
                        seeTabBar.toggle()
                    }) {
                        Image(systemName: "magnifyingglass").font(.system(size: UIScreen.main.bounds.width/14, weight: .regular)).foregroundColor(Color(red: 179.0/255.0, green: 179.0/255.0, blue: 179.0/255.0))
                        Text("Исполнитель, трек или альбом").multilineTextAlignment(.leading).foregroundColor(.black).font(.system(size: UIScreen.main.bounds.width/25, weight: .regular))
                    }.padding(.horizontal).padding(.vertical,5)
                    Spacer()
                }.background( RoundedRectangle( cornerRadius: 10).fill(Color.white)).padding(.horizontal)
                .padding(.vertical,7)
                HStack{
                    Text("Топ жанров").fontWeight(.bold).font(.system(size:UIScreen.main.bounds.width/23)).foregroundColor(.white).padding(.horizontal).padding(.vertical,7)
                    Spacer()
                }
                VStack{
                    HStack{
                        ZStack (alignment: .topLeading){
                        RoundedRectangle( cornerRadius: 10).fill(Color.orange)
                            Text("Хип-Хоп").fontWeight(.bold).font(.system(size:UIScreen.main.bounds.width/26)).foregroundColor(.white).padding()
                        }
                        ZStack (alignment: .topLeading){
                        RoundedRectangle( cornerRadius: 10).fill(Color.green)
                            Text("Поп").fontWeight(.bold).font(.system(size:UIScreen.main.bounds.width/26)).foregroundColor(.white).padding()
                        }
                    }.frame(height: 100).padding(.horizontal)
                    HStack{
                        ZStack (alignment: .topLeading){
                        RoundedRectangle( cornerRadius: 10).fill(Color.red)
                            Text("Рок").fontWeight(.bold).font(.system(size:UIScreen.main.bounds.width/26)).foregroundColor(.white).padding()
                        }
                        ZStack (alignment: .topLeading){
                        RoundedRectangle( cornerRadius: 10).fill(Color.blue)
                            Text("Инди").fontWeight(.bold).font(.system(size:UIScreen.main.bounds.width/26)).foregroundColor(.white).padding()
                        }
                    }.frame(height: 100).padding(.horizontal)
                        
                    
                    
                }
            }
        }
        }
        else {
            SearchBar(togleBar: $togleBar,boolNextAuido: $boolNextAuido, countMusik: $countMusik, seeAudioplay: $seeAudioplay, isDownloading: $isDownloading, safeURL: $safeURL, playAndpausetogle: $playAndpausetogle, nameArtistSearch:$nameArtistSearch,NameTrackSearch:$NameTrackSearch,seeTabBar: $seeTabBar, indexPlayer: $indexPlayer).environmentObject(search)
        }
    }
}

//struct SearchMusik_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchMusik()
//    }
//}
