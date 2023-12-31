//
//  AddPersonView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 8/18/23.
//

import SwiftUI
import iPhoneNumberField
import SwiftData

struct AddPersonView: View {

    @Binding var showAddPersonView: Bool
    @State var shouldShowImagePicker = false
    @State var name: String = ""
    @State var email: String = ""
    @State var phoneNumber: String = ""
    @State var notes: String = ""
    @State var birthDay: Date = Date.now
    @State var image: UIImage?
    @State private var nameIsEmpty = false
    let notify = NotificationHandler()
    var offset: Int
    var stageName: String
    var count: Int
    @EnvironmentObject var viewModel: AppViewModel

    
//    private var filteredNames: [Items] {
//            return title.items.sorted(by: { $0.orderIndex < $1.orderIndex })
//        }
//    
//    private var filteredItems: [Items] {
//            return filteredNames.sorted(by: { $0.isLiked && !$1.isLiked })
//        }
    
    var body: some View {
        NavigationStack{
            ZStack(alignment: .bottom){
                ScrollView{
                    VStack(alignment: .center){
                        Button (action: {
                            shouldShowImagePicker.toggle()
                        }){
                            VStack(alignment: . center){
                                if let image = self.image{
                                    Image(uiImage: image)
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(50)
                                        .overlay(
                                            Circle().stroke(Color(K.Colors.mainColor), lineWidth: 2)
                                        )
                                        .padding(15)
                                    
                                }else{
                                    Image(systemName: "person.fill.viewfinder")
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(Color(K.Colors.mainColor))
                                        .padding(15)
                                    
                                    
                                }
                                Text("tap to change Image")
                                    .foregroundStyle(.secondary)
                                    .foregroundStyle(Color(K.Colors.mainColor))
                            }
                            .padding(15)
                        }
                        VStack(alignment: .leading, spacing: 20){
                            VStack{
                                HStack{
                                    Text("Write Person Name")
                                        .font(.title2)
                                        .fontWeight(.medium)
                                    Spacer()
                                    Text("(required)")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                        .fontWeight(.medium)
                                }
                                HStack{
                                    TextField("Name", text: $name)
                                        .textContentType(.name)
                                        }
                                .padding(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5.0).stroke(Color(K.Colors.gray), lineWidth: 1)
                                )
                            }
                            VStack{
                                HStack{
                                    Text("Email")
                                        .font(.title2)
                                        .fontWeight(.medium)
                                    Spacer()
                                    Text("(optional)")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                        .fontWeight(.medium)
                                }
                                HStack{
                                    TextField("Email", text: $email)
                                        .textInputAutocapitalization(.never)
                                        .disableAutocorrection(true)
                                        .textContentType(.emailAddress)
                                        .keyboardType(.emailAddress)
                                        }
                                .padding(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5.0).stroke(Color(K.Colors.gray), lineWidth: 1)
                                )
                            }
                            VStack(alignment: .leading, spacing: 20){
                                HStack{
                                    Text("Phone")
                                        .font(.title2)
                                        .fontWeight(.medium)
                                    Spacer()
                                    Text("(optional)")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                        .fontWeight(.medium)
                                }
                                HStack(alignment: .center, spacing: 0.0){
                                    ZStack(alignment: .leading){
                                        iPhoneNumberField("Phone Number", text: $phoneNumber)
                                            .maximumDigits(15)
                                            .prefixHidden(false)
                                            .flagHidden(false)
                                            .flagSelectable(true)
                                            .placeholderColor(Color(K.Colors.darkGray))
                                            .frame(height: 45)
                                            .disableAutocorrection(true)
                                            .textInputAutocapitalization(.never)
                                            .padding(0)
                                            .textContentType(.telephoneNumber)
                                    }
                                    .padding(.leading)
                                    Spacer()
                                }
                                .frame(height: 50)
                                .overlay(
                                    RoundedRectangle(cornerSize: .init(width: 7, height: 7))
                                        .stroke(Color(K.Colors.gray), lineWidth: 1)
                                )
                            }
                            VStack{
                                HStack{
                                    Text("Notes")
                                        .font(.title2)
                                        .fontWeight(.medium)
                                    Spacer()
                                    Text("(optional)")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                        .fontWeight(.medium)
                                }
                                HStack{
                                    TextField("Notes", text: $notes)
                                        }
                                .padding(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5.0).stroke(Color(K.Colors.gray), lineWidth: 1)
                                )
                            }
                            VStack{
                                HStack{
                                    Text("Birthday")
                                        .font(.title2)
                                        .fontWeight(.medium)
                                    Spacer()
                                    Text("(optional)")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                        .fontWeight(.medium)
                                }
                                HStack{
                                    Text("Birthday")
//                                            .foregroundStyle(.secondary.opacity(0.5))
                                    DatePicker(
                                            "",
                                            selection: $birthDay,
                                            displayedComponents: [.date]
                                        )
                                        }
                                .padding(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5.0).stroke(Color(K.Colors.gray), lineWidth: 1)
                                )
                            }
                            .padding(.bottom, 75)
                        }
                        .padding(15)
                    }
                    Spacer()
                }
                VStack(alignment: .center, spacing: 30){
                    Button(action: {
                        if !name.isEmpty{
                            addItem()
                        }else{
                            nameError()
                        }
                    }){
                        Text("Add")
                            .foregroundColor(Color.white)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(Color(K.Colors.mainColor))
                            .cornerRadius(7)
                    }
                    if nameIsEmpty{
                        HStack(alignment: .center){
                            Text("Name is empty")
                                .foregroundStyle(Color(K.Colors.justDarkGray))
                        }
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                        .background(Color(K.Colors.justLightGray))
                        .cornerRadius(7)
                        .onTapGesture(perform: {
                            withAnimation{
                                nameIsEmpty = false
                            }
                        })
                        .offset(y: nameIsEmpty ? -20 : 150)
                    }
                }
                .padding(.bottom, nameIsEmpty ? 0 : 15)
                .padding(.horizontal, 15)
            }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.vertical)
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            if !name.isEmpty{
                                addItem()
                            }else{
                                nameError()
                            }
                        }){
                            Text("Save")
                                .foregroundColor(Color(K.Colors.mainColor))
                        }
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
        }
        .modifier(DismissingKeyboard())
