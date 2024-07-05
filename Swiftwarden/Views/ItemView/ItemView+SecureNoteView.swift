import Foundation
import NukeUI
import SwiftUI

extension ItemView {
    struct SecureNoteView: View {
        @Binding var cipher: Cipher?
        @Binding var editing: Bool
        @Binding var reprompt: RepromptState
        @State var showReprompt: Bool = false
        @State var showPassword: Bool = false
        @StateObject var account: Account
        
        var body: some View {
                VStack {     
                    ViewHeader(itemType: .secureNote, cipher: $cipher)
                    ScrollView {
                        VStack {
                            if let fields = cipher?.fields {
                                CustomFieldsView(fields)
                            }
                            
                            if let notes = cipher?.notes {
                                Field(title: "Note", content: notes, buttons: {})
                                let _ = print(notes)
                            }
                        }
                        .padding()
                        }
                    }
                .toolbar {
                    RegularCipherOptions(cipher: $cipher, editing: $editing)
            }
                
            }
        }
        
    }
