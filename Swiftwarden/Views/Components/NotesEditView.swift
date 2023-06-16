//
//  NotesEditView.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2023-06-16.
//

import SwiftUI

struct NotesEditView: View {
    @Binding var text: String
    init(_ text: Binding<String>) {
        self._text = text
    }
    
    var body: some View {
        VStack {
            Text("Note")
                .font(.system(size: 10))
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .foregroundColor(.gray)
            GroupBox {
                TextEditor(text: $text)
                    .scrollContentBackground(.hidden)
                    .font(.custom("Avenir", size: 14))
                    .lineSpacing(5)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
        }
        .frame(minHeight: 200, maxHeight: 200)
    }
}

struct NotesEditView_Previews: PreviewProvider {
    static var previews: some View {
        @State var text: String = "Tersting text"
        NotesEditView($text)
            .padding()
    }
}
