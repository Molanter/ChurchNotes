//
//  SearchPersonView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 3/13/24.
//

import SwiftUI
import FirebaseFirestore

struct SearchPersonView: View {
    @EnvironmentObject var published: PublishedVariebles
    @Environment(\.dismiss) private var dismiss
    
    @State private var people: [User] = []
    @State private var users: [User] = []

    @State private var searchText = ""
    @State private var limit = 10
    
    var db = Firestore.firestore()
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(people){ person in
                    HStack(alignment: .top){
                        VStack(alignment: .center){
                            Spacer()
                            Image(systemName: personInUserList(person: person) ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(K.Colors.mainColor)
                                .symbolEffect(.bounce, value: personInUserList(person: person))
                            Spacer()
                        }
                        ZStack(alignment: .bottomTrailing){
                            if !person.profileImageUrl.isEmpty{
                                AsyncImage(url: URL(string: person.profileImageUrl)){image in
                                    image.resizable()
                                    
                                }placeholder: {
                                    ProgressView()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 35, height: 35)
                                }
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 35, height: 35)
                                .cornerRadius(.infinity)
                            }else{
                                Image(systemName: "person.crop.circle.fill")
                                    .symbolRenderingMode(.palette)
                                    .resizable()
                                    .foregroundStyle(.white, Color(K.Colors.lightGray))
                                    .font(.largeTitle)
                                    .frame(width: 35, height: 35)
                            }
                            ZStack{
                                    if let b = K.Badges().getBadgeArray()[person.badge] as? Badge{
                                        if b.string != ""{
                                            Text(b.string)
                                                .foregroundStyle(Color.white)
                                                .font(.system(size: 10))
                                                .padding(3)
                                                .background(
                                                    Circle()
                                                        .fill(K.Colors.mainColor)
                                                        .opacity(0.7)
                                                )
                                        }else{
                                            Image(systemName: b.image)
                                                .foregroundStyle(Color.white)
                                                .font(.system(size: 10))
                                                .padding(3)
                                                .background(
                                                    Circle()
                                                        .fill(K.Colors.mainColor)
                                                        .opacity(0.7)
                                                )
                                        }
                                    }
                                }
                        }
                        VStack(alignment: .leading){
                            Text(person.name.capitalized)
                                .foregroundStyle(.primary)
                                .font(.title3)
                                .bold()
                            Text("\(person.email) • \(person.username)")
                                .foregroundStyle(.secondary)
                                .font(.body)
                        }
                    }
                    .frame(height: 40)
                    .onTapGesture {
                        if personInUserList(person: person) {
                            users.removeAll(where: { user in
                                user.id == person.id
                            })
                        }else {
                            users.append(person)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "search-name")
            .onChange(of: searchText, { oldValue, newValue in
                print("changed")
                search()
            })
            .onAppear{
                search()
            }
            .toolbar {
                ToolbarItem(placement: .status) {
                    Button{
                        published.usersToShare = users
                        published.showShare = true
                        dismiss()
                    }label: {
                        HStack(alignment: .center, spacing: 10){
                            Image(systemName: "square.and.arrow.up")
                            Text("share-person")
                        }
                            .foregroundStyle(K.Colors.mainColor)
                    }
                }
            }
            .navigationBarBackground()
        }
    }
    
    private func search(){
        print("searching")
        let nameQuery = db.collection("users")
                .order(by: "name")
                .start(at: [searchText])
                .end(at: [searchText + "\u{f8ff}"])
                .limit(to: limit)

            // Perform the search on the username field
            let usernameQuery = db.collection("users")
                .order(by: "username")
                .start(at: [searchText.lowercased()])
                .end(at: [searchText.lowercased() + "\u{f8ff}"])
                .limit(to: limit)

            // Perform the search on the email field
            let emailQuery = db.collection("users")
                .order(by: "email")
                .start(at: [searchText.lowercased()])
                .end(at: [searchText.lowercased() + "\u{f8ff}"])
                .limit(to: limit)

            // Fetch and combine the results
        let group = DispatchGroup()

            var combinedResults = Set<String>()
            var combinedPeople: [User] = []

            for query in [nameQuery, usernameQuery, emailQuery] {
                group.enter()
                query.getDocuments { (querySnapshot, error) in
                    if let documents = querySnapshot?.documents {
                        for document in documents {
                            let userId = document.documentID
                            // To avoid duplicates
                            if !combinedResults.contains(userId) {
                                combinedResults.insert(userId)
                                let userModel = User(data: document.data())
                                combinedPeople.append(userModel)
                            }
                        }
                    } else if let error = error {
                        print("Error searching users: \(error.localizedDescription)")
                    }
                    group.leave()
                }
            }

            group.notify(queue: .main) {
                // Sort combinedPeople if needed
                self.people = combinedPeople.sorted(by: { $0.name < $1.name })
            }
        print("finished")
    }
    
    func personInUserList(person: User) -> Bool {
//        guard let array = published.usersToShare else {return false}
        return users.contains(where: { user in
                user.id == person.id
            })
        }
}

#Preview {
    SearchPersonView()
}
