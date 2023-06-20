import Foundation
import NukeUI
import SwiftUI

extension ItemView {
    struct CardView: View {
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
                        Icon(itemType: .card, account: account)
                        VStack {
                            Text(cipher?.name ?? "")
                                .font(.system(size: 15))
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                            Text(verbatim: "Credit Card")
                                .font(.system(size: 10))
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                            
                        }
                        FavoriteButton(cipher: $cipher, account: account)
                        
                    }
                    .padding([.leading,.trailing], 5)
                    Divider()
                        .padding([.leading,.trailing], 5)
                    ScrollView {
                        Group {
                            if let cardholder = cipher?.card?.cardHolderName {
                                Field(
                                    title: "Cardholder Name",
                                    content: cardholder,
                                    buttons: {
                                        //                                        Copy(content: cardholder)
                                    })
                            }
                            if let number = cipher?.card?.number {
                                Field(
                                    title: "Number",
                                    content: number,
                                    secure: true,
                                    reprompt: $reprompt,
                                    showReprompt: $showReprompt,
                                    email: account.user.getEmail(),
                                    buttons: {
                                        Copy(content: number)
                                    })
                            }
                            if let brand = cipher?.card?.brand {
                                Field(
                                    title: "Brand",
                                    content: brand,
                                    buttons: {
                                    })
                            }
                            
                            if cipher?.card?.expMonth != nil || cipher?.card?.expYear != nil {
                                Field(
                                    title: "Expiration Date",
                                    content: "\(cipher?.card?.expMonth ?? "_") / \(cipher?.card?.expYear ?? "_")",
                                    buttons: {
                                    }
                                )
                            }
                            if let code = cipher?.card?.code {
                                Field(
                                    title: "Security Code",
                                    content: code,
                                    secure: true,
                                    reprompt: $reprompt,
                                    showReprompt: $showReprompt,
                                    email: account.user.getEmail(),
                                    buttons: {
                                        Copy(content: code)
                                    })
                            }
                                
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
struct CardViewPreview: PreviewProvider {
    static var previews: some View {
        let cardInfo = Card(cardHolderName: "Test", code: "123", expMonth: nil, expYear: "2021", number: "1234")
        @State var card: Cipher? = Cipher(card: cardInfo, fields: [CustomField(type: 3, name: "test", value: "test")])

        let cipherDeleted = Cipher(deletedDate: "today", fields: [CustomField(type: 0, name: "test", value: "test")], login: Login(password: "test", username: "test"), name: "Test")
        
        let account = Account()

        ItemView.CardView(cipher: $card, editing: .constant(false), reprompt: .constant(.none), account: Account())
    }
}

