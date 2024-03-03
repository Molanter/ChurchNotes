//
//  AddNotificationView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 11/5/23.
//

import SwiftUI

struct AddNotificationView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
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
    @State var dayTaped = false
    
    let notify = NotificationHandler()
    
    var body: some View {
        NavigationStack{
            List{
                Section(header: Text("example-message-look")){
                    HStack(alignment: .top, spacing: 10){
                        AppIcon()
                            .frame(width: 50, height: 50)
                            .cornerRadius(8)
                        VStack(alignment: .leading){
                            HStack{
                                Text("pray-reminder")
                                    .font(.headline)
                                Spacer()
                                Text(notificationTime, style: .time)
                                    .foregroundStyle(.secondary)
                            }
                            Text(message.isEmpty ? String(localized: "time-to-pray-take-your-time") : message)
                        }
                    }
                }
                Section{
                    Picker(selection: $picked, label: Text("choose-days")) {
                        Text("all-days").tag(1)
                            .font(.title3)
                        Text("weekdays").tag(2)
                        Text("weekends").tag(3)
                        Text("custom").tag(4)
                        
                    }
                    .accentColor(Color(K.Colors.lightGray))
                    .onChange(of: picked) { oldValue, newValue in
                        if !dayTaped{
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
                        }else {
                            dayTaped = false
                        }
                    }
                    ScrollView(.horizontal){
                        HStack{
                            Text("sunday")
                                .onTapGesture {
                                    dayTaped = true
                                    withAnimation{
                                        self.sunday.toggle()
                                        if sunday && monday && tuesday && wednsday && thursday && friday && saturday{
                                            picked = 1
                                        }else if sunday && !monday && !tuesday && !wednsday && !thursday && !friday && saturday{
                                            picked = 3
                                        }else if !sunday && monday && tuesday && wednsday && thursday && friday && !saturday{
                                            picked = 2
                                        }else{
                                            picked = 4
                                        }
                                    }
                                }
                                .foregroundStyle(sunday ? Color.white : Color(K.Colors.justLightGray))
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 7)
                                        .fill(sunday ? K.Colors.mainColor : Color.clear)
                                        .stroke(sunday ? Color.clear : Color(K.Colors.justLightGray), lineWidth: sunday ? 0 : 2)
                                )
                                .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.1), radius: 5, x: 0, y: 10)
                                .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.1), radius: 5, x: 0, y: 8)
                            Text("monday")
                                .onTapGesture {
                                    dayTaped = true
                                    withAnimation{
                                        self.monday.toggle()
                                        if sunday && monday && tuesday && wednsday && thursday && friday && saturday{
                                            picked = 1
                                        }else if sunday && !monday && !tuesday && !wednsday && !thursday && !friday && saturday{
                                            picked = 3
                                        }else if !sunday && monday && tuesday && wednsday && thursday && friday && !saturday{
                                            picked = 2
                                        }else{
                                            picked = 4
                                        }
                                    }
                                }
                                .foregroundStyle(monday ? Color.white : Color(K.Colors.justLightGray))
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 7)
                                        .fill(monday ? K.Colors.mainColor : Color.clear)
                                        .stroke(monday ? Color.clear : Color(K.Colors.justLightGray), lineWidth: monday ? 0 : 2)
                                )
                                .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.1), radius: 5, x: 0, y: 10)
                                .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.1), radius: 5, x: 0, y: 8)
                            Text("tuesday")
                                .onTapGesture {
                                    dayTaped = true
                                    withAnimation{
                                        self.tuesday.toggle()
                                        if sunday && monday && tuesday && wednsday && thursday && friday && saturday{
                                            picked = 1
                                        }else if sunday && !monday && !tuesday && !wednsday && !thursday && !friday && saturday{
                                            picked = 3
                                        }else if !sunday && monday && tuesday && wednsday && thursday && friday && !saturday{
                                            picked = 2
                                        }else{
                                            picked = 4
                                        }                                    }
                                }
                                .foregroundStyle(tuesday ? Color.white : Color(K.Colors.justLightGray))
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 7)
                                        .fill(tuesday ? K.Colors.mainColor : Color.clear)
                                        .stroke(tuesday ? Color.clear : Color(K.Colors.justLightGray), lineWidth: tuesday ? 0 : 2)
                                )
                                .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.1), radius: 5, x: 0, y: 10)
                                .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.1), radius: 5, x: 0, y: 8)
                            Text("wednsday")
                                .onTapGesture {
                                    dayTaped = true
                                    withAnimation{
                                        self.wednsday.toggle()
                                        if sunday && monday && tuesday && wednsday && thursday && friday && saturday{
                                            picked = 1
                                        }else if sunday && !monday && !tuesday && !wednsday && !thursday && !friday && saturday{
                                            picked = 3
                                        }else if !sunday && monday && tuesday && wednsday && thursday && friday && !saturday{
                                            picked = 2
                                        }else{
                                            picked = 4
                                        }                                    }
                                }
                                .foregroundStyle(wednsday ? Color.white : Color(K.Colors.justLightGray))
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 7)
                                        .fill(wednsday ? K.Colors.mainColor : Color.clear)
                                        .stroke(wednsday ? Color.clear : Color(K.Colors.justLightGray), lineWidth: wednsday ? 0 : 2)
                                )
                                .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.1), radius: 5, x: 0, y: 10)
                                .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.1), radius: 5, x: 0, y: 8)
                            Text("thursday")
                                .onTapGesture {
                                    dayTaped = true
                                    withAnimation{
                                        self.thursday.toggle()
                                        if sunday && monday && tuesday && wednsday && thursday && friday && saturday{
                                            picked = 1
                                        }else if sunday && !monday && !tuesday && !wednsday && !thursday && !friday && saturday{
                                            picked = 3
                                        }else if !sunday && monday && tuesday && wednsday && thursday && friday && !saturday{
                                            picked = 2
                                        }else{
                                            picked = 4
                                        }
                                    }
                                }
                                .foregroundStyle(thursday ? Color.white : Color(K.Colors.justLightGray))
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 7)
                                        .fill(thursday ? K.Colors.mainColor : Color.clear)
                                        .stroke(thursday ? Color.clear : Color(K.Colors.justLightGray), lineWidth: thursday ? 0 : 2)
                                )
                                .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.1), radius: 5, x: 0, y: 10)
                                .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.1), radius: 5, x: 0, y: 8)
                            Text("friday")
                                .onTapGesture {
                                    dayTaped = true
                                    withAnimation{
                                        self.friday.toggle()
                                        if sunday && monday && tuesday && wednsday && thursday && friday && saturday{
                                            picked = 1
                                        }else if sunday && !monday && !tuesday && !wednsday && !thursday && !friday && saturday{
                                            picked = 3
                                        }else if !sunday && monday && tuesday && wednsday && thursday && friday && !saturday{
                                            picked = 2
                                        }else{
                                            picked = 4
                                        }                                    }
                                }
                                .foregroundStyle(friday ? Color.white : Color(K.Colors.justLightGray))
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 7)
                                        .fill(friday ? K.Colors.mainColor : Color.clear)
                                        .stroke(friday ? Color.clear : Color(K.Colors.justLightGray), lineWidth: friday ? 0 : 2)
                                )
                                .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.1), radius: 5, x: 0, y: 10)
                                .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.1), radius: 5, x: 0, y: 8)
                            Text("saturday")
                                .onTapGesture {
                                    dayTaped = true
                                    withAnimation{
                                        self.saturday.toggle()
                                        if sunday && monday && tuesday && wednsday && thursday && friday && saturday{
                                            picked = 1
                                        }else if sunday && !monday && !tuesday && !wednsday && !thursday && !friday && saturday{
                                            picked = 3
                                        }else if !sunday && monday && tuesday && wednsday && thursday && friday && !saturday{
                                            picked = 2
                                        }else{
                                            picked = 4
                                        }                                    }
                                }
                                .foregroundStyle(saturday ? Color.white : Color(K.Colors.justLightGray))
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 7)
                                        .fill(saturday ? K.Colors.mainColor : Color.clear)
                                        .stroke(saturday ? Color.clear : Color(K.Colors.justLightGray), lineWidth: saturday ? 0 : 2)
                                )
                                .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.1), radius: 5, x: 0, y: 10)
                                .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.1), radius: 5, x: 0, y: 8)
                        }
                        .padding()
                    }
                    .listRowInsets(EdgeInsets())
                }
                
                Section{
                    DatePicker(
                        "set-time",
                        selection: $notificationTime,
                        displayedComponents: [.hourAndMinute]
                    )
                    .padding(.vertical, 1)
                }
                Section(header: Text("write-message")){
                    TextField("pray-for", text: $message, axis: .vertical)
                        .lineLimit(5)
                        .disableAutocorrection(false)
                        .textInputAutocapitalization(.sentences)
                        .keyboardType(.default)
                        .multilineTextAlignment(.leading)
                        .textSelection(.enabled)
                }
                Section{
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
                    .background(K.Colors.mainColor)
                    .cornerRadius(10)
                    .listRowInsets(EdgeInsets())
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .navigationTitle("add-notification")
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    self.setNotifications()
                }){
                    Text("add")
                        .foregroundStyle(K.Colors.mainColor)
                }
            }
        })
        .actionSheet(isPresented: $showAlert) {
            ActionSheet(title: Text("hhey"),
                        message: Text("you-did-not-choose-the-time"),
                        buttons: [
                            .cancel(),
                            .default(
                                Text(K.Hiden.ok.randomElement()!)
                            ){
                                showAlert.toggle()
                            }
                        ]
            )
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
