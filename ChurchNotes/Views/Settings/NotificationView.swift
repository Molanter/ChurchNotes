//
//  NotificationView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 8/15/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct NotificationView: View {
    @Binding var notifications: Bool
    @Binding var documentId: String
    @Binding var notificationTime: Date
    @State var toggle = false
    @State var selectedDate = Date.now
    let notify = NotificationHandler()
    
    var db = Firestore.firestore()

    var body: some View{
        NavigationStack{
            VStack(alignment: .leading, spacing: 10){
                VStack{
                    HStack{
                        Text("Every day at time:")
                        Spacer()
                        if notifications{
                            Text(selectedDate.formatted(.dateTime.hour().minute()))
                                .padding()
                        }else{
                            DatePicker(
                                    "",
                                    selection: $notificationTime,
                                    displayedComponents: [.hourAndMinute]
                                )
                        }
                    }
                    Button(action: {everyDayNotify()}){
                        Text(notifications ? "Stop" : "Set")
                            .foregroundColor(Color.white)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(notifications ? Color(K.Colors.pink) : Color(K.Colors.mainColor))
                            .cornerRadius(7)
                    }
                }
//                VStack{
//                    HStack{
//                        Text("Every day at time:")
//                        Spacer()
//                        DatePicker(
//                                "",
//                                selection: $notificationTime,
//                                displayedComponents: [.hourAndMinute]
//                            )
//                    }
//                    Button(action: {everyDayNotify()}){
//                        Text(notifications ? "Stop" : "Set")
//                            .foregroundColor(Color.white)
//                            .padding(.vertical, 10)
//                            .frame(maxWidth: .infinity)
//                            .background(notifications ? Color(K.Colors.pink) : Color(K.Colors.mainColor))
//                            .cornerRadius(7)
//                    }
//                }
                Spacer()
            }
            .padding(.horizontal, 15)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Set notifications")
            .onAppear{
                notify.askPermission()
                fetchDictionary()
                
            }
        }
    }
    
    func fetchDictionary(){
        if let userID = Auth.auth().currentUser?.uid{
            db.collection("users").document("profiles").collection(userID).getDocuments() { querySnapshot, err in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let dictionary = document.data()
                        let notifications = dictionary["notifications"] as! Bool
                        let notificationTime = (dictionary["notificationTime"] as? Timestamp)?.dateValue() ?? Date()

                        self.notificationTime = notificationTime
                        self.selectedDate = notificationTime
                        print(notificationTime.formatted(.dateTime.hour().minute()))
                        self.notifications = notifications
                        
                        self.toggle = self.notifications
                        if notifications == true{
                            self.selectedDate = self.notificationTime
                        }else{
                            self.notificationTime = Date.now
                        }
                    }
                }
            }
        }
    }

    func everyDayNotify(){
        self.selectedDate = notificationTime
        print(String(notificationTime.formatted(.dateTime.hour().minute())))
        if notifications == false{
            notifications = true
            notify.sendNotification(
                date: notificationTime,
                type: "everyDay",
                title: "Praying Time",
                body: "Every day reminding for praying. Take your time.")
            
            if let userID = Auth.auth().currentUser?.uid{
                let ref = db.collection("users").document("profiles").collection(userID).document(documentId)
                ref.updateData(
                    ["notifications": notifications,
                     "notificationTime": notificationTime
                    ]){error in
                        if let error = error{
                            print("Error while updating profile:  -\(error)")
                        }else{
                        }
                    }
            }
        }else if notifications == true{
            notifications = false
            
            if let userID = Auth.auth().currentUser?.uid{
                let ref = db.collection("users").document("profiles").collection(userID).document(documentId)
                ref.updateData(
                    ["notifications": notifications,
                     "notificationTime": notificationTime
                    ]){error in
                        if let error = error{
                            print("Error while updating profile:  -\(error)")
                        }else{
                        }
                    }
            }
            notify.stopNotifying(type: "everyDay")
            self.notificationTime = Date.now
        }
    }
}


//#Preview {
//    NotificationView()
//}
