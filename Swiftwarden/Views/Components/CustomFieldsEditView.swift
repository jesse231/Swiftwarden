//
//  CustomFields.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2023-06-13.
//

import SwiftUI

struct LinkedItem: View {
    @Binding var linked: Int?
    @Binding var name: String
    var body: some View {
        HStack{
            TextField("name", text: $name)
                .textFieldStyle(.plain)
            Spacer()
            Picker ("", selection: $linked){
                Text("Username").tag(100 as Int?)
                Text("Password").tag(101 as Int?)
            }
            .padding(.trailing)
            .pickerStyle(.menu)
            .frame(width: 150)
        }
    }
}

struct TextItem: View {
    @Binding var name: String
    @Binding var value: String
    var showButton = false
    @State private var show = false
    var body: some View {
        TextField("name", text: $name)
            .textFieldStyle(.plain)
        Divider()
        HStack {
            TextField("value", text: $value)
                .textFieldStyle(.plain)
            if showButton {
                Button {
                    show.toggle()
                } label: {
                    Image(systemName: "eye")
                }
                .buttonStyle(.borderless)
                .padding(.trailing)
            }
        }
    }
}

struct ToggleItem: View {
    @Binding var isOn: Bool
    @Binding var name: String
    var body: some View {
        HStack{
            TextField("name", text: $name)
                .textFieldStyle(.plain)
            Toggle("", isOn: $isOn)
                .padding(.trailing)
        }
        .onDisappear {
            print(isOn)
        }
    }
}

struct CustomFieldsEdit: View {
    @Binding var fields: [CustomField]
    @State var showOptions = false
    @State var option: String = ""
    @State var showItem: [Bool]
    var showLinked: Bool
    
    init(fields: Binding<[CustomField]>, showLinked: Bool? = nil) {
        self._fields = fields
        var show: [Bool] = []
        for _ in fields.wrappedValue {
            show.append(true)
        }
        _showItem = State(initialValue: show)
        self.showLinked = showLinked ?? true
    }
    
    
    var body: some View {
        VStack {
            Text("Custom Fields")
                .font(.system(size: 10))
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .foregroundColor(.gray)
            ForEach(0..<fields.count, id: \.self) { index in
                VStack {
                    HStack{
                        Button {
                            fields.remove(at: index)
                        } label: {
                            Image(systemName: "minus.circle")
                        }
                        GroupBox{
                            let name = Binding(
                                get: { fields[index].name ?? "" },
                                set: { fields[index].name = $0 }
                            )
                            let value = Binding(
                                get: { fields[index].value ?? "" },
                                set: { fields[index].value = $0 }
                            )
                            let type = fields[index].type
                            if  type == 0 {
                                TextItem(name: name, value: value)
                            } else if type == 1 {
                                TextItem(name: name, value: value, showButton: true)
                            } else if type == 2 {
                                let isOn = Binding<Bool>(
                                    get:
                                        {return fields[index].value == "true"},
                                    set:{ fields[index].value = $0 ? "true" : "false"})
                                ToggleItem(isOn: isOn, name: name)
                            } else if type == 3 {
                                let linked = Binding(
                                    get: { fields[index].linkedID ?? 100 as Int? },
                                    set: { fields[index].linkedID = $0 as Int? }
                                )
                                LinkedItem(linked: linked, name: name)
                            }
                        }
                    }
                }
            }
            Menu {
                Button {
                    fields.append(CustomField(type: 0))
                    showOptions = false
                } label: {
                    Text("Text")
                }
                Button {
                    fields.append(CustomField(type: 1))
                    showOptions = false
                } label: {
                    Text("Hidden")
                }
                Button {
                    fields.append(CustomField(type: 2))
                    showOptions = false
                } label: {
                    Text("Boolean")
                }
                if showLinked {
                    Button {
                        fields.append(CustomField(type: 3))
                        showOptions = false
                    } label: {
                        Text("Linked")
                    }
                }
            } label: {
                Label("Add Field", systemImage: "plus")
            }
            .frame(width: 100, height: 50, alignment: .center)
            .padding()
            .menuStyle(.button)
            .menuIndicator(.hidden)
        }
    }
}

struct CustomFields_Previews: PreviewProvider {
    static var previews: some View {
        @State var custom: [CustomField] = [CustomField(type: 0), CustomField(type: 1), CustomField(type: 2), CustomField(type: 3)]
        CustomFieldsEdit(fields: $custom)
    }
}
