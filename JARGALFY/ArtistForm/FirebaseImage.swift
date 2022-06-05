//
//  FirebaseImage.swift
//  JARGALFY
//
//  Created by Антон Зайцев on 17.12.2020.
//
import SwiftUI
import Combine
import FirebaseStorage
import UIKit

struct FirebaseImageView: View {
    @ObservedObject var imageLoader:DataLoader
    @State var image:UIImage = UIImage()
    init(imageURL: String) {
        imageLoader = DataLoader(urlString:imageURL)
    }
    let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
    var body: some View {
        VStack {
            
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(50)
                .frame(width: 200, height: 200)
        }.onReceive(imageLoader.didChange) { data in
            self.image = UIImage(data: data) ?? UIImage()
        }
    }
}

class DataLoader: ObservableObject {
    @Published var didChange = PassthroughSubject<Data, Never>()
    @Published var data = Data() {
        didSet {
            didChange.send(data)
        }
    }
    
    init(urlString:String) {
        getDataFromURL(urlString: urlString)
    }
    
    func getDataFromURL(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }.resume()
    }
}
