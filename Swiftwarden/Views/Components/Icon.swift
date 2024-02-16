//
//  Icon.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2023-05-16.
//

import SwiftUI
import Nuke
import NukeUI

struct Icon: View {
    let hostname: String?
    let itemType: ItemType
    
    var api: Api?
    let priority: ImageRequest.Priority
    init(itemType: ItemType, hostname: String? = nil, priority: ImageRequest.Priority = .high, api: Api? = nil) {
        self.itemType = itemType
        self.hostname = hostname
        self.priority = priority
        self.api = api
        ImagePipeline.Configuration.isSignpostLoggingEnabled = true
    }
    
//    let pipeline =
//    ImagePipeline {
//        $0.dataLoader = DataLoader(configuration: {
//            // Disable disk caching built into URLSession
//            let conf = DataLoader.defaultConfiguration
//            conf.urlCache = nil
//            return conf
//        }())
//
//        $0.imageCache = ImageCache()
//        $0.dataCache = try! DataCache(name: "com.github.kean.Nuke.DataCache")
//    }
//    ImagePipeline {
//        $0.dataCache = try? DataCache(name: "com.swiftwarden.datacache")
//        $0.dataCachePolicy = .storeAll
//    }

//    private let pipeline = ImagePipeline {
//        $0.dataLoader = {
//            let config = URLSessionConfiguration.default
//            config.urlCache = nil
//            return DataLoader(configuration: config)
//        }()
//
////        $0.imageCache = ImageCache()
//    }
        
    var body: some View {
        let _ = print(itemType)
        if itemType == .password {
            LazyImage(url: api?.getIcons(host: hostname ?? "")) { state in
                if let image = state.image {
                    image
                        .resizable()
                        .background(.white)
                        .clipShape(Rectangle())
                        .cornerRadius(5)
                        .frame(width: 35, height: 35)
                } else {
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(width: 35, height: 35)
                        .cornerRadius(5)
                        .overlay(
                            Circle()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.black)
                                .overlay(
                                    Image(systemName: "lock.square.fill")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .frame(width: 35, height: 35)
                                )
                        )
                }
            }
            } else if itemType == .card  {
            Rectangle()
                .foregroundColor(.white)
                .frame(width: 35, height: 35)
                .cornerRadius(5)
                .overlay(
                    Image(systemName: "creditcard.fill")
                        .resizable()
                        .foregroundColor(.black)
                        .background(.white)
                        .frame(width: 30, height: 25)
                )
            } else if itemType == .identity {
                Rectangle()
                    .foregroundColor(.white)
                    .frame(width: 35, height: 35)
                    .cornerRadius(5)
                    .overlay(
                        Image(systemName: "person.fill")
                            .resizable()
                            .foregroundColor(.black)
                            .background(.white)
                            .frame(width: 30, height: 30)
                    )
            } else if itemType == .secureNote {
                Rectangle()
                    .foregroundColor(.white)
                    .frame(width: 35, height: 35)
                    .cornerRadius(5)
                    .overlay(
                        Image(systemName: "lock.doc")
                            .resizable()
                            .foregroundColor(.black)
                            .background(.white)
                            .frame(width: 25, height: 30)
                    )
        }
    }
}

struct Icon_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
//            HStack{
//                Icon(itemType: ItemType.password, hostname: "", api: Account().api)
//                Spacer().frame(width: 20)
//                VStack {
//                    Text("name")
//                        .id(UUID())
//                        .font(.system(size: 15)).fontWeight(.semibold)
//                        .frame(maxWidth: .infinity, alignment: .topLeading)
//                    Spacer().frame(height: 5)
//                    Text(verbatim: "username")
//                        .font(.system(size: 10))
//                        .frame(maxWidth: .infinity, alignment: .topLeading)
//                }
//            }
//            .padding(.leading)
//            HStack{
//                Icon(itemType: ItemType.password, hostname: "google.com", api: Account().api)
//                Spacer().frame(width: 20)
//                VStack {
//                    Text("name")
//                        .id(UUID())
//                        .font(.system(size: 15)).fontWeight(.semibold)
//                        .frame(maxWidth: .infinity, alignment: .topLeading)
//                    Spacer().frame(height: 5)
//                    Text(verbatim: "username")
//                        .font(.system(size: 10))
//                        .frame(maxWidth: .infinity, alignment: .topLeading)
//                }
//            }.padding(.leading)
//            Icon(itemType: ItemType.card)
//            Icon(itemType: ItemType.identity)
//            Icon(itemType: ItemType.secureNote)
            LazyImage(url: URL(string:"")).onCompletion {
                if case .failure(let error) = $0 {
                    print(error)
                }
            }
            
        }
        .frame(width: .infinity, height: .infinity)

    }
}
