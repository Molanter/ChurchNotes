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
    @Published var errorMessage = ""
    @Published var peopleArray = [Person]()
    @Published var stagesArray = [Stage]()
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
    
    var isSignedIn: Bool{
        return auth.currentUser != nil
    }
    
    private var sortedStages: [Stage]{
        return stagesArray.sorted(by: { $0.orderIndex < $1.orderIndex })
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
    
    func saveStages(_ first: Bool = false, name: String = "") {
        // Create a reference to Firestore
        
        // Specify the path to the collection
        let collectionPath = "stages"
        guard let userId = auth.currentUser?.uid else {return}
        
        // Create an array of data to save as documents
        if first == true{
            let dataArray: [[String: Any]] = [
                ["name": "New Friend", "orderIndex": 0, "userId": userId, "createBy": "app"],
                ["name": "Invited", "orderIndex": 1, "userId": userId, "createBy": "app"],
                ["name": "Attanded", "orderIndex": 2, "userId": userId, "createBy": "app"],
                ["name": "Baptized", "orderIndex": 3, "userId": userId, "createBy": "app"],
                ["name": "Acepted Christ", "orderIndex": 4, "userId": userId, "createBy": "app"],
                ["name": "Serving", "orderIndex": 5, "userId": userId, "createBy": "app"],
                ["name": "Joined Group", "orderIndex": 6, "userId": userId, "createBy": "app"],
                // Add more data as needed
            ]
            
            // Iterate through the array and save each document
            for (index, data) in dataArray.enumerated() {
                let documentPath = "\(userId)\(index)" // You can use a unique identifier here
                db.collection(collectionPath).document(documentPath).setData(data, merge: true) { error in
                    if let error = error {
                        print("Error writing document: \(error)")
                    } else {
                        print("Document \(documentPath) successfully written!   First  1")
                    }
                }
            }
        }else{
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
    }
    
    
    
    //MARK: People
    func fetchPeople(){
        guard let userId = auth.currentUser?.uid else {return}
        db.collection("people")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { [self] querySnapshot, error in
                if let err = error{
                    self.errorMessage = err.localizedDescription
                    print("err l:  _ \(err.localizedDescription)")
                } else {
                    peopleArray.removeAll()
                    querySnapshot?.documents.forEach({ queryDocumentSnapshot in
                        let data = queryDocumentSnapshot.data()
                        let docId = queryDocumentSnapshot.documentID
                        let personModel = Person(documentId: docId, data: data)
                        self.peopleArray.append(personModel)
                        print(personModel.timestamp)
                    })
                }
            }
    }
    
    func handleSend(name: String, notes: String, email: String, title: String, phone: String, imageData: UIImage?, orderIndex: Int, isCheked: Bool, isLiked: Bool, isDone: Bool, birthDay: Date, timestamp: Date, titleNumber: Int) {
        guard let userId = auth.currentUser?.uid else {
            self.errorMessage = "User ID is missing."
            return
        }
        
        var personData: [String: Any] = [
            "userId": userId,
            "name": name,
            "notes": notes,
            "email": email,
            "title": title,
            "titleNumber": titleNumber,
            "phone": phone,
            "imageData": "",
            "orderIndex": orderIndex,
            "isCheked": isCheked,
            "isLiked": isLiked,
            "isDone": isDone,
            "birthDay": birthDay,
            "timeStamp": timestamp
        ]
        
        if let imageData = imageData, let imageDat = imageData.jpegData(compressionQuality: 0.4) {
            let writerDocument = db.collection("people").document()
            let storegeProfileRef = storage.child("people").child(writerDocument.documentID)
            
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
                            print("Data saved successfully")
                        }
                    }
                }
            }
        } else {
            // No image data provided, save data without an image URL
            let writerDocument = db.collection("people").document()
            writerDocument.setData(personData) { error in
                if let er = error {
                    self.errorMessage = er.localizedDescription
                    print("Error: \(er.localizedDescription)")
                } else {
                    print("Data saved successfully (no image)")
                }
            }
        }
    }
    
    func likePerson(documentId: String, isLiked: Bool){
        let ref = db.collection("people").document(documentId)
        
        ref.updateData(
            ["isLiked": isLiked]){error in
                if let error = error{
                    print("Error while updating profile:  -\(error)")
                }else{
                    print("profile is updated!")
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
    
    func deletePerson(documentId: String){
        db.collection("people").document(documentId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func twoNames(name: String) -> String{
        return String(name.components(separatedBy: " ").compactMap { $0.first }).count >= 3 ? String(String(name.components(separatedBy: " ").compactMap { $0.first }).prefix(2)) : String(name.components(separatedBy: " ").compactMap { $0.first })
    }
    
    
    //MARK: Current User
    
    func fetchUser(){
        if let userID = Auth.auth().currentUser?.uid{
            db.collection("users").document(userID).getDocument { querySnapshot, err in
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
            self.err = "Passwords do not match"
            return
        }
        
        guard let user = Auth.auth().currentUser, let email = user.email else {
            self.err = "User not authenticated or email not available"
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        
        // Reauthenticate the user with their current password
        user.reauthenticate(with: credential) { _, error in
            if let error = error {
                self.err = "Reauthentication failed: \(error.localizedDescription)"
                return
            }
            
            // If reauthentication is successful, update the password
            user.updatePassword(to: newPassword) { error in
                if let error = error {
                    self.err = "Password update failed: \(error.localizedDescription)"
                } else {
                    self.err = "Password updated successfully"
                }
            }
        }
    }
    
    func resetPassword(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.err = error.localizedDescription
            } else {
                self.passwordReseted = "Password reset email sent. Please check your email."
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
                    self!.saveStages(true)
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
                    self!.saveStages(true)
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
    
    func updateProfile(image: UIImage?, name: String, username: String, country: String, phone: String, documentId: String, oldImageLink: String){
        if let userID = auth.currentUser?.uid{
            let ref = db.collection("users").document(userID)
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
                                        peopleArray.removeAll()
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
                                     "uid": userID
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
                storage.child("users").child(userID).delete { error in
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
            if let document = document, /*document.exists,*/ let userID = Auth.auth().currentUser?.uid, let uid = document["uid"] as? String, userID == uid {
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
            "message": message == "" ? "Time to pray, take you time." : message
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
}
