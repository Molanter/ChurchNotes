//
//  AddNotificationView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 11/5/23.
//

import SwiftUI

struct AddNotificationView: View {
    @Binding var showView: Bool
    @State var picked = 4
    @State var sunday = false
    @State var monday = false
    @State var tuesday = false
    @State var wednsday = false
    @State var thursday = false
    @State var friday = false
    @State var saturday = false
    @State var notificationTime = Date.now
    @State var message = ""
    @State var showAlert = false
    let notify = NotificationHandler()
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        NavigationStack{
            ScrollView(.vertical){
                VStack(alignment: .leading, spacing: 10){
                    HStack{
                        Text("choose-days")
                            .padding(.top)
                            .bold()
                            .font(.title2)
                        Spacer()
                        Picker(selection: $picked, label: Text("picker")) {
                            Text("all-days").tag(1)
                                .font(.title3)
                            Text("weekdays").tag(2)
                            Text("weekends").tag(3)
                            Text("custom").tag(4)
                            
                        }
                        .accentColor(Color(K.Colors.lightGray))
                    }
                    .onChange(of: picked) { oldValue, newValue in
                        withAnimation{
                            if newValue == 1{
                                self.sunday = true
                                self.monday = true
                                self.tuesday = true
                                self.wednsday = true
                                self.thursday = true
                                self.friday = true
                                self.saturday = true
                            }else if newValue == 2{
                                self.sunday = false
                                self.monday = true
                                self.tuesday = true
                                self.wednsday = true
                                self.thursday = true
                                self.friday = true
                                self.saturday = false
                            }else if newValue == 3{
                                self.sunday = true
                                self.monday = false
                                self.tuesday = false
                                self.wednsday = false
                                self.thursday = false
                                self.friday = false
                                self.saturday = true
                            }else if newValue == 4{
                                self.sunday = false
                                self.monday = false
                                self.tuesday = false
                                self.wednsday = false
                                self.thursday = false
                                self.friday = false
                                self.saturday = false
                            }
                        }
                    }
                    HStack{
                        Text("sunday")
                            .onTapGesture {
                                withAnimation{
                                    if picked == 4{
                                        self.sunday.toggle()
                                    }
                                }
                            }
                            .foregroundStyle(sunday ? Color.white : Color(K.Colors.justLightGray))
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 7)
                                    .fill(sunday ? Color(K.Colors.mainColor) : Color.clear)
                                    .stroke(sunday ? Color.clear : Color(K.Colors.justLightGray), lineWidth: sunday ? 0 : 2)
                            )
                            .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.1), radius: 5, x: 0, y: 10)
                            .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.1), radius: 5, x: 0, y: 8)
                        Text("monday")
                            .onTapGesture {
                                withAnimation{
                                    if picked == 4{
                                        self.monday.toggle()
                                    }
                                }
                            }
                            .foregroundStyle(monday ? Color.white : Color(K.Colors.justLightGray))
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 7)
                                    .fill(monday ? Color(K.Colors.mainColor) : Color.clear)
                                    .stroke(monday ? Color.clear : Color(K.Colors.justLightGray), lineWidth: monday ? 0 : 2)
                            )
                            .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.1), radius: 5, x: 0, y: 10)
                            .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.1), radius: 5, x: 0, y: 8)
                        Text("tuesday")
                            .onTapGesture {
                                withAnimation{
                                    if picked == 4{
                                        self.tuesday.toggle()
                                    }
                                }
                            }
                            .foregroundStyle(tuesday ? Color.white : Color(K.Colors.justLightGray))
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 7)
                                    .fill(tuesday ? Color(K.Colors.mainColor) : Color.clear)
                                    .stroke(tuesday ? Color.clear : Color(K.Colors.justLightGray), lineWidth: tuesday ? 0 : 2)
                            )
                            .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.1), radius: 5, x: 0, y: 10)
                            .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.1), radius: 5, x: 0, y: 8)
                        Text("wednsday")
                            .onTapGesture {
                                withAnimation{
                                    if picked == 4{
                                        self.wednsday.toggle()
                                    }
                                }
                            }
                            .foregroundStyle(wednsday ? Color.white : Color(K.Colors.justLightGray))
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 7)
                                    .fill(wednsday ? Color(K.Colors.mainColor) : Color.clear)
                                    .stroke(wednsday ? Color.clear : Color(K.Colors.justLightGray), lineWidth: wednsday ? 0 : 2)
                            )
                            .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.1), radius: 5, x: 0, y: 10)
                            .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.1), radius: 5, x: 0, y: 8)
                        Text("thursday")
                            .onTapGesture {
                                withAnimation{
                                    if picked == 4{
                                        self.thursday.toggle()
                                    }
                                }
                            }
                            .foregroundStyle(thursday ? Color.white : Color(K.Colors.justLightGray))
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 7)
                                    .fill(thursday ? Color(K.Colors.mainColor) : Color.clear)
                                    .stroke(thursday ? Color.clear : Color(K.Colors.justLightGray), lineWidth: thursday ? 0 : 2)
                            )
                            .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.1), radius: 5, x: 0, y: 10)
                            .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.1), radius: 5, x: 0, y: 8)
                        Text("friday")
                            .onTapGesture {
                                withAnimation{
                                    if picked == 4{
                                        self.friday.toggle()
                                    }
                                }
                            }
                            .foregroundStyle(friday ? Color.white : Color(K.Colors.justLightGray))
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 7)
                                    .fill(friday ? Color(K.Colors.mainColor) : Color.clear)
                                    .stroke(friday ? Color.clear : Color(K.Colors.justLightGray), lineWidth: friday ? 0 : 2)
                            )
                            .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.1), radius: 5, x: 0, y: 10)
                            .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.1), radius: 5, x: 0, y: 8)
                        Text("saturday")
                            .onTapGesture {
                                withAnimation{
                                    if picked == 4{
                                        self.saturday.toggle()
                                    }
                                }
                            }
                            .foregroundStyle(saturday ? Color.white : Color(K.Colors.justLightGray))
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 7)
                                    .fill(saturday ? Color(K.Colors.mainColor) : Color.clear)
                                    .stroke(saturday ? Color.clear : Color(K.Colors.justLightGray), lineWidth: saturday ? 0 : 2)
                            )
                            .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.1), radius: 5, x: 0, y: 10)
                            .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.1), radius: 5, x: 0, y: 8)
                    }
                    HStack{
                        Text("set-time")
                            .bold()
                            .font(.title2)
                        Spacer()
                        DatePicker(
                            "",
                            selection: $notificationTime,
                            displayedComponents: [.hourAndMinute]
                        )
                    }
                    .padding(.top)
                    VStack{
                        Text("write-message")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .bold()
                            .font(.title2)
                        ZStack(alignment: .leading){
                            if message.isEmpty {
                                Text("pray-for")
                                    .padding(.leading)
                                    .foregroundStyle(.secondary)
                            }
                            TextField("", text: $message)
                                .padding(.leading)
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.never)
                                .opacity(0.75)
                                .padding(0)
                                .keyboardType(.default)
                        }
                        .frame(minHeight: 50, maxHeight: .infinity)
                        .overlay(
                            RoundedRectangle(cornerSize: .init(width: 7, height: 7))
                                .stroke(Color(K.Colors.justLightGray).opacity(0.5), lineWidth: 1)
                        )
                    }
                    .padding(.top)
                    Button(action: {
                        if picked == 4 && !sunday && !monday && !tuesday && !wednsday && !thursday && !friday && !saturday{
                            self.showAlert.toggle()
                        }else{
                            self.setNotifications()
                        }
                    }){
                        Text("set-notifications")
                            .foregroundStyle(Color.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                    }
                    .background(Color(K.Colors.mainColor))
                    .cornerRadius(7)
                    .padding(.top)
                    Spacer()
                }
            }
            .padding(.horizontal, 15)
            .frame(maxWidth: .infinity, alignment: .leading)
            .navigationTitle("add-notification")
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    self.setNotifications()
                }){
                    Text("add")
                        .foregroundStyle(Color(K.Colors.mainColor))
                }
            }
        })
        .alert("logout", isPresented: $showAlert) {
            Button("cancel", role: .cancel) {}
            Button("yes") {
                self.showAlert.toggle()
            }
        }message: {
            Text("you-did-not-choose-the-time")
        }
    }
    
    private func setNotifications(){
        let count = viewModel.notificationsArray.count
        if sunday{
            notify.scheduleNotifications(days: [1], message: message, date: notificationTime, count: count)
        }
        if monday{
            notify.scheduleNotifications(days: [2], message: message, date: notificationTime, count: count)
        }
        if tuesday{
            notify.scheduleNotifications(days: [3], message: message, date: notificationTime, count: count)
        }
        if wednsday{
            notify.scheduleNotifications(days: [4], message: message, date: notificationTime, count: count)
        }
        if thursday{
            notify.scheduleNotifications(days: [5], message: message, date: notificationTime, count: count)
        }
        if friday{
            notify.scheduleNotifications(days: [6], message: message, date: notificationTime, count: count)
        }
        if saturday{
            notify.scheduleNotifications(days: [7], message: message, date: notificationTime, count: count)
        }
        viewModel.createNotification(sunday: sunday, monday: monday, tuesday: tuesday, wednsday: wednsday, thursday: thursday, friday: friday, saturday: saturday, date: notificationTime, message: message, count: count)
        self.showView = false
    }
}

//#Preview {
//    AddNotificationView()
//}
