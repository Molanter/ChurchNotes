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
import SwiftData

final
class AppViewModel: ObservableObject{
    @Published var credentials: [Credential] = []
    
    //    var ref: DatabaseReference! = Database.database().reference()
    @Published var errorMessage = ""
    @Published var peopleArray = [Person]()
    @Published var peopleaskToShareArray = [Person]()
    @Published var stagesArray = [Stage]()
    @Published var prayingWithArray = [User]()
    @Published var messagesArray = [MessageModel]()
    @Published var supportMessageArray = [LastMessageModel]()
    @Published var notificationArray = [NotificationModel]()
    @Published var tokensArray = [String]()
    @Published var badgesArray: [String] = []
    @Published var firebadgesArray: [FireBadge] = []

    @Published var achievementsArray = [Achievements]()
    @Published var usernameIsTaken = false
    @Published var signedIn = false
    @Published var isAuthenticated = false
    @Published var isProfileFinished = false
    @Published var passwordReseted: String?
    @Published var currentUser: User?
    @Published var moved: Int = 0

    
    @Published var isAvailable = false

    var db = Firestore.firestore()
    var storage = Storage.storage().reference(forURL: "gs://curchnote.appspot.com")
    var auth = Auth.auth()
    @Published var err = ""
    @State var profileImage = ""
    let deviceName = "\(UIDevice.current.name) \(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
    
    var published = PublishedVariebles()
    private var authModel = AuthViewModel()
    
    var isSignedIn: Bool{
        return auth.currentUser != nil
    }
    
