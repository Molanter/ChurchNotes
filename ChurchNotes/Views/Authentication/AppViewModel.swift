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
import FirebaseFunctions

class AppViewModel: ObservableObject{
    //    var ref: DatabaseReference! = Database.database().reference()
    @Published var errorMessage = ""
    @Published var peopleArray = [Person]()
    @Published var stagesArray = [Stage]()
    @Published var messagesArray = [MessageModel]()
    @Published var supportMessageArray = [LastMessageModel]()
    @Published var tokensArray: [String] = []
    @Published var badgesArray: [String] = []
    @Published var achievementsArray = [Achievements]()
    @Published var notificationsArray = [Notifics]()
    @Published var usernameIsTaken = false
    @Published var isAvailable = false
    @Published var signedIn = false
    @Published var isAuthenticated = false
    @Published var isProfileFinished = false
    @Published var passwordReseted: String?
    @Published var currentUser: Users?
    @Published var moved: Int = 0
    var db = Firestore.firestore()
    var storage = Storage.storage().reference(forURL: "gs://curchnote.appspot.com")
    var auth = Auth.auth()
    @Published var err = ""
    @State var profileImage = ""
    
    var published = PublishedVariebles()
    
    var isSignedIn: Bool{
        return auth.currentUser != nil
    }
    
