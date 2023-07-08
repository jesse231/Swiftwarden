//
//  ItemView+Editing.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2023-05-14.
//

import SwiftUI
import NukeUI

extension ItemView {
    struct CardEditing: View {
        @Binding var cipher: Cipher?
        @Binding var editing: Bool
        @StateObject var account: Account
                
        @State private var name: String
        @State private var cardholderName = ""
        @State private var number = ""
        
        @State private var brand: String?
        @State private var expirationMonth: String?
        @State private var expirationYear: String?
        @State private var securityCode = ""
        
        @State private var folder: String?
        @State private var favorite: Bool
        @State private var reprompt: RepromptState
        
        @State private var notes = ""
        
        @State private var fields: [CustomField] = []
        
        init(cipher: Binding<Cipher?>, editing: Binding<Bool>, account: Account) {
            _cipher = cipher
            _editing = editing
            _account = StateObject(wrappedValue: account)
            
            _name = State(initialValue: cipher.wrappedValue?.name ?? "")
            _cardholderName = State(initialValue: cipher.wrappedValue?.card?.cardHolderName ?? "")
            _number = State(initialValue: cipher.wrappedValue?.card?.number ?? "")
            _brand = State(initialValue: cipher.wrappedValue?.card?.brand)
            _expirationMonth = State(initialValue: cipher.wrappedValue?.card?.expMonth ?? nil as String?)
            _expirationYear = State(initialValue: cipher.wrappedValue?.card?.expYear ?? nil as String?)
            _securityCode = State(initialValue: cipher.wrappedValue?.card?.code ?? "")
            _folder = State(initialValue: cipher.wrappedValue?.folderID ?? nil as String?)
            _favorite = State(initialValue: cipher.wrappedValue?.favorite ?? false)
            reprompt = RepromptState.fromInt(cipher.wrappedValue?.reprompt ?? 0)
            _notes = State(initialValue: cipher.wrappedValue?.notes ?? "")
            _fields = State(initialValue: cipher.wrappedValue?.fields ?? [])
        }
        
        
        
        func save() async throws {
                let index = account.user.getCiphers(deleted: true).firstIndex(of: cipher!)
                
                var modCipher = cipher!
                modCipher.name = name
                let card = Card(
                    brand: brand != "" ? brand : nil,
                    cardHolderName: cardholderName != "" ? cardholderName : nil,
                    code: securityCode != "" ? securityCode : nil,
                    expMonth: expirationMonth,
                    expYear: expirationYear,
                    number: number != "" ? number : nil
                )
                modCipher.card = card
                
                modCipher.notes = notes != "" ? notes : nil
                modCipher.fields = fields
                
                modCipher.favorite = favorite
                modCipher.reprompt = reprompt.toInt()
                modCipher.folderID = folder
                
                
                try await account.user.updateCipher(cipher: modCipher, index: index)
                cipher = modCipher
        }
        
        var body: some View {
            Group {
                VStack {
                    HStack {
                        Icon(itemType: .card, account: account)
                        VStack {
                            TextField("No Name", text: $name)
                                .font(.system(size: 15))
                                .fontWeight(.semibold)
                                .textFieldStyle(.plain)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                .padding(.bottom, -5)
                            Text(verbatim: "Credit Card")
                                .font(.system(size: 10))
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                        }
                        FavoriteEditingButton(favorite: $favorite)
                    }
                    Divider()
                    ScrollView {
                        VStack {
                            EditingField(title: "Cardholder Name", text: $cardholderName) {
                            }
                            EditingField(title: "Number", text: $number, secure: true) {
                            }
                            Divider()
                            Form {
                                Picker("Brand", selection: $brand) {
                                    Group {
                                        Text("Select").tag(nil as String?)
                                        Text("Visa").tag("Visa" as String?)
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
                            }
                            .formStyle(.grouped)
                            .padding([.leading, .trailing], -25)

                                EditingField(title: "Security Code", text: $securityCode, buttons: {})
                            Divider()
                            Group {
                                CustomFieldsEdit(fields: Binding<[CustomField]>(
                                    get: {
                                        return cipher?.fields ?? []
                                    },
                                    set: { newValue in
                                        cipher?.fields = newValue
                                    }
                                ))
                                NotesEditView(Binding<String>(
                                    get: {
                                        return cipher?.notes ?? ""
                                    },
                                    set: { newValue in
                                        cipher?.notes = newValue
                                    }
                                ))
                            }
                            Divider()
                            CipherOptions(folder: $folder, favorite: $favorite, reprompt: $reprompt)
                                .environmentObject(account)
                        }
                        .padding(.trailing)
                        .padding(.leading)
                    }
                    .frame(maxWidth: .infinity)
                    .toolbar {
                        EditingToolbarOptions(cipher: $cipher, editing: $editing, account: account, save: save)
                    }
                }
            }
        }
    }
}

struct CardEditing_Preview: PreviewProvider {
    static var previews: some View {
        let cipher = Cipher(login: Login(password: "test", username: "test"), name: "Test")
        let account = Account()
        
        ItemView.CardEditing(cipher: .constant(cipher), editing: .constant(true), account: account)
            .padding()
    }
}
