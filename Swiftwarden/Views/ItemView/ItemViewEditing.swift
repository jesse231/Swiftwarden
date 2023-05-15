import Foundation
import SwiftUI

struct ItemEditingView: View {
    @EnvironmentObject var account: Account
    @Binding var editing: Bool
    @Binding var cipher: Cipher
    
    @State var name: String = ""
    
    @State var username: String = ""
    @State var password: String = ""
    @State var hostname: String = ""
    
    @State var favorite: Bool = false
    @State var folder: Folder = Folder(id: "", name: "")
    @State var reprompt: Bool = false
    
    var body: some View {
        GroupBox{
            HStack{
                Spacer()
                Button {
                    Task {
                        let index = account.user.getCiphers(deleted: true).firstIndex(of: account.selectedCipher)

                        var modCipher = cipher
                        modCipher.name = name
                        modCipher.login?.username = username
                        modCipher.login?.password = password
                        modCipher.login?.uris = [Uris(uri: hostname)]
                        modCipher.favorite = favorite
                        modCipher.reprompt = reprompt ? 1 : 0
                        try await account.user.updateCipher(cipher: modCipher, api: account.api, index: index)
                        account.selectedCipher = modCipher
                        cipher = modCipher
                        
                        self.editing = false
                    }
                    
                    
                    
                } label: {
                    Text("Done")
                }
            }
            VStack{
                HStack{
                        Image(systemName: "lock.circle")
                            .resizable()
                            .frame(width: 35, height: 35)
                    VStack{
                        //GroupBox{
                            TextField("Name", text: $name)
//                                .padding(8)
                                .font(.system(size: 15))
                                .fontWeight(.bold)
                       // }
                            .textFieldStyle(.plain)
                            .textFieldStyle(.plain)
                        Text(verbatim: "Login")
                            .font(.system(size: 10))
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                        
                    }
                    Button (action: {
                        favorite = !favorite
                        account.selectedCipher.favorite = favorite
//                            allPasswords.favourites.append(allPasswords.currentPassworzd)
                        Task {
                            try await account.api.updatePassword(cipher: account.selectedCipher)
                        }
                    } ){
                        if (favorite) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        } else {
                            Image(systemName: "star")
                            
                        }
                    }.buttonStyle(.plain)
                   
                    
                }
                EditingField(title: "Username", content: $username).padding(.bottom, 8)
                EditingField(title: "Password", content: $password, secure: true).padding(.bottom, 8)
                EditingField(title: "Website", content: $hostname).padding(.bottom, 8)
                
//                if folder  {
                    Picker(selection: $folder, label: Text("Folder")) {
                        ForEach(account.user.getFolders(), id:\.self) {folder in
                            Text(folder.name)
                        }
                    }
//                }
                HStack{
                    Text("Master Password re-prompt")
                        .frame(alignment: .trailing)
                        .foregroundColor(.gray)
                    Spacer()
                    Toggle("Reprompt", isOn: $reprompt).labelsHidden()
                }
            }
        }
            .onAppear(
                perform: {
                    name = account.selectedCipher.name ?? ""
                    username = account.selectedCipher.login?.username ?? ""
                    password = account.selectedCipher.login?.password ?? ""
                    hostname = account.selectedCipher.login?.uris?.first?.uri ?? ""
                    favorite = account.selectedCipher.favorite ?? false
                    if let folderID = account.selectedCipher.folderID {
                        self.folder = account.user.getFolders().filter({$0.id == folderID}).first!
                    } else {
                        folder = account.user.getFolders().first!
                    }
                    reprompt = account.selectedCipher.reprompt == 1 ? true : false
                                    
                })
    }
}

struct ItemEditingView_Previews: PreviewProvider {
    static var previews: some View {
        @State var editing = false
//        ItemEditingView(editing: $editing)
//                .environmentObject(Account())
//                .padding()
//                .previewLayout(.sizeThatFits)
    }
}
