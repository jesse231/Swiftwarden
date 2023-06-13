//
//  AddUrlList.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2023-05-17.
//

import SwiftUI

struct AddUrlList: View {
    @Binding var urls: [Uris]
    var body: some View {
        VStack {
            Text("Website")
                .font(.system(size: 10))
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .foregroundColor(.gray)
            ForEach(urls.indices, id: \.self) {index in
                HStack {
                    GroupBox {
                        HStack {
                            Button {
                                urls.remove(at: index)
                            } label: {
                                Image(systemName: "minus.circle")
                            }
                            TextField("URL", text: $urls[index].uri)
                                .textFieldStyle(.plain)
                            Picker("", selection: Binding(
                                get: { urls[index].match ?? -1 },
                                set: { urls[index].match = ($0 == -1) ? nil : $0 }
                            )) {
                                Text("Default").tag(-1)
                                Text("Base Domain").tag(0)
                                Text("Host").tag(1)
                                Text("Starts With").tag(2)
                                Text("Regular Expression").tag(4)
                                Text("Exact").tag(3)
                                Text("Never").tag(5)
                            }
                        }
                    }
                }
            }
            HStack {
                Spacer()
                Button {
                    urls.append(Uris(url: ""))
                } label: {
                    Image(systemName: "plus.circle")
                    Text("Add Url")
                }
                Spacer()
            }
        }
    }
}

struct AddUrlList_Previews: PreviewProvider {
    static var previews: some View {
        @State var urls = [Uris(url: "test.com"), Uris(url: "example.com")]
        GroupBox {
            AddUrlList(urls: $urls)
        }
    }
}
