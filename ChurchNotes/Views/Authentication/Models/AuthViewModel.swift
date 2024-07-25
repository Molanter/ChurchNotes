//
//  AuthViewModel.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/24/24.
//

import SwiftUI
import Observation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import SwiftData

@Observable
final class AuthViewModel {
    private var credentials: [Credential] = []
    var isAvailable = false
    var errorMessage = ""
    var signedIn = false
    let deviceName = "\(UIDevice.current.name) \(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
    
    let auth = Auth.auth()
    var db = Firestore.firestore()
    var storage = Storage.storage().reference(forURL: "gs://curchnote.appspot.com")
    var published = PublishedVariebles()

    var isSignedIn: Bool{
        return auth.currentUser != nil
    }
    
    //MARK: Authentication
    func register(email: String, password: String, image: UIImage?, name: String, userName: String, country: String, phone: String, modelContext: ModelContext){
        auth.createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if error != nil{
                self?.errorMessage = error!.localizedDescription
            }else{
                if image == nil{
                    print("image == nil")
                    guard let uid = Auth.auth().currentUser?.uid else { return }
                    let dictionary: Dictionary <String, Any> = [
                        "uid": uid,
                        "email": email,
                        "name": name,
                        "timeStamp": Date.now,
                        "username": userName,
                        "notes": "",
                        //                        "dateOfBirth": dateOfBirth,
                        "country": country,
                        "profileImageUrl": "",
                        "phoneNumber": phone,
                        "status": "",
                        "role": "user",
                        "devises": FieldValue.arrayUnion([self!.deviceName])
                    ]
                    self!.db.collection("users").document(uid).setData(dictionary) { errorMessage in
                        if let errorMessage = errorMessage {
                            print("Error writing document: \(errorMessage.localizedDescription)")
                        } else {
                            self?.errorMessage = ""
                            self?.signedIn = true
                            K.deviceName = self!.deviceName
                            print("Document successfully written!")
                        }
                        
                        
                    }
                    self!.db.collection("usernames").document(userName).setData(
                        ["username": userName,
                         "uid": uid
                        ]) { error in
                            if let error = error {
                                print("Error adding document: \(error)")
                            } else {
                                print("Document added with ID: \(userName)")
                            }
                        }
                    if self?.credentials.count ?? 0 <= 4 {
                        if let array = self?.credentials.filter({ $0.email == self?.published.encrypt(email, key: K.key())}), array.isEmpty {
                            if let em = self?.published.encrypt(email, key: K.key()), let pass = self?.published.encrypt(password, key: K.key()){
                                let newCred = Credential(email: em, password: pass, imageData: nil, username: userName)
                                modelContext.insert(newCred)
                            }
                            
                        }
                    }else {
                        self?.credentials.remove(at: 0)
                        if let array = self?.credentials.filter({ $0.email == self?.published.encrypt(email, key: K.key())}), array.isEmpty {
                            if let em = self?.published.encrypt(email, key: K.key()), let pass = self?.published.encrypt(password, key: K.key()){
                                let newCred = Credential(email: em, password: pass, imageData: nil, username: userName)
                                modelContext.insert(newCred)
                            }
                            
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
                        "mainColor": "blue-purple",
                        "username": userName,
                        "notifications": false,
                        "notificationTime": Date.now,
                        "notes": "",
                        //                        "dateOfBirth": dateOfBirth,
                        "country": country,
                        "profileImageUrl": "",
                        "phoneNumber": phone,
                        "status": "",
                        "role": "user",
                        "devises": FieldValue.arrayUnion([self!.deviceName])
                    ]
                    let storegeProfileRef = self!.storage.child("users").child(self!.auth.currentUser!.uid)
                    let metadata = StorageMetadata()
                    metadata.contentType = "image/jpg"
                    storegeProfileRef.putData(imageData, metadata: metadata, completion: { (storageMetaData, error) in
                        if let error = error{
                            print(error.localizedDescription)
                            self?.errorMessage = error.localizedDescription
                            return
                        }
                        storegeProfileRef.downloadURL { url, error in
                            if let metaImageUrl = url?.absoluteString{
                                
                                if image != nil{
                                    dictionary["profileImageUrl"] = metaImageUrl
                                }
                            }
                            
                            self!.db.collection("users").document(uid).setData(dictionary) { errorMessage in
                                if let errorMessage = errorMessage {
                                    print("Error writing document: \(errorMessage.localizedDescription)")
                                } else {
                                    self?.errorMessage = ""
                                    self?.signedIn = true
                                    K.deviceName = self!.deviceName
                                    print("Document successfully written!")
                                }
                                self!.db.collection("usernames").document(userName).setData(
                                    ["username": userName,
                                     "uid": uid
                                    ]) { error in
                                        if let error = error {
                                            print("Error adding document: \(error)")
                                        } else {
                                            print("Document added with ID: \(userName)")
                                        }
                                    }
                                
                            }
                        }
                    })
                    if self?.credentials.count ?? 0 <= 4 {
                        if let array = self?.credentials.filter({ $0.email == self?.published.encrypt(email, key: K.key())}), array.isEmpty {
                            if let em = self?.published.encrypt(email, key: K.key()), let pass = self?.published.encrypt(password, key: K.key()){
                                let newCred = Credential(email: em, password: pass, imageData: imageData, username: userName)
                                modelContext.insert(newCred)
                            }
                            
                        }
                    }else {
                        self?.credentials.remove(at: 0)
                        if let array = self?.credentials.filter({ $0.email == self?.published.encrypt(email, key: K.key())}), array.isEmpty {
                            if let em = self?.published.encrypt(email, key: K.key()), let pass = self?.published.encrypt(password, key: K.key()){
                                let newCred = Credential(email: em, password: pass, imageData: imageData, username: userName)
                                modelContext.insert(newCred)
                            }
                            
                        }
                    }
                    print("User created succesfuly!")
                }
            }
        }
    }
    
