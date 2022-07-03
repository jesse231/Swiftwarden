//
//  ContentView.swift
//  Bitwarden
//
//  Created by Jesse Seeligsohn on 2022-07-02.
//

import SwiftUI

struct ContentView: View {
    @State var currentOption = 0
    var body: some View {
        NavigationView{
            
//            let options: [Option] = [
//                .init(label:"All Items", icon: "house", destination: MainView),
//                .init(label:"Favourites", icon: "star", ),
//                .init(label:"Trash", icon: "trash.fill"),
//            ]
            
            SideBar()
            
            
//
//            SideView(options: options, currentSelection : $currentOption)
            
//            switch currentOption {
//            case 1:
//                MainView()
//            default:
//                Text("testing")
//
//            }
            
        }
    }
}
//
//struct Option : Hashable {
//    let label: String
//    let icon: String
//}
    
struct SideBar: View {
    
    var body: some View {
        VStack{
            Spacer().frame(height:10)
        List{
                NavigationLink(
                    destination: ItemsView(),
                    label: {
                    Label("All Items", systemImage: "shield.lefthalf.fill")
                   })
            
            NavigationLink(
                destination: FavouritesView(),
                label: {
                Label("Favourites", systemImage: "star.fill")
               })
            
            NavigationLink(
                destination: TrashView(),
                label: {
                Label("Trash", systemImage: "trash.fill")
               })
            }.listStyle(.sidebar)
    }
    }
}
struct ItemsView: View {
    var body: some View {
        Text("test")
        
    }
}
struct FavouritesView: View {
    var body: some View {
        Text("test")
        
    }
}
struct TrashView: View {
    var body: some View {
        Text("test")
        
    }
}



struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}
