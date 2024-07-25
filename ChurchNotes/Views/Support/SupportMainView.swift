//
//  SupportMainView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 1/20/24.
//

import SwiftUI
import SwiftData

struct SupportMainView: View {
    @EnvironmentObject var published: PublishedVariebles
    @EnvironmentObject var viewModel: AppViewModel
    
    @Query var strings: [StringDataModel]

    @State private var showSendEmailView = false
    @State private var showIssueReportView = false
    
    var backgroundType: String {
        if let strModel = strings.first(where: { $0.name == "backgroundType" }) {
            return strModel.string
        }else {
            return "none"
        }
    }
    
    var body: some View {
        NavigationStack{
            List{
//                Section{
//                    VStack{
//                        NavigationLink(destination: SupportChatView()
//                            .navigationBarTitleDisplayMode(.inline)
//                        ){
//                            HStack(spacing: 15){
//                                Image(systemName: "message")
//                                    .font(.system(size: 25))
//                                    .fontWeight(.light)
//                                VStack(alignment: .leading, spacing: 5){
//                                    Text("cchatt")
//                                        .font(.subheadline)
//                                        .fontWeight(.semibold)
//                                        .foregroundStyle(.primary)
//                                    Text("chat-with-support-volunteer")
//                                        .font(.caption)
//                                        .foregroundStyle(.secondary)
//                                }
//                                //                                                                                Spacer()
//                                //                                                                                Image(systemName: "chevron.forward")
//                                //                                                                                    .frame(width: 28)
//                            }
//                            //                                            .padding(.leading, 20)
//                            //                                            .padding(.trailing, 25)
//                        }
//                        .navigationDestination(
//                            isPresented: Binding(
//                                get: { published.currentSettingsNavigationLink == "support-chat" },
//                                set: { newValue in
//                                    published.currentSettingsNavigationLink = newValue ? "support-chat" : nil
//                                }
//                            )
//                        ) {
//                            SupportChatView()
//                                .onAppear(perform: {
//                                    published.tabsAreHidden = true
//                                })
//                                .navigationBarTitleDisplayMode(.inline)
//                        }
//                        //                            Divider()
//                    }
//                }
                Section{
                    SupportLink(name: String(localized: "ssend-mmail"), info: String(localized: "fill-form-and-send-email"), systemImageName: "envelope")
                        .onTapGesture {
                            withAnimation {
                                self.showSendEmailView.toggle()
                            }
                        }
                    SupportLink(name: String(localized: "no-answer-report"), info: String(localized: "write-issue-report"), systemImageName: "exclamationmark.bubble")
                    .onTapGesture {
                        withAnimation {
                            self.showIssueReportView.toggle()
                        }
                    }
                }
                .listRowBackground(
                    GlassListRow()
                )
            }
            .scrollContentBackground(backgroundType == "none" ? .visible : .hidden)
            .background {
                ListBackground()
            }
            .listStyle(.insetGrouped)
            .accentColor(Color(K.Colors.lightGray))
            .navigationTitle(String(localized: "ssupport"))
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showSendEmailView) {
                NavigationStack{
                    SupportSendEmailView()
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
