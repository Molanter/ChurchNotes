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
    
    @FocusState var focus: FocusedField?
    
    @State var shouldShowImagePicker = false
    @State var name: String = ""
    @State var email: String = ""
    @State var phoneNumber: String = ""
    @State var notes: String = ""
    @State var birthDay: Date = Date.now
    @State var timestamp: Date = Date.now
    @State var image: UIImage?
    @State private var nameIsEmpty = false
    let notify = NotificationHandler()
    var offset: Int
    var stageName: String
    var titleNumber: Int
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
                            VStack(alignment: .leading){
                                HStack{
                                    Text("Write Person Name")
                                        .font(.title2)
                                        .fontWeight(.medium)
                                    Text("*")
                                        .font(.title2)
                                        .foregroundStyle(Color(K.Colors.red))
                                        .fontWeight(.medium)
                                }
                                HStack{
                                    TextField("Name", text: $name)
                                        .focused($focus, equals: .name)
                                        .textContentType(.name)
                                        }
                                .padding(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5.0).stroke(Color(K.Colors.gray), lineWidth: 1)
                                )
                            }
                            VStack(alignment: .leading){
                                    Text("Email")
                                        .font(.title2)
                                        .fontWeight(.medium)
                                HStack{
                                    TextField("Email", text: $email)
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
                                    Text("Phone")
                                        .font(.title2)
                                        .fontWeight(.medium)
                                HStack(alignment: .center, spacing: 0.0){
                                    TextField("Phone", text: $phoneNumber)
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
                                    Text("Notes")
                                        .font(.title2)
                                        .fontWeight(.medium)
                                HStack{
                                    TextField("Notes", text: $notes)
                                        .focused($focus, equals: .notes)
                                        }
                                .padding(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5.0).stroke(Color(K.Colors.gray), lineWidth: 1)
                                )
                            }
                            VStack(alignment: .leading){
                                    Text("Birthday")
                                        .font(.title2)
                                        .fontWeight(.medium)
                                    DatePicker(
                                            "Birthday",
                                            selection: $birthDay,
                                            displayedComponents: [.date]
                                        )
                                    .focused($focus, equals: .birthday)
                                .padding(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5.0).stroke(Color(K.Colors.gray), lineWidth: 1)
                                )
                            }
                            .padding(.bottom, 75)
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
                                        if !name.isEmpty{
                                            addItem()
                                        }else{
                                            nameError()
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
//        .modifier(DismissingKeyboard())
//        .background(Color(K.Colors.background))
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
    }
        
        func nameError(){
            withAnimation{
                nameIsEmpty = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                withAnimation{
                    nameIsEmpty = false
                }
                }
        }
        
        func addItem() {
            viewModel.handleSend(name: name, notes: notes, email: email, title: stageName, phone: phoneNumber, imageData: image, orderIndex: count, isCheked: false, isLiked: false, isDone: false, birthDay: birthDay, timestamp: timestamp, titleNumber: titleNumber)
                    email = ""
                    name = ""
                    notes = ""
                    phoneNumber = ""
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
