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
            AllItemsView()
            ItemView()
        }
        
    }
}
    
struct SideBar: View {
    
    var body: some View {
        let menuItems: [(label: String, icon: String, color: Color, destination: AnyView)] = [
            (label: "All Items", icon: "shield.lefthalf.fill", color: Color.blue, destination: AnyView(AllItemsView())),
            (label: "Favourites", icon: "star.fill", color: Color.yellow, destination: AnyView(FavouritesView())),
            (label: "Trash", icon: "trash.fill", color: Color.red, destination: AnyView(TrashView())),
        ]
        
        let types: [(label: String, icon: String, color: Color, destination: AnyView)] = [
            (label: "Login", icon: "arrow.right.square.fill", color: Color.gray, destination: AnyView(AllItemsView())),
            (label: "Card", icon: "creditcard", color: Color.gray, destination: AnyView(FavouritesView())),
            (label: "Identity", icon: "person.crop.square.fill", color: Color.gray, destination: AnyView(TrashView())),
            (label: "Secure Note", icon: "lock.fill", color: Color.gray, destination: AnyView(TrashView())),
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
            
            Section(header: Text("Types")) {
                ForEach(0..<types.count) { i in

                    NavigationLink(
                        destination: types[i].destination,
                        label: {
                            Label {
                                Text(types[i].label)
                            } icon: {
                                Image(systemName: types[i].icon).foregroundColor(types[i].color)
                            }
                        }).padding(4)
                }
            }
            Section(header: Text("Folders")) {
             Text("test")
            }
            }.listStyle(.sidebar)

    }
    }
}


struct AllItemsView: View {
    
    var body: some View {
        List{
            NavigationLink(
                destination: {
                    ItemView()
                },
                label: {
                    Image(systemName: "plus.square.fill").resizable().frame(width: 35, height: 35)
                    Spacer().frame(width: 20)
                    VStack{
                    Text("Adobe")
                            .font(.system(size: 15)).fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                        Spacer().frame(height: 5)
                        Text(verbatim: "username@gmail.com").font(.system(size: 10))
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                }
            ).padding(5)
            
            }

            
        }
}
//WIP
struct ItemView : View {
    var body: some View {
        List{
            HStack{
                Image(systemName: "plus.square.fill").resizable().frame(width: 35, height: 35)
                VStack{
                Text("Adobe")
                        .font(.system(size: 15)).fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
//                    Spacer().frame(height: 5)
                    Text(verbatim: "Login").font(.system(size: 10))
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                Image(systemName: "star.fill")
            }
        Divider()
            Text("username")
        }
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
        Group {
            ContentView()
            ContentView()
        }
    }
}
