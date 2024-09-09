//
//  Constants.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 6/27/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI
import CryptoKit
import SwiftData


struct K{
    static func key() -> SymmetricKey {
        // Default key if loading from UserDefaults fails
        let defaultKey = SymmetricKey(size: .bits256)

        if let k = UserDefaults.standard.data(forKey: "key") {
            print("Key loaded from UserDefaults")
            do {
                let loadedKey = try SymmetricKey(data: k)
                return loadedKey
            } catch {
                print("Failed to load key from UserDefaults:", error)
                return defaultKey
            }
        } else {
            print("Creating a new key")
            let keyData = defaultKey.withUnsafeBytes { Data($0) }
            UserDefaults.standard.set(keyData, forKey: "key")
            return defaultKey
        }
    }


//    static var key = SymmetricKey(size: .bits256)
//    @Query var credentials: [Credential]
    
    @AppStorage("choosedStages") static var choosedStages: Int = 0
    @AppStorage("favouriteSign") static var favouriteSign: String = "heart"
    @AppStorage("testFeatures") static var testFeatures: Bool = false
    @AppStorage("swipeStage") static var swipeStage: Bool = false
    @AppStorage("showStatus") static var showStatus: Bool = true
    @AppStorage("deviceName") static var deviceName: String = "\(UIDevice.current.name) \(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"

    struct Colors{
        static let colorsDictionary: [String: String] = [
            String(localized: "ppurple"): "blue-purple",
            String(localized: "llight-bblue"): "light-blue",
            String(localized: "bblue"): "bluee",
            String(localized: "ddark-bblue"): "dark-blue",
            String(localized: "oorange"): "orangee",
            String(localized: "ggreen"): "greenn",
            String(localized: "yyellow"): "yelloww",
            String(localized: "rred"): "redd"
        ]
//        @AppStorage("mainColor") static var mainColor: String = "blue-purple"
        @AppStorage("mainColor") static var mainColor: Color = Color(K.Colors.bluePurple)
        @AppStorage("color") static var color: String = "blue-purple"

        @AppStorage("appearance") static var appearance: Int = 0
        @AppStorage("favouriteSignColor") static var favouriteSignColor = "redd"
        
        static let red = "redd"
        static let blue = "bluee"
        static let yellow = "yelloww"
        static let green = "greenn"
        static let lightGray = "light-grayy"
        static let justLightGray = "justLightGray"
        static let gray = "grayy"
        static let darkGray = "dark-grayy"
        static let justDarkGray = "justDarkGray"
        static let background = "backgroundd"
        static let bluePurple = "blue-purple"
        static let lightGreen = "light-green"
        static let orange = "orangee"
        static let pink = "pinkk"
        static let lightBlue = "light-blue"
        static let darkBlue = "dark-blue"
        static let text = "text-appearance"
        static let blackAndWhite = "blackAndWhite"
        static let whiteGray = "whiteGray"
        static let listBg = "list-bg"
        static let rowBg = "list-row-bg"
        static let colorArray: [Color] = [.yellow, .yelloww, .orange, .redd, .pink, .purple, .darkBlue, .bluee, .lightBlue, .lightGreen, .green, .cyan, .indigo, .gray, .mint, .indigo, .teal]
    }
}

class Utilities {

    @AppStorage("appearance") var appearance: Int = 0
    var userInterfaceStyle: ColorScheme = .dark

    func overrideDisplayMode() {
        var userInterfaceStyle: UIUserInterfaceStyle

        if appearance == 0{
            userInterfaceStyle = .unspecified
        }else if appearance == 2 {
            userInterfaceStyle = .light
        } else if appearance == 1 {
            userInterfaceStyle = .dark
        } else {
            userInterfaceStyle = .unspecified
        }
    
        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = userInterfaceStyle
    }
}

extension Character {
    var isEnglishCharacter: Bool {
        return ("A"..."Z" ~= self) || ("a"..."z" ~= self)
    }

    var isNumber: Bool {
        return "0"..."9" ~= self
    }

    var isAllowedSymbol: Bool {
        let allowedSymbols: Set<Character> = ["-", "_", "."]
        return allowedSymbols.contains(self)
    }
}
