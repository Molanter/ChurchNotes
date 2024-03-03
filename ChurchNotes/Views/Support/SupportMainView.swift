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
    
    @State private var showSendEmailView = false
    @State private var showIssueReportView = false
    
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
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.primary)
                                    Text("chat-with-support-volunteer")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                //                                                                                Spacer()
                                //                                                                                Image(systemName: "chevron.forward")
                                //                                                                                    .frame(width: 28)
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
                                .navigationBarTitleDisplayMode(.inline)
                        }
                        //                            Divider()
                    }
                }
                Section{
                    
                    VStack{
                        HStack(spacing: 15){
                            Image(systemName: "envelope")
                                .font(.system(size: 25))
                                .fontWeight(.light)
                            VStack(alignment: .leading, spacing: 5){
                                Text("ssend-mmail")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.primary)
                                Text("fill-form-and-send-email")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.forward")
                                .font(.system(size: 13))
                                .foregroundStyle(.secondary)
                                .opacity(0.5)
                                .bold()
                        }
                        .accentColor(Color(K.Colors.lightGray))
                    }
                    .onTapGesture {
                        withAnimation {
                            self.showSendEmailView.toggle()
                        }
                    }
                    VStack{
                        HStack(spacing: 15){
                            Image(systemName: "exclamationmark.bubble")
                                .font(.system(size: 25))
                                .fontWeight(.light)
                            VStack(alignment: .leading, spacing: 5){
                                Text("no-answer-report")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.primary)
                                Text("write-issue-report")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.forward")
                                .font(.system(size: 13))
                                .foregroundStyle(.secondary)
                                .opacity(0.5)
                                .bold()
                        }
                        .accentColor(Color(K.Colors.lightGray))
                    }
                    .onTapGesture {
                        withAnimation {
                            self.showIssueReportView.toggle()
                        }
                    }
                }
            }
            .listStyle(.sidebar)
            .accentColor(Color(K.Colors.lightGray))
            .navigationTitle(String(localized: "ssupport"))
            .sheet(isPresented: $showSendEmailView) {
                NavigationStack{
                    SupportSendEmailView()
                        .padding(.horizontal, 15)
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button{
                                    self.showSendEmailView = false
                                }label: {
                                    Text("done")
                                        .foregroundStyle(K.Colors.mainColor)
                                }
                            }
                        }
                }
                .presentationDetents([.height(300), .medium])
            }
            .sheet(isPresented: $showIssueReportView) {
                NavigationStack{
                    ShakeReportView()
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button{
                                    self.showIssueReportView = false
                                }label: {
                                    Text("done")
                                        .foregroundStyle(K.Colors.mainColor)
                                }
                            }
                        }
                }
                .presentationDetents([.height(300), .medium])
            }
        }
    }
}
//#Preview {
//    SupportMainView()
//}
