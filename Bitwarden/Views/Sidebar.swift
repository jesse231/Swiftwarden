//
//  SidebarView.swift
//  Bitwarden
//
//  Created by Jesse Seeligsohn on 2023-01-11.
//

import SwiftUI

struct SideBar: View {
    @EnvironmentObject var allPasswords : Passwords
    @State var selection: Int? = 0
    
    var body: some View {
        let menuItems: [(label: String, icon: String, color: Color, destination: AnyView)] = [
            (label: "All Items", icon: "shield.lefthalf.fill", color: Color.blue, destination: AnyView(PasswordsList(ciphers: allPasswords.searchResults).environmentObject(allPasswords))),
            (label: "Favorites", icon: "star.fill", color: Color.yellow, destination: AnyView(PasswordsList(ciphers: allPasswords.favourites).environmentObject(allPasswords))),
            (label: "Trash", icon: "trash.fill", color: Color.red, destination: AnyView(PasswordsList(ciphers: allPasswords.trash).environmentObject(allPasswords))),
        ]
        
        let types: [(label: String, icon: String, color: Color, destination: AnyView)] = [
            (label: "Login", icon: "arrow.right.square.fill", color: Color.gray, destination: AnyView(PasswordsList(ciphers: allPasswords.passwords).environmentObject(allPasswords))),
            (label: "Card", icon: "creditcard.fill", color: Color.gray, destination: AnyView(PasswordsList(ciphers: allPasswords.cards).environmentObject(allPasswords))),
            //            (label: "Identity", icon: "person.crop.square.fill", color: Color.gray, destination: AnyView(TrashView())),
            //            (label: "Secure Note", icon: "lock.fill", color: Color.gray, destination: AnyView(PasswordsList(ciphers: allPasswords.passwords).environmentObject(allPasswords))),
        ]
        
        List {
            
            ForEach(0..<menuItems.count) { i in
                NavigationLink(
                    destination: menuItems[i].destination,
                    // Fix for allowing default to be selected
                                        tag: i,
                                        selection: $selection,
                    label: {
                        Label {
                            Text(menuItems[i].label)
                        } icon: {
                            Image(systemName: menuItems[i].icon).accentColor(menuItems[i].color)
                        }
                    }
                ).padding(4)
            }
            
            Section(header: Text("Types")) {
                ForEach(0..<types.count) { i in
                    
                    NavigationLink(
                        destination: types[i].destination,
                        label: {
                            Label {
                                Text(types[i].label)
                            } icon: {
                                Image(systemName: types[i].icon).accentColor(types[i].color)
                            }
                        }).padding(4)
                }
            }
            Section(header: Text("Folders")) {
                Text("test")
            }
        }.listStyle(SidebarListStyle())
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SideBar()
    }
}
