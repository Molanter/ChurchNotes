//
//  AddPersonView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 8/18/23.
//

import SwiftUI

struct AddPersonView: View {
    @Binding var showAddPersonView: Bool
    
    @ObservedObject private var keyboard = KeyboardResponder()
    
    @EnvironmentObject var published: PublishedVariebles
    @EnvironmentObject var viewModel: AppViewModel
    
    @FocusState var focus: FocusedField?
    @State var shouldShowImagePicker = false
    @State var name: String = ""
    @State var email: String = ""
    @State var phoneNumber: String = ""
    @State var notes: String = ""
    @State var birthDay: Date = Date()
    @State var timestamp: Date = Date.now
    @State var image: UIImage?
    @State private var nameIsEmpty = false
    @State var errorText = ""
    
    var createName: String?
    let notify = NotificationHandler()
    var offset: Int
    var stageName: String
    var titleNumber: Int
    var count: Int
    
    
    var body: some View {
        NavigationView{
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
                                Text("tap-to-change-image")
                                    .foregroundStyle(.secondary)
                                    .foregroundStyle(Color(K.Colors.mainColor))
                            }
                            .padding(15)
                        }
                        VStack(alignment: .leading, spacing: 20){
                            VStack(alignment: .leading){
                                HStack{
                                    Text("write-person-name")
                                        .font(.title2)
                                        .fontWeight(.medium)
                                    Text("*")
                                        .font(.title2)
                                        .foregroundStyle(Color(K.Colors.red))
                                        .fontWeight(.medium)
                                }
                                HStack{
                                    TextField("name", text: $name)
                                        .offset(y: -keyboard.keyboardHeight / 2)
                                        .focused($focus, equals: .name)
                                        .textContentType(.name)
                                }
                                .padding(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5.0).stroke(Color(K.Colors.gray), lineWidth: 1)
                                )
                            }
                            VStack(alignment: .leading){
                                Text("eemail")
                                    .font(.title2)
                                    .fontWeight(.medium)
                                HStack{
                                    TextField("eemail", text: $email)
                                        .offset(y: -keyboard.keyboardHeight / 2)
                                        .focused($focus, equals: .email)
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
                            VStack(alignment: .leading){
                                Text("pphone")
                                    .font(.title2)
                                    .fontWeight(.medium)
                                HStack(alignment: .center, spacing: 0.0){
                                    TextField("pphone", text: $phoneNumber)
                                        .offset(y: -keyboard.keyboardHeight / 2)
                                        .focused($focus, equals: .phone)
                                        .textInputAutocapitalization(.never)
                                        .disableAutocorrection(true)
                                        .textContentType(.telephoneNumber)
                                        .keyboardType(.numberPad)
                                }
                                .padding(10)
                                .overlay(
                                    RoundedRectangle(cornerSize: .init(width: 7, height: 7))
                                        .stroke(Color(K.Colors.gray), lineWidth: 1)
                                )
                            }
                            VStack(alignment: .leading){
                                Text("notes")
                                    .font(.title2)
                                    .fontWeight(.medium)
                                HStack{
                                    TextField("notes", text: $notes)
                                        .offset(y: -keyboard.keyboardHeight / 2)
                                        .focused($focus, equals: .notes)
                                }
                                .padding(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5.0).stroke(Color(K.Colors.gray), lineWidth: 1)
                                )
                            }
                            VStack(alignment: .leading){
                                HStack{
                                    Text("bbirthday")
                                        .font(.title2)
                                        .fontWeight(.medium)
                                    //                                    Spacer()
                                    //                                    Text("long-press")
                                    //                                        .foregroundStyle(.secondary)
                                }
                                HStack{
                                    DatePicker(
                                        String(localized: "long-press"),
                                        selection: $birthDay,
                                        displayedComponents: [.date]
                                    )
                                    .datePickerStyle(.compact)
                                    .foregroundStyle(Color.secondary)
                                }
                                .padding(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5.0).stroke(Color(K.Colors.gray), lineWidth: 1)
                                )
                            }
                            .padding(.bottom, 50)
                            Button(action: {
                                if viewModel.peopleArray.count < 20 && !name.isEmpty{
                                    addItem()
                                }else if viewModel.peopleArray.count > 20{
                                    showError(false)
                                }else if name.isEmpty && viewModel.peopleArray.count < 20{
                                    showError()
                                }
                            }){
                                Text("add")
                                    .foregroundColor(Color.white)
                                    .padding(.vertical, 10)
                                    .frame(maxWidth: .infinity)
                                    .background(Color(K.Colors.mainColor))
                                    .cornerRadius(7)
                            }
                        }
                        .onSubmit {
                            switch focus {
                            case .name:
                                focus = .email
                            case .email:
                                focus = .phone
                            case .phone:
                                focus = .notes
                            case .notes:
                                focus = .birthday
                            case .birthday:
                                if viewModel.peopleArray.count < 20 && !name.isEmpty{
                                    addItem()
                                }else if viewModel.peopleArray.count > 20{
                                    showError(false)
                                }else if name.isEmpty && viewModel.peopleArray.count < 20{
                                    showError()
                                }
                            default:
                                break
                            }
                        }
                        .padding(15)
                    }
                    Spacer()
                }
                VStack(alignment: .center, spacing: 30){
                    
                    if nameIsEmpty{
                        HStack(alignment: .center){
                            Text(errorText)
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
            .modifier(DismissingKeyboard())
            .sheet(isPresented: $shouldShowImagePicker) {
                ImagePicker(image: $image)
            }
            //        .onAppear(perform: {
            //            if let countryCode = Locale.current.region?.identifier {
            //                phoneNumber = "+\(K.CountryCodes.countryPrefixes[countryCode] ?? "US")"
            //                let country = NSLocale.current.localizedString(forRegionCode: countryCode)
            //                let i = K.Countries.countryList.firstIndex(of: country!) ?? 0
            //            }
            //        })
            .onAppear {
                if let newName = createName{
                    self.name = newName
                    self.focus = .name
                }
            }
            .onDisappear {
                //                self.createName = nil
                self.published.createPersonName = ""
            }
        }
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    if viewModel.peopleArray.count < 20 && !name.isEmpty{
                        addItem()
                    }else if viewModel.peopleArray.count >= 20{
                        showError(false)
                    }else if name.isEmpty && viewModel.peopleArray.count < 20{
                        showError()
                    }
                }){
                    Text("add")
                        .foregroundColor(Color(K.Colors.mainColor))
                }
            }
        }
    }
    
    func showError(_ name: Bool = true){
        if name{
//            self.errorText = String(localized: "name-is-empty")
            Toast.shared.present(
                title: String(localized: "name-is-empty"),
                symbol: "questionmark.square",
                isUserInteractionEnabled: true,
                timing: .long
            )
        }else{
//            self.errorText = String(localized: "people-limit-reached")
            Toast.shared.present(
                title: String(localized: "people-limit-reached"),
                symbol: "person.3.sequence",
                isUserInteractionEnabled: true,
                timing: .long
            )
        }
//        withAnimation{
//            nameIsEmpty = true
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
//            withAnimation{
//                nameIsEmpty = false
//            }
//        }
    }
    
    func addItem() {
        viewModel.handleSend(name: name, notes: notes, email: email, title: stageName, phone: phoneNumber, imageData: image, orderIndex: count, isCheked: false, isLiked: false, isDone: false, birthDay: birthDay, timestamp: timestamp, titleNumber: titleNumber)
        email = ""
        name = ""
        notes = ""
        phoneNumber = ""
        Toast.shared.present(
            title: String(localized: "person-added"),
            symbol: "checkmark",
            isUserInteractionEnabled: true,
            timing: .long
            )
        showAddPersonView = false
    }
    
    enum FocusedField:Hashable{
        case name,email,phone,notes,birthday
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
