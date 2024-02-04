//
//  SupportVolunteerList.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 1/27/24.
//

import SwiftUI

struct SupportVolunteerList: View {
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var published: PublishedVariebles

    @State var searchText = ""
    var body: some View {
        NavigationStack{
            List{
                ForEach(searchText.isEmpty ? viewModel.supportMessageArray : viewModel.supportMessageArray.filter { $0.name.contains(searchText)}){ msg in
                    NavigationLink{
                        SupportChatView(support: true)
                            .onAppear(perform: {
                                published.tabsAreHidden = true
                            })
                            .toolbar(.hidden, for: .tabBar)
                    }label: {
                        HStack(spacing: 15){
                            if !msg.profileImage.isEmpty{
                                AsyncImage(url: URL(string: msg.profileImage)){image in
                                    image.resizable()
                                    
                                }placeholder: {
                                    ProgressView()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 50, height: 50)
                                }
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .cornerRadius(30)
                                .overlay(
                                    Circle().stroke(.gray.opacity(0.6), lineWidth: 1)
                                )
                            }else{
                                ZStack(alignment: .center){
                                    Circle()
                                        .foregroundColor(Color(K.Colors.darkGray))
                                        .frame(width: 50, height: 50)
                                    Text(viewModel.twoNames(name: msg.name))
                                        .textCase(.uppercase)
                                        .foregroundColor(Color.white)
                                }
                                
                            }
                            VStack{
                                HStack{
                                    Text(msg.name.capitalized)
                                        .font(.system(size: 16))
                                        .bold()
                                    Spacer()
                                    Text(msg.time, style: .time)
                                        .font(.system(size: 12))
                                        .foregroundStyle(.secondary)
                                }
                                HStack{
                                    if !msg.message.isEmpty{
                                        HStack{
                                            if !msg.type.isEmpty, msg.type != "/image"{
                                                Text("\(msg.type): ")
                                            }
                                            Text(msg.message)
                                        }
                                            .font(.system(size: 14))
                                            .multilineTextAlignment(.leading)
                                            .foregroundStyle(.secondary)
                                    }else if msg.image{
                                        Image(systemName: "photo")
                                            .foregroundStyle(.secondary)
                                            .font(.system(size: 14))
                                    }
                                    Spacer()
                                }
                                Spacer()
                            }
                            .padding(.vertical, 5)
                        }
                        .frame(height: 50)
                    }
                    .contextMenu(ContextMenu(menuItems: {
                        Button(role: .destructive) {
                            for msg in viewModel.messagesArray.sorted(by: { $0.time < $1.time }){
                                viewModel.deleteMessage(documentId: msg.documentId)
                                if !msg.image.isEmpty{
                                    viewModel.deleteImage(docId: msg.documentId)
                                }
                            }
                            viewModel.deleteSupportConversation()
                            viewModel.fetchChatList()
                        } label: {
                            Label("delete", systemImage: "trash")
                        }

                    }))
                }
            }
            .listStyle(.inset)
            .searchable(text: $searchText, placement: .sidebar, prompt: "search-name")
            .refreshable{
                viewModel.fetchChatList()
            }
            .onAppear(perform: {
                published.tabsAreHidden = false
            })
            .onDisappear(perform: {
                if published.currentTabView == 1{
                    published.tabsAreHidden = true
                }
                viewModel.fetchChatList()
            })
        }
        .onAppear {
            viewModel.fetchChatList()
        }
    }
}

//#Preview {
//    SupportVolunteerList()
//}
