//
//  NameMessageModel.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 4/23/24.
//

import SwiftUI
import FirebaseFirestore

struct NameMessageModel: View{
    let notif: NotificationModel
    var db = Firestore.firestore()

    @State private var name = "Someone"
    @State private var profileImage = ""
    
    var body: some View{
        HStack(alignment: .top) {
//            AsyncImage(url: URL(string: profileImage)){image in
//                image.resizable()
//            }placeholder: {
//                ProgressView()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 15, height: 15)
//            }
//            .aspectRatio(contentMode: .fill)
//            .frame(width: 15, height: 15)
//            .cornerRadius(.infinity)
             Text(!name.isEmpty ? "\(name) \(notif.message)" : "Someone \(notif.message)")
        }
        .onAppear{
            getName(notif.from)
        }
    }
    
    private func getName(_ userID: String) {
            db.collection("users").document(userID).getDocument { querySnapshot, err in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if let  document = querySnapshot {
                        let dictionary = document.data()
                        
                        if let dictionary = dictionary{
                            let profileImage = dictionary["profileImageUrl"] as! String
                            let name = dictionary["name"] as! String
                            self.profileImage = profileImage
                            
                            self.name = name
                        }
                    }
                }
            }
    }
}
