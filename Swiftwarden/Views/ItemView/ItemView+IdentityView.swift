import Foundation
import NukeUI
import SwiftUI

extension ItemView {
    struct IdentityView: View {
        @Binding var cipher: Cipher?
        @Binding var editing: Bool
        @Binding var reprompt: RepromptState
        @State var showReprompt: Bool = false
        @State var showPassword: Bool = false
        
        @StateObject var account: Account
                
        var body: some View {
                VStack {           
                    ViewHeader(itemType: .identity, cipher: $cipher)
                    ScrollView {
                        VStack {
                            Group {
                                if let title = cipher?.identity?.title {
                                    Field(title: "Title", content: title, buttons: {})
                                }
                                if let firstName = cipher?.identity?.firstName {
                                    Field(title: "First Name", content: firstName, buttons: {})
                                }
                                if let middleName = cipher?.identity?.middleName {
                                    Field(title: "Middle Name", content: middleName, buttons: {})
                                }
                                if let lastName = cipher?.identity?.lastName {
                                    Field(title: "Last Name", content: lastName, buttons: {})
                                }
                            }
                            Group {
                                if let username = cipher?.identity?.username {
                                    Field(title: "Username", content: username, buttons: {})
                                }
                                if let company = cipher?.identity?.company {
                                    Field(title: "Company", content: company, buttons: {})
                                }
                                if let ssn = cipher?.identity?.ssn {
                                    Field(title: "SSN", content: ssn, buttons: {})
                                }
                                if let passportNumber = cipher?.identity?.passportNumber {
                                    Field(title: "Passport Number", content: passportNumber, buttons: {})
                                }
                                if let licenseNumber = cipher?.identity?.licenseNumber {
                                    Field(title: "License Number", content: licenseNumber, buttons: {})
                                }
                            }
                            Group {
                                if let email = cipher?.identity?.email {
                                    Field(title: "Email", content: email, buttons: {})
                                }
                                if let phone = cipher?.identity?.phone {
                                    Field(title: "Phone", content: phone, buttons: {})
                                }
                                if let address1 = cipher?.identity?.address1 {
                                    Field(title: "Address 1", content: address1, buttons: {})
                                }
                                if let address2 = cipher?.identity?.address2 {
                                    Field(title: "Address 2", content: address2, buttons: {})
                                }
                                if let address3 = cipher?.identity?.address3 {
                                    Field(title: "Address 3", content: address3, buttons: {})
                                }
                                if let city = cipher?.identity?.city {
                                    Field(title: "City / Town", content: city, buttons: {})
                                }
                                if let state = cipher?.identity?.state {
                                    Field(title: "State / Province", content: state, buttons: {})
                                }
                                if let zip = cipher?.identity?.postalCode {
                                    Field(title: "Zip / Postal Code", content: zip, buttons: {})
                                }
                                if let country = cipher?.identity?.country {
                                    Field(title: "Country", content: country, buttons: {})
                                }
                            }
                            if let fields = cipher?.fields {
                                CustomFieldsView(fields)
                            }

                            if let notes = cipher?.notes {
                                Field(title: "Note", content: notes, showButton: false, buttons: {})
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
struct IdentityView_Preview: PreviewProvider {
    static var previews: some View {
        Text("test")
    }
}

