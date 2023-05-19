import Foundation
import SwiftUI

struct Popout: View {
    @State var username = "username"
    @State var password = "password"
    var body: some View {
        VStack {
            HStack {
                Text("Username:")
                TextField("test", text: $username)
            }
            HStack {
                Text("Password:")
                TextField("password", text: $password)
            }
            Spacer()
        }
    }

}
