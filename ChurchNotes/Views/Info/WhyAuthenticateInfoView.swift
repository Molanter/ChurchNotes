//
//  WhyAuthenticateInfoView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 10/30/23.
//

import SwiftUI

struct WhyAuthenticateInfoView: View {
    var body: some View {
        VStack(alignment: .leading){
            Text("Why You need to authenticate?")
                .font(.title2)
                .bold()
                .foregroundStyle(.primary)
                .padding(.horizontal, 15)
            List{
                Section{
                    Text("Authentication is a crucial component of our app, and it serves several important purposes, both for us users and for our app's functionality. Here's why a you need to authenticate when using our app:")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                Section(header: Text("Personalization:")){
                    Text("Authentication allows your app to provide a personalized experience to users. By knowing who the user is, you can tailor the content, recommendations, and settings to their preferences. This personal touch enhances the user experience.")
                }
                Section(header: Text("Data Security: ")){
                    Text("User authentication helps in securing sensitive data. When users create accounts and log in, their data is protected from unauthorized access. This is especially important if your app deals with personal information, such as prayer requests or notes.")
                }
                Section(header: Text("Access Control:")){
                    Text("Authentication allows you to control who can access specific features or content within your app. For example, certain prayers or journal entries might be private, while others can be shared with the community. Users can manage their own data and decide who sees it.")
                }
                Section(header: Text("User Accountability:")){
                    Text("Knowing the identity of users fosters accountability. Users are less likely to engage in harmful or abusive behavior when they are associated with their real identities. This can help create a positive and supportive user community.")
                }
                Section(header: Text("Communication:")){
                    Text("Authenticated users can interact with one another more effectively. They can like, comment on, and share prayer requests, and engage in meaningful discussions with others. Authentication enables social features that encourage community building.")
                }
                Section(header: Text("Data Sync:")){
                    Text("If your app is available on multiple devices or platforms, authentication ensures data synchronization. Users can seamlessly access their prayer journal and other data from any device.")
                }
                Section(header: Text("Personal Progress Tracking: ")){
                    Text("Users can track their personal spiritual journeys over time. Authentication allows them to keep a history of their prayers and spiritual experiences in one place.")
                }
                Section(header: Text("Enhanced Features:")){
                    Text("Certain features, such as reminders and notifications, depend on knowing the user's identity. These features can significantly enhance the prayer and spiritual experience.")
                }
                Section(header: Text("Community Trust:")){
                    Text("An authenticated community can build trust among its members. Users are more likely to trust and support one another when they know they are interacting with real individuals rather than anonymous entities.")
                }
                Section(header: Text("Support and Assistance:")){
                    Text("In case users encounter issues, need support, or have questions, authentication helps you provide individualized assistance and support.")
                }
                Section{
                    Text("In summary, authentication is essential for personalization, data security, access control, and creating a supportive and accountable user community. It enables your app to offer a tailored, secure, and engaging experience that meets the needs and expectations of our users.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
            }
            .listStyle(.grouped)
        }
    }
}

#Preview {
    WhyAuthenticateInfoView()
}
