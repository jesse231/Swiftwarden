//
//  Footer.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2024-07-03.
//

import SwiftUI

struct Footer: View {
    @Binding var itemType: ItemType?
    // function button calls
    var create: (() -> Void)
    var body: some View {
        HStack {
            Button {
                itemType = nil
            } label: {
                Text("Cancel")
            }
            Spacer()
            Button {
                create()
                itemType = nil
            } label: {
                Text("Save")
            }
        }
    }
}

#Preview {
    Footer(itemType: .constant(nil), create: {})
}
