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
        
        var body: some View {
                VStack {
                    ViewHeader(itemType: .card, cipher: $cipher)
                    ScrollView {
                        Group {
                            if let cardholder = cipher?.card?.cardHolderName {
                                Field(
                                    title: "Cardholder Name",
                                    content: cardholder,
                                    showButton: true,
                                    buttons: {
                                        Copy(content: cardholder)
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
                                    showButton: true,
                                    buttons: {
                                        Copy(content: number)
                                    })
                            }
                            if let brand = cipher?.card?.brand {
                                Field(
                                    title: "Brand",
                                    content: brand,
                                    showButton: true,
                                    buttons: {
                                        Copy(content: brand)
                                    })
                            }
                            
                            if cipher?.card?.expMonth != nil || cipher?.card?.expYear != nil {
                                Field(
                                    title: "Expiration Date",
                                    content: "\(cipher?.card?.expMonth ?? "_") / \(cipher?.card?.expYear ?? "_")",
                                    showButton: true,
                                    buttons: {
                                        Copy(content: "\(cipher?.card?.expMonth ?? "_") / \(cipher?.card?.expYear ?? "_")")
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
                                    showButton: true,
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
                            .padding()
                        }
                    }
                .frame(maxWidth: .infinity)
                .toolbar {
                    RegularCipherOptions(cipher: $cipher, editing: $editing)
            }
                
            }
        }
        
    }
//struct CardViewPreview: PreviewProvider {
//    static var previews: some View {
//        let cardInfo = Card(cardHolderName: "Test", code: "123", expMonth: nil, expYear: "2021", number: "1234")
//        @State var card: Cipher? = Cipher(card: cardInfo, fields: [CustomField(type: 3, name: "test", value: "test")])
//
//        let cipherDeleted = Cipher(deletedDate: "today", fields: [CustomField(type: 0, name: "test", value: "test")], login: Login(password: "test", username: "test"), name: "Test")
//        
//        let account = Account()
//
//        ItemView.CardView(cipher: $card, editing: .constant(false), reprompt: .constant(.none), account: Account())
//    }
//}

