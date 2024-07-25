//
//  NotificationsView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 4/2/24.
//

import SwiftUI
import FirebaseFirestore
import SwiftData

struct NotificationsView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var published: PublishedVariebles
    
    @Query var strings: [StringDataModel]

    @State private var showAction = false
    @State private var notificationToDelete: NotificationModel?
    
    var db = Firestore.firestore()
    
    var backgroundType: String {
        if let strModel = strings.first(where: { $0.name == "backgroundType" }) {
            return strModel.string
        }else {
            return "none"
        }
    }
    
    var body: some View {
        NavigationStack{
            if !viewModel.notificationArray.isEmpty{
                List{
                    ForEach(viewModel.notificationArray){ notif in
                        if notif.type == "share-person"{
                            Section(header:
                                        HStack{
                                Image(systemName: "person.2.fill")
                                Text("share-person")
                            }
                            ){
                                ForEach(notif.people, id: \.self){ id in
                                    PersonRowById(id: id)
                                        .padding(10)
                                        .listRowInsets(EdgeInsets())
                                        .contextMenu(menuItems: {
                                            Button {
                                                viewModel.adduserIdToDocument(documentId: id, newuserId: viewModel.currentUser?.uid ?? "")
                                                var newArray = notif.people.filter { personId in
                                                    personId != id
                                                }
                                                viewModel.updatePeopleList(documentId: notif.documentId, people: newArray)
                                                viewModel.fetchNotifications()
                                            }label: {
                                                Label("add", systemImage: "hand.thumbsup")
                                            }
                                            Button(role: .destructive) {
                                                var newArray = notif.people.filter { personId in
                                                    personId != id
                                                }
                                                viewModel.updatePeopleList(documentId: notif.documentId, people: newArray)
                                                if newArray.isEmpty {
                                                    viewModel.stopNotifing(item: notif)
                                                }
                                                viewModel.fetchNotifications()
                                            }label: {
                                                Label("remove", systemImage: "hand.thumbsdown")
                                            }
                                        })
                                        .swipeActions(edge: .leading) {
                                            Button{
                                                viewModel.adduserIdToDocument(documentId: id, newuserId: viewModel.currentUser?.uid ?? "")
                                                var newArray = notif.people.filter { personId in
                                                    personId != id
                                                }
                                                viewModel.updatePeopleList(documentId: notif.documentId, people: newArray)
                                                viewModel.fetchNotifications()
                                            }label: {
                                                Label("add", systemImage: "hand.thumbsup")
                                            }
                                        }
                                        .swipeActions(edge: .trailing){
                                            Button(role: .destructive){
                                                var newArray = notif.people.filter { personId in
                                                    personId != id
                                                }
                                                viewModel.updatePeopleList(documentId: notif.documentId, people: newArray)
                                                if newArray.isEmpty {
                                                    viewModel.stopNotifing(item: notif)
                                                }
                                                viewModel.fetchNotifications()
                                            }label: {
                                                Label("remove", systemImage: "hand.thumbsdown")
                                            }
                                        }
                                }
                                HStack(alignment: .top){
                                    NameMessageModel(notif: notif)
                                    Spacer()
                                    Image(systemName: "xmark")
                                        .onTapGesture {
                                            notificationToDelete = notif
                                            self.showAction.toggle()
                                        }
                                }
                            }
                            .listRowBackground(
                                GlassListRow()
                            )
                            Section{
                                HStack(spacing: 10){
                                    Text("accept")
                                        .foregroundStyle(Color.white)
                                        .padding(10)
                                        .frame(maxWidth: .infinity)
                                        .background(K.Colors.mainColor)
                                        .cornerRadius(10)
                                        .onTapGesture {
                                            for id in notif.people{
                                                viewModel.adduserIdToDocument(documentId: id, newuserId: viewModel.currentUser?.uid ?? "")
                                            }
                                            viewModel.fetchPeople()
                                            Toast.shared.present(
                                                title: String(localized: "person-added"),
                                                symbol: "checkmark",
                                                isUserInteractionEnabled: true,
                                                timing: .long
                                            )
                                            viewModel.stopNotifing(item: notif)
                                        }
                                    Text("decline")
                                        .foregroundStyle(Color.white)
                                        .padding(10)
                                        .frame(maxWidth: .infinity)
                                        .background(Color.red)
                                        .cornerRadius(10)
                                        .onTapGesture {
                                            notificationToDelete = notif
                                            self.showAction.toggle()
                                        }
                                    
                                    .confirmationDialog("", isPresented: $showAction, titleVisibility: .hidden) {
                                        Button("decline", role: .destructive) {
                                            if let deleteNotif = notificationToDelete{
                                                viewModel.stopNotifing(item: deleteNotif)
                                            }
                                        }
                                        Button("cancel", role: .cancel) {
                                        }
                                    }
                                }
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets())
                            }
                            .listRowBackground(
                                GlassListRow()
                            )
                            .listSectionSpacing(10)
                        }
                    }
                    
                }
                .scrollContentBackground(backgroundType == "none" ? .visible : .hidden)
                .background {
                    ListBackground()
                }
                .refreshable {
                    viewModel.fetchNotifications()
                }
                .navigationTitle("notifications-title")
                .navigationBarTitleDisplayMode(.large)
            }else {
                VStack(alignment: .leading){
                    Image(systemName: "bell.slash")
                    Text("you-do-not-have-notifications")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear{
            viewModel.fetchNotifications()
            if published.currentTabView == 4{
                published.tabsAreHidden = false
            }
            published.notShowItemPersonView = true
        }
        .onDisappear(perform: {
            if published.currentTabView == 4{
                published.tabsAreHidden = true
            }
            published.notShowItemPersonView = false
        })
    }
}

//#Preview {
//    NotificationsView()
//}



