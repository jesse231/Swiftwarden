//
//  GeneratePasswordButton.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2023-05-19.
//

import Foundation
import SwiftUI

struct Options: Equatable {
    var length: Int
    var upperCase: Bool
    var lowerCase: Bool
    var numbers: Bool
    var specialChar: Bool
}
func ==(lhs: Options, rhs: Options) -> Bool {
    return lhs.length == rhs.length &&
        lhs.upperCase == rhs.upperCase &&
        lhs.lowerCase == rhs.lowerCase &&
        lhs.numbers == rhs.numbers &&
        lhs.specialChar == rhs.specialChar
}

struct GeneratePasswordPopup: View {
    @State var password: String = ""
    @Binding var show: Bool
    @State var showAlert = false
    @Binding var change: String
    @State var switchPassword = false
    
    // Options
    @State var length: Double = 14
    @State var upperCase = true
    @State var lowerCase = true
    @State var numbers = true
    @State var specialChar = true
    
    
    var body: some View {
        VStack {
            Field(title: "Password", content: password, buttons: {Copy(content: password)}, monospaced: true )
                .padding()
            Text("Password Length: \(Int(length))")
            Slider(value: $length, in: 5...128)
                .padding()
            Divider()
            ScrollView {
                VStack {
                    HStack {
                        Text("Capital Letters (A-Z)")
                            .frame(alignment: .trailing)
                            .foregroundColor(.gray)
                        Spacer()
                        Toggle("", isOn: $upperCase).labelsHidden()
                    }
                    .padding()
                    HStack {
                        Text("Lowercase Letters (a-z)")
                            .frame(alignment: .trailing)
                            .foregroundColor(.gray)
                        Spacer()
                        Toggle("", isOn: $lowerCase).labelsHidden()
                    }
                    .padding()
                    HStack {
                        Text("Numbers (0-9)")
                            .frame(alignment: .trailing)
                            .foregroundColor(.gray)
                        Spacer()
                        Toggle("", isOn: $numbers).labelsHidden()
                    }
                    .padding()
                    HStack {
                        Text("Special Characters (!@#$%^&*)")
                            .frame(alignment: .trailing)
                            .foregroundColor(.gray)
                        Spacer()
                        Toggle("", isOn: $specialChar).labelsHidden()
                    }
                    .padding()
                    Spacer()
                    HStack {
                        Button {
                            show = false
                        } label: {
                            Text("Cancel")
                        }
                        Spacer()
                        Button {
                            if password != "" {
                                showAlert = true
                            }
                        } label: {
                            Text("Use")
                        }
                    }
                }
                .padding(.leading)
                .padding(.trailing)
            }
            .frame(maxWidth: .infinity)
            //.padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Overwrite Password"), message: Text("Are you sure you want to overwrite your current password?"),
                      primaryButton: .default(Text("Overwrite"), action: {
                    show = false
                    switchPassword = true
                }),
                      secondaryButton: .cancel(Text("Cancel")))
            }
            .onChange(of: Options(length: Int(length), upperCase: upperCase, lowerCase: lowerCase, numbers: numbers, specialChar: specialChar)) { options in
                
                do {
                    if !(options.lowerCase || options.upperCase || options.numbers || options.specialChar) {
                        lowerCase = true
                    }
                    password = try Generator.makePassword(size: options.length, upper: upperCase, lower: lowerCase, num: numbers, special: specialChar)
                } catch {
                    print(error)
                }
            }
            .onAppear {
                do {
                    password = try Generator.makePassword(size: Int(length))
                } catch {
                    print(error)
                }
            }
            .onDisappear {
                if switchPassword {
                    change = password
                }
            }
            .padding()
        }
        .frame(width: 400, height: 500)
    }
        
}

struct GeneratePasswordButton: View {
    @Binding var password: String
    @State private var showPopup = false
    var body: some View {
        Button {
            showPopup = true
        } label: {
            HoverSquare {
                Image(systemName: "arrow.triangle.2.circlepath")
            }
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showPopup) {
            GeneratePasswordPopup(show: $showPopup, change: $password)
        }
    }
}

