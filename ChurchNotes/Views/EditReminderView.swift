//
//  EditReminderView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 2/16/24.
//

import SwiftUI
import SwiftData

struct EditReminderView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var published: PublishedVariebles
    @Environment(\.modelContext) var modelContext
    
    @Query var reminders: [ReminderDataModel]

    @Binding var showEdit: ReminderDataModel?
        
    @State var sunday = false
    @State var monday = false
    @State var tuesday = false
    @State var wednsday = false
    @State var thursday = false
    @State var friday = false
    @State var saturday = false
    @State var notificationTime = Date.now
    @State var message = ""
    @State var dayTaped = false
    @State var picked = 4
    @State var showAlert = false
    
    var notific: ReminderDataModel
    let notify = ReminderHandler()
    
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
                    HStack{
                        Text("choose-days")
                        Spacer()
                        Menu{
                            Button{
                                picked = 1
                            }label: {
                                Text(String(localized: "all-days"))
                            }
                            Button{
                                picked = 2
                            }label: {
                                Text(String(localized: "weekdays"))
                            }
                            Button{
                                picked = 3
                            }label: {
                                Text(String(localized: "weekends"))
                            }
                            Button{
                                picked = 4
                            }label: {
                                Text(String(localized: "custom"))
                            }
                        }label: {
                            Text(daysReturn())
                            Image(systemName: "chevron.up.chevron.down")
                        }
                        .accentColor(Color(K.Colors.lightGray))
                    }
//                    Picker(selection: $picked, label: Text("edit-days")) {
//                        Text("all-days").tag(1)
//                        Text("weekdays").tag(2)
//                        Text("weekends").tag(3)
//                        Text("custom").tag(4)
//                        
//                    }
//                    .accentColor(Color(K.Colors.lightGray))
                    .onChange(of: picked) { oldValue, newValue in
                        if !dayTaped{
                            withAnimation{
                                if newValue == 1{
                                    sunday = true
                                    monday = true
                                    tuesday = true
                                    wednsday = true
                                    thursday = true
                                    friday = true
                                    saturday = true
                                }else if newValue == 2{
                                    sunday = false
                                    monday = true
                                    tuesday = true
                                    wednsday = true
                                    thursday = true
                                    friday = true
                                    saturday = false
                                }else if newValue == 3{
                                    sunday = true
                                    monday = false
                                    tuesday = false
                                    wednsday = false
                                    thursday = false
                                    friday = false
                                    saturday = true
                                }else if newValue == 4{
                                    sunday = false
                                    monday = false
                                    tuesday = false
                                    wednsday = false
                                    thursday = false
                                    friday = false
                                    saturday = false
                                }
                            }
                        }else{
                            dayTaped = false
                        }
                    }
                    ScrollView(.horizontal){
                        HStack{
                            Text("sunday")
                                .onTapGesture {
                                    dayTaped = true
                                    withAnimation{
                                        sunday.toggle()
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
                                        monday.toggle()
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
                                        tuesday.toggle()
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
                                        wednsday.toggle()
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
                                        thursday.toggle()
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
                                        friday.toggle()
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
                                        saturday.toggle()
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
                        "edit-time",
                        selection: $notificationTime,
                        displayedComponents: [.hourAndMinute]
                    )
                    .padding(.vertical, 1)
                }
                Section(header: Text("edit-message")){
                    
                    TextField("pray-for", text: $message, axis: .vertical)
                        .lineLimit(5)
                        .disableAutocorrection(false)
                        .textInputAutocapitalization(.sentences)
                        .keyboardType(.default)
                        .multilineTextAlignment(.leading)
                        .textSelection(.enabled)
                }
                Section{
                    Text("save")
                        .foregroundStyle(Color.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(K.Colors.mainColor)
                        .cornerRadius(7)
                        .listRowInsets(EdgeInsets())
                        .onTapGesture {
                            if picked == 4 && !sunday && !monday && !tuesday && !wednsday && !thursday && !friday && !saturday{
                                self.showAlert.toggle()
                            }else{
                                self.setNotifications()
                            }
                        }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .navigationTitle("edit-reminder")
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        self.setNotifications()
                    }){
                        Text("save")
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
            .modifier(DismissingKeyboard())
            .onAppear {
                sunday = notific.sunday
                monday = notific.monday
                tuesday = notific.tuesday
                wednsday = notific.wednsday
                thursday = notific.thursday
                friday = notific.friday
                saturday = notific.saturday
                notificationTime = notific.date
                message = notific.message
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
    }
    
    private func removeNotification(item: ReminderDataModel){
        modelContext.delete(item)
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
    }
    
    private func setNotifications(){
        removeNotification(item: notific)
        let count = reminders.count
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
        let newReminder = ReminderDataModel(message: message, date: notificationTime, sunday: sunday, monday: monday, tuesday: tuesday, wednsday: wednsday, thursday: thursday, friday: friday, saturday: saturday, orderIndex: notific.orderIndex)
        modelContext.insert(newReminder)
        showEdit = nil
    }
    
    private func daysReturn() -> String {
        var days = ""
        if self.sunday && self.monday && self.tuesday && self.wednsday && self.thursday && self.friday && self.saturday{
            days = String(localized: "all-days")
        }else if self.sunday && !self.monday && !self.tuesday && !self.wednsday && !self.thursday && !self.friday && self.saturday{
            days = String(localized: "weekends")
        }else if !self.sunday && self.monday && self.tuesday && self.wednsday && self.thursday && self.friday && !self.saturday{
                days = String(localized: "weekdays")
        }else{
            days = String(localized: "custom")
        }
        return days
    }
}

//#Preview {
//    EditReminderView()
//}
