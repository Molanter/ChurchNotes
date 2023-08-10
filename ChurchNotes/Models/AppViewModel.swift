//
//  AppViewModel.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/17/23.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SwiftData

class AppViewModel: ObservableObject{
//    var ref: DatabaseReference! = Database.database().reference()
    var db = Firestore.firestore()
    var storage = Storage.storage().reference(forURL: "gs://curchnote.appspot.com")
    var auth = Auth.auth()
    @Environment(\.modelContext) private var modelContext
    var err = ""
    @State var profileImage = ""
    @Query var profile: [UserProfile]
    @Published var signedIn = false
    var isSignedIn: Bool{
        return auth.currentUser != nil
    }
     
    func twoNames(name: String) -> String{
        return String(name.components(separatedBy: " ").compactMap { $0.first }).count >= 3 ? String(String(name.components(separatedBy: " ").compactMap { $0.first }).prefix(2)) : String(name.components(separatedBy: " ").compactMap { $0.first })
    }
    
    func passSecure(password: String) -> Color{
        var passColor: Color = Color(K.Colors.gray)
        var bigLatter = false
        var smalLatter = false
        var symbol = false
        var numberPass = false
        var passCount = false
        var passwordSecure = 0
        for character in password{
            if "ABCDEFGHIJKLMNOPQRSTUVWXYZ".contains(character){
                bigLatter = true
            }
            if "abcdefghijklmnopqrstuvwxyz".contains(character){
                smalLatter = true
                
            }
            if "!@#$%^&*_-+=§±`~'.,".contains(character){
                symbol = true
                
            }
            if "0123456789".contains(character){
                numberPass = true
                
            }
            if password.count > 7{
                passCount = true
                
            }
        }
        if bigLatter == true{passwordSecure += 1}
        if smalLatter == true{passwordSecure += 1}
        if symbol == true{passwordSecure += 1}
        if numberPass == true{passwordSecure += 1}
        if passCount == true{passwordSecure += 1}
        
        switch passwordSecure{
        case ...0:
            passColor = Color(K.Colors.gray)
        case 1:
            passColor = Color(K.Colors.red)
        case 2:
            passColor = Color.orange
        case 3:
            passColor = Color(K.Colors.yellow)
        case 4:
            passColor = Color(K.Colors.blue)
        case 5...:
            passColor = Color(K.Colors.green)
        default:
            passColor = Color(K.Colors.gray)
        }
        print(passwordSecure)
        return passColor
    }
    
