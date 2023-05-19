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
