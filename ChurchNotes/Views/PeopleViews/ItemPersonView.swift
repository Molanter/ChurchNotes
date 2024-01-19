//
//  ItemPersonView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/6/23.
//

import SwiftUI

struct ItemPersonView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var published: PublishedVariebles

    @FocusState var focus: FocusedField?

    @State var item: Person
    @State var edit = false
    @State var name = ""
    @State var email = ""
    @State var phone = ""
    @State var notes = ""
    @State var shouldShowImagePicker = false
    @State var image: UIImage?
    @State var phoneError = false
    @State private var isShowingDeleteAlert = false
    @State private var editAlert = false
    @State private var anonymously = false

    @Binding var currentItem: Person?
    
    var body: some View {
        VStack{
            VStack{
                if edit{
                    editView
                }else{
                    profileView
                }
            }
            .edgesIgnoringSafeArea(.top)
        }
//        .alert("Save Changes?", isPresented: $editAlert) {
//            Button("No", role: .destructive) {
//                item.name = self.name
//                item.email = self.email
//                item.phone = self.phone
//                item.notes = self.notes
//            }
//            Button("Yes", role: .cancel) {
//                viewModel.editPerson(documentId: item.documentId, name: item.name, email: item.email, phone: item.phone, notes: item.notes, image: image)
//            }
//        } message: {
//            Text("Do you whant to save changes?")
//        }
        .modifier(DismissingKeyboard())
        .toolbar{
            ToolbarItem(placement: .topBarTrailing){
                Button(action: {
                    if edit == false{
                        self.edit = true
                        self.name = item.name
                        self.email = item.email
                        self.phone = item.phone
                        self.notes = item.notes
                    }else{
                        self.edit = false
                            if item.name == ""{
                                item.name = self.name
                            }
//                        if self.name != item.name || self.email != item.email || self.phone != item.phone || self.notes != item.notes{
//                            self.editAlert.toggle()
//                        }
                        viewModel.editPerson(documentId: item.documentId, name: item.name, email: item.email, phone: item.phone, notes: item.notes, image: image)
                    }
                    if let _ = image, item.imageData.isEmpty{
                        self.image = nil
                    }
                }){
                    Text(edit ? "done" : "edit")
                }
            }
        }
        .sheet(isPresented: $shouldShowImagePicker) {
            ImagePicker(image: $image)
                .onDisappear {
                    if let _ = image{
                        self.anonymously = false
                    }
                }
        }
    }
    
    var editView: some View{
        VStack{
            ZStack(alignment: .bottom){
                ZStack(alignment: .top){
                    Ellipse()
                        .foregroundColor(Color(K.Colors.mainColor))
                        .frame(width: 557.89917, height: 206.48558)
                        .cornerRadius(500)
                        .shadow( radius: 30)
                    Rectangle()
                        .foregroundColor(Color(K.Colors.mainColor))
                        .frame(width: 557.89917, height: 90)
                }
                VStack(alignment: .center){
                    Text(item.name == "" ? "name" : item.name)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .font(.title2)
                        .fontWeight(.medium)
                        .font(.system(size: 24))
                    if edit{
                        Button(action: {
                            self.shouldShowImagePicker.toggle()
                        }){
                            Text("tap-to-change-image")
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .font(.callout)
                                .fontWeight(.light)
                                .padding(.bottom)
                        }
                    }else{
                        if item.email != ""{
                            Text(item.email.lowercased())
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .font(.callout)
                                .fontWeight(.light)
                                .padding(.bottom)
                        }else{
                            if item.birthDay != item.timestamp{
                                HStack(spacing: 1){
                                    Text(item.birthDay, format: .dateTime.month(.wide))
                                    Text(item.birthDay, format: .dateTime.day())
                                    Text(", \(item.birthDay, format: .dateTime.year()), ")
                                    Text(item.birthDay, style: .time)
                                }
                                .multilineTextAlignment(.center)
                                .font(.callout)
                                .fontWeight(.light)
                                .foregroundColor(.white)
                                .foregroundStyle(.secondary)
                                .font(.system(size: 15))
                                .padding(.bottom)
                            }
                        }
                    }
                    ZStack(alignment: .center){
                        Circle()
                            .fill(Color(K.Colors.blackAndWhite))
                            .frame(width: 80, height: 80)
                        Button(action: {
                            self.shouldShowImagePicker.toggle()
                        }){
                            if item.imageData != ""{
                                if let img = image{
                                    Image(uiImage: img)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 80, height: 80)
                                        .cornerRadius(40)
                                        .overlay(
                                            Circle().stroke(.white, lineWidth: 2)
                                        )
                                        .background(Color(K.Colors.blackAndWhite))
                                        .cornerRadius(.infinity)
                                }else{
                                    AsyncImage(url: URL(string: item.imageData)){image in
                                        image.resizable()
                                        
                                    }placeholder: {
                                        ProgressView()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 80, height: 80)
                                    }
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(40)
                                    .overlay(
                                        Circle().stroke(.white, lineWidth: 2)
                                    )
                                    .background(Color(K.Colors.blackAndWhite))
                                    .cornerRadius(.infinity)
                                }
                            }else if let img = image{
                                Image(uiImage: img)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(40)
                                    .overlay(
                                        Circle().stroke(.white, lineWidth: 2)
                                    )
                                    .background(Color(K.Colors.blackAndWhite))
                                    .cornerRadius(.infinity)
                            }else{
                                ZStack(alignment: .center){
                                    Circle()
                                        .foregroundColor(Color(K.Colors.darkGray))
                                        .frame(width: 80, height: 80)
                                    Text(viewModel.twoNames(name: item.name))
                                        .font(.system(size: 35))
                                        .textCase(.uppercase)
                                        .foregroundColor(Color.white)
                                }
                                .overlay(
                                    Circle().stroke(.white, lineWidth: 2)
                                )
                            }
                        }
                    }
                }
                .offset(y: 35)
            }
            .padding(.bottom, 50)
            ScrollView{
                VStack(alignment: .leading, spacing: 15){
                    HStack(spacing: 20){
                        ZStack{
                            Circle()
                                .foregroundStyle(Color(K.Colors.gray).opacity(0.5))
                                .frame(width: 40, height: 40)
                            Image(systemName: "person")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20)
                                .foregroundStyle(Color(K.Colors.mainColor))
                                .fontWeight(.light)
                        }
                        HStack{
                            TextField(item.name.isEmpty ? "name" : item.name, text: $item.name)
                                .focused($focus, equals: .name)
                                .textInputAutocapitalization(.words)
                                .autocorrectionDisabled(true)
                                .font(.title3)
                                .fontWeight(.light)
                                .font(.system(size: 20))
                                .padding(10)
                        }
                        .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.06), radius: 4, x: 0, y: 4)
                        .overlay(
                            RoundedRectangle(cornerSize: .init(width: 7, height: 7))
                                .stroke(Color(K.Colors.justLightGray).opacity(0.5), lineWidth: 1)
                        )
                    }
                    Divider()
                    HStack(spacing: 20){
                        ZStack{
                            Circle()
                                .foregroundStyle(Color(K.Colors.gray).opacity(0.5))
                                .frame(width: 40, height: 40)
                            Image(systemName: "envelope")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20)
                                .foregroundStyle(Color(K.Colors.mainColor))
                                .fontWeight(.light)
                        }
                        HStack{
                            TextField(item.email.isEmpty ? "eemail" : item.email, text: $item.email)
                                .focused($focus, equals: .email)
                                .textCase(.lowercase)
                                .font(.title3)
                                .fontWeight(.light)
                                .font(.system(size: 20))
                                .padding(10)
                                .keyboardType(.emailAddress)
                                .textContentType(.emailAddress)
                        }
                        .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.06), radius: 4, x: 0, y: 4)
                        .overlay(
                            RoundedRectangle(cornerSize: .init(width: 7, height: 7))
                                .stroke(Color(K.Colors.justLightGray).opacity(0.5), lineWidth: 1)
                        )
                    }
                    Divider()
                    HStack(spacing: 20){
                        ZStack{
                            Circle()
                                .foregroundStyle(Color(K.Colors.gray).opacity(0.5))
                                .frame(width: 40, height: 40)
                            Image(systemName: "phone")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20)
                                .foregroundStyle(Color(K.Colors.mainColor))
                                .fontWeight(.light)
                        }
                        HStack(alignment: .center, spacing: 0.0){
                            TextField("pphone", text: $item.phone)
                                .focused($focus, equals: .phone)
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                                .padding(10)
                                .textContentType(.telephoneNumber)
                                .keyboardType(.numberPad)
                        }
                        .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.06), radius: 4, x: 0, y: 4)
                        .overlay(
                            RoundedRectangle(cornerSize: .init(width: 7, height: 7))
                                .stroke(Color(K.Colors.justLightGray).opacity(0.5), lineWidth: 1)
                        )
                    }
                    Divider()
                    HStack(spacing: 20){
                        ZStack{
                            Circle()
                                .foregroundStyle(Color(K.Colors.gray).opacity(0.5))
                                .frame(width: 40, height: 40)
                            Image(systemName: "square.and.pencil")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20)
                                .foregroundStyle(Color(K.Colors.mainColor))
                                .fontWeight(.light)
                        }
                        HStack{
                            TextField(item.notes.isEmpty ? "notes" : item.notes, text: $item.notes, axis: .vertical)
                                .focused($focus, equals: .notes)
                                .font(.title3)
                                .fontWeight(.light)
                                .font(.system(size: 20))
                                .padding(10)
                        }
                        .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.06), radius: 4, x: 0, y: 4)
                        .overlay(
                            RoundedRectangle(cornerSize: .init(width: 7, height: 7))
                                .stroke(Color(K.Colors.justLightGray).opacity(0.5), lineWidth: 1)
                        )
                    }
                    Divider()
                    if item.imageData != ""{
                        HStack(spacing: 20){
                            ZStack{
                                Circle()
                                    .foregroundStyle(Color(K.Colors.gray).opacity(0.5))
                                    .frame(width: 40, height: 40)
                                Image(systemName: "person.crop.circle.badge.xmark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30)
                                    .offset(x: -2, y: 1)
                                    .foregroundStyle(Color(K.Colors.mainColor))
                                    .fontWeight(.light)
                            }
                            HStack{
                                Image(systemName: anonymously ? "checkmark.square.fill" : "square")
                                    .contentTransition(.symbolEffect(.replace))
                                    .onTapGesture {
                                        self.anonymously.toggle()
                                    }
                                Text("rremove-iimage")
                                    .foregroundColor(Color(K.Colors.text))
                                    .multilineTextAlignment(.center)
                                    .font(.system(size: 20))
                                    .fontWeight(.light)
                                    .padding(.vertical)
                            }
                        }
                        Divider()
                    }
                    HStack(spacing: 20){
                        ZStack(alignment: .center){
                            Button(action: {
                                self.isShowingDeleteAlert.toggle()
                            }){
                                Text("delete")
                                    .foregroundStyle(Color.white)
                                    .padding()
                            }
                            .frame(maxWidth: .infinity)
                            .background(Color(K.Colors.red).opacity(0.65))
                            .cornerRadius(7)
                        }
                        Button(action: {
                            if item.name == ""{
                                item.name = self.name
                            }
                            viewModel.editPerson(documentId: item.documentId, name: item.name, email: item.email, phone: item.phone, notes: item.notes, image: image)
                            if item.imageData != "", self.anonymously{
                                viewModel.deleteImageFromPerson(item.documentId)
                                item.imageData = ""
                                image = nil
                            }
                            self.edit.toggle()
                        }){
                            Text("Save")
                                .foregroundStyle(Color.white)
                                .padding()
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color(K.Colors.mainColor))
                        .cornerRadius(7)
                    }
                    .frame(maxWidth: .infinity)
                    Spacer()
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
                                focus = nil
                            default:
                                break
                            }
                        }
            }
            .onAppear {
                UIScrollView.appearance().showsVerticalScrollIndicator = false
                UIScrollView.appearance().showsHorizontalScrollIndicator = false
            }
            .padding(.horizontal, 15)
            .frame(maxHeight: .infinity)
            Spacer()
            
        }
        .alert("delete-person", isPresented: $isShowingDeleteAlert) {
            Button("cancel", role: .cancel) {}
            Button("delete", role: .destructive) {
                viewModel.deletePerson(documentId: item.documentId)
                isShowingDeleteAlert = false
            }
        } message: {
            Text("do-you-really-want-to-delete-this-person")
        }
    }
    
    var profileView: some View{
        ZStack(alignment: .bottom){
            VStack{
                ZStack(alignment: .bottom){
                    ZStack(alignment: .top){
                        Ellipse()
                            .foregroundColor(Color(K.Colors.mainColor))
                            .frame(width: 557.89917, height: 206.48558)
                            .cornerRadius(500)
                            .shadow( radius: 30)
                        Rectangle()
                            .foregroundColor(Color(K.Colors.mainColor))
                            .frame(width: 557.89917, height: 90)
                    }
                    VStack(alignment: .center){
                        Text(item.name)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .font(.title2)
                            .fontWeight(.medium)
                            .font(.system(size: 24))
                        if item.email != ""{
                            Text(item.email)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .font(.callout)
                                .fontWeight(.light)
                                .padding(.bottom)
                        }else{
                            HStack(spacing: 1){
                                Text(item.timestamp, format: .dateTime.month(.wide))
                                Text(item.timestamp, format: .dateTime.day())
                                Text(", \(item.timestamp, format: .dateTime.year()), ")
                                Text(item.timestamp, style: .time)
                            }
                            .multilineTextAlignment(.center)
                            .font(.callout)
                            .fontWeight(.light)
                            .foregroundColor(.white)
                            .foregroundStyle(.secondary)
                            .font(.system(size: 15))
                            .padding(.bottom)
                        }
                        ZStack(alignment: .center){
                            Circle()
                                .fill(Color(K.Colors.blackAndWhite))
                                .frame(width: 80, height: 80)
                            if item.imageData != "", !self.anonymously{
                                if let img = image{
                                    Image(uiImage: img)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 80, height: 80)
                                        .cornerRadius(40)
                                        .overlay(
                                            Circle().stroke(.white, lineWidth: 2)
                                        )
                                }else{
                                    AsyncImage(url: URL(string: item.imageData)){image in
                                        image.resizable()
                                        
                                    }placeholder: {
                                        ProgressView()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 80, height: 80)
                                    }
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(40)
                                    .overlay(
                                        Circle().stroke(.white, lineWidth: 2)
                                    )
                                }
                            }else if let img = image, !self.anonymously{
                                Image(uiImage: img)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(40)
                                    .overlay(
                                        Circle().stroke(.white, lineWidth: 2)
                                    )
                                    .background(Color(K.Colors.blackAndWhite))
                                    .cornerRadius(.infinity)
                            }else{
                                ZStack(alignment: .center){
                                    Circle()
                                        .foregroundColor(Color(K.Colors.darkGray))
                                        .frame(width: 80, height: 80)
                                    Text(String(item.name.components(separatedBy: " ").compactMap { $0.first }).count >= 3 ? String(String(item.name.components(separatedBy: " ").compactMap { $0.first }).prefix(2)) : String(item.name.components(separatedBy: " ").compactMap { $0.first }))
                                        .font(.system(size: 35))
                                        .textCase(.uppercase)
                                        .foregroundColor(Color.white)
                                }
                                .overlay(
                                    Circle().stroke(.white, lineWidth: 2)
                                )
                            }
                        }
                        
                        
                    }
                    .offset(y: 35)
                }
                ScrollView{
                    VStack(alignment: .leading){
                        VStack(alignment: .leading, spacing: 15){
                            HStack(spacing: 20){
                                ZStack{
                                    Circle()
                                        .foregroundStyle(Color(K.Colors.gray).opacity(0.5))
                                        .frame(width: 40, height: 40)
                                    Image(systemName: "person")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20)
                                        .foregroundStyle(Color(K.Colors.mainColor))
                                        .fontWeight(.light)
                                }
                                Text(item.name.isEmpty ? "name" : item.name)
                                    .font(.title3)
                                    .fontWeight(.light)
                                    .font(.system(size: 20))
                            }
                            .padding(.top, 50)
                            Divider()
                            if item.email != ""{
                                VStack(alignment: .leading, spacing: 15){
                                    HStack(spacing: 20){
                                        ZStack{
                                            Circle()
                                                .foregroundStyle(Color(K.Colors.gray).opacity(0.5))
                                                .frame(width: 40, height: 40)
                                            Image(systemName: "envelope")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 20)
                                                .foregroundStyle(Color(K.Colors.mainColor))
                                                .fontWeight(.light)
                                        }
                                        Text(item.email)
                                            .font(.title3)
                                            .fontWeight(.light)
                                            .font(.system(size: 20))
                                    }
                                    Divider()
                                    
                                }
                            }
                            if item.phone != ""{
                                HStack(spacing: 20){
                                    ZStack{
                                        Circle()
                                            .foregroundStyle(Color(K.Colors.gray).opacity(0.5))
                                            .frame(width: 40, height: 40)
                                        Image(systemName: "phone")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20)
                                            .foregroundStyle(Color(K.Colors.mainColor))
                                            .fontWeight(.light)
                                    }
                                    HStack(alignment: .center, spacing: 0.0){
                                        Text(item.phone)
                                            .font(.title3)
                                            .fontWeight(.light)
                                            .font(.system(size: 18))
                                    }
                                    .frame(height: 45)
                                }
                                Divider()
                            }
                            VStack(alignment: .leading, spacing: 15){
                                HStack(spacing: 18){
                                    ZStack{
                                        Circle()
                                            .foregroundStyle(Color(K.Colors.gray).opacity(0.5))
                                            .frame(width: 40, height: 40)
                                        Image(systemName: "folder")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20)
                                            .foregroundStyle(Color(K.Colors.mainColor))
                                            .fontWeight(.light)
                                    }
                                    Text(item.title)
                                        .font(.title3)
                                        .fontWeight(.light)
                                        .font(.system(size: 18))
                                }
                                Divider()
                            }
                            if item.birthDay != item.timestamp{
                                HStack(spacing: 20){
                                    ZStack{
                                        Circle()
                                            .foregroundStyle(Color(K.Colors.gray).opacity(0.5))
                                            .frame(width: 40, height: 40)
                                        Image(systemName: "gift")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20)
                                            .foregroundStyle(Color(K.Colors.mainColor))
                                            .fontWeight(.light)
                                    }
                                    HStack(spacing: 1){
                                        Text(item.birthDay, format: .dateTime.month(.twoDigits))
                                        Text("/\(item.birthDay, format: .dateTime.day())/")
                                        Text(item.birthDay, format: .dateTime.year())
                                    }
                                    .font(.title3)
                                    .fontWeight(.light)
                                    .font(.system(size: 18))
                                }
                                Divider()
                            }
                            if item.notes != ""{
                                VStack(alignment: .leading, spacing: 15){
                                    HStack(spacing: 18){
                                        ZStack{
                                            Circle()
                                                .foregroundStyle(Color(K.Colors.gray).opacity(0.5))
                                                .frame(width: 40, height: 40)
                                            Image(systemName: "square.and.pencil")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 20)
                                                .foregroundStyle(Color(K.Colors.mainColor))
                                                .fontWeight(.light)
                                        }
                                        Text(item.notes)
                                            .multilineTextAlignment(.leading)
                                            .lineLimit(10)
                                            .font(.title3)
                                            .fontWeight(.light)
                                            .font(.system(size: 18))
                                    }
                                    Divider()
                                }
                            }
                            VStack(alignment: .leading, spacing: 15){
                                HStack(spacing: 20){
                                    ZStack{
                                        Circle()
                                            .foregroundStyle(Color(K.Colors.gray).opacity(0.5))
                                            .frame(width: 40, height: 40)
                                        Image(systemName: "person.badge.clock")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 25)
                                            .foregroundStyle(Color(K.Colors.mainColor))
                                            .fontWeight(.light)
                                            .offset(x: 2)
                                    }
                                    HStack(spacing: 1){
                                        Text(item.timestamp, format: .dateTime.month(.twoDigits))
                                        Text("/\(item.timestamp, format: .dateTime.day())/")
                                        Text(item.timestamp, format: .dateTime.year())
                                    }
                                    .font(.title3)
                                    .fontWeight(.light)
                                    .font(.system(size: 18))
                                }
                                Divider()
                            }
                            Spacer()
                        }
                        if !item.phone.isEmpty{
                            NavigationLink{
                                GeometryReader{ proxy in
                                    let size = proxy
                                    CameraView(recipients: [item.phone], message: "", size: size, item: item)
                                }
                            } label:{
                                HStack(spacing: 20){
                                    ZStack{
                                        Circle()
                                            .foregroundStyle(Color(K.Colors.gray).opacity(0.5))
                                            .frame(width: 40, height: 40)
                                        Image(systemName: "video.badge.plus")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 30)
                                            .foregroundStyle(Color(K.Colors.mainColor))
                                            .fontWeight(.light)
                                    }
                                    HStack(spacing: 0.0){
                                        Text("record-video-for \(Text(item.name.capitalized).bold())")
                                            .foregroundStyle(Color("text-appearance"))
                                            .font(.title3)
                                            .fontWeight(.light)
                                            .font(.system(size: 18))
                                            .lineLimit(3)
                                            .multilineTextAlignment(.leading)
                                    }
                                }
                            }
                        }else{
                            Button{
                                phoneIsEmpty()
                            } label:{
                                HStack(spacing: 20){
                                    ZStack{
                                        Circle()
                                            .foregroundStyle(Color(K.Colors.gray).opacity(0.5))
                                            .frame(width: 40, height: 40)
                                        Image(systemName: "video.badge.plus")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 30)
                                            .foregroundStyle(Color(K.Colors.mainColor))
                                            .fontWeight(.light)
                                    }
                                    HStack(spacing: 0.0){
                                        Text("record-video-for \(Text(item.name.capitalized).bold())")
                                            .foregroundStyle(K.Colors.appearance >= 1 ? (K.Colors.appearance == 2 ? Color.black : Color.white) : Color("text-appearance"))
                                            .font(.title3)
                                            .fontWeight(.light)
                                            .font(.system(size: 18))
                                            .lineLimit(3)
                                            .multilineTextAlignment(.leading)
                                    }
                                }
                            }
                        }
                        Divider()
                    }
                    VStack(alignment: .leading, spacing: 5){
                        if !K.AppStages.stagesArray.filter({$0.name.contains(item.title)}).isEmpty && !item.isDone{
                            Text("control-stages")
                                .foregroundStyle(.secondary)
                                .font(.body)
                                .padding(.vertical, 10)
                        }
                        HStack(alignment: .center, spacing: 20){
                            if item.title != "New Friend" && item.isDone == false && !K.AppStages.stagesArray.filter({$0.name.contains(item.title)}).isEmpty{
                                    Button(action: {
                                        self.previousStage()
                                    }){
                                        HStack(alignment: .center){
                                            Image(systemName: "arrowshape.turn.up.left.fill")
                                                .foregroundStyle(Color(K.Colors.mainColor))
                                            Text("previous")
                                                .font(.system(size: 20))
                                                .foregroundStyle(Color(K.Colors.mainColor))
                                                .padding()
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .cornerRadius(7)
                                    .overlay(
                                        RoundedRectangle(cornerSize: .init(width: 7, height: 7))
                                            .stroke(Color(K.Colors.mainColor), lineWidth: 2)
                                    )
                                }
                            if item.isDone == false && !K.AppStages.stagesArray.filter({$0.name.contains(item.title)}).isEmpty{
                                Button(action: {
                                    if item.title != "Joined Group"{
                                        self.nextStage()
                                    }else{
                                        viewModel.isDonePerson(documentId: item.documentId, isDone: true)
                                        self.viewModel.addAchiv(name: "done", int: (viewModel.currentUser?.done ?? 0) + 1)
                                        if let user = viewModel.currentUser{
                                            if user.done == 0{
                                                viewModel.addBadge(name: "dDone")
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                    self.published.currentBadge = K.Badges().dDone
                                                }
                                                viewModel.getFcmByEmail(email: user.email, messageText: "You received a new badge 'Done'", subtitle: "Congratulations", title: "New Badge", imageURL: "", link: "", badgeCount: 5)
                                            }else if user.done == 4{
                                                viewModel.addBadge(name: "dCongrats")
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                    self.published.currentBadge = K.Badges().dCongrats
                                                }
                                                viewModel.getFcmByEmail(email: user.email, messageText: "You received a new badge 'Congrats'", subtitle: "Congratulations", title: "New Badge", imageURL: "", link: "", badgeCount: 5)

                                            }else if user.done == 14{
                                                viewModel.addBadge(name: "ddone")
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                    self.published.currentBadge = K.Badges().ddone
                                                }
                                                viewModel.getFcmByEmail(email: user.email, messageText: "You received a new badge 'done'", subtitle: "Congratulations", title: "New Badge", imageURL: "", link: "", badgeCount: 5)

                                            }
                                        }
                                        self.currentItem = nil
                                    }
                                }){
                                    HStack(alignment: .center){
                                        Text(item.title == "Joined Group" ? "ffinish" : "nnext")
                                            .font(.system(size: 20))
                                            .foregroundStyle(Color(K.Colors.mainColor))
                                            .padding()
                                        Image(systemName: item.title == "Joined Group" ? "person.fill.checkmark" : "arrowshape.turn.up.right.fill")
                                            .foregroundStyle(Color(K.Colors.mainColor))
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .cornerRadius(7)
                                .overlay(
                                    RoundedRectangle(cornerSize: .init(width: 7, height: 7))
                                        .stroke(Color(K.Colors.mainColor), lineWidth: 2)
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 5)
                    .frame(maxWidth: .infinity)
                    Spacer()
                    
                }
                .onAppear {
                    UIScrollView.appearance().showsVerticalScrollIndicator = false
                    UIScrollView.appearance().showsHorizontalScrollIndicator = false
                }
                .padding(.horizontal, 15)
                .frame(maxHeight: .infinity)
                Spacer()
            }
            .alert("phone-number-is-empty", isPresented: $phoneError) {
                Button("cancel", role: .cancel) {}
                Button(action: {
                    if edit == false{
                        self.edit = true
                        self.name = item.name
                        self.email = item.email
                        self.phone = item.phone
                        self.notes = item.notes
                    }else{
                        self.edit = false
//                        self.editAlert.toggle()
                        viewModel.editPerson(documentId: item.documentId, name: item.name, email: item.email, phone: item.phone, notes: item.notes, image: image)
                    }
                }) {
                    Text("add-number")
                }
                
            }message: {
                Text("add-person-phone-number-for-recording-video")
            }
        }
    }
    
    private func phoneIsEmpty(){
        withAnimation{
            self.phoneError.toggle()
        }
    }
    
    private func nextStage(){
        let num = viewModel.currentUser?.next ?? 0
        self.viewModel.addAchiv(name: "next", int: num + 1)
        print(num + 0)
        viewModel.nextStage(documentId: item.documentId, titleNumber: item.titleNumber)
        if let user = viewModel.currentUser{
            if user.next == 4{
                viewModel.addBadge(name: "nNext")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.published.currentBadge = K.Badges().nNext
                }
                viewModel.getFcmByEmail(email: user.email, messageText: "You received a new badge 'Next'", subtitle: "Congratulations", title: "New Badge", imageURL: "", link: "", badgeCount: 5)
            }else if user.next == 19{
                viewModel.addBadge(name: "nGoing")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.published.currentBadge = K.Badges().nGoing
                }
                viewModel.getFcmByEmail(email: user.email, messageText: "You received a new badge 'Going'", subtitle: "Congratulations", title: "New Badge", imageURL: "", link: "", badgeCount: 5)
            }else if user.next == 49{
                viewModel.addBadge(name: "nnext")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.published.currentBadge = K.Badges().nnext
                }
                viewModel.getFcmByEmail(email: user.email, messageText: "You received a new badge 'next'", subtitle: "Congratulations", title: "New Badge", imageURL: "", link: "", badgeCount: 5)
            }
        }
        self.currentItem = nil
    }
    
    private func previousStage(){
        let num = viewModel.currentUser?.next ?? 0
        self.viewModel.addAchiv(name: "next", int: num != 0 ? num - 1 : 0)
        print(num + 0)
        viewModel.previousStage(documentId: item.documentId, titleNumber: item.titleNumber)
        self.currentItem = nil
    }

    
    enum FocusedField:Hashable{
            case name,email,phone,notes,birthday
        }
}


