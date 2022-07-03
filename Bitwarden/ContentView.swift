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
            SideBar()
        }
    }
}
    
struct SideBar: View {
    
    var body: some View {
        let menuItems: [(label: String, icon: String, color: Color, destination: AnyView)] = [
            (label: "All Items", icon: "shield.lefthalf.fill", color: Color.blue, destination: AnyView(ItemsView())),
            (label: "Favourites", icon: "star.fill", color: Color.yellow, destination: AnyView(FavouritesView())),
            (label: "Trash", icon: "trash.fill", color: Color.red, destination: AnyView(TrashView())),
        ]
        
        VStack{
            Spacer().frame(height:10)
        List{
            ForEach(0..<menuItems.count) { i in
                NavigationLink(
                    destination: menuItems[i].destination,
                    label: {
                        Label {
                            Text(menuItems[i].label)
                        } icon: {
                            Image(systemName: menuItems[i].icon).foregroundColor(menuItems[i].color)
                        }
                    }).padding(4)
            }
            }.listStyle(.sidebar)
    }
    }
}
struct ItemsView: View {
    var body: some View {
        Text("Items")
        
    }
}
struct FavouritesView: View {
    var body: some View {
        Text("Favourites")
        
    }
}
struct TrashView: View {
    var body: some View {
        Text("Trash")
        
    }
}



struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}
