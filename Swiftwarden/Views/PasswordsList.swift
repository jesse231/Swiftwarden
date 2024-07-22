import Foundation
import NukeUI
import SwiftUI
import CoreImage
import Nuke

struct PasswordsList: View, Equatable {
    @EnvironmentObject var account: Account
    @Environment (\.route) var routeManager: RouteManager
    @Binding var searchText: String
    @State private var deleteDialog = false
    @State private var filtered: [Cipher] = []
    @State private var isLoading = false
    var imagePrefetcher = ImagePrefetcher()
    var folderID: String?
    let prefetcher = ImagePrefetcher()
    
    static func == (lhs: PasswordsList, rhs: PasswordsList) -> Bool {
        lhs.searchText == rhs.searchText && lhs.display == rhs.display //&& lhs.selection == rhs.selection
    }
    
    
    
    var display: PasswordListType
    func passwordsToDisplay() -> [Cipher] {
        var ciphers: [Cipher]
        switch display {
        case .normal:
            ciphers = account.user.getCiphers()
        case .trash:
            ciphers = account.user.getTrash()
        case .favorite:
            ciphers = account.user.getFavorites()
        case .login:
            ciphers = account.user.getLogins()
        case .card:
            ciphers = account.user.getCards()
        case .folder:
            ciphers = account.user.getCiphersInFolder(folderID: folderID)
        case .identity:
            ciphers = account.user.getIdentities()
        case .secureNote:
            ciphers = account.user.getSecureNotes()
        }
        let filtered = ciphers.filter { cipher in
            return cipher.name?.lowercased().contains(searchText.lowercased()) ?? false || searchText == ""
        }
        Task {
            var urls: [URL] = []
            for cipher in filtered {
                if let url = URL(string: cipher.login?.domain ?? "") {
                    urls.append(url)
                }
            }
            prefetcher.startPrefetching(with: urls)
        }
        
        return filtered
    }
    
    private func loadData() {
        guard !isLoading else { return }
        isLoading = true
        DispatchQueue.global().async {
            let loadedCiphers = passwordsToDisplay()
            DispatchQueue.main.async {
                filtered = loadedCiphers
                isLoading = false
            }
        }
    }
    
    init(searchText: Binding<String>, display: PasswordListType, folderID: String? = nil) {
        self._searchText = searchText
        self.display = display
        self.folderID = folderID
    }
    
    func favoriteButton(cipher: Cipher) -> some View {
        Button {
            Task {
                do {
                    withAnimation {
                        account.user.toggleFavorite(cipher: cipher)
                        if routeManager.lastSelected?.id == cipher.id {
                            routeManager.lastSelected?.favorite?.toggle()
                        }
                    }
                } catch {
                    print(error)
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
            set: { routeManager.selection = $0
            }
        )
        List(filtered.indices, id: \.self, selection: selectionBinding) { index in
            let cipher = filtered[index]
            let globalIndex = account.user.data.passwords.firstIndex(where: { $0.id == cipher.id }) ?? 0
            ListElement(cipher: cipher, globCipher: $account.user.data.passwords[globalIndex])
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
        .animation(.default, value: filtered)
        .onReceive(routeManager.$selection.dropFirst()) { select in
            if select.isEmpty {
                routeManager.lastSelected = nil
            }
            if let index = select.max() {
                routeManager.lastSelected = filtered[index]
            }
        }
        .onAppear {
            routeManager.selection = []
            loadData()
        }
        .onChange(of: searchText) { _ in
            loadData()
        }
        .onReceive(account.user.data.$passwords) { data in
            DispatchQueue.main.async {
                loadData()
            }
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
}
