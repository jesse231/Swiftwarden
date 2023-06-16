//
//  CustomFieldsView.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2023-06-14.
//

import SwiftUI

struct BooleanField: View {
    var title: String
    var bool: Bool
    var body: some View {
        VStack {
                Text(title)
                    .font(.system(size: 10))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .foregroundColor(.gray)
                Toggle("", isOn: .constant(bool))
                    .toggleStyle(.switch)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(.leading, -7)
            }
        .padding()

    }
}

struct LinkedField: View {
    var title: String
    var linkedID: Int
    var body: some View {
        VStack {
                Text(title)
                    .font(.system(size: 10))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .foregroundColor(.gray)
                Label("Username", systemImage: "link")
                    .toggleStyle(.switch)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
        .padding()

    }
}

struct CustomFieldsView: View {
    @State var customFields: [CustomField]
    init(_ customFields: [CustomField]) {
        self.customFields = customFields
    }
    var body: some View {
//        VStack {
//        Text("Custom Fields")
//                .font(.headline)
//                .frame(maxWidth: .infinity, alignment: .topLeading)
//                .padding([.leading])
                //.animation(.default)
                //'.transition(.scale)
            VStack {
                ForEach(customFields, id: \.self) { field in
                    if field.type == 0 {
                        Field(title: field.name ?? "", content: field.value ?? "", buttons: {Copy(content: field.value ?? "")})
                    } else if field.type == 1 {
                        Field(title: field.name ?? "", content: field.value ?? "", secure: true, buttons: {
                            Copy(content: field.value ?? "")
                        })
                    } else if field.type == 2 {
                        BooleanField(title: field.name ?? "", bool: field.value == "true")
                    } else if field.type == 3 {
                        LinkedField(title: field.name ?? "", linkedID: field.linkedID ?? 100)
                    }
                }
            }        
//        }
    }
}

struct CustomFieldsView_Previews: PreviewProvider {
    static var previews: some View {
        CustomFieldsView([CustomField(type: 0, name: "test", value: "test"), CustomField(type: 3, name: "test", value: "true", linkedID: 100)])
    }
}
