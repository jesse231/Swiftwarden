//
//  UniversalView.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2024-07-07.
//

import SwiftUI

struct UniversalViewItems: View {
    var note: String?
    var fields: [CustomField]
    var body: some View {
        VStack {
            if let note {
                Field(
                    title: "Note",
                    content: note,
                    showButton: false,
                    buttons: {})
            }
            CustomFieldsView(fields)
        }
    }
}

#Preview {
    UniversalViewItems(note: "Secure Note", fields: [CustomField(type: 0, name: "Field 1", value: "Value 1"), CustomField(type: 1, name: "Field 2", value: "Value 2")])
        .padding()
        .frame(width: 300, height: 300)
}
