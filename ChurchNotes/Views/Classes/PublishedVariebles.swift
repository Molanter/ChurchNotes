//
//  PublishedVariebles.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 11/29/23.
//

import SwiftUI
import FirebaseAuth
import Contacts
import CryptoKit

class PublishedVariebles: ObservableObject{
    //MARK: Optional

    @Published var currentProfileMainView: Int?
    @Published var currentSettingsNavigationLink: String?
    @Published var currentPeopleNavigationLink: String?
    @Published var contactToAdd: CNContact?
    @Published var findUserId: String?
    @Published var currentItem: Person?
    @Published var currentSplitItem: Person?
    @Published var supportPersonChat: User?
    @Published var currentBadge: Badge?
    
    //MARK: NotCHangable
    @Published var uid = Auth.auth().currentUser?.uid
    @Published var device = UIDevice.current.userInterfaceIdiom

    //MARK: String
    @Published var searchText = ""
    @Published var createPersonName = ""
    @Published var fcm = ""

    //MARK: Int
    @Published var minute = 60
    @Published var nowStage = 0
    @Published var currentTabView = 0
    @Published var currentTab = 0

    //MARK: Bool
    @Published var tabsAreHidden = false
    @Published var sended = false
    @Published var showEditProfileSheet = false
    @Published var deleteCanceled = false
    @Published var isEditing = false
    @Published var showShare = false
    @Published var showEditButtonInIPV = true
    @Published var notShowItemPersonView = false
    @Published var passwordSecure = false
    @Published var closed = true
    
    //MARK: Array / Set
    @Published var selectPeopleArray = Set<Person.ID>()
    @Published var usersToShare: [User] = []
    
    //MARK: Functions
    func deviceImage(_ name: String) -> String{
        var device = ""
        if name.contains("iPad") || name.contains("iPadOS") {
            device = "ipad"
        }else if name.contains("iPhone") || name.contains("iOS") {
            device = "iphone"
        }
        return device
    }
    
    func decrypt(_ ciphertext: String) -> String? {
            guard let data = Data(base64Encoded: ciphertext) else {
                return nil
            }
            do {
                let sealedBox = try AES.GCM.SealedBox(combined: data)
                let decryptedData = try AES.GCM.open(sealedBox, using: K.key())
                guard let decryptedString = String(data: decryptedData, encoding: .utf8) else {
                    return nil
                }
                return decryptedString
            } catch {
                print("Decryption failed: \(error.localizedDescription)")
                return nil
            }
        }

    func encrypt(_ plaintext: String, key: SymmetricKey) -> String? {
            guard let data = plaintext.data(using: .utf8) else {
                return nil
            }
            do {
                let sealedBox = try AES.GCM.seal(data, using: key)
                let ciphertext = sealedBox.combined!
                return ciphertext.base64EncodedString()
            } catch {
                print("Encryption failed: \(error.localizedDescription)")
                return nil
            }
        }
    
    func getImageData(url: URL) -> Data? {
        // Use a semaphore to wait for the completion of the data task
        let semaphore = DispatchSemaphore(value: 0)
        var imageData: Data?

        URLSession.shared.dataTask(with: url) { data, response, error in
            defer { semaphore.signal() } // Signal the semaphore when the task completes

            guard let data = data, error == nil else {
                print("Failed to download image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            imageData = data
        }.resume()

        // Wait for the semaphore until the task completes
        _ = semaphore.wait(timeout: .distantFuture)

        return imageData
    }
}
