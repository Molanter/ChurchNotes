//
//  NotificationView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 8/15/23.
//

import SwiftUI

struct NotificationView: View {
    @State var addNotification = false
    @Binding var notifications: Bool
    @Binding var documentId: String
    @Binding var notificationTime: Date
    @State var toggle = false
    @State var showActionSheet = false
    @State var selectedDate = Date.now
    @State var deleteItem: Notifics?
    let notify = NotificationHandler()
    @EnvironmentObject var viewModel: AppViewModel
    
    
    var body: some View{
        NavigationStack{
            VStack(alignment: .leading, spacing: 10){
                    if !viewModel.notificationsArray.isEmpty{
                        List{

                        ForEach(viewModel.notificationsArray){ notification in
                            VStack(alignment: .leading){
                                HStack{
                                    Text(notification.date, style: .time)
                                        .bold()
                                        .font(.title3)
                                    HStack(spacing: 1){
                                        Text(notification.sunday ? "Sun " : "")
                                        Text(notification.monday ? "Mon " : "")
                                        Text(notification.tuesday ? "Tue " : "")
                                        Text(notification.wednsday ? "Wed " : "")
                                        Text(notification.thursday ? "Thu " : "")
                                        Text(notification.friday ? "Fri " : "")
                                        Text(notification.saturday ? "Sat " : "")
                                    }
                                    .frame(alignment: .leading)
                                    .foregroundStyle(.secondary)
                                    .font(.body)
                                    Spacer()
                                    Button(action: {
                                        self.deleteItem = notification
                                        self.showActionSheet.toggle()
                                    }){
                                        Image(systemName: "xmark")
                                            .font(.title2)
                                    }
                                }
                                Text(notification.message)
                                    .font(.body)
                            }
                            .actionSheet(isPresented: $showActionSheet) {
                                ActionSheet(title: Text("You want to remove this notification"),
                                            message: Text("Press '**Remove**' to resume."),
                                            buttons: [
                                                .cancel(),
                                                .destructive(
                                                    Text("Remove")
                                                ){
                                                    removeNotification(item: notification)
                                                }
                                            ]
                                )
                            }
                            
                            //                            .background(
                            //                                RoundedRectangle(cornerRadius: 10).stroke(Color(K.Colors.darkGray), lineWidth: 1)
                            //                            )
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
                            Text("You don't have notifications yet.")
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    
                
                Spacer()
            }
            .padding(.horizontal, 15)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Notifications")
            .onAppear{
                notify.askPermission()
                viewModel.fetchNotifications()
            }
            .sheet(isPresented: $addNotification, content: {
                NavigationStack{
                    AddNotificationView(showView: $addNotification)
                        .accentColor(Color(K.Colors.mainColor))
                        .toolbar(content: {
                            ToolbarItem(placement: .topBarLeading) {
                                Button(action: {
                                    self.addNotification = false
                                }){
                                    Image(systemName: "xmark.circle")
                                        .foregroundStyle((Color(K.Colors.mainColor)))
                                }
                            }
                        })
                }
            })
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        self.addNotification.toggle()
                    }){
                        Image(systemName: "plus")
                    }
                }
            })
        }
    }
    
    private func removeNotification(item: Notifics){
        notify.stopNotifiing(message: item.message, count: item.orderIndex)
        viewModel.stopNotifing(item: item)
    }
}


//#Preview {
//    NotificationView()
//}
