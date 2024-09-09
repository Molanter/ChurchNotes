//
//  AddPersonView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 8/18/23.
//

import SwiftUI
import Contacts
import SwiftData
import iPhoneNumberField

struct AddPersonView: View {
    @Binding var showAddPersonView: Bool
    
    @ObservedObject private var keyboard = KeyboardResponder()
    
    @EnvironmentObject var published: PublishedVariebles
    @EnvironmentObject var viewModel: AppViewModel
    
    @Query var strings: [StringDataModel]

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
    @State private var showAddFromContacts = false
    
    var createName: String?
    let notify = ReminderHandler()
    var offset: Int
    var stageName: String
    var titleNumber: Int
    var count: Int
    
    var backgroundType: String {
        if let strModel = strings.first(where: { $0.name == "backgroundType" }) {
            return strModel.string
        }else {
            return "none"
        }
    }
    
    var body: some View {
//        NavigationView{
            List{
                Section(header:
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
                                    Circle().stroke(K.Colors.mainColor, lineWidth: 2)
                                )
                                .padding(15)
                            
                        }else{
                            Image(systemName: "person.fill.viewfinder")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(K.Colors.mainColor)
                                .padding(15)
                            
                            
                        }
                        Text("tap-to-change-image")
                            .foregroundStyle(.secondary)
                            .foregroundStyle(K.Colors.mainColor)
                    }
                    .padding(15)
                }
                    .textCase(nil)
                    .listRowInsets(EdgeInsets())
                    .frame(maxWidth: .infinity)
                ){
                    
                }
                .listRowBackground(
                    GlassListRow()
                )
                Label("add-from-contacts", systemImage: "person.crop.circle.badge.plus")
                    .listRowBackground(
                        GlassListRow()
                    )
                    .foregroundStyle(K.Colors.mainColor)
                    .onTapGesture {
                        requestContactsAccess { granted in
                            if granted {
                                self.showAddFromContacts.toggle()
                            }
                        }
                        print("Add from contacts pressed")
                    }
                    .navigationDestination(isPresented: $showAddFromContacts) {
                        ContactsListView()
                            .onAppear{
                                published.contactToAdd = nil
                            }
                            .onDisappear{
                                if let contact = published.contactToAdd{
                                    name = ""
                                    phoneNumber = ""
                                    email = ""
                                    image = nil
                                    name = "\(contact.givenName) \(contact.familyName)"
                                    if let number = contact.phoneNumbers.first(where: { $0.label == CNLabelPhoneNumberMobile }){
                                        phoneNumber = number.value.stringValue
                                    }else if let number = contact.phoneNumbers.first{
                                        phoneNumber = number.value.stringValue
                                    }
                                    if let email = contact.emailAddresses.first{
                                        self.email = email.value.lowercased
                                    }
                                    if contact.imageDataAvailable{
                                        if let imageData = contact.imageData, let uiImage = UIImage(data: imageData) {
                                            image = uiImage
                                        }
                                    }
                                }
                            }
                    }
                Section{
                    HStack{
                        TextField("name", text: $name, axis: .horizontal)
                            .lineLimit(1)
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.words)
                            .keyboardType(.default)
                            .textSelection(.enabled)
                            .focused($focus, equals: .name)
                        Spacer()
                        Image(systemName: "person")
                    }
                }header: {
                    Text("write-person-name")
                }footer: {
                    Text(name.isEmpty ? "rrequired" : "")
                }
                .listRowBackground(
                    GlassListRow()
                )
                Section(header: Text("eemail")){
                    HStack{
                        TextField("eemail", text: $email)
                            .offset(y: -keyboard.keyboardHeight / 2)
                            .focused($focus, equals: .email)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .textSelection(.enabled)
                        Spacer()
                        Image(systemName: "envelope")
                    }
                }
                .listRowBackground(
                    GlassListRow()
                )
                Section(header: Text("pphone")){
                    HStack{
                        iPhoneNumberField(String(localized: "pphone"), text: $phoneNumber)
                            .flagHidden(false)
                            .flagSelectable(true)
                            .maximumDigits(10)
                            .prefixHidden(false)
                            .ignoresSafeArea(.keyboard, edges: .bottom)
                            .focused($focus, equals: .phone)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(false)
                            .textContentType(.telephoneNumber)
                            .keyboardType(.numberPad)
                            .textSelection(.enabled)
                        Spacer()
                        Image(systemName: "phone")
                    }
                }
                .listRowBackground(
                    GlassListRow()
                )
                Section(header: Text("notes")){
                    HStack{
                        TextField("notes", text: $notes, axis: .vertical)
                            .offset(y: -keyboard.keyboardHeight / 2)
                            .focused($focus, equals: .notes)
                            .lineLimit(5)
                            .disableAutocorrection(false)
                            .textInputAutocapitalization(.sentences)
                            .keyboardType(.default)
                            .textSelection(.enabled)
                        Spacer()
                        Image(systemName: "list.bullet")
                    }
                }
                .listRowBackground(
                    GlassListRow()
                )
//                Section(header: Text("bbirthday")){
//                    DatePicker(
//                        String(localized: "long-press"),
//                        selection: $birthDay,
//                        displayedComponents: [.date]
//                    )
//                    .datePickerStyle(.compact)
//                    .padding(.vertical, 1)
//                }
//                .listRowBackground(
//                    GlassListRow()
//                )
                Section{
                        Text("add")
                            .foregroundColor(Color.white)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(K.Colors.mainColor)
                            .cornerRadius(10)
                    .listRowInsets(EdgeInsets())
                    .onTapGesture {
                        if viewModel.peopleArray.count < 20 && !name.isEmpty{
                            addItem()
                        }else if viewModel.peopleArray.count >= 20{
                            showError(false)
                        }else if name.isEmpty && viewModel.peopleArray.count < 20{
                            showError()
                        }
                    }
                }
                .listRowBackground(
                    GlassListRow()
                )
            }
            .scrollContentBackground(backgroundType == "none" ? .visible : .hidden)
            .background {
                ListBackground()
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
            .modifier(DismissingKeyboard())
            .sheet(isPresented: $shouldShowImagePicker) {
                ImagePicker(image: $image)
            }
            .onAppear {
                if let newName = createName{
                    self.name = newName
                    self.focus = .name
                }
            }
            .onDisappear {
                self.published.createPersonName = ""
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
                            .foregroundColor(K.Colors.mainColor)
                    }
                }
            }
            .accentColor(K.Colors.mainColor)
            .edgesIgnoringSafeArea(.bottom)
    }
    
    func showError(_ name: Bool = true){
        if name{
            Toast.shared.present(
                title: String(localized: "name-is-empty"),
                symbol: "questionmark.square",
                isUserInteractionEnabled: true,
                timing: .long
            )
        }else{
            Toast.shared.present(
                title: String(localized: "people-limit-reached"),
                symbol: "person.3.sequence",
                isUserInteractionEnabled: true,
                timing: .long
            )
        }
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
    
    func requestContactsAccess(completion: @escaping (Bool) -> Void) {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { granted, error in
            completion(granted)
        }
    }
}

//#Preview {
//    AddPersonView()
//}
