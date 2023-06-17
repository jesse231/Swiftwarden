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
            
            _name = State(initialValue: account.selectedCipher.name ?? "")
            _cardholderName = State(initialValue: account.selectedCipher.card?.cardHolderName ?? "")
            _number = State(initialValue: account.selectedCipher.card?.number ?? "")
            _brand = State(initialValue: account.selectedCipher.card?.brand ?? "")
            print(account.selectedCipher.card?.expMonth)
            _expirationMonth = State(initialValue: account.selectedCipher.card?.expMonth ?? nil as String?)
            _expirationYear = State(initialValue: account.selectedCipher.card?.expYear ?? nil as String?)
            _securityCode = State(initialValue: account.selectedCipher.card?.code ?? "")
            _folder = State(initialValue: account.selectedCipher.folderID ?? nil as String?)
            _favorite = State(initialValue: account.selectedCipher.favorite ?? false)
            reprompt = RepromptState.fromInt(cipher.wrappedValue?.reprompt ?? 0)
            _notes = State(initialValue: account.selectedCipher.notes ?? "")
            _fields = State(initialValue: account.selectedCipher.fields ?? [])
        }
        
        
        
        func edit () async throws {
            let index = account.user.getCiphers(deleted: true).firstIndex(of: account.selectedCipher)
            
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
            
            try await account.user.updateCipher(cipher: modCipher, index: index)
            account.selectedCipher = modCipher
            cipher = modCipher
        }
        
        var body: some View {
            Group {
                VStack {
                    HStack {
                        Button {
                            self.editing = false
                        } label: {
                            Text("Cancel")
                        }
                        Spacer()
                        Button {
                            Task {
                                try await edit()
                                self.editing = false
                            }
                        } label: {
                            Text("Done")
                        }
                    }
                    .padding(.bottom)
                    HStack {
                        Icon(hostname: extractHost(cipher: cipher), account: account)
                        VStack {
                            TextField("No Name", text: $name)
                                .font(.system(size: 15))
                                .fontWeight(.semibold)
                                .textFieldStyle(.plain)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                .padding(.bottom, -5)
                            Text(verbatim: "Login")
                                .font(.system(size: 10))
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                        }
                        FavoriteButton(cipher: $cipher, account: account)
                    }
                    Divider()
                    ScrollView {
                        VStack {
                            EditingField(title: "Cardholder Name", text: $cardholderName) {
                            }
                            .padding()
                            EditingField(title: "Number", text: $number, secure: true) {
                            }
                            Divider()
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
                            Form {
                                Picker(selection: $folder, label: Text("Folder")) {
                                    ForEach(account.user.getFolders(), id: \.self) {folder in
                                        Text(folder.name).tag(folder.id as String?)
                                    }
                                }
                                Toggle("Favorite", isOn: Binding<Bool>(
                                    get: {
                                        return self.cipher?.favorite ?? false
                                    },
                                    set: { newValue in
                                        self.cipher?.favorite = newValue
                                    }
                                )
                                )
                                Toggle("Master Password Re-prompt", isOn: Binding<Bool>(
                                    get: {
                                        return self.reprompt.reprompt()
                                    },
                                    set: { newValue in
                                        self.reprompt = newValue ? .require : .none
                                    }
                                ))
                                
                            }
                        }
                        .padding(.trailing)
                        .padding(.leading)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

struct CardEditingPreview: PreviewProvider {
    static var previews: some View {
        let cipher = Cipher(login: Login(password: "test", username: "test"), name: "Test")
        let account = Account()
        
        ItemView.CardEditing(cipher: .constant(cipher), editing: .constant(true), account: account)
            .padding()
    }
}
