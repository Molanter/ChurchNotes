//
//  SupportMainView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 1/20/24.
//

import SwiftUI

struct SupportMainView: View {
    @EnvironmentObject var published: PublishedVariebles
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        NavigationStack{
            //            ScrollView{
            List{
                //                    VStack(alignment: .leading, spacing: 10){
                Section{
                    VStack{
                        NavigationLink(destination: SupportChatView()
                            .navigationBarTitleDisplayMode(.inline)
                        ){
                            HStack(spacing: 15){
                                Image(systemName: "message")
                                    .font(.system(size: 25))
                                    .fontWeight(.light)
                                VStack(alignment: .leading, spacing: 5){
                                    Text("cchatt")
                                        .font(.system(size: 15))
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.primary)
                                    Text("chat-with-support-volunteer")
                                        .font(.system(size: 11))
                                        .foregroundStyle(.secondary)
                                }
                                //                                                Spacer()
                                //                                                Image(systemName: "chevron.forward")
                                //                                                    .frame(width: 28)
                            }
                            //                                            .padding(.leading, 20)
                            //                                            .padding(.trailing, 25)
                        }
                        .navigationDestination(
                            isPresented: Binding(
                                get: { published.currentSettingsNavigationLink == "support-chat" },
                                set: { newValue in
                                    published.currentSettingsNavigationLink = newValue ? "support-chat" : nil
                                }
                            )
                        ) {
                            SupportChatView()
                                .onAppear(perform: {
                                    published.tabsAreHidden = true
                                })
                                .toolbar(.hidden, for: .tabBar)
                                .navigationBarTitleDisplayMode(.inline)
                        }
                        //                            Divider()
                    }
                }
                Section{
                    VStack{
                        DisclosureGroup {
                            SupportSendEmailView()
                            //                                    .padding(.vertical, 10)
                        } label: {
                            HStack(spacing: 15){
                                Image(systemName: "envelope")
                                    .font(.system(size: 25))
                                    .fontWeight(.light)
                                VStack(alignment: .leading, spacing: 5){
                                    Text("ssend-mmail")
                                        .font(.system(size: 15))
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.primary)
                                    Text("fill-form-and-send-email")
                                        .font(.system(size: 11))
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .accentColor(Color(K.Colors.lightGray))
                        //                            .padding(.leading, 15)
                        //                            .padding(.trailing, 30)
                        //                            Divider()
                    }
                    
                    VStack{
                        DisclosureGroup {
                            ShakeReportView()
                            //                                    .padding(.vertical, 10)
                        } label: {
                            HStack(spacing: 15){
                                Image(systemName: "exclamationmark.bubble")
                                    .font(.system(size: 25))
                                    .fontWeight(.light)
                                VStack(alignment: .leading, spacing: 5){
                                    Text("no-answer-report")
                                        .font(.system(size: 15))
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.primary)
                                    Text("write-issue-report")
                                        .font(.system(size: 11))
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .accentColor(Color(K.Colors.lightGray))
                        //                            .padding(.leading, 15)
                        //                            .padding(.trailing, 30)
                        //                            Divider()
                    }
                }
                //                    }
            }
            .listStyle(.sidebar)
            .accentColor(Color(K.Colors.lightGray))
            //            }
            .navigationTitle(String(localized: "ssupport"))
        }
    }
}

//#Preview {
//    SupportMainView()
//}
