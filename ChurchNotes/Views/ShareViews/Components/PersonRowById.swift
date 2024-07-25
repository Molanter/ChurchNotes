//
//  PersonRowById.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 4/3/24.
//

import SwiftUI
import FirebaseFirestore

struct PersonRowById: View {
    let id: String

    
    var db = Firestore.firestore()

    init(id: String) {
        self.id = id
    }

    @State private var person: Person?

    var body: some View {
        if let person = person {
            RowPersonModel(item: person)
        } else {
            ProgressView()
                .onAppear {
                    fetchUser(id: id) { fetchedPerson in
                        self.person = fetchedPerson
                    }
                }
        }
    }
    
    func fetchUser(id: String, completion: @escaping (Person?) -> Void) {
        db.collection("people").document(id).getDocument { querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
                completion(nil)
            } else {
                if let document = querySnapshot, document.exists {
                    let data = document.data()
                    let docId = document.documentID
                    
                    if let userIdMap = data?["userId"] as? [String: Any]{
                        let personModel = Person(
                            documentId: docId,
                            data: data!,
                            isLiked: false,
                            orderIndex: 0,
                            userId: Array(userIdMap.keys)
                        )
                        completion(personModel)
                    } else {
                        print("userId map or its properties not found in the document")
                        completion(nil)
                    }
                } else {
                    print("Document does not exist")
                    completion(nil)
                }
            }
        }
    }

}

//#Preview {
//    PersonRowById()
//}