    private var sortedStages: [AppStage]{
        return K.AppStages.stagesArray.sorted(by: { $0.orderIndex < $1.orderIndex })
    }
    
    
    
    
    //MARK: Reports
    func shakeReport(_ anonymously: Bool = false, errorText: String = "") {
        let collectionPath = "shakeErrors"
        guard let userId = auth.currentUser?.uid else {
            return
        }
        
        let stageData: [String: Any] = [
            "errorText": errorText,
            "timestamp": Date.now,
            "userId": anonymously ? "" : userId,
            "createBy": userId
        ]
        
        let documentPath = "\(userId)_\(stagesArray.count - 1)" // Unique identifier based on name
        db.collection(collectionPath).document(documentPath).setData(stageData) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document \(documentPath) successfully written!")
            }
        }
    }
    
    
    
    //MARK: Stages
    func deleteStage(documentId: String){
        db.collection("stages").document(documentId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func editStage(name: String, documentId: String){
        let ref = db.collection("stages").document(documentId)
        ref.updateData(
            ["name": name]
        ){error in
            if let error = error{
                print("Error while updating profile:  -\(error)")
            }else{
                print("profile is updated! \(name)")
            }
        }
    }
    
    func fetchStages() {
        guard let userId = auth.currentUser?.uid else {
            return
        }
        
        db.collection("stages")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    print("Error: \(error.localizedDescription)")
                } else {
                    stagesArray.removeAll() // Clear the array here, after error check
                    querySnapshot?.documents.forEach({ queryDocumentSnapshot in
                        let data = queryDocumentSnapshot.data()
                        let docId = queryDocumentSnapshot.documentID
                        let stageModel = Stage(documentId: docId, data: data)
                        self.stagesArray.append(stageModel)
                    })
                }
            }
    }
    
    func saveStages(name: String = "") {
        // Create a reference to Firestore
        
        // Specify the path to the collection
        let collectionPath = "stages"
        guard let userId = auth.currentUser?.uid else {return}
        
        let stageData: [String: Any] = [
            "name": name,
            "orderIndex": stagesArray.count - 1,
            "userId": userId,
            "createBy": "user"
        ]
        
        let documentPath = "\(userId)_\(stagesArray.count - 1)" // Unique identifier based on name
        db.collection(collectionPath).document(documentPath).setData(stageData, merge: true) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document \(documentPath) successfully written!")
            }
        }
    }
    
    
    
    //MARK: People
    
    func nextStage(documentId: String, titleNumber: Int){
        let ref = db.collection("people").document(documentId)
        
        if titleNumber != 6{
            let newName = sortedStages[titleNumber + 1].name
            
            ref.updateData(
                [
                    "title": newName,
                    "titleNumber": titleNumber + 1]
            ){error in
                if let error = error{
                    self.moved = 0
                    print("Error while updating profile:  -\(error)")
                }else{
                    self.moved = 1
                    print("profile is updated! \(newName) \(titleNumber)")
                }
            }
        }
    }
    
    func previousStage(documentId: String, titleNumber: Int){
        let ref = db.collection("people").document(documentId)
        
        if titleNumber != 0{
            let newName = sortedStages[titleNumber - 1].name
            
            ref.updateData(
                [
                    "title": newName,
                    "titleNumber": titleNumber - 1
                ]){error in
                    if let error = error{
                        self.moved = 0
                        print("Error while updating profile:  -\(error)")
                    }else{
                        self.moved = 2
                        print("profile is updated! \(newName) \(titleNumber)")
                    }
                }
        }
    }
    
    func adduserIdToDocument(documentId: String, newuserId: String) {
        let documentRef = db.collection("people").document(documentId)
        
        // Atomically update the userId dictionary by adding a new entry
        documentRef.setData([
            "userId.\(newuserId)": [
                "isLiked": false,
                "orderIndex": 0
            ]
        ], merge: true) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated with new userId.")
            }
        }
    }
    
    
    func removeuserIdFromDocument(documentId: String, userIdToRemove: String) {
        let documentRef = db.collection("people").document(documentId)
        
        // Atomically remove the userId from the array
        documentRef.updateData([
            "userIds": FieldValue.arrayRemove([userIdToRemove])
        ]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated, removed userId.")
            }
        }
    }
    
    func deleteImageFromPerson(_ docId: String){
        let ref = db.collection("people").document(docId)
        
        ref.updateData(
            [
                "imageData": ""
            ]){error in
                if let error = error{
                    print("Error while updating profile:  -\(error)")
                }else{
                    self.storage.child("people").child(docId).delete { error in
                        if let error = error {
                            print("Error while updating profile:  -\(error)")
                        } else {
                            print("image is deleted from storege!")
                        }
                    }
                    print("image is deleted from profile!")
                }
            }
    }
    
    func fetchPeople(){
        print("fetch")
        guard let userId = auth.currentUser?.uid else { return }
        db.collection("people")
            .whereField("userId.\(userId)", isNotEqualTo: [])
            .addSnapshotListener { [self] querySnapshot, error in
                if let err = error {
                    self.errorMessage = err.localizedDescription
                    print("Error: \(err.localizedDescription)")
                } else {
                    peopleArray.removeAll()
                    querySnapshot?.documents.forEach { queryDocumentSnapshot in
                        let data = queryDocumentSnapshot.data()
                        let docId = queryDocumentSnapshot.documentID
                        
                        if let userIdsDict = data["userId"] as? [String: [String: Any]],
                           let userDict = userIdsDict[userId],
                           let isLiked = userDict["isLiked"] as? Bool,
                           let orderIndex = userDict["orderIndex"] as? Int {
                            let personModel = Person(documentId: docId, data: data, isLiked: isLiked, orderIndex: orderIndex)
                            self.peopleArray.append(personModel)
                        } else {
                            print("userId or isLiked not found in the document")
                        }
                    }
                }
            }
    }
    
    
    func handleSend(name: String, notes: String, email: String, title: String, phone: String, imageData: UIImage?, orderIndex: Int, isCheked: Bool, isLiked: Bool, isDone: Bool, birthDay: Date, timestamp: Date, titleNumber: Int) {
        guard let userId = auth.currentUser?.uid else {
            self.errorMessage = "user-id-is-missing"
            return
        }
        
        var personData: [String: Any] = [
            "createdBy": userId,
            "name": name,
            "notes": notes,
            "email": email,
            "phone": phone,
            "imageData": "",
            "birthDay": birthDay,
            "timeStamp": timestamp,
            "titleNumber": titleNumber,
            "title": title,
            "isDone": isDone,
            "userId": [
                userId: [
                    "isLiked": isLiked,
                    "orderIndex": orderIndex
                ]
            ]
            //            "userId": [userId],
            //            "isLiked": [false]
        ]
        
        if let imageData = imageData, let imageDat = imageData.jpegData(compressionQuality: 0.4) {
            let writerDocument = db.collection("people").document()
            let storegeProfileRef = storage.child("people").child(writerDocument.documentID)
            //            let ref = db.collection("people").document(writerDocument.documentID).collection("userId").document(userId)
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            
            storegeProfileRef.putData(imageDat, metadata: metadata) { (storageMetaData, error) in
                if let error = error {
                    print(error.localizedDescription)
                    self.err = error.localizedDescription
                    return
                }
                
                storegeProfileRef.downloadURL { [self] url, error in
                    if let metaImageUrl = url?.absoluteString {
                        personData["imageData"] = metaImageUrl // Update the imageData with the image URL
                    }
                    
                    // Save the data to Firestore
                    writerDocument.setData(personData) { error in
                        if let er = error {
                            self.errorMessage = er.localizedDescription
                            print("Error: \(er.localizedDescription)")
                        } else {
                            //                            ref.setData(
                            //                                ["userId": userId,
                            //                                 "orderIndex": orderIndex,
                            //                                 "isCheked": isCheked,
                            //                                 "isLiked": isLiked
                            //                                ]){error in
                            //                                    if let error = error{
                            //                                        print("Error while updating profile:  -\(error)")
                            //                                    }else{
                            //                                        print("userId and info added")
                            //                                    }
                            //                                }
                            print("Data saved successfully")
                        }
                    }
                }
            }
        } else {
            // No image data provided, save data without an image URL
            let writerDocument = db.collection("people").document()
            //            let ref = db.collection("people").document(writerDocument.documentID).collection("userId").document(userId)
            writerDocument.setData(personData) { error in
                if let er = error {
                    self.errorMessage = er.localizedDescription
                    print("Error: \(er.localizedDescription)")
                } else {
                    //                    ref.setData(
                    //                        ["userId": userId,
                    //                         "orderIndex": orderIndex,
                    //                         "isCheked": isCheked,
                    //                         "isLiked": isLiked
                    //                        ]){error in
                    //                            if let error = error{
                    //                                print("Error while updating profile:  -\(error)")
                    //                            }else{
                    //                                print("userId and info added")
                    //                            }
                    //                        }
                    print("Data saved successfully (no image)")
                }
            }
        }
    }
    
    func likePerson(documentId: String, isLiked: Bool){
        guard let userId = auth.currentUser?.uid else {return}
        
        let documentRef = db.collection("people").document(documentId)
        
        // Update the isLiked field for the specified userId
        documentRef.updateData([
            "userId.\(userId).isLiked": isLiked
        ]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Like added successfully.")
            }
        }
    }
    
    func editPerson(documentId: String, name: String, email: String, phone: String, notes: String, image: UIImage?){
        let ref = db.collection("people").document(documentId)
        
        if image == nil{
            ref.updateData(
                [
                    "name": name,
                    "email": email,
                    "phone": phone,
                    "notes": notes
                ]){error in
                    if let error = error{
                        print("Error while updating profile:  -\(error)")
                    }else{
                        print("profile is updated!")
                    }
                }
        }else{
            storage.child("people").child(documentId).delete { error in
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
            let storegeProfileRef = self.storage.child("people").child(documentId)
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
                            [
                                "name": name,
                                "email": email,
                                "phone": phone,
                                "notes": notes,
                                "imageData": metaImageUrl
                            ]){error in
                                if let error = error{
                                    print("Error while updating profile:  -\(error)")
                                }else{
                                    print("profile is updated!")
                                }
                            }
                    }
                }
            })
        }
    }
    
    
    func isDonePerson(documentId: String, isDone: Bool){
        let ref = db.collection("people").document(documentId)
        ref.updateData(
            ["isDone": isDone]){error in
                if let error = error{
                    print("Error while updating profile:  -\(error)")
                }else{
                    print("profile is updated!")
                }
            }
    }
    
    func deletePerson(documentId: String, userIdToDelete: String = Auth.auth().currentUser?.uid ?? "") {
        let documentRef = db.collection("people").document(documentId)
        
        documentRef.getDocument { (document, error) in
            if let document = document, document.exists {
                var userIds = document["userId"] as? [String: [String: Any]] ?? [:]
                
                // Check if the specified userId exists in the userIds dictionary
                if userIds.count > 1 {
                    // Remove only the specified userId from the array
                    userIds.removeValue(forKey: userIdToDelete)
                    
                    // Update the userIds field in the document
                    documentRef.updateData(["userId": userIds]) { error in
                        if let error = error {
                            print("Error updating userIds field: \(error)")
                        } else {
                            print("userId removed from the document!")
                        }
                    }
                } else {
                    // Delete the entire document if no other userIds are present
                    documentRef.delete { error in
                        if let error = error {
                            print("Error removing document: \(error)")
                        } else {
                            let storageRef = self.storage.child("people").child(documentId)
                            storageRef.delete { error in
                                if let error = error {
                                    print("Error deleting file: \(error)")
                                } else {
                                    print("File deleted successfully!")
                                }
                            }
                            print("Document successfully removed!")
                        }
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func twoNames(name: String) -> String{
        return String(name.components(separatedBy: " ").compactMap { $0.first }).count >= 3 ? String(String(name.components(separatedBy: " ").compactMap { $0.first }).prefix(2)) : String(name.components(separatedBy: " ").compactMap { $0.first })
    }
    
    
    //MARK: Current User
    
    func changeEmail(currentPassword: String, newEmail: String) {
        guard let user = Auth.auth().currentUser else {
            self.err = "no-user-logged-in"
            return
        }
        guard let userId = auth.currentUser?.uid else{return}
        let ref = db.collection("users").document(userId)
        
        let credential = EmailAuthProvider.credential(withEmail: user.email!, password: currentPassword)
        
        user.reauthenticate(with: credential) { _, error in
            if let error = error {
                self.err = error.localizedDescription
            } else {
                user.updateEmail(to: newEmail) { error in
                    if let error = error {
                        self.err = error.localizedDescription
                    } else {
                        // Email changed successfully
                        // You might want to sign out the user and ask them to log in with the new email
                        self.err = "email-changed-successfully"
                        ref.updateData(
                            ["email": newEmail
                            ]){error in
                                if let error = error{
                                    print("Error while updating profile:  -\(error)")
                                }else{
                                    
                                }
                            }
                        self.logOut()
                    }
                }
            }
        }
    }
    
    func fetchUser(){
        if let userId = Auth.auth().currentUser?.uid{
            db.collection("users").document(userId).getDocument { querySnapshot, err in
                if let err = err {
                    print("Error getting documents: \(err)")
                    self.err = err.localizedDescription
                } else {
                    self.currentUser = nil
                    if let  document = querySnapshot {
                        let dictionary = document.data()
                        if let dictionary = dictionary{
                            
                            let curUser = Users(data: dictionary)
                            self.currentUser = curUser
                        }
                    }
                }
            }
            
        }
        
    }
    
    
    //MARK: Password
    
    func changePassword(currentPassword: String, newPassword: String, confirmPassword: String) {
        guard newPassword == confirmPassword else {
            self.err = "passwords-do-not-match"
            return
        }
        
        guard let user = Auth.auth().currentUser, let email = user.email else {
            self.err = "user-not-authenticated-or-email-not-available"
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        
        // Reauthenticate the user with their current password
        user.reauthenticate(with: credential) { _, error in
            if let error = error {
                self.err = "reauthentication-failed: \(error.localizedDescription)"
                return
            }
            
            // If reauthentication is successful, update the password
            user.updatePassword(to: newPassword) { error in
                if let error = error {
                    self.err = "password-update-failed: \(error.localizedDescription)"
                } else {
                    self.err = "password-updated-successfully"
                }
            }
        }
    }
    
    func resetPassword(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.err = error.localizedDescription
            } else {
                self.passwordReseted = "password-reset-email-sent"
            }
        }
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
    
    
    
    
    //MARK: Acount
    func logOut(){
        do {
            try Auth.auth().signOut()
            self.signedIn = false
            self.isProfileFinished = false
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
        self.isProfileFinished = true
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
                        "notifications": false,
                        "notificationTime": Date.now,
                        "notes": "",
                        //                        "dateOfBirth": dateOfBirth,
                        "country": country,
                        "profileImageUrl": "",
                        "phoneNumber": phone,
                        "status": "",
                        "role": "user"
                    ]
                    self!.db.collection("users").document(uid).setData(dictionary) { err in
                        if let err = err {
                            print("Error writing document: \(err.localizedDescription)")
                        } else {
                            self?.signedIn = true
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
                    print("User created succesfuly! with no image!)")
                    self!.isProfileFinished = true
                    
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
                        "status": ""
                    ]
                    let storegeProfileRef = self!.storage.child("users").child(self!.auth.currentUser!.uid)
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
                            
                            self!.db.collection("users").document(uid).setData(dictionary) { err in
                                if let err = err {
                                    print("Error writing document: \(err.localizedDescription)")
                                } else {
                                    self?.signedIn = true
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
                    print("User created succesfuly!")
                    self!.isProfileFinished = true
                }
            }
        }
    }
    
    //    func createProfileStore(email: String, image: String, name: String, country: String, phone: String, username: String){
    //            self.profileImage = ""
    //            guard let uid = Auth.auth().currentUser?.uid else { return }
    //                let dictionary: Dictionary <String, Any> = [
    //                    "uid": uid,
    //                    "email": email,
    //                    "name": name,
    //                    "timeStamp": Date.now,
    //                    "username": username,
    //                    "notifications": false,
    //                    "notificationTime": Date.now,
    //                    "notes": "",
    ////                        "dateOfBirth": dateOfBirth,
    //                    "country": country,
    //                    "profileImageUrl": image,
    //                    "phoneNumber": phone,
    //                    "status": "",
    //                    "role": "user"
    //                ]
    //                        self.db.collection("users").document(uid).setData(dictionary, merge: true) { err in
    //                            if let err = err {
    //                                print("Error writing document: \(err.localizedDescription)")
    //                            } else {
    //                                print("Document successfully written!")
    //                            }
    //
    //
    //                        }
    //
    //            print("User created succesfuly!)")
    //            self.saveStages(true)
    //        self.signedIn = true
    //
    //
    //    }
    
    func addAchiv(name: String, int: Int){
        guard let userId = auth.currentUser?.uid else{return}
        
        self.db.collection("users").document(userId).updateData(
            [name: int
            ]) { error in
                if let error = error {
                    print("Error adding document: \(error)")
                } else {
                    self.fetchUser()
                    print("Document added with ID: \(name) \(int)")
                }
            }
    }
    
    func updateFcmToken(token: String){
        guard let userId = auth.currentUser?.uid else{return}
        let ref = db.collection("users").document(userId).collection("fcmTokens").document(token)
        
        ref.setData(
            ["token": token
            ]){error in
                if let error = error{
                    print("Error while updating profile:  -\(error)")
                }else{
                    print("token is updated!")
                }
            }
    }
    
    func deleteFcmToken(token: String){
        guard let userId = auth.currentUser?.uid else{return}
        let ref = db.collection("users").document(userId).collection("fcmTokens").document(token)
        
        ref.delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func updateProfile(image: UIImage?, name: String, username: String, country: String, phone: String, documentId: String, oldImageLink: String, userId: String){
        let ref = db.collection("users").document(userId)
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
                        guard let userId = self.auth.currentUser?.uid else {return}
                        self.db.collection("usernames")
                            .whereField("userId", isEqualTo: userId)
                            .addSnapshotListener { [self] querySnapshot, error in
                                if let err = error{
                                    self.errorMessage = err.localizedDescription
                                    print("err l:  _ \(err.localizedDescription)")
                                } else {
                                    querySnapshot?.documents.forEach({ queryDocumentSnapshot in
                                        let data = queryDocumentSnapshot.data()
                                        let docId = queryDocumentSnapshot.documentID
                                        print(docId)
                                    })
                                }
                            }
                        //                            db.collection("usernames").document(username).setData(
                        //                                ["username": userName,
                        //                                 "uid": uid
                        //                                ]) { error in
                        //                                if let error = error {
                        //                                    print("Error adding document: \(error)")
                        //                                } else {
                        //                                    print("Document added with ID: \(userName)")
                        //                                }
                        //                            }
                        if username != ""{
                            self.db.collection("usernames").document(username).setData(
                                ["username": username,
                                 "uid": userId
                                ]) { error in
                                    if let error = error {
                                        print("Error adding document: \(error)")
                                    } else {
                                        print("Document added with ID: \(username)")
                                    }
                                }
                        }
                        print("profile is updated!")
                    }
                }
        }else{
            storage.child("users").child(userId).delete { error in
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
            let storegeProfileRef = self.storage.child("users").child(self.auth.currentUser!.uid)
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
                        self.currentUser?.profileImageUrl = metaImageUrl
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
    
    
    //MARK: Notifications
    func createNotification(sunday: Bool, monday: Bool, tuesday: Bool, wednsday: Bool, thursday: Bool, friday: Bool, saturday: Bool, date: Date, message: String, count: Int){
        guard let uid = Auth.auth().currentUser?.uid else{return}
        let dictionary: Dictionary <String, Any> = [
            "uid": uid,
            "sunday": sunday,
            "monday": monday,
            "tuesday": tuesday,
            "wednsday": wednsday,
            "thursday": thursday,
            "friday": friday,
            "saturday": saturday,
            "date": date,
            "orderIndex": count,
            "message": message == "" ? "time-to-pray_take-you-time" : message
        ]
        self.db.collection("notifications").document().setData(dictionary) { err in
            if let err = err {
                print("Error writing document: \(err.localizedDescription)")
            } else {
                print("Document successfully written!")
            }
            
            
        }
    }
    
    func fetchNotifications(){
        guard let userId = auth.currentUser?.uid else {return}
        db.collection("notifications")
            .whereField("uid", isEqualTo: userId)
            .addSnapshotListener { [self] querySnapshot, error in
                if let err = error{
                    self.errorMessage = err.localizedDescription
                    print("err l:  _ \(err.localizedDescription)")
                } else {
                    notificationsArray.removeAll()
                    querySnapshot?.documents.forEach({ queryDocumentSnapshot in
                        let data = queryDocumentSnapshot.data()
                        let docId = queryDocumentSnapshot.documentID
                        let personModel = Notifics(documentId: docId, data: data)
                        self.notificationsArray.append(personModel)
                    })
                }
            }
    }
    
    func removeAllNotifications(){
        guard let userId = auth.currentUser?.uid else {return}
        
        for notific in notificationsArray{
            db.collection("notifications").document(notific.documentId).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
        }
    }
    
    func stopNotifing(item: Notifics){
        guard let userId = auth.currentUser?.uid else {return}
        db.collection("notifications").document(item.documentId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    
    
    //MARK: Achievements
    
    func fetchAchievements() {
        guard let userId = auth.currentUser?.uid else {
            return
        }
        
        db.collection("achievements")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    print("Error: \(error.localizedDescription)")
                } else {
                    achievementsArray.removeAll() // Clear the array here, after error check
                    querySnapshot?.documents.forEach({ queryDocumentSnapshot in
                        let data = queryDocumentSnapshot.data()
                        let docId = queryDocumentSnapshot.documentID
                        let achievementModel = Achievements(documentId: docId, data: data)
                        self.achievementsArray.append(achievementModel)
                    })
                }
            }
    }
    
    func createAchievement(name: String = "") {
        // Create a reference to Firestore
        
        // Specify the path to the collection
        let collectionPath = "achievements"
        guard let userId = auth.currentUser?.uid else { return }
        
        let achievementData: [String: Any] = [
            "name": name,
            "int": 0,
            "userId": userId,
        ]
        
        let documentPath = "\(userId)_\(achievementsArray.count - 1)" // Unique identifier based on name
        db.collection(collectionPath).document(documentPath).setData(achievementData, merge: true) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document \(documentPath) successfully written!")
            }
        }
    }
    
    func editAchievements(documentId: String, int: Int){
        let ref = db.collection("achievements").document(documentId)
        
        ref.updateData(
            [
                "int": int
            ]){error in
                if let error = error{
                    self.moved = 0
                    print("Error while updating profile:  -\(error)")
                }else{
                    print("achievements is updated!")
                }
            }
    }
    
    //MARK: Notification
    
    func getFcmByEmail(email: String, messageText: String?, subtitle: String?, title: String?, imageURL: String?, link: String?, badgeCount: Int?){
        db.collection("users")
            .whereField("email", isEqualTo: email)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    print("Error: \(error.localizedDescription)")
                } else {
                    print("emm")
                    querySnapshot?.documents.forEach({ queryDocumentSnapshot in
                        self.tokensArray.removeAll()
                        let data = queryDocumentSnapshot.data()
                        let token = data["token"] as? String ?? ""
                        print("token  ", token)
                        self.tokensArray.append(token)
                        //
                    })
                    self.sendNotification(messageText: messageText ?? "", subtitle: subtitle ?? "", title: title ?? "", imageURL: imageURL ?? "", link: link ?? "", fcmTokens: self.tokensArray, badgeCount: badgeCount ?? 0)
                }
            }
    }
    
    func sendNotification(messageText: String, subtitle: String, title: String, imageURL: String, link: String, fcmTokens: [String], badgeCount: Int) {
        // Fetch all FCM tokens associated with the user ID from your server or database
        
        for fcmToken in fcmTokens {
            // Prepare the FCM payload
            let message: [String: Any] = [
                "to": fcmToken,
                "notification": [
                    "title": title,
                    "subtitle": subtitle,
                    "body": messageText,
                    "image": imageURL,
                    "badge": badgeCount  // Add badge count to the notification payload
                ],
                "data": [
                    "badge": 5, // Set the badge count here
                    "sound": "default",
                    "link": link
                ]
            ]
            // Send the notification using Firebase Cloud Messaging API
            let url = URL(string: "https://fcm.googleapis.com/fcm/send")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("key=AAAAha_FqrM:APA91bFphB5J-VnxnFqeEdX2U-kjuBB9tSiKuWQSXfZ04MthgYj7FKpD_XRfonba91-xwdHZ0JyKV4NaKmPQowFnw295mr8KSnVfbcG2xvQzatDLHQFIKEfvktBGMfSB7S1a0Eq7KQVE", forHTTPHeaderField: "Authorization")
            
            do {
                print("not 1")
                
                let jsonData = try JSONSerialization.data(withJSONObject: message, options: [])
                request.httpBody = jsonData
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print("Error sending notification: \(error.localizedDescription)")
                    } else if let data = data {
                        let responseString = String(data: data, encoding: .utf8)
                        print("Notification sent successfully, response: \(responseString ?? "")")
                    }
                }
                
                task.resume()
            } catch {
                print("Error serializing JSON: \(error.localizedDescription)")
            }
        }
    }
    
    func sendNotification() {
        guard let url = URL(string: "https://us-central1-curchnote.cloudfunctions.net/updateBadgeCount") else {
            print("Invalid Cloud Function URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "userId": auth.currentUser?.uid ?? "",
            "badgeCount": 5
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            print("Error encoding JSON: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending notification: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                print("Notification sent successfully")
            } else {
                print("Error sending notification. Response: \(response.debugDescription)")
            }
        }.resume()
    }
    
    
    //MARK: Jedai
    
    func getuserIdByEmail(email: String, completion: @escaping (String) -> Void) {
        db.collection("users")
            .whereField("email", isEqualTo: email)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    print("Error: \(error.localizedDescription)")
                    completion("") // Call completion with an empty string to indicate failure
                } else {
                    querySnapshot?.documents.forEach { queryDocumentSnapshot in
                        let data = queryDocumentSnapshot.data()
                        let uid = data["uid"] as? String ?? ""
                        completion(uid) // Call completion with the obtained userId
                    }
                }
            }
    }
    
    
    
    func updateRole(role: String, uid: String){
        let ref = db.collection("users").document(uid)
        
        ref.updateData(
            ["role": role
            ]){error in
                if let err = error{
                    print("Error while updating role: ", err.localizedDescription)
                }else{
                    print("Role updated")
                }
            }
        
    }
    
    func updateStatus(status: String, uid: String) {
        let ref = db.collection("users").document(uid)
        
        ref.updateData(["status": status]) { error in
            if let err = error {
                print("Error while updating status: ", err.localizedDescription)
            } else {
                print("Status updated")
            }
        }
    }
    
    func deleteAccount(userId: String, completion: @escaping (Error?) -> Void) {
        let deleteAccountFunction = Functions.functions().httpsCallable("deleteAccountByuserId")
        
        let data = ["userId": userId]
        
        deleteAccountFunction.call(data) { (result, error) in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    
    //MARK: Badges
    
    func setBadge(name: String) {
        guard let userId = auth.currentUser?.uid else { return }
        let ref = db.collection("users").document(userId)
        
        ref.updateData(
            [
                "badge": name
            ]) { error in
                if let error = error {
                    print("Error while updating profile: \(error)")
                } else {
                    Toast.shared.present(
                        title: String(localized: "bbadge-sseted"),
                        symbol: "checkmark.shield",
                        isUserInteractionEnabled: true,
                        timing: .long
                    )
                    print("Badge setted!")
                }
            }
    }
    
    func addBadge(name: String) {
        guard let userId = auth.currentUser?.uid else { return }
        let ref = db.collection("users").document(userId)
        
        ref.updateData(
            [
                "badges": FieldValue.arrayUnion([name])
            ]) { error in
                if let error = error {
                    print("Error while updating profile: \(error)")
                } else {
                    print("Badge added!")
                }
            }
    }
    
    func deleteBadge(name: String) {
        guard let userId = auth.currentUser?.uid else { return }
        let ref = db.collection("users").document(userId)
        
        ref.updateData(
            [
                "badges": FieldValue.arrayRemove([name])
            ]) { error in
                if let error = error {
                    print("Error while updating profile: \(error)")
                } else {
                    print("Badge deleted!")
                }
            }
    }
    
    func fetchBadges() {
        guard let userId = auth.currentUser?.uid else { return }
        let ref = db.collection("users").document(userId)
        
        ref.getDocument { document, error in
            if let error = error {
                print("Error fetching badges: \(error)")
            } else if let document = document, document.exists {
                if let badges = document.data()?["badges"] as? [String] {
                    self.badgesArray = badges
                    print("Badges fetched successfully: \(badges)")
                } else {
                    print("Badges array not found in the document")
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    
    
    //MARK: Support
    
    func sentMessage(message: String, image: UIImage?, type: String, from: String){
        guard let userId = auth.currentUser?.uid else { return }
        let ref = db.collection("messages").document(userId).collection("support").document()
        let timestamp = Date.now
        var imgUrl = ""
        if let imageSelected = image{
            guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else{
                return
            }
            let storegeProfileRef = storage.child("messages").child(ref.documentID)
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
                        ref.setData([
                            "message": message,
                            "from": from,
                            "to": "support",
                            "image": metaImageUrl,
                            "type": type,
                            "time": timestamp,
                            "reviewed": false
                        ]) { error in
                            if let error = error {
                                print("Error while creating message: \(error)")
                            } else {
                                print("Message sented!")
                            }
                        }
                    }
                }
            })
        }else{
            ref.setData([
                "message": message,
                "from": from,
                "to": "support",
                "image": "",
                "type": type,
                "time": timestamp,
                "reviewed": false
            ]) { error in
                if let error = error {
                    print("Error while creating message: \(error)")
                } else {
                    print("Message sented!")
                }
            }
        }
    }
    
    func setLastMessage(message: String, image: Bool, type: String?){
        guard let userId = auth.currentUser?.uid else { return }
        let ref = db.collection("messages").document(userId)
        let date = Date.now
        ref.setData([
            "name": currentUser?.name ?? "",
            "profileImage": currentUser?.profileImageUrl ?? "",
            "message": message,
            "from": userId,
            "image": image,
            "time": date,
            "type": type
        ]) { error in
            if let error = error {
                print("Error while creating message: \(error)")
            } else {
                print("Message sented!")
            }
        }
    }
    
    func viewMessage(docId: String){
        guard let userId = auth.currentUser?.uid else { return }
        
        let ref = db.collection("messages")
            .document(userId)
            .collection("support")
            .document(docId)
        ref.updateData([
            "reviewed": false
        ]) { error in
            if let error = error {
                print("Error while viewing message: \(error)")
            } else {
                print("Message viewed!")
            }
        }
    }
    
    func fetchMessages() {
        guard let userId = auth.currentUser?.uid else {
            return
        }
        
        db.collection("messages")
            .document(userId)
            .collection("support")
        //            .whereFilter(Filter.orFilter([
        //                            Filter.whereField("to", isEqualTo: from),
        //                            Filter.whereField("from", isEqualTo: from)
        //                        ]))
            .order(by: "time", descending: false)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    print("Error: \(error.localizedDescription)")
                } else {
                    messagesArray.removeAll()
                    querySnapshot?.documents.forEach({ queryDocumentSnapshot in
                        let data = queryDocumentSnapshot.data()
                        let docId = queryDocumentSnapshot.documentID
                        let achievementModel = MessageModel(documentId: docId, data: data)
                        self.messagesArray.append(achievementModel)
                    })
                }
            }
    }
    
    func fetchChatList() {
        let messagesCollection = db.collection("messages")
        
        // Fetching document names
        messagesCollection
            .order(by: "time", descending: false)
            .getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    print("Document ID: \(document.documentID)")
                    self.supportMessageArray.removeAll()
                    querySnapshot?.documents.forEach { queryDocumentSnapshot in
                        let data = queryDocumentSnapshot.data()
                        let docId = queryDocumentSnapshot.documentID
                        
                        let model = LastMessageModel(documentId: docId, data: data)
                        self.supportMessageArray.append(model)
                    }
                }
            }
        }
    }
    
    func deleteMessage(documentId: String){
        guard let userId = auth.currentUser?.uid else {
            return
        }
        
        db.collection("messages")
            .document(userId)
            .collection("support")
            .document(documentId)
            .delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func deleteImage(docId: String){
        storage.child("messages").child(docId).delete { error in
            if let error = error {
                print("Error while updating profile:  -\(error)")
            } else {
                // File deleted successfully
            }
        }
    }
    
    func deleteSupportConversation(){
        guard let userId = auth.currentUser?.uid else {
            return
        }
        
        db.collection("messages")
            .document(userId)
            .delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
    }
}
