//
//  UserModel.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/24/24.
//

import Foundation

struct User: Identifiable{
    var id: String{uid}
    var next, done, bloger: Int
    var uid,email, name, username, notes, country, profileImageUrl, phoneNumber, status, role, badge, reason: String
    var devicesArray: [String]
    init(data: [String: Any]){
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.name = data["name"] as? String ?? ""
        self.username = data["username"] as? String ?? ""
        self.role = data["role"] as? String ?? ""
        self.notes = data["notes"] as? String ?? ""
        self.country = data["country"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
        self.phoneNumber = data["phoneNumber"] as? String ?? ""
        self.status = data["status"] as? String ?? ""
        self.reason = data["reason"] as? String ?? ""
        self.next = data["next"] as? Int ?? 0
        self.done = data["done"] as? Int ?? 0
        self.bloger = data["bloger"] as? Int ?? 0
        self.badge = data["badge"] as? String ?? ""
        self.devicesArray = data["devices"] as? [String] ?? []
    }
}
