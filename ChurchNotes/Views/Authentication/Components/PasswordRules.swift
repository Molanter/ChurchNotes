//
//  PasswordRules.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 5/10/24.
//

import SwiftUI

struct PasswordRules: View {
    @EnvironmentObject var published: PublishedVariebles

    @Binding var pass: String
    
    var body: some View {
        labels
        .onChange(of: pass) {
            checkPass()
        }
    }
    
    var labels: some View {
        VStack(alignment: .leading, spacing: 2) {
            Label("pass-capital", systemImage: capital() ? "checkmark" : "xmark")
                .foregroundStyle(capital() ? Color.green : Color.red)
                .font(.caption)
            Label("pass-lowercase", systemImage: lowercase() ? "checkmark" : "xmark")
                .foregroundStyle(lowercase() ? Color.green : Color.red)
                .font(.caption)
            Label("pass-special", systemImage: special() ? "checkmark" : "xmark")
                .foregroundStyle(special() ? Color.green : Color.red)
                .font(.caption)
            Label("pass-numbers", systemImage: numbers() ? "checkmark" : "xmark")
                .foregroundStyle(numbers() ? Color.green : Color.red)
                .font(.caption)
            Label("pass-long", systemImage: numbers() ? "checkmark" : "xmark")
                .foregroundStyle(numbers() ? Color.green : Color.red)
                .font(.caption)
        }
    }
    func capital() -> Bool {
        for character in pass {
            if character.isUppercase {
                return true
            }
        }
        return false
    }
    
    func lowercase() -> Bool {
        for character in pass {
            if character.isLowercase {
                return true
            }
        }
        return false
    }
    func special() -> Bool {
        let specialCharacters = "!@#$%^&*_'-+=§±`~,;"
        
        for character in pass {
            if specialCharacters.contains(character) {
                return true
            }
        }
        return false
    }
    func numbers() -> Bool {
        let numbers = "1234567890"
        
        for character in pass {
            if numbers.contains(character) {
                return true
            }
        }
        return false
    }
    func long() -> Bool {
        if pass.count >= 10 {
            return true
        }else {
            return false
        }
    }
    func checkPass() {
        if capital(), lowercase(), special(), numbers(), long() {
            published.passwordSecure = true
        }else {
            published.passwordSecure = false
        }
    }
}

//#Preview {
//    PasswordRules(pass: "edfgpP.@")
//}




//if "0123456789".contains(character){
//    numberPass = true
//    
//}
//if password.count > 7{
//    passCount = true
//    
//}
