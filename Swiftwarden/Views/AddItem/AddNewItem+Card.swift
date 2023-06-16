//
//  AddNewItem+Card.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2023-06-12.
//

import SwiftUI
extension AddNewItemPopup {

    struct AddNewCard: View {
        var account: Account
        @Binding var name: String
        @Binding var show: Bool
        
        @State private var cardholderName = ""
        @State private var number = ""
        
        @State private var brand: String?
        @State private var expirationMonth: String?
        @State private var expirationYear: String?
        @State private var securityCode = ""
        
        @State private var folder: String?
        @State private var favorite = false
        @State private var reprompt = false
        
        @State private var notes = ""
        
        @State private var fields: [CustomField] = []
        
        var body: some View {
            VStack {
                ScrollView {
                    VStack{
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
                                            Text("Visa").tag("visa")
                                            Text("Mastercard").tag("mastercard")
                                            Text("American Express").tag("american-express")
                                        }
                                        Text("Discover").tag("discover")
                                        Text("Diners Club").tag("diners-club")
                                        Text("JCB").tag("jcb")
                                        Text("Maestro").tag("maestro")
                                        Text("UnionPay").tag("unionpay")
                                        Text("RuPay").tag("rupay")
                                        Text("Other").tag("other")
                                    }
                                    Picker("Expiration Month", selection: $expirationMonth) {
                                        Group {
                                            Text("Select").tag(nil as String?)
                                            Text("January").tag("01")
                                            Text("February").tag("02")
                                            Text("March").tag("03")
                                        }
                                        Text("April").tag("04")
                                        Text("May").tag("05")
                                        Text("June").tag("06")
                                        Text("July").tag("07")
                                        Text("August").tag("08")
                                        Text("September").tag("09")
                                        Text("October").tag("10")
                                        Text("November").tag("11")
                                        Text("December").tag("12")
                                    }
                                    Picker("Expiration Year", selection: $expirationYear) {
                                        Text("Select").tag(nil as String?)
                                        let currentYear = Calendar.current.component(.year, from: Date())
                                        ForEach (currentYear...currentYear+10, id: \.self) { year in
                                            Text("\(year)").tag("\(year)")
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
                            Divider()

                            CustomFieldsEdit(fields: $fields)
                            Divider()
                            NotesEditView($notes)
                            Divider()
                        }
                        Form {
                            Picker("Folder", selection: $folder) {
                                Text("No Folder").tag(nil as String?)
                                ForEach(account.user.getFolders(), id: \.self) {folder in
                                    Text(folder.name).tag(folder.id)
                                }
                                
                            }
                            Toggle("Favorite", isOn: $favorite)
                            Toggle("Master password re-prompt", isOn: $reprompt)
                        }
                        .scaledToFit()
                        .scaledToFill()
                        .scrollDisabled(true)
                        .formStyle(.grouped)
                        .scrollContentBackground(.hidden)
                    }
                    .padding()
                }
                HStack{
                    Button {
                        show = false
                    } label: {
                        Text("Cancel")
                    }
                    Spacer()
                    Button {
                        Task {
                            let card = Card(
                                brand: brand,
                                cardHolderName: cardholderName,
                                code: securityCode, expMonth: expirationMonth,
                                expYear: expirationYear,
                                number: number
                            )
                            
                            let newCipher = Cipher(
                                card: card,
                                favorite: favorite,
                                fields: fields,
                                folderID: folder,
                                name: name,
                                notes: notes != "" ? notes : nil,
                                reprompt: reprompt ? 1 : 0,
                                type: 1
                            )
                            do {
                                self.account.selectedCipher =
                                try await account.user.addCipher(cipher: newCipher)
                            }
                            catch {
                                print(error)
                            }
                            
                        }
                        show = false
                    } label: {
                        Text("Save")
                    }
                }
            }
        }
    }
    
}

struct AddNewItem_Card_Previews: PreviewProvider {
    static var previews: some View {
        AddNewItemPopup.AddNewCard(account: Account(), name: .constant("New Card"), show: .constant(true))
            .padding()
    }
}
