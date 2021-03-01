//
//  GetDataTop.swift
//  JARGALFY
//
//  Created by Антон Зайцев on 07.10.2020.
//

import SwiftUI
import Firebase

struct DataMain : Identifiable {
    
    var id : String
    var CommentPlayList: Array<String>
    var ImageArray : Array<String>
    var NamePlayList : Array<String>
    var NewColorList : Array<Int>
    var Index : Array<Int>
    var PATH : Array<String>
}
struct MusikFile : Identifiable {
    
    var id : String
    var Image : Array<String>
    var NameArtist : Array<String>
    var NameTrack : Array<String>
    var ssilka : Array<String>
    var NameAlbom : String
    var TextTrack : Array<String>
    var NewColorList : Array<Int>
}
struct SearchMusikData : Identifiable {
    
    var id : String
    var Image : Array<String>
    var NameArtist : Array<String>
    var NameTrack : Array<String>
    var ssilka : Array<String>
    var NameAlbom : String
    var TextTrack : Array<String>
}
struct SearchHistory : Identifiable {
    
    var id : String
    var NameArtist : Array<String>
    var NameTrack : Array<String>
}
struct PlayListUserArray : Identifiable {
    
    var id : String
    var countTrack : Array<Int>
    var MassPlayList : Array<String>
}
struct PlayListUserArrayClick : Identifiable {
    
    var id : String
    var Image : Array<String>
    var NameArtist : Array<String>
    var NameTrack : Array<String>
    var ssilka : Array<String>
    var TextTrack : Array<String>
    var NamePlayList : String
}
struct MediaTeack : Identifiable {
    
    var id : String
    var Image : Array<String>
    var NameArtist : Array<String>
    var NameTrack : Array<String>
    var ssilka : Array<String>
    var TextTrack : Array<String>
}
class DataMainMenu : ObservableObject{
    
    @Published var datas = [DataMain]()
    init() {
        let collectionAndDocuments = "MenuCollection"
        let db = Firestore.firestore()
        
        db.collection(collectionAndDocuments).document(collectionAndDocuments).collection(collectionAndDocuments).addSnapshotListener { (snap, err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
            
            for i in snap!.documentChanges{
                
                if i.type == .added{
                    
                    let id = i.document.documentID
                    let CommentPlayList = i.document.get("CommentPlayList") as! Array<String>
                    let ImageArray = i.document.get("ImageArray") as! Array<String>
                    let NamePlayList = i.document.get("NamePlayList") as! Array<String>
                    let NewColorList = i.document.get("NewColorList") as! Array<Int>
                    let Index = i.document.get("Index") as! Array<Int>
                    let PATH = i.document.get("PATH") as! Array<String>
                    self.datas.append(DataMain(id: id, CommentPlayList: CommentPlayList, ImageArray: ImageArray, NamePlayList: NamePlayList, NewColorList: NewColorList,Index: Index,PATH: PATH))
                }
            }
        }
    }
}
class SearchMusikJargalFy : ObservableObject{
    
    @Published var Search = [SearchMusikData]()
    init() {
        let db = Firestore.firestore()
        db.collection("Search").addSnapshotListener { (snap, err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
            for i in snap!.documentChanges{
                if i.type == .added{
                    let id = i.document.documentID
                    let Image = i.document.get("Image") as! Array<String>
                    let NameArtist = i.document.get("NameArtist") as! Array<String>
                    let NameTrack = i.document.get("NameTrack") as! Array<String>
                    let ssilka = i.document.get("ssilka") as! Array<String>
                    let TextTrack = i.document.get("TextTrack") as! Array<String>
                    self.Search.append(SearchMusikData(id: id, Image: Image, NameArtist: NameArtist, NameTrack: NameTrack, ssilka: ssilka, NameAlbom: "", TextTrack: TextTrack))
                }
            }
        }
    }
    
}
class Searchhistory : ObservableObject{
    
