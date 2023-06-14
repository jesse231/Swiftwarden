//
//  CustomFieldsView.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2023-06-14.
//

import SwiftUI

struct CustomFieldsView: View {
    @State var customFields: [CustomField]
    init(_ customFields: [CustomField]) {
        self.customFields = customFields
    }
    var body: some View {
        VStack {
        Text("Custom Fields")
                .font(.headline)
                .padding(.bottom, -10)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding([.leading])
            VStack {
                ForEach(customFields, id: \.self) { field in
                    if field.type == 0 {
                        Field(title: field.name ?? "", content: field.value ?? "", buttons: {})
                    } else if field.type == 1 {
                        Field(title: field.name ?? "", content: field.value ?? "", buttons: {
                            Copy(content: field.value ?? "")
                        })
                    }
                    
                }
            }.padding(.leading)
        
        }
    }
}

struct CustomFieldsView_Previews: PreviewProvider {
    static var previews: some View {
        CustomFieldsView([CustomField(type: 0, name: "test", value: "test"), CustomField(type: 1, name: "test", value: "test")])
    }
}
