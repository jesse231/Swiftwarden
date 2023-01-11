//
//  ContentView.swift
//  Bitwarden
//
//  Created by Jesse Seeligsohn on 2022-07-02.
//

import SwiftUI
import UniformTypeIdentifiers

    
extension View {
    private func newWindowInternal(with title: String) -> NSWindow {
        let window = NSWindow(
            contentRect: NSRect(x: 20, y: 20, width: 680, height: 600),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false)
        window.center()
        window.isReleasedWhenClosed = false
        window.title = title
        window.makeKeyAndOrderFront(nil)
        return window
    }
    
    func openNewWindow(with title: String = "new Window") {
        self.newWindowInternal(with: title).contentView = NSHostingView(rootView: self)
    }
}

struct ContentView: View {
    @State var loginSuccess = false
    @State var email: String = ""
    @State var password: String = ""
    @State var server: String = ""
    var body: some View {
        if loginSuccess {
            MainView(email: email, password: password, base: server)
        } else {
            LoginView(loginSuccess: $loginSuccess, email: $email, password: $password, server: $server)
        }

    }
}


struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
