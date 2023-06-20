//
//  ItemView+Editing.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2023-05-14.
//

import SwiftUI
import NukeUI

extension ItemView {
    struct IdentityEditing: View {
        @Binding var cipher: Cipher?
        @Binding var editing: Bool
        @StateObject var account: Account
        
        @State private var name = ""
        @State private var title: String?
        @State private var firstName = ""
        @State private var middleName = ""
        @State private var lastName = ""
        
        @State private var username = ""
        @State private var company = ""
        @State private var socialSecurityNumber = ""
        @State private var passportNumber = ""
        @State private var licenseNumber = ""
        
        @State private var email = ""
        @State private var phone = ""
        @State private var address1 = ""
        @State private var address2 = ""
        @State private var address3 = ""
        @State private var city = ""
        @State private var state = ""
        @State private var zip = ""
        @State private var country = ""
        
        @State private var fields: [CustomField] = []
        
        @State private var notes = ""
        
        @State private var folder: String?
        @State private var favorite: Bool
        @State private var reprompt: RepromptState
                        
        init(cipher: Binding<Cipher?>, editing: Binding<Bool>, account: Account) {
            _cipher = cipher
            _editing = editing
            _account = StateObject(wrappedValue: account)
            _name = State(wrappedValue: cipher.wrappedValue?.name ?? "")
            _title = State(wrappedValue: cipher.wrappedValue?.identity?.title)
            _firstName = State(wrappedValue: cipher.wrappedValue?.identity?.firstName ?? "")
            _middleName = State(wrappedValue: cipher.wrappedValue?.identity?.middleName ?? "")
            _lastName = State(wrappedValue: cipher.wrappedValue?.identity?.lastName ?? "")
            _username = State(wrappedValue: cipher.wrappedValue?.identity?.username ?? "")
            _company = State(wrappedValue: cipher.wrappedValue?.identity?.company ?? "")
            _socialSecurityNumber = State(wrappedValue: cipher.wrappedValue?.identity?.ssn ?? "")
            _passportNumber = State(wrappedValue: cipher.wrappedValue?.identity?.passportNumber ?? "")
            _licenseNumber = State(wrappedValue: cipher.wrappedValue?.identity?.licenseNumber ?? "")
            _email = State(wrappedValue: cipher.wrappedValue?.identity?.email ?? "")
            _phone = State(wrappedValue: cipher.wrappedValue?.identity?.phone ?? "")
            _address1 = State(wrappedValue: cipher.wrappedValue?.identity?.address1 ?? "")
            _address2 = State(wrappedValue: cipher.wrappedValue?.identity?.address2 ?? "")
            _address3 = State(wrappedValue: cipher.wrappedValue?.identity?.address3 ?? "")
            _city = State(wrappedValue: cipher.wrappedValue?.identity?.city ?? "")
            _state = State(wrappedValue: cipher.wrappedValue?.identity?.state ?? "")
            _zip = State(wrappedValue: cipher.wrappedValue?.identity?.postalCode ?? "")
            _country = State(wrappedValue: cipher.wrappedValue?.identity?.country ?? "")
            _fields = State(wrappedValue: cipher.wrappedValue?.fields ?? [])
            
            reprompt = RepromptState.fromInt(cipher.wrappedValue?.reprompt ?? 0)
            _notes = State(initialValue: account.selectedCipher.notes ?? "")
            _fields = State(initialValue: account.selectedCipher.fields ?? [])
            _favorite = State(initialValue: account.selectedCipher.favorite ?? false)
        }
        
        
        
