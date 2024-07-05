//
//  ItemView+ToolBarComponents.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2023-07-04.
//

import SwiftUI

struct RegularCipherOptions: ToolbarContent {
    @Binding var cipher: Cipher?
    @Binding var editing: Bool
    @EnvironmentObject var account: Account
    @Environment (\.route) var routeManager: RouteManager
    
    func restore() async throws {
        if let cipher {
            do {
                try await account.user.restoreCipher(cipher: cipher)
                routeManager.lastSelected = nil
                routeManager.selection = []
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
                routeManager.lastSelected = nil
                routeManager.selection = []
            } catch {
                print(error)
            }
        }
    }
    
    func delete() async throws {
        if let cipher {
            do {
                try await account.user.deleteCipher(cipher: cipher)
                routeManager.lastSelected = nil
                routeManager.selection = []
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
                            try await restore()
                        }
                    } label: {
                        Label("Restore", systemImage: "arrow.counterclockwise.circle")
                            .labelStyle(.titleOnly)
                    }
                }
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
            }
        }
    }
}
struct EditingToolbarOptions: ToolbarContent {
    @Binding var cipher: Cipher?
    @Binding var editing: Bool
    var account: Account
    var save: () -> Void
    
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
                        editing = false
                        save()
                } label: {
                    Label("Done", systemImage: "lock.shield.fill")
                        .labelStyle(.titleOnly)
                }
            }
        }
    }
}
