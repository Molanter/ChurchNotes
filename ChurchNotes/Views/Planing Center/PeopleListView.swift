//
//  PeopleListView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 10/30/23.
//

import SwiftUI
import OAuth2

struct Item: Identifiable, Decodable {
    var id: String
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
}

class PeopleViewModel: ObservableObject {
    @Published var people = [Item]()
    var oauth2: OAuth2CodeGrant?

    init() {
        setupOAuth2()
    }

    func setupOAuth2() {
        oauth2 = OAuth2CodeGrant(settings: [
            "client_id": "3fd19db760f18bf3ebfe5b33e168383ebe3b72a30e099c5bb6d864f7241b88dc",
            "client_secret": "5a9698fa003f6b81b323a1dfd0b1054fc2cdcb5abe9f3011e2bd7d4d9679e7f6",
            "authorize_uri": "https://api.planningcenteronline.com/oauth/authorize",
            "token_uri": "https://api.planningcenteronline.com/oauth/token",
            "redirect_uris": ["your-redirect-uri"],
        ])
        authenticate()
    }

    func authenticate() {
        guard let oauth2 = oauth2 else {
            return
        }

        oauth2.authConfig.authorizeEmbedded = false
        oauth2.authConfig.authorizeContext = UIApplication.shared.windows.last?.rootViewController
        oauth2.authorize() { authParameters, error in
            if let params = authParameters, let accessToken = params["access_token"] as? String {
                self.fetchData(accessToken: accessToken)
            } else if let error = error {
                print("OAuth2 authentication error: \(error)")
            }
        }
    }

    func fetchData(accessToken: String) {
        // Replace with your Planning Center API URL
        guard let apiUrl = URL(string: "YOUR_API_ENDPOINT") else {
            print("Invalid API URL")
            return
        }

        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if let data = data {
                do {
                    let response = try JSONDecoder().decode([Item].self, from: data)
                    DispatchQueue.main.async {
                        self.people = response
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            }
        }.resume()
    }
}

struct PeopleListView: View {
    @EnvironmentObject var peopleViewModel: PeopleViewModel

    var body: some View {
        List(peopleViewModel.people) { person in
            VStack(alignment: .leading) {
                Text("Name: \(person.firstName) \(person.lastName)")
                Text("Email: \(person.email)")
                Text("Phone: \(person.phone)")
            }
        }
        .onAppear(perform: {
            peopleViewModel.authenticate()
            print("apearedd")
        })
        .navigationBarTitle("People List")
    }
}

