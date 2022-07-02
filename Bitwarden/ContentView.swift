//
//  ContentView.swift
//  Bitwarden
//
//  Created by Jesse Seeligsohn on 2022-07-02.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView{
            let options: [Option] = [
                .init(title:"All Items", icon: "house"),
                .init(title:"Favourites", icon: "star"),
                .init(title:"Trash", icon: "trash.fill"),
            ]
            SideView(options: options)
        
        MainView()
        }
    }
}

struct Option : Hashable {
    let title: String
    let icon: String
}
    
struct SideView: View {
    
    let options: [Option]
    
    var body: some View {
        VStack {
            ForEach(options, id:\.self) { option in
                HStack {
                    Image(systemName: option.icon)
                    Text(option.title)
                    Spacer()
                }.padding(6)
            }
        }.padding()
        Spacer()
    }
}
struct MainView: View {
    var body: some View {
        Text("test")
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