    func logOut(){
        do {
            try Auth.auth().signOut()
            self.signedIn = false
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    func login(email: String, password: String){
        auth.signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if error != nil {
                self?.err = error!.localizedDescription
            }else{
                self?.signedIn = true
                print("User logined succesfuly!")
            }
        }
    }
    
    func register(email: String, password: String, image: UIImage?, name: String, userName: String, country: String, phone: String){
        auth.createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if error != nil{
                self?.err = error!.localizedDescription
            }else{
                if image == nil{
                    print("image == nil")
                    self?.profileImage = ""
                    guard let uid = Auth.auth().currentUser?.uid else { return }
                        let dictionary: Dictionary <String, Any> = [
                            "uid": uid,
                            "email": email,
                            "name": name,
                            "timeStamp": Date.now,
                            "username": userName,
    //                        "dateOfBirth": dateOfBirth,
                            "country": country,
                            "profileImageUrl": "",
                            "phoneNumber": phone,
                            "status": ""
                        ]
                                self!.db.collection("users").document("profiles").collection(uid).document().setData(dictionary) { err in
                                    if let err = err {
                                        print("Error writing document: \(err.localizedDescription)")
                                    } else {
    //                                    let newProfile = UserProfile(name: name, phoneNumber: phone, email: email, cristian: true, notes: "", country: country, profileImage: self!.profileImage, username: userName, uid: uid)
    //                                    self?.modelContext.insert(newProfile)
    //                                    print(newProfile)
                                        self?.signedIn = true
                                        print("Document successfully written!")
                                    }
                                
                                    
                                }
                    print("User created succesfuly! with no image!)")
                }else{
                    guard let imageSelected = image else{
                        return
                    }
                    
                    guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else{
                        return
                    }
                guard let uid = Auth.auth().currentUser?.uid else { return }
                    var dictionary: Dictionary <String, Any> = [
                        "uid": uid,
                        "email": email,
                        "name": name,
                        "timeStamp": Date.now,
                        "username": userName,
//                        "dateOfBirth": dateOfBirth,
                        "country": country,
                        "profileImageUrl": "",
                        "phoneNumber": phone,
                        "status": ""
                    ]
                    let storegeProfileRef = self!.storage.child("users").child("profiles").child(self!.auth.currentUser!.uid)
                    let metadata = StorageMetadata()
                    metadata.contentType = "image/jpg"
                    storegeProfileRef.putData(imageData, metadata: metadata, completion: { (storageMetaData, error) in
                        if let error = error{
                            print(error.localizedDescription)
                            self?.err = error.localizedDescription
                            return
                        }
                        storegeProfileRef.downloadURL { url, error in
                            if let metaImageUrl = url?.absoluteString{
                                
                                if image != nil{
                                    dictionary["profileImageUrl"] = metaImageUrl
                                    self?.profileImage = metaImageUrl
                                }else{
                                    self?.profileImage = ""
                                    dictionary["profileImageUrl"] = self?.profileImage
                                }
                            }
                                
                            self!.db.collection("users").document("profiles").collection(uid).document().setData(dictionary) { err in
                                if let err = err {
                                    print("Error writing document: \(err.localizedDescription)")
                                } else {
//                                    let newProfile = UserProfile(name: name, phoneNumber: phone, email: email, cristian: true, notes: "", country: country, profileImage: self!.profileImage, username: userName, uid: uid)
//                                    self?.modelContext.insert(newProfile)
//                                    print(newProfile)
                                    self?.signedIn = true
                                    print("Document successfully written!")
                                }
                            
                                
                            }
                        }
                    })
                print("User created succesfuly!")}
            }
        }
    }
    
    func updateProfile(image: UIImage?, name: String, username: String, country: String, phone: String, documentId: String, oldImageLink: String){
        if let userID = auth.currentUser?.uid{
            let ref = db.collection("users").document("profiles").collection(userID).document(documentId)
            if image == nil{
                print("ref:   -\(ref)")
                ref.updateData(
                    ["name": name,
                     "username": username,
                     "country": country,
                     "phoneNumber": phone
                    ]){error in
                        if let error = error{
                            print("Error while updating profile:  -\(error)")
                        }else{
                            print("profile is updated!")
                        }
                    }
            }else{
                storage.child("users").child("profiles").child(userID).delete { error in
                    if let error = error {
                        print("Error while updating profile:  -\(error)")
                    } else {
                        // File deleted successfully
                    }
                }
                guard let imageSelected = image else{
                    return
                }
                
                guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else{
                    return
                }
                let storegeProfileRef = self.storage.child("users").child("profiles").child(self.auth.currentUser!.uid)
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpg"
                storegeProfileRef.putData(imageData, metadata: metadata, completion: { (storageMetaData, error) in
                    if let error = error{
                        print(error.localizedDescription)
                        self.err = error.localizedDescription
                        return
                    }
                    storegeProfileRef.downloadURL { url, error in
                        if let metaImageUrl = url?.absoluteString{
                            ref.updateData(
                                ["name": name,
                                 "profileImageUrl": metaImageUrl,
                                 "username": username,
                                 "country": country,
                                 "phoneNumber": phone
                                ]){error in
                                    if let error = error{
                                        print("Error while updating profile with image:  -\(error)")
                                    }else{
                                        print("profile is updated! with image!)")
                                    }
                                }
                            }
                    }
                })
            }
        }
    }
}
