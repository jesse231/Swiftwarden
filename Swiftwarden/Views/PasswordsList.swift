import Foundation
import NukeUI
import SwiftUI
import CoreImage
import Nuke

struct PasswordsList: View {
    @EnvironmentObject var account: Account
    @EnvironmentObject var data: AccountData
    @Environment (\.route) var routeManager: RouteManager
    @Environment (\.appState) var appState: AppState
    @Binding var searchText: String
    @State private var deleteDialog = false
    @State private var isLoading = false
    var imagePrefetcher = ImagePrefetcher()
    let prefetcher = ImagePrefetcher()
    
    
    
    var display: PasswordListType
    
    private func loadData() {
        guard !isLoading else { return }
        isLoading = true
        DispatchQueue.main.async {
            account.user.passwordsToDisplay(display: display, searchText: searchText)
        }
    }
    
    func favoriteButton(cipher: Cipher) -> some View {
        Button {
            Task {
                withAnimation {
                    account.user.toggleFavorite(cipher: cipher)
                    if routeManager.lastSelected?.id == cipher.id {
                        routeManager.lastSelected?.favorite?.toggle()
                    }
                }
            }
        } label: {
            Label("Favorite", systemImage: "star")
        }
        .tint(.yellow)
    }
    
    func deleteButton(cipher: Cipher) -> some View {
        Button(role:.destructive) {
            if routeManager.lastSelected?.id == cipher.id {
                routeManager.lastSelected = nil
            }
            account.user.deleteCipher(cipher: cipher)
        } label: {
            Label("Delete", systemImage: "trash")
        }
    }
    
    func restoreButton(cipher: Cipher) -> some View {
        Button(role: .destructive) {
            if routeManager.lastSelected?.id == cipher.id {
                routeManager.lastSelected = nil
            }
            account.user.restoreCipher(cipher: cipher)
        } label: {
            Label("Restore", systemImage: "clock.arrow.circlepath")
        }
        .tint(.blue)
    }
    
    func permanentDeleteButton(cipher: Cipher) -> some View {
        Button(role: .destructive) {
            if routeManager.lastSelected?.id == cipher.id {
                routeManager.lastSelected = nil
            }
            account.user.deleteCipherPermanently(cipher: cipher)
        } label: {
            Label("Delete", systemImage: "trash")
        }
        .tint(.red)
    }

    var body: some View {
        let selectionBinding = Binding<Set<Int>>(
            get: { routeManager.selection },
            set: { routeManager.selection = $0}
        )
        List(account.user.data.currentPasswords.indices, id: \.self, selection: selectionBinding) { index in
            let cipher = account.user.data.currentPasswords[index]
            ListElement(cipher: cipher)
                .id(cipher.id)
                .padding(5)
                .listRowSeparator(.hidden)
                .swipeActions(edge: .leading) {
                    if display == .trash {
                        restoreButton(cipher: cipher)
                    } else {
                        favoriteButton(cipher: cipher)
                    }
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    if display == .trash {
                        permanentDeleteButton(cipher: cipher)
                    } else {
                        deleteButton(cipher: cipher)
                    }
                }
        }
        .animation(.default, value: data.currentPasswords)
        .onReceive(routeManager.$selection.dropFirst()) { select in
            if select.isEmpty {
                routeManager.lastSelected = nil
            }
            if let index = select.max() {
                routeManager.lastSelected = data.currentPasswords[index]
            }
        }
        .onReceive(data.$currentPasswords) { newPasswords in
            if display == .favorite {
                for cipher in newPasswords {
                    if !(cipher.favorite ?? false), let index = data.currentPasswords.firstIndex(of: cipher) {
                        data.currentPasswords.remove(at: index)
                        routeManager.selection = []
                    }
                }
            }
        }
        .onAppear {
            routeManager.selection = []
            loadData()
            appState.selectedType = display
        }
        .toolbar {
            ToolbarItem {
                ListToolbar()
                    .environmentObject(account)
            }
            
        }
        .frame(minWidth: 350, idealWidth: 500)
    }
}

#Preview {
    PasswordsList(searchText: .constant(""), display: .normal)
        .environmentObject(Account())
        .environmentObject(AccountData())
}
