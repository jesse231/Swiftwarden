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
        
        @State private var cardholderName = ""
        @State private var number = ""
        
        @State private var brand = ""
        @State private var expirationMonth = ""
        @State private var expirationYear = ""
        @State private var securityCode = ""
        
        @State private var folder: Folder
        @State private var favorite = false
        @State private var reprompt = false
        
        @State private var notes = ""
        
        @State private var customFields: [CustomField] = []
        init (account: Account, name: Binding<String>) {
            self.account = account
            self._name = name
            _folder = State(initialValue: account.user.getFolders()[0])
        }
        
        var body: some View {
            Text("Test")
        }
    }
    
}

struct AddNewItem_Card_Previews: PreviewProvider {
    static var previews: some View {
        AddNewItemPopup.AddNewCard(account: Account(), name: .constant("New Card"))
    }
}
