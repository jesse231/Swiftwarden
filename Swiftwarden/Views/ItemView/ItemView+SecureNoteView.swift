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
        
        func delete() async throws {
            if let cipher {
                do {
                    try await account.user.deleteCipher(cipher: cipher)
                    account.selectedCipher = Cipher()
                    self.cipher = nil
                } catch {
                    print(error)
                }
            }
        }
        func deletePermanently() async throws {
            if let cipher {
                do {
                    try await account.user.deleteCipherPermanently(cipher: cipher)
                    account.selectedCipher = Cipher()
                    self.cipher = nil
                } catch {
                    print(error)
                }
            }
        }
        func restore() async throws {
            if let cipher {
                do {
                    try await account.user.restoreCipher(cipher: cipher)
                    account.selectedCipher = Cipher()
                    self.cipher = nil
                } catch {
                    print(error)
                }
            }
        }
        
        var body: some View {
                VStack {
                    HStack {
                        if cipher?.deletedDate == nil {
                            Button {
                                Task {
                                    try await delete()
                                }
                            } label: {
                                Text("Delete")
                            }
                            Spacer()
                            Button {
                                editing = true
                            } label: {
                                Text("Edit")
                            }
                        } else {
                            Button {
                                Task {
                                    try await deletePermanently()
                                }
                            } label: {
                                Text("Delete Permanently")
                            }
                            Spacer()
                            Button {
                                Task {
                                    try await restore()
                                }
                            } label: {
                                Text("Restore")
                            }
                        }
                    }
                    .padding(.bottom)
                    
                    HStack {
                        Icon(itemType: .secureNote, account: account)
                        VStack {
                            Text(cipher?.name ?? "")
                                .font(.system(size: 15))
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                            Text(verbatim: "Secure Note")
                                .font(.system(size: 10))
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                        }
                        FavoriteButton(cipher: $cipher, account: account)
                    }
                    .padding([.leading,.trailing], 5)
                    Divider()
                        .padding([.leading,.trailing], 5)
                    ScrollView {
                        VStack {
                            if let fields = cipher?.fields {
                                CustomFieldsView(fields)
                            }
                            
                            if let notes = cipher?.notes {
                                Field(title: "Note", content: notes, buttons: {})
                            }
                        }
                                .padding([.trailing])
                        }
                        .padding(.trailing)
                    }
                .frame(maxWidth: .infinity)
                //                    .sheet(isPresented: $showReprompt) {
                //                        RepromptPopup(showReprompt: $showReprompt, showPassword: $showPassword, reprompt: $reprompt, account: account)
                //                    }
                
            }
        }
        
    }
struct SecureNoteView_Preview: PreviewProvider {
    static var previews: some View {
        Text("test")
    }
}