//        .background(Color(K.Colors.background))
        .sheet(isPresented: $shouldShowImagePicker) {
            ImagePicker(image: $image)
        }
    }
        
        func nameError(){
            withAnimation{
                nameIsEmpty = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
                withAnimation{
                    nameIsEmpty = false
                }
                }
        }
        
        func addItem() {
//            let modifiedDate = Calendar.current.date(byAdding: .day, value: -1, to: birthDay)!
//
//            let descriptor = FetchDescriptor<ItemsTitle>()
//            let count = (try? modelContext.fetchCount(descriptor)) ?? 0
//            print(count)
//            withAnimation {
//                
//                    
//                    
//                    let newItem = Items(name: name, isLiked: false, isCheked: false, notes: notes, imageData: imageData, email: email, birthDay: birthDay >= modifiedDate ? nil : birthDay, title: title.name, phone: phoneNumber.count > 5 ? phoneNumber : "", orderIndex: count, isDone: false)
//                    title.items.append(newItem)
//
//
                    viewModel.handleSend(name: name, notes: notes, email: email, title: stageName, phone: phoneNumber, imageData: image, orderIndex: count, isCheked: false, isLiked: false, isDone: false, birthDay: birthDay)
//
////                    for (index, item) in filteredItems.enumerated() {
//                            item.orderIndex = index
////                        }
//                    notify.sendNotification(
//                        date: birthDay,
//                        type: "birthday",
//                        title: "B-day",
//                        body: "Today is \(name)'s birthday!",
//                        name: name
//                    )
//                    
//                    
                    email = ""
                    name = ""
                    notes = ""
                    phoneNumber = ""
                showAddPersonView = false
//            }
        }
}

//#Preview {
//    AddPersonView()
//}


//extension [Person] {
//    func updateOrderIndices() {
//        for (index, item) in enumerated() {
//            item.orderIndex = index
//        }
//    }
//}
