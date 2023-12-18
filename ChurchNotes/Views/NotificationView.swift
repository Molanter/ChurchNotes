//
//  NotificationView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 8/15/23.
//

import SwiftUI

struct NotificationView: View {
    @State var addNotification = false
    @State var toggle = false
    @State var showActionSheet = false
    @State var showRemoveAll = false
    @State var selectedDate = Date.now
    @State var deleteItem: Notifics?
    @State var showInfo = false
    let notify = NotificationHandler()
    @EnvironmentObject var viewModel: AppViewModel
    
    
    var body: some View{
        NavigationStack{
            VStack(alignment: .leading, spacing: 10){
                    if !viewModel.notificationsArray.isEmpty{
                        List{

                        ForEach(viewModel.notificationsArray){ notf in
                            VStack(alignment: .leading){
                                HStack{
                                    Text(notf.date, style: .time)
                                        .bold()
                                        .font(.title3)
                                    HStack(spacing: 1){
                                        if notf.sunday && notf.monday && notf.tuesday && notf.wednsday && notf.thursday && notf.friday && notf.saturday{
                                            Text("all-days")
                                        }else if notf.sunday && !notf.monday && !notf.tuesday && !notf.wednsday && !notf.thursday && !notf.friday && notf.saturday{
                                            Text("weekends")
                                        }else if !notf.sunday && notf.monday && notf.tuesday && notf.wednsday && notf.thursday && notf.friday && !notf.saturday{
                                            Text("weekdays")
                                        }else{
                                            Text(notf.sunday ? "sun" : "")
                                            Text(notf.monday ? "mon" : "")
                                            Text(notf.tuesday ? "tue" : "")
                                            Text(notf.wednsday ? "wed" : "")
                                            Text(notf.thursday ? "thu" : "")
                                            Text(notf.friday ? "fri" : "")
                                            Text(notf.saturday ? "sat" : "")
                                        }
                                    }
                                    .frame(alignment: .leading)
                                    .foregroundStyle(.secondary)
                                    .font(.body)
                                    Spacer()
                                    Button(action: {
                                        self.deleteItem = notf
                                        self.showActionSheet.toggle()
                                    }){
                                        Image(systemName: "xmark")
                                            .font(.title2)
                                    }
                                }
                                Text(notf.message)
                                    .font(.body)
                            }
                            .actionSheet(isPresented: $showActionSheet) {
                                ActionSheet(title: Text("you-want-to-remove-this-notification"),
                                            message: Text("press-remove-to-resume"),
                                            buttons: [
                                                .cancel(),
                                                .destructive(
                                                    Text("remove")
                                                ){
                                                    removeNotification(item: notf)
                                                }
                                            ]
                                )
                            }
                        }
                        .onDelete { indexSet in
                            if let firstIndex = indexSet.first {
                                self.deleteItem = viewModel.notificationsArray[firstIndex]
                                self.showActionSheet.toggle()
                            }
                        }
                        }
                        .listStyle(.plain)
                    }else{
                        VStack(alignment: .leading){
                            Image(systemName: "bell.slash")
                            Text("you-do-not-have-notifications-yet")
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    
                
                Spacer()
                HStack{
                    Spacer()
                    Button(action: {
                        self.showInfo = true
                    }){
                        Image(systemName: "info.circle")
                            .font(.system(size: 22))
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(Color(K.Colors.mainColor))
                            .padding(15)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("notifications")
            .onAppear{
                notify.askPermission()
                viewModel.fetchNotifications()
            }
            .actionSheet(isPresented: $showRemoveAll) {
                ActionSheet(title: Text("you-want-to-remove-all-notification"),
                            message: Text("this-action-can-not-be-undone"),
                            buttons: [
                                .cancel(),
                                .destructive(
                                    Text("remove")
                                ){
                                    notify.removeAllNotifications()
                                    viewModel.removeAllNotifications()
                                }
                            ]
                )
            }
            .sheet(isPresented: $showInfo, content: {
                NavigationStack{
                    NotificationsInfo()
                        .toolbar(content: {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button(action: {
                                    self.showInfo = false
                                }){
                                    Text("done")
                                        .foregroundStyle(Color(K.Colors.mainColor))
                                }
                            }
                        })
                }
                    .presentationDetents([.height(250)])
            })
            .sheet(isPresented: $addNotification, content: {
                NavigationStack{
                    AddNotificationView(showView: $addNotification)
                        .accentColor(Color(K.Colors.mainColor))
                        .toolbar(content: {
                            ToolbarItem(placement: .topBarLeading) {
                                Button(action: {
                                    self.addNotification = false
                                }){
                                    Text("cancel")
                                        .foregroundStyle((Color(K.Colors.mainColor)))
                                }
                            }
                        })
                }
            })
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        self.showRemoveAll.toggle()
                    }){
                        Image(systemName: "clock.badge.xmark.fill")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        self.addNotification.toggle()
                    }){
                        Image(systemName: "plus")
                    }
                }
            })
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func removeNotification(item: Notifics){
        if item.sunday{
            notify.stopNotifying(day: 1, count: item.orderIndex)
        }
        if item.monday{
            notify.stopNotifying(day: 2, count: item.orderIndex)
        }
        if item.tuesday{
            notify.stopNotifying(day: 3, count: item.orderIndex)
        }
        if item.wednsday{
            notify.stopNotifying(day: 4, count: item.orderIndex)
        }
        if item.thursday{
            notify.stopNotifying(day: 5, count: item.orderIndex)
        }
        if item.friday{
            notify.stopNotifying(day: 6, count: item.orderIndex)
        }
        if item.saturday{
            notify.stopNotifying(day: 7, count: item.orderIndex)
        }
        viewModel.stopNotifing(item: item)
    }
}


//#Preview {
//    NotificationView()
//}
