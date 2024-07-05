//
//  AddNewItem+Card.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2023-06-12.
//

import SwiftUI
extension AddNewItemPopup {
    
    struct AddIdentity: View {
        var account: Account
        @Binding var name: String
        @Binding var itemType: ItemType?
        
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
        @State private var favorite = false
        @State private var reprompt: RepromptState = .none
        
        func create() {
            Task {
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
                
                let newCipher = Cipher(
                    favorite: favorite,
                    fields: fields,
                    folderID: folder,
                    identity: identity,
                    name: name,
                    notes: notes != "" ? notes : nil,
                    reprompt: reprompt.toInt(),
                    type: 4
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
                    VStack{
                        Group {
                            GroupBox {
                                TextField("Name", text: $name)
                                    .textFieldStyle(.plain)
                                    .padding(8)
                            }
                            .padding(.bottom, -16)
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
                                .frame(height: 22)
                            }
                            .formStyle(.grouped)
                            .scrollContentBackground(.hidden)
                            .padding([.leading, .trailing], -20)
                            .padding(.bottom, -16)
                        }
                        Group {
                            GroupBox {
                                TextField("First Name", text: $firstName)
                                    .textFieldStyle(.plain)
                                    .padding(8)
                            }.padding(.bottom, 4)
                            GroupBox {
                                TextField("Middle Name", text: $middleName)
                                    .textFieldStyle(.plain)
                                    .padding(8)
                            }
                            .padding(.bottom, 4)
                            GroupBox {
                                TextField("Last Name", text: $lastName)
                                    .textFieldStyle(.plain)
                                    .padding(8)
                            }.padding(.bottom, 4)
                        }
                        Divider()
                        Group {
                            GroupBox {
                                TextField("Username", text: $username)
                                    .textFieldStyle(.plain)
                                    .padding(8)
                            }.padding(.bottom, 4)
                            GroupBox {
                                TextField("Company", text: $company)
                                    .textFieldStyle(.plain)
                                    .padding(8)
                            }.padding(.bottom, 4)
                            GroupBox {
                                TextField("First Name", text: $firstName)
                                    .textFieldStyle(.plain)
                                    .padding(8)
                            }.padding(.bottom, 4)
                            GroupBox {
                                TextField("Social Security Number", text: $socialSecurityNumber)
                                    .textFieldStyle(.plain)
                                    .padding(8)
                            }.padding(.bottom, 4)
                            GroupBox {
                                TextField("Passport Number", text: $passportNumber)
                                    .textFieldStyle(.plain)
                                    .padding(8)
                            }.padding(.bottom, 4)
                            GroupBox {
                                TextField("License Number", text: $licenseNumber)
                                    .textFieldStyle(.plain)
                                    .padding(8)
                            }.padding(.bottom, 4)
                        }
                        Divider()
                        Group {
                            GroupBox {
                                TextField("Email", text: $email)
                                    .textFieldStyle(.plain)
                                    .padding(8)
                            }.padding(.bottom, 4)
                            GroupBox {
                                TextField("Phone", text: $phone)
                                    .textFieldStyle(.plain)
                                    .padding(8)
                            }.padding(.bottom, 4)
                            GroupBox {
                                TextField("Address 1", text: $address1)
                                    .textFieldStyle(.plain)
                                    .padding(8)
                            }.padding(.bottom, 4)
                            GroupBox {
                                TextField("Address 2", text: $address2)
                                    .textFieldStyle(.plain)
                                    .padding(8)
                            }.padding(.bottom, 4)
                        }
                        Group {
                            GroupBox {
                                TextField("Address 3", text: $address3)
                                    .textFieldStyle(.plain)
                                    .padding(8)
                            }.padding(.bottom, 4)
                            GroupBox {
                                TextField("City", text: $city)
                                    .textFieldStyle(.plain)
                                    .padding(8)
                            }.padding(.bottom, 4)
                            GroupBox {
                                TextField("State", text: $state)
                                    .textFieldStyle(.plain)
                                    .padding(8)
                            }.padding(.bottom, 4)
                            GroupBox {
                                TextField("Zip", text: $zip)
                                    .textFieldStyle(.plain)
                                    .padding(8)
                            }.padding(.bottom, 4)
                            GroupBox {
                                TextField("Country", text: $country)
                                    .textFieldStyle(.plain)
                                    .padding(8)
                            }
                        }
                        Group {
                            CustomFieldsEdit(fields: $fields)
                            Divider()
                            NotesEditView($notes)
                        }
                        Divider()
                        CipherOptions(folder: $folder, favorite: $favorite, reprompt: $reprompt)
                            .environmentObject(account)
                    }
                    .padding(20)
                }
            }
            Footer(itemType: $itemType, create: create)
                .padding(20)
                .background(.gray.opacity(0.1))
        }
    }
}

#Preview {
    AddNewItemPopup(itemType: .constant(.identity))
        .environmentObject(Account())
}