        func edit () async throws {
            let index = account.user.getCiphers(deleted: true).firstIndex(of: account.selectedCipher)
            
            var modCipher = cipher!
            modCipher.name = name
            let identity = Identity(
                address1: address1 != "" ? address1 : nil,
                address2: address2 != "" ? address2 : nil,
                address3: address3 != "" ? address3 : nil,
                city: city != "" ? city : nil,
                company: company != "" ? company : nil,
                country: country != "" ? country : nil,
                email: email != "" ? email : nil,
                firstName: firstName != "" ? firstName : nil,
                lastName: lastName != "" ? lastName : nil,
                licenseNumber: licenseNumber != "" ? licenseNumber : nil,
                middleName: middleName != "" ? middleName : nil,
                passportNumber: passportNumber != "" ? passportNumber : nil,
                phone: phone != "" ? phone : nil,
                postalCode: zip != "" ? zip : nil,
                ssn: socialSecurityNumber != "" ? socialSecurityNumber : nil,
                state: state != "" ? state : nil,
                title: title != "" ? title : nil,
                username: username != "" ? username : nil
            )
            modCipher.identity = identity
            
            modCipher.notes = notes
            modCipher.fields = fields
            
            modCipher.favorite = cipher?.favorite
            modCipher.reprompt = reprompt.toInt()
            modCipher.folderID = folder
            
            
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
                        Icon(itemType: .identity, account: account)
                        VStack {
                            TextField("No Name", text: $name)
                                .font(.system(size: 15))
                                .fontWeight(.semibold)
                                .textFieldStyle(.plain)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                .padding(.bottom, -5)
                            Text(verbatim: "Identity")
                                .font(.system(size: 10))
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                        }
                        FavoriteButton(cipher: $cipher, account: account)
                    }
                    Divider()
                    ScrollView {
                        VStack {
                            Group {
                                Form {
                                    Picker("Title", selection: $title) {
                                        Group {
                                            Text("Select").tag(nil as String?)
                                            Text("Mr").tag("Mr" as String?)
                                            Text("Mrs").tag("Mrs" as String?)
                                            Text("Ms").tag("Ms" as String?)
                                            Text("Mx").tag("Mx" as String?)
                                            Text("Miss").tag("Miss" as String?)
                                            Text("Dr.").tag("Dr." as String?)
                                        }
                                    }
                                }
                                .formStyle(.grouped)
                                .scrollContentBackground(.hidden)
                                .padding(.top, 0)
                                .padding([.leading, .trailing], -20)
                                .padding(.bottom, -8)
                                
                                EditingField(title: "First Name", text: $firstName, buttons: {})
                                    .padding()
                                EditingField(title: "Middle Name", text: $middleName, buttons: {})
                                    .padding()
                                EditingField(title: "Last Name", text: $lastName, buttons: {})
                                    .padding()
                            }
                            Group {
                                EditingField(title: "Username", text: $username, buttons: {})
                                    .padding()
                                EditingField(title: "Company", text: $company, buttons: {})
                                    .padding()
                                EditingField(title: "SSN", text: $socialSecurityNumber, buttons: {})
                                    .padding()
                                EditingField(title: "Passport Number", text: $passportNumber, buttons: {})
                                    .padding()
                                EditingField(title: "License Number", text: $licenseNumber, buttons: {})
                                    .padding()
                            }
                            Group {
                                EditingField(title: "Email", text: $email, buttons: {})
                                    .padding()
                                EditingField(title: "Phone", text: $phone, buttons: {})
                                    .padding()
                                EditingField(title: "Address 1", text: $address1, buttons: {})
                                    .padding()
                                EditingField(title: "Address 2", text: $address2, buttons: {})
                                    .padding()
                                EditingField(title: "Address 3", text: $address3, buttons: {})
                                    .padding()
                                EditingField(title: "City", text: $city, buttons: {})
                                    .padding()
                                EditingField(title: "State", text: $state, buttons: {})
                                    .padding()
                                EditingField(title: "Zip", text: $zip, buttons: {})
                                    .padding()
                                EditingField(title: "Country", text: $country, buttons: {})
                                    .padding()
                            }
                                Form {
                                    Picker(selection: $folder, label: Text("Folder")) {
                                        ForEach(account.user.getFolders(), id: \.self) {folder in
                                            Text(folder.name)
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
                                .formStyle(.grouped)
                                .scrollContentBackground(.hidden)
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

struct IdentityEditing_Preview: PreviewProvider {
    static var previews: some View {
        let cipher = Cipher(login: Login(password: "test", username: "test"), name: "Test")
        let account = Account()
        
        ItemView.CardEditing(cipher: .constant(cipher), editing: .constant(true), account: account)
            .padding()
    }
}
