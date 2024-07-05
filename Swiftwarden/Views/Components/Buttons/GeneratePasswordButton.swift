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
            Field(title: "Password", content: password, monospaced: true, buttons: {Copy(content: password)} )
                .padding()
            Text("Password Length: \(Int(length))")
            Slider(value: $length, in: 5...128)
                .padding()
            Divider()
                VStack {
                    Form {
                        Toggle("Capital Letters (A-Z)", isOn: $upperCase)
                        Toggle("Lowercase Letters (a-z)", isOn: $lowerCase)
                        Toggle("Numbers (0-9)", isOn: $numbers)
                        Toggle("Special Characters (!@#$%^&*)", isOn: $specialChar)
                    }
                    .formStyle(.grouped)
                    .scrollDisabled(true)
                    .scrollContentBackground(.hidden)
                    Spacer()
                    HStack {
                        Button {
                            show = false
                        } label: {
                            Text("Cancel")
                        }
                        Spacer()
                        Button {
                            if change != "" {
                                showAlert = true
                            } else {
                                show = false
                                switchPassword = true
                            }
                        } label: {
                            Text("Use")
                        }
                    }
                    .padding()
                }
                .padding(.leading)
                .padding(.trailing)
        }
        .frame(width: 400, height: 430)
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


// Preview
struct GeneratePasswordButton_Previews: PreviewProvider {
    static var previews: some View {
        GeneratePasswordPopup(show: .constant(true), change: .constant(""))
    
    }
}

