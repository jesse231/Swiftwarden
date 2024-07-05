//
//  ListToolbar.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2024-06-26.
//

import SwiftUI

struct ListToolbar: View {
    @State private var itemType: ItemType?
    var body: some View {
        Menu {
            Button {
                Task {
                    itemType = .password
                }
            } label: {
                Label("Add Password", systemImage: "key")
                    .foregroundColor(.primary)
                    .labelStyle(.titleAndIcon)
            }
            Button {
                Task {
                    itemType = .card
                }
            } label: {
                Label("Add Card", systemImage: "creditcard")
                    .foregroundColor(.primary)
                    .labelStyle(.titleAndIcon)
            }
            Button {
                itemType = .identity
            } label: {
                Label("Add Identity", systemImage: "person")
                    .foregroundColor(.primary)
                    .labelStyle(.titleAndIcon)
            }
            Button {
                itemType = .secureNote
            } label: {
                Label("Add Secure Note", systemImage: "doc.text")
                    .foregroundColor(.primary)
                    .labelStyle(.titleAndIcon)
            }
        } label: {
            Image(systemName: "plus")
        }
        .sheet(item: $itemType) { itemType in
            let binding = Binding<ItemType?>(get: { itemType }, set: { self.itemType = $0 })
            AddNewItemPopup(itemType: binding)
        }

    }
}

#Preview {
    ListToolbar()
}
