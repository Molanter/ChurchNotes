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
                        Text("Chose days:")
                            .padding(.top)
                            .bold()
                            .font(.title2)
                        Spacer()
                        Picker(selection: $picked, label: Text("Picker")) {
                            Text("All Days").tag(1)
                                .font(.title3)
                            Text("Weekdays").tag(2)
                            Text("Weekend").tag(3)
                            Text("Custom").tag(4)
                            
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
                        Text("S")
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
                        Text("M")
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
                        Text("T")
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
                        Text("W")
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
                        Text("T")
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
                        Text("F")
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
                        Text("S")
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
                        Text("Set time:")
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
                        Text("Write message:")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .bold()
                            .font(.title2)
                        ZStack(alignment: .leading){
                            if message.isEmpty {
                                Text("Write here...")
                                    .padding(.leading)
                                    .foregroundColor(Color(K.Colors.lightGray))
                            }
                            TextField("", text: $message)
                                .padding(.leading)
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.never)
                                .opacity(0.75)
                                .padding(0)
                                .keyboardType(.namePhonePad)
                                .textCase(.lowercase)
                                .textContentType(.username)
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
                        Text("Set Notifications")
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
            .navigationTitle("Add Notification")
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    self.setNotifications()
                }){
                    Image(systemName: "checkmark.circle")
                }
            }
        })
        .alert("Logout", isPresented: $showAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Yes") {
                self.showAlert.toggle()
            }
        }message: {
            Text("You didn't choose the time. Choose all days?")
        }
    }
    
    private func setNotifications(){
        let count = viewModel.notificationsArray.count
        if picked != 4{
            notify.scheduleNotifications(days: picked == 1 ? [1, 2, 3, 4, 5, 6, 7] : (picked == 2 ? [2, 3, 4, 5, 6] : [1, 7]), message: message, date: notificationTime, count: count)
            viewModel.createNotification(sunday: sunday, monday: monday, tuesday: tuesday, wednsday: wednsday, thursday: thursday, friday: friday, saturday: saturday, date: notificationTime, message: message, count: count)
            self.showView = false
        }else{
            var array: [Int] = []
            if sunday{
                array.append(1)
            }else if monday{
                array.append(2)
            }else if tuesday{
                array.append(3)
            }else if wednsday{
                array.append(4)
            }else if thursday{
                array.append(5)
            }else if friday{
                array.append(6)
            }else if saturday{
                array.append(7)
            }
            notify.scheduleNotifications(days: array, message: message, date: notificationTime, count: count)
            viewModel.createNotification(sunday: sunday, monday: monday, tuesday: tuesday, wednsday: wednsday, thursday: thursday, friday: friday, saturday: saturday, date: notificationTime, message: message, count: count)
            self.showView = false
        }
    }
}

//#Preview {
//    AddNotificationView()
//}
