//
//  ItemView+ToolBarComponents.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2023-07-04.
//

import SwiftUI

extension ItemView {
    
    struct RegularCipherOptions: ToolbarContent {
        @Binding var cipher: Cipher?
        @Binding var editing: Bool
        let account: Account
        
        func restore() async throws {
            if let cipher {
                do {
                    try await account.user.restoreCipher(cipher: cipher)
                    self.cipher = nil
                } catch {
                    print(error)
                }
            }
        }
        
        func deletePermanently() async throws {
            if let cipher {
                do {
                    try await account.user.deleteCipherPermanently(cipher: cipher)
                    self.cipher = nil
                } catch {
                    print(error)
                }
            }
        }
        
        func delete() async throws {
            if let cipher {
                do {
                    try await account.user.deleteCipher(cipher: cipher)
                    self.cipher = nil
                } catch {
                    print(error)
                }
            }
        }
        
        var body: some ToolbarContent {
            Group {
                if cipher?.deletedDate == nil {
                        ToolbarItem {
                            Button {
                                editing = true
                            } label: {
                                Label("Edit", systemImage: "applepencil")
                                    .labelStyle(.titleOnly)
                            }
                        }
                        ToolbarItem {
                            Button {
                                Task {
                                    try await delete()
                                }
                            } label: {
                                Label("Delete", systemImage: "x.circle")
                                    .labelStyle(.titleOnly)
                            }
                        }
                } else {
                    ToolbarItem {
                        Button {
                            Task {
                                try await deletePermanently()
                            }
                        } label: {
                            Label("Delete Permanently", systemImage: "trash")
                                .labelStyle(.titleOnly)
                        }
                    }
                    ToolbarItem {
                        Button {
                            Task {
                                try await restore()
                            }
                        } label: {
                            Label("Restore", systemImage: "arrow.counterclockwise.circle")
                                .labelStyle(.titleOnly)
                        }
                    }
                }
            }
        }
    }
    struct EditingToolbarOptions: ToolbarContent {
        @Binding var cipher: Cipher?
        @Binding var editing: Bool
        var account: Account
        var save: () async throws -> Void
        
        var body: some ToolbarContent {
            Group {
                ToolbarItem {
                    Button {
                        Task {
                            editing = false
                        }
                    } label: {
                        Label("Cancel", systemImage: "x.circle.fill")
                            .labelStyle(.titleOnly)
                    }
                }
                ToolbarItem {
                    Button {
                        Task {
                            try await save()
                            editing = false
                        }
                    } label: {
                        Label("Done", systemImage: "lock.shield.fill")
                            .labelStyle(.titleOnly)
                    }
                }
            }
        }
    }
}

//struct ItemView_ToolBarComponents_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemView_ToolBarComponents()
//    }
//}
