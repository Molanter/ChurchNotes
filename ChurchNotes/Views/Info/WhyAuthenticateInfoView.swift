//
//  WhyAuthenticateInfoView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 10/30/23.
//

import SwiftUI

struct WhyAuthenticateInfoView: View {
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 10){
                Text("Why You need to authenticate?")
                    .font(.title)
                    .bold()
                Text("Authentication is a crucial component of our app, and it serves several important purposes, both for us users and for our app's functionality. Here's why a you need to authenticate when using our app:")
                    .padding(.bottom)
                VStack(alignment: .leading){
                    Text("Personalization:")
                        .font(.title3)
                        .bold()
                    Text("Authentication allows your app to provide a personalized experience to users. By knowing who the user is, you can tailor the content, recommendations, and settings to their preferences. This personal touch enhances the user experience.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                .padding(.bottom)
                VStack(alignment: .leading){
                    Text("Data Security: ")
                        .font(.title3)
                        .bold()
                    Text("User authentication helps in securing sensitive data. When users create accounts and log in, their data is protected from unauthorized access. This is especially important if your app deals with personal information, such as prayer requests or notes.")
                        .foregroundStyle(.secondary)
                        .font(.body)
                }
                .padding(.bottom)
                VStack(alignment: .leading){
                    Text("Access Control:")
                        .font(.title3)
                        .bold()
                    Text("Authentication allows you to control who can access specific features or content within your app. For example, certain prayers or journal entries might be private, while others can be shared with the community. Users can manage their own data and decide who sees it.")
                        .foregroundStyle(.secondary)
                        .font(.body)
                }
                .padding(.bottom)
                VStack(alignment: .leading){
                    Text("User Accountability:")
                        .font(.title3)
                        .bold()
                    Text("Knowing the identity of users fosters accountability. Users are less likely to engage in harmful or abusive behavior when they are associated with their real identities. This can help create a positive and supportive user community.")
                        .foregroundStyle(.secondary)
                        .font(.body)
                }
                .padding(.bottom)
                VStack(alignment: .leading){
                    Text("Communication:")
                        .font(.title3)
                        .bold()
                    Text("Authenticated users can interact with one another more effectively. They can like, comment on, and share prayer requests, and engage in meaningful discussions with others. Authentication enables social features that encourage community building.")
                        .foregroundStyle(.secondary)
                        .font(.body)
                }
                .padding(.bottom)
                VStack(alignment: .leading){
                    Text("Data Sync:")
                        .font(.title3)
                        .bold()
                    Text("If your app is available on multiple devices or platforms, authentication ensures data synchronization. Users can seamlessly access their prayer journal and other data from any device.")
                        .foregroundStyle(.secondary)
                        .font(.body)
                }
                .padding(.bottom)
                VStack(alignment: .leading){
                    Text("Personal Progress Tracking: ")
                        .font(.title3)
                        .bold()
                    Text("Users can track their personal spiritual journeys over time. Authentication allows them to keep a history of their prayers and spiritual experiences in one place.")
                        .foregroundStyle(.secondary)
                        .font(.body)
                }
                .padding(.bottom)
                VStack(alignment: .leading){
                    Text("Enhanced Features:")
                        .font(.title3)
                        .bold()
                    Text("Certain features, such as reminders and notifications, depend on knowing the user's identity. These features can significantly enhance the prayer and spiritual experience.")
                        .foregroundStyle(.secondary)
                        .font(.body)
                }
                .padding(.bottom)
                VStack(alignment: .leading){
                    Text("Community Trust:")
                        .font(.title3)
                        .bold()
                    Text("An authenticated community can build trust among its members. Users are more likely to trust and support one another when they know they are interacting with real individuals rather than anonymous entities.")
                        .foregroundStyle(.secondary)
                        .font(.body)
                }
                .padding(.bottom)
                VStack(alignment: .leading){
                    Text("Support and Assistance:")
                        .font(.title3)
                        .bold()
                    Text("In case users encounter issues, need support, or have questions, authentication helps you provide individualized assistance and support.")
                        .foregroundStyle(.secondary)
                        .font(.body)
                }
                .padding(.bottom)
                Text("In summary, authentication is essential for personalization, data security, access control, and creating a supportive and accountable user community. It enables your app to offer a tailored, secure, and engaging experience that meets the needs and expectations of our users.")
                    .padding(.top)
            }
        }
        .padding(.horizontal, 15)
    }
}

#Preview {
    WhyAuthenticateInfoView()
}
