//
//  UniversalEditItems.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2024-07-07.
//

import SwiftUI

struct UniversalEditItems: View {
    @Binding var notes: String?
    @Binding var fields: [CustomField]
    var body: some View {
        VStack {
            NotesEditView(text: $notes)
            Divider()
            CustomFieldsEdit(fields: $fields)
        }
    }
}

struct UniversalEditItems_Previews: PreviewProvider {
    static var previews: some View {
        @State var note: String? = "Secure Note"
        @State var fields = [CustomField(name: "Field 1", value: "Value 1"), CustomField(name: "Field 2", value: "Value 2")]
        UniversalEditItems(notes: $note, fields: $fields)
            .padding()
    }
}