    @Published var Search = [SearchHistory]()
    init() {
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            db.collection("users").document(uid).collection("Search").addSnapshotListener { (snap, err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
            for i in snap!.documentChanges{
                if i.type == .added{
                    let id = i.document.documentID
                    let NameArtist = i.document.get("nameArtist") as! Array<String>
                    let NameTrack = i.document.get("NameTrack") as! Array<String>
                    self.Search.append(SearchHistory(id: id, NameArtist: NameArtist, NameTrack: NameTrack))
                }
            }
            }
        }
    }
}

class NewSong : ObservableObject{
    @Published var datas = [MusikFile]()
    var collection1: String?
    var documents1: String?
    var collection2: String?
    var documents2: String?
    var collection3: String?
    let db = Firestore.firestore()
    init(collection1: String, documents1: String,collection2: String,documents2: String,collection3: String ) {
        self.collection1 = collection1
        self.documents1 = documents1
        self.collection2 = documents2
        self.documents2 = documents2
        self.collection3 = collection3
        UPDATE(collection1: collection1, documents1: documents1, collection2: collection2, documents2: documents2, collection3: collection3)
            }
    func UPDATE(collection1: String,documents1: String,collection2: String,documents2: String,collection3: String ){
        let db = Firestore.firestore()
        db.collection(collection1).document(documents1).collection(collection2).document(documents2).collection(collection3).addSnapshotListener { (snap, err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
            for i in snap!.documentChanges{
                self.datas.removeAll()
                if i.type == .added{
                    
                    let id = i.document.documentID
                    let Image = i.document.get("Image") as! Array<String>
                    let NameArtist = i.document.get("NameArtist") as! Array<String>
                    let NameTrack = i.document.get("NameTrack") as! Array<String>
                    let ssilka = i.document.get("Ссылки") as! Array<String>
                    let NameAlbom = i.document.get("NameAlbom") as! String
                    let TextTrack = i.document.get("TextTrack") as! Array<String>
                    let NewColorList = i.document.get("NewColorList") as! Array<Int>
                    self.datas.append(MusikFile(id: id, Image: Image, NameArtist: NameArtist, NameTrack: NameTrack, ssilka: ssilka, NameAlbom: NameAlbom, TextTrack: TextTrack, NewColorList: NewColorList))
                }
            }
        }
    }
}

class PlayListData : ObservableObject{
    
    @Published var DataPlayList = [PlayListUserArray]()
    init() {
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            db.collection("users").document(uid).collection("usersList").addSnapshotListener { (snap, err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
            for i in snap!.documentChanges{
                self.DataPlayList.removeAll()
                if i.type == .added{
                    let id = i.document.documentID
                    let CountTrack = i.document.get("CountTrack") as! Array<Int>
                    let MassPlayList = i.document.get("MassPlayList") as! Array<String>
                    self.DataPlayList.append(PlayListUserArray(id: id, countTrack: CountTrack, MassPlayList: MassPlayList))
                }
            }
            }
        }
    }
}

class PlayListDataClick : ObservableObject{
    
    @Published var DataPlayListClick = [PlayListUserArrayClick]()
    var NamePlayList: String = "MyLoveTrack"
    let db = Firestore.firestore()
    init() {
        UPDATE(NamePlayList: NamePlayList )
    }
    func UPDATE(NamePlayList: String ){
        
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
        db.collection("users").document(uid).collection("PlaylistUser").document(NamePlayList).collection(NamePlayList).addSnapshotListener { (snap, err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
            else {
                self.DataPlayListClick.removeAll()
            }
            for i in snap!.documentChanges{
                if i.type == .added{
                    let id = i.document.documentID
                    let Image = i.document.get("Image") as! Array<String>
                    let NameArtist = i.document.get("NameArtist") as! Array<String>
                    let NamePlayList = i.document.get("NamePlayList") as! String
                    let NameTrack = i.document.get("NameTrack") as! Array<String>
                    let TextTrack = i.document.get("TextTrack") as! Array<String>
                    let ssilka = i.document.get("ssilka") as! Array<String>
                    self.DataPlayListClick.append(PlayListUserArrayClick(id: id, Image: Image, NameArtist: NameArtist, NameTrack: NameTrack, ssilka: ssilka, TextTrack: TextTrack, NamePlayList: NamePlayList))
                }
            }
            }
        
    }
    
}
}
class MyLoveMedia : ObservableObject{
    
    @Published var MediaData = [MediaTeack]()
    init() {
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            db.collection("users").document(uid).collection("MyMusik").addSnapshotListener { (snap, err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
            for i in snap!.documentChanges{
                if i.type == .added{
                    let id = i.document.documentID
                    let Image = i.document.get("Image") as! Array<String>
                    let NameArtist = i.document.get("NameArtist") as! Array<String>
                    let NameTrack = i.document.get("NameTrack") as! Array<String>
                    let TextTrack = i.document.get("TextTrack") as! Array<String>
                    let ssilka = i.document.get("ssilka") as! Array<String>
                    self.MediaData.append(MediaTeack(id: id, Image: Image, NameArtist: NameArtist, NameTrack: NameTrack, ssilka: ssilka, TextTrack: TextTrack))
                }
            }
            }
        }
    }
}