    func login(email: String, password: String, createIcon: Bool = true, modelContext: ModelContext) {
        auth.signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if error != nil {
                self?.errorMessage = error!.localizedDescription
            }else{
                self?.signedIn = true
                self?.errorMessage = ""
                
                if let userId = authResult?.user.uid {
                    self?.db.collection("users").document(userId).updateData([
                        "devices": FieldValue.arrayUnion([self!.deviceName])
                    ]) { error in
                        if let error = error {
                            self?.errorMessage = error.localizedDescription
                        } else {
                            K.deviceName = self!.deviceName
                            print("Device added successfully.")
                        }
                    }
                }
                if createIcon{
                    if self?.credentials.count ?? 0 <= 4 {
                        if let encryptedEmail = self?.published.encrypt(email, key: K.key()) {
                            if self?.credentials.map({ $0.email }).contains(encryptedEmail) == false {
                                if let em = self?.published.encrypt(email, key: K.key()), let pass = self?.published.encrypt(password, key: K.key()){
                                    let newCred = Credential(email: em, password: pass, imageData: nil, username: email)
                                    modelContext.insert(newCred)
                                }
                            }
                        }
                    }else {
                        self?.credentials.remove(at: 0)
                        if let encryptedEmail = self?.published.encrypt(email, key: K.key()) {
                            if self?.credentials.map({ $0.email }).contains(encryptedEmail) == false {
                                if let em = self?.published.encrypt(email, key: K.key()), let pass = self?.published.encrypt(password, key: K.key()){
                                    let newCred = Credential(email: em, password: pass, imageData: nil, username: email)
                                    modelContext.insert(newCred)
                                }
                            }
                        }
                    }
                }
                
//                self?.fetchUser()
                print("User logined succesfuly!")
            }
        }
    }
    
    //MARK: Username
    
    func checkUsernameAvailability(username: String) {
        isUsernameAvailable(username: username) { (available, _) in
            DispatchQueue.main.async {
                self.isAvailable = available
            }
        }
    }
    
    func isUsernameAvailable(username: String, completion: @escaping (Bool, Error?) -> Void) {
        let db = Firestore.firestore()
        let publicUsernamesCollection = db.collection("usernames")
        
        // Check if a document with the given username exists in the "PublicUsernames" collection.
        publicUsernamesCollection.document(username).getDocument { (document, error) in
            if let document = document, /*document.exists,*/ let userId = Auth.auth().currentUser?.uid, let uid = document["uid"] as? String, userId == uid {
                // Username is taken by current user.
                completion(true, nil)
            }else if let document = document, document.exists {
                // Username already taken.
                
                completion(false, nil)
            } else if let error = error {
                // An error occurred while checking the availability.
                completion(false, error)
            } else {
                // Username is available.
                completion(true, nil)
            }
        }
    }
}
