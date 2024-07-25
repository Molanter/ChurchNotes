//
//  CredentialsDataModel.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 5/7/24.
//

import SwiftUI
import CryptoKit
import SwiftData

@Model
final class Credential {
    @Attribute(.unique) var email: String
    var password: String
    var image: Data?
    var username: String
    
    init(email: String, password: String, imageData: Data?, username: String) {
            self.email = email
            self.password = password
            self.image = imageData
            self.username = username
        }
}


