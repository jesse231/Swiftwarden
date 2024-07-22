//
//  AddNewItem+Card.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2023-06-12.
//

import SwiftUI
extension AddNewItemPopup {
    
    struct AddCard: View {
        var account: Account
        @Binding var name: String
        @Binding var itemType: ItemType?
        
        @State private var cardholderName = ""
        @State private var number = ""
        
        @State private var brand: String?
        @State private var expirationMonth: String?
        @State private var expirationYear: String?
        @State private var securityCode = ""
        
        @State private var folder: String?
        @State private var favorite = false
        @State private var reprompt: RepromptState = .none
        
        @State private var notes: String?
        
        @State private var fields: [CustomField] = []
        
        func create() {
            Task {
                let card = Card(
                    brand: brand != "" ? brand : nil,
                    cardHolderName: cardholderName != "" ? cardholderName : nil,
                    code: securityCode != "" ? securityCode : nil,
                    expMonth: expirationMonth,
                    expYear: expirationYear,
                    number: number != "" ? number : nil
                )
                
                let newCipher = Cipher(
                    card: card,
                    favorite: favorite,
                    fields: fields,
                    folderID: folder,
                    name: name,
                    notes: notes,
                    reprompt: reprompt.toInt(),
                    type: 3
                )
                do {
                    try await account.user.addCipher(cipher: newCipher)
                }
                catch {
                    print(error)
                }
                
            }
        }
        
        var body: some View {
            VStack {
                ScrollView {
                    VStack {
                        Group {
                            GroupBox {
                                TextField("Name", text: $name)
                                    .textFieldStyle(.plain)
                                    .padding(8)
                            }
                            .padding(.bottom, 4)
                            GroupBox {
                                TextField("Cardholder Name", text: $cardholderName)
                                    .textFieldStyle(.plain)
                                    .padding(8)
                            }.padding(.bottom, 4)
                            GroupBox {
                                SecureField("Number", text: $number)
                                    .textFieldStyle(.plain)
                                    .padding(8)
                            }.padding(.bottom, 12)
                            Divider()
                            Group {
                                Form {
                                    Picker("Brand", selection: $brand) {
                                        Group {
                                            Text("Select").tag(nil as String?)
                                            Text("Visa").tag("" as String?)
                                            Text("Mastercard").tag("mastercard" as String?)
                                            Text("American Express").tag("american-express" as String?)
                                        }
                                        Text("Discover").tag("discover" as String?)
                                        Text("Diners Club").tag("diners-club" as String?)
                                        Text("JCB").tag("jcb" as String?)
                                        Text("Maestro").tag("maestro" as String?)
                                        Text("UnionPay").tag("unionpay" as String?)
                                        Text("RuPay").tag("rupay" as String?)
                                        Text("Other").tag("other" as String?)
                                    }

                                    Picker("Expiration Month", selection: $expirationMonth) {
                                        Group {
                                            Text("Select").tag(nil as String?)
                                            Text("January").tag("01" as String?)
                                            Text("February").tag("02" as String?)
                                            Text("March").tag("03" as String?)
                                        }
                                        Text("April").tag("04" as String?)
                                        Text("May").tag("05" as String?)
                                        Text("June").tag("06" as String?)
                                        Text("July").tag("07" as String?)
                                        Text("August").tag("08" as String?)
                                        Text("September").tag("09" as String?)
                                        Text("October").tag("10" as String?)
                                        Text("November").tag("11" as String?)
                                        Text("December").tag("12" as String?)
                                    }

                                    Picker("Expiration Year", selection: $expirationYear) {
                                        Text("Select").tag(nil as String?)
                                        let currentYear = Calendar.current.component(.year, from: Date())
                                        ForEach (currentYear...currentYear+10, id: \.self) { year in
                                            Text("\(String(year).replacingOccurrences(of: ",", with: ""))").tag("\(year)" as String?)
                                        }
                                    }

                                    HStack {
                                        Text("Security Code")
                                        GroupBox {
                                            SecureField("", text: $securityCode)
                                                .textFieldStyle(.plain)
                                        }
                                    }
                                }
                            }
                            UniversalEditItems(notes: $notes, fields: $fields)
                        }
                        CipherOptions(folder: $folder, favorite: $favorite, reprompt: $reprompt)
                            .environmentObject(account)
                    }
                    .padding(20)
                }
                Footer(itemType: $itemType, create: create)
                    .padding(20)
                    .background(.gray.opacity(0.1))
            }
        }
    }
    
}

#Preview {
    AddNewItemPopup.AddCard(account: Account(), name: .constant("New Card"), itemType: .constant(.card))
}