    var sortedStages: [AppStage]{
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
                    self.fetchPeople()
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
                        self.fetchPeople()
                        print("profile is updated! \(newName) \(titleNumber)")
                    }
                }
        }
    }
    
    func adduserIdToDocument(documentId: String, newuserId: String) {
        let documentRef = db.collection("people").document(documentId)
        
        // Atomically update the userId dictionary by adding a new entry
        documentRef.setData([
            "userId": [
                newuserId: [
                    "isLiked": false,
                    "orderIndex": 0
                ]
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
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let peopleRef = Firestore.firestore().collection("people")
        peopleRef
            .whereField("userId.\(userId)", isNotEqualTo: NSNull())
            .getDocuments { [weak self] (querySnapshot, error) in
                if let error = error {
                    print("Error fetching documents: \(error)")
                } else if let documents = querySnapshot?.documents {
                    var processedPeopleArray: [Person] = []
                    
                    for document in documents {
                        let data = document.data()
                        let docId = document.documentID
                        
                        // Assuming 'userId' is a map within each 'people' document
                        if let userIdMap = data["userId"] as? [String: Any],
                           let userDict = userIdMap[userId] as? [String: Any],
                           let isLiked = userDict["isLiked"] as? Bool,
                           let orderIndex = userDict["orderIndex"] as? Int {
                            
                            let personModel = Person(
                                documentId: docId,
                                data: data, // Pass the entire data if needed
                                isLiked: isLiked,
                                orderIndex: orderIndex,
                                userId: Array(userIdMap.keys) // Assuming keys are user IDs you're interested in
                            )
                            processedPeopleArray.append(personModel)
                        } else {
                            print("userId map or its properties not found in the document")
                        }
                    }
                    
                    self?.peopleArray = processedPeopleArray
                } else {
                    print("No documents found")
                }
            }
    }
    
    
    func fethPrayingWith(userId: String){
        db.collection("users").document(userId).getDocument { querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
                self.err = err.localizedDescription
            } else {
                self.currentUser = nil
                if let  document = querySnapshot {
                    let dictionary = document.data()
                    if let dictionary = dictionary{
                        let curUser = User(data: dictionary)
                        self.prayingWithArray.append(curUser)
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
                        if let index = self.peopleArray.firstIndex(where: { $0.documentId == documentId }) {
                            self.peopleArray[index].imageData = metaImageUrl
                        }
                        
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
    
    func changeorderIndex(documentId: String, orderIndex: Int){
        let ref = db.collection("people").document(documentId)
        guard let userId = auth.currentUser?.uid else{return}
        let fieldPath = "userId.\(userId).orderIndex"
        
        ref.updateData(
            [fieldPath: orderIndex]){error in
                if let error = error{
                    print("Error while updating orderIndex:  -\(error)")
                }else{
                    print("orderIndex is updated!")
                }
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
            self.err = String(localized: "no-user-logged-in")
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
                        self.err = String(localized: "email-changed-successfully")
                        ref.updateData(
                            ["email": newEmail
                            ]){error in
                                if let error = error{
                                    print("Error while updating profile:  -\(error)")
                                }else{
                                    if let encryptedEmail = self.published.encrypt(Auth.auth().currentUser?.email ?? "", key: K.key()) {
                                        let modelsWithSameEmail = self.credentials.filter { $0.email == encryptedEmail }
                                        if !modelsWithSameEmail.isEmpty {
                                            for model in modelsWithSameEmail {
                                                if let newPass = self.published.encrypt(newEmail, key: K.key()) {
                                                    model.password = newPass
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        self.logOut()
                    }
                }
            }
        }
    }
    
    func deleteImageFromCurrentUser(){
        guard let userId = auth.currentUser?.uid else{return}
        let ref = db.collection("users").document(userId)
        
        ref.updateData(
            [
                "profileImageUrl": ""
            ]){error in
                if let error = error{
                    print("Error while updating user:  -\(error)")
                }else{
                    self.storage.child("users").child(userId).delete { error in
                        if let error = error {
                            print("Error while updating user:  -\(error)")
                        } else {
                            print("image is deleted from storege!")
                        }
                    }
                    print("image is deleted from user!")
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
                            
                            let curUser = User(data: dictionary)
                            self.currentUser = curUser
                            for model in self.credentials {
                                if let decryptedEmail = self.published.decrypt(model.email) {
                                    if decryptedEmail == curUser.email {
                                        print("Models with the same email exist")
                                        
                                        if let url = URL(string: curUser.profileImageUrl), let img = self.published.getImageData(url: url) {
                                            model.image = img
                                            model.username = curUser.username
                                        }
                                    }
                                } else {
                                    print("No models with the same email exist")
                                }
                            }
                            print(self.credentials.count)
                        }
                    }
                }
            }
        }
    }
    
    func fetchAppSecure(completion: @escaping (Bool) -> Void) {
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("users").document(userID).getDocument { querySnapshot, err in
                if let err = err {
                    print("Error getting documents: \(err)")
                    completion(false) // Return false in case of an error
                } else {
                    if let document = querySnapshot, let dictionary = document.data() {
                        if let secureApp = dictionary["secureApp"] as? Bool {
                            completion(secureApp)
                        }else {
                            let ref = self.db.collection("users").document(userID)
                            
                            ref.updateData(
                                ["secureApp": false
                                ]){error in
                                    if let error = error{
                                        print("Error while updating profile:  -\(error)")
                                    }else{
                                        print("secureApp is updated!")
                                    }
                                }
                        }
                    } else {
                        completion(false) // Return false if no document is found
                    }
                }
            }
        } else {
            completion(false) // Return false if userID is nil
        }
    }
    
    func changeAppSecure(_ bool: Bool) {
        if let userID = Auth.auth().currentUser?.uid {
            let ref = self.db.collection("users").document(userID)
            
            ref.updateData(
                ["secureApp": bool
                ]){error in
                    if let error = error{
                        print("Error while updating profile:  -\(error)")
                    }else{
                        print("secureApp is updated!")
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
                    if let encryptedEmail = self.published.encrypt(Auth.auth().currentUser?.email ?? "", key: K.key()) {
                        let modelsWithSameEmail = self.credentials.filter { $0.email == encryptedEmail }
                        if !modelsWithSameEmail.isEmpty {
                            for model in modelsWithSameEmail{
                                if let password = self.published.encrypt(newPassword, key: K.key()){
                                    model.password = password
                                }
                            }
                        }
                    }
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
    
    func deleteUserAccount() {
        let user = Auth.auth().currentUser
        
        user?.delete { error in
            if let error = error {
                
            } else {
                
            }
        }
    }
    func deleteProfile(modelContext: ModelContext){
        guard let userId = auth.currentUser?.uid else {
            return
        }
        
        db.collection("users")
            .document(userId)
            .delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    if let encryptedEmail = self.published.encrypt(Auth.auth().currentUser?.email ?? "", key: K.key()) {
                        let modelsWithSameEmail = self.credentials.filter { $0.email == encryptedEmail }
                        if !modelsWithSameEmail.isEmpty {
                            for model in modelsWithSameEmail {
                                modelContext.delete(model)
                            }
                        }
                    }
                    print("Profile successfully removed!")
                }
            }
    }
    
    func logOut(){
        do {
            removeDeviceFromUser()
            try Auth.auth().signOut()
            authModel.signedIn = false
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func checkDeviceForUser(completion: @escaping (Bool, Error?) -> Void) {
        guard let userId = auth.currentUser?.uid else {return}
        
        let docRef = db.collection("users").document(userId)
        
        docRef.getDocument { (document, error) in
            if let error = error {
                completion(false, error)
            } else if let document = document, document.exists {
                if let devices = document.get("devices") as? [String] {
                    // Check if the devices array contains the deviceName
                    completion(devices.contains(self.deviceName), nil)
                } else {
                    // The document does not have a "devices" field or it's not an array
                    completion(false, nil)
                }
            } else {
                // The document does not exist
                completion(false, nil)
            }
        }
    }
    
    func removeDeviceFromUser(device: String = K.deviceName) {
        guard let userId = auth.currentUser?.uid else {return}
        let db = Firestore.firestore()
        db.collection("users").document(userId).updateData([
            "devices": FieldValue.arrayRemove([device])
        ]) { error in
            if let error = error {
                // Handle the error
                print("Error removing device: \(error.localizedDescription)")
            } else {
                // The device was removed
                print("Device removed successfully.")
            }
        }
    }
    
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
                        if let encryptedEmail = self.published.encrypt(Auth.auth().currentUser?.email ?? "", key: K.key()) {
                            let modelsWithSameEmail = self.credentials.filter { $0.email == encryptedEmail }
                            if !modelsWithSameEmail.isEmpty {
                                for model in modelsWithSameEmail {
                                    model.username = username
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
                                    if let encryptedEmail = self.published.encrypt(Auth.auth().currentUser?.email ?? "", key: K.key()) {
                                        let modelsWithSameEmail = self.credentials.filter { $0.email == encryptedEmail }
                                        if !modelsWithSameEmail.isEmpty {
                                            for model in modelsWithSameEmail {
                                                if let url = URL(string: metaImageUrl) {
                                                    model.image = self.published.getImageData(url: url)
                                                    model.username = username
                                                }
                                            }
                                        }
                                    }
                                    
                                    print("profile is updated! with image!)")
                                }
                            }
                    }
                }
            })
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
    
    func updateStatus(status: String, uid: String, reason: String = "") {
        let ref = db.collection("users").document(uid)
        
        ref.updateData([
            "status": status,
            "reason": reason
        ]) { error in
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
                    self.firebadgesArray.removeAll()
                    self.loadBadges()
                } else {
                    print("Badges array not found in the document")
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func loadBadges() {
        self.firebadgesArray.removeAll()
        for id in badgesArray {
            db.collection("badges")
                .whereField("strId", isEqualTo: id)
                .addSnapshotListener { [weak self] querySnapshot, error in
                    guard let self = self else { return }
                    if let error = error {
                        errorMessage = error.localizedDescription
                        print("Error: \(error.localizedDescription)")
                    } else {
                        querySnapshot?.documents.forEach({ queryDocumentSnapshot in
                            let data = queryDocumentSnapshot.data()
                            let docId = queryDocumentSnapshot.documentID
                            let badgeModel = FireBadge(documentId: docId, data: data)
                            self.firebadgesArray.append(badgeModel)
                        })
                    }
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
    
    func setLastMessage(message: String, image: Bool, type: String?, uid: String){
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
            "type": type,
            "uid": uid
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
        //                    .whereFilter(Filter.orFilter([
        //                                    Filter.whereField("to", isEqualTo: from),
        //                                    Filter.whereField("from", isEqualTo: from)
        //                                ]))
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
    
    //MARK: Chats
    
    func loadUserByUID(uid: String){
        db.collection("users").document(uid).getDocument { querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
                self.err = err.localizedDescription
            } else {
                self.published.supportPersonChat = nil
                if let  document = querySnapshot {
                    let dictionary = document.data()
                    if let dictionary = dictionary{
                        
                        let curUser = User(data: dictionary)
                        self.published.supportPersonChat = curUser
                    }
                }
            }
        }
    }
    
    //MARK: Notification
    func createNotification(date: Date, message: String, type: String, people: [String], uid: String, from: String){
        print(UIDevice.current.name)
        let dictionary: Dictionary <String, Any> = [
            "to": uid,
            "date": date,
            "type": type,
            "message": message,
            "people": people,
            "from": from
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
            .whereField("to", isEqualTo: userId)
            .addSnapshotListener { [self] querySnapshot, error in
                if let err = error{
                    self.errorMessage = err.localizedDescription
                    print("err l:  _ \(err.localizedDescription)")
                } else {
                    print("fetch")
                    notificationArray.removeAll()
                    querySnapshot?.documents.forEach({ queryDocumentSnapshot in
                        let data = queryDocumentSnapshot.data()
                        let docId = queryDocumentSnapshot.documentID
                        let notificationModel = NotificationModel(documentId: docId, data: data)
                        self.notificationArray.append(notificationModel)
                    })
                }
            }
    }
    
    func removeAllNotifications(){
        guard let userId = auth.currentUser?.uid else {return}
        
        for notific in notificationArray{
            db.collection("notifications").document(notific.documentId).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
        }
    }
    
    func stopNotifing(item: NotificationModel){
        guard let userId = auth.currentUser?.uid else {return}
        db.collection("notifications").document(item.documentId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func updatePeopleList(documentId: String, people: [String]) {
        let ref = db.collection("notifications").document(documentId)
        
        ref.updateData(["people": people]) { error in
            if let err = error {
                print("Error while updating notification: ", err.localizedDescription)
            } else {
                print("Notification updated")
            }
        }
    }
}
