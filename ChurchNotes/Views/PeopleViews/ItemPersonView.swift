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
//    deleteImageFromPerson
    @Binding var currentItem: Person?
    
    var body: some View {
        profileView
            .edgesIgnoringSafeArea(.top)
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
                            update()
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
    
    var profileView: some View{
        NavigationStack{
            GeometryReader { gr in
                List{
                    Section (header: VStack {
                        RectOvalPath()
                            .fill(K.Colors.mainColor)
                        VStack(alignment: .center, spacing: 5){
                            Text(item.name == "" ? "name" : item.name)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .font(.title2)
                                .fontWeight(.medium)
                            if edit{
                                Button(action: {
                                    self.shouldShowImagePicker.toggle()
                                }){
                                    Text("tap-to-change-image")
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .font(.callout)
                                        .padding(.bottom)
                                    
                                }
                            }else{
                                if item.email != ""{
                                    Text(item.email.lowercased())
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .font(.callout)
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
                                        .foregroundColor(.white)
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
                                .disabled(!edit)
                            }
                        }
                        .offset(y: 40)
                    }
                        .textCase(nil)
                        .listRowInsets(EdgeInsets())
                        .frame(width: gr.size.width)
                    ){
                        
                    }
                    .frame(height: 200)
                    .padding(.bottom, 15)
                    if !edit{
                        Section (header: Text("iinfo")){
                            VStack(alignment: .leading){
                                Text("name-low")
                                    .font(.subheadline)
                                Text(item.name)
                                    .font(.headline)
                            }
                            if !item.notes.isEmpty{
                                VStack(alignment: .leading){
                                    Text("notes-low")
                                        .font(.subheadline)
                                    Text(item.notes)
                                        .font(.headline)
                                }
                            }
                            VStack(alignment: .leading){
                                Text("stage-low")
                                    .font(.subheadline)
                                Text(item.title)
                                    .font(.headline)
                            }
                            VStack(alignment: .leading){
                                Text("birthday-low")
                                    .font(.subheadline)
                                HStack(spacing: 1){
                                    Text(item.birthDay, format: .dateTime.month(.twoDigits))
                                    Text("/\(item.birthDay, format: .dateTime.day())/")
                                    Text(item.birthDay, format: .dateTime.year())
                                }
                                .font(.headline)
                            }
                            VStack(alignment: .leading){
                                Text("added-time")
                                    .font(.subheadline)
                                HStack(spacing: 1){
                                    Text(item.timestamp, format: .dateTime.month(.twoDigits))
                                    Text("/\(item.timestamp, format: .dateTime.day())/")
                                    Text(item.timestamp, format: .dateTime.year())
                                }
                                .font(.headline)
                            }
                            
                        }
                        if !item.email.isEmpty || !item.phone.isEmpty{
                            Section (header: Text("ccontacts")){
                                if !item.email.isEmpty{
                                    VStack(alignment: .leading){
                                        Text("eemail-low")
                                            .font(.subheadline)
                                        Menu{
                                            Button{
                                                UIPasteboard.general.string = item.email
                                                Toast.shared.present(
                                                    title: String(localized: "ccopiedd"),
                                                    symbol: "envelope",
                                                    isUserInteractionEnabled: true,
                                                    timing: .long
                                                )
                                            }label: {
                                                Label("ccoppy-email", systemImage: "envelope")
                                            }
                                        }label: {
                                            Text(item.email)
                                                .font(.headline)
                                                .foregroundStyle(K.Colors.mainColor)
                                        }
                                    }
                                }
                                if !item.phone.isEmpty{
                                    VStack(alignment: .leading){
                                        Text("phone-low")
                                            .font(.subheadline)
                                        Menu{
                                            Button{
                                                UIPasteboard.general.string = item.phone
                                                Toast.shared.present(
                                                    title: String(localized: "ccopiedd"),
                                                    symbol: "phone",
                                                    isUserInteractionEnabled: true,
                                                    timing: .long
                                                )
                                            }label: {
                                                Label("ccoppy-phone", systemImage: "phone")
                                            }
                                        }label: {
                                            Text(item.phone)
                                                .font(.headline)
                                                .foregroundStyle(K.Colors.mainColor)
                                        }
                                    }
                                }
                            }
                        }
                        Section {
                            if item.phone.isEmpty{
                                Label("record-video-for \(Text(item.name.capitalized).bold())", systemImage: "video.fill")
                                    .foregroundStyle(K.Colors.mainColor)
                                    .onTapGesture {
                                        phoneIsEmpty()
                                    }
                            }else {
                                NavigationLink {
                                    GeometryReader{ proxy in
                                        let size = proxy
                                        CameraView(recipients: [item.phone], message: "", size: size, item: item)
                                    }
                                } label: {
                                    Label("record-video-for \(Text(item.name.capitalized).bold())", systemImage: "video.fill")
                                        .foregroundStyle(K.Colors.mainColor)
                                }
                                
                            }
                        } header: {
                            Text("video")
                        }
                        if !K.AppStages.stagesArray.filter({$0.name.contains(item.title)}).isEmpty && !item.isDone{
                            Section {
                                HStack{
                                    if item.title == "Joined Group"{
                                        Spacer()
                                    }
                                    if item.title != "New Friend" && item.isDone == false && !K.AppStages.stagesArray.filter({$0.name.contains(item.title)}).isEmpty{
                                        HStack {
                                            Image(systemName: "arrowshape.turn.up.backward.fill")
                                            Text("Previous")
                                        }
                                        .onTapGesture {
                                            self.previousStage()
                                        }
                                    }
                                    Spacer()
                                    if item.isDone == false && !K.AppStages.stagesArray.filter({$0.name.contains(item.title)}).isEmpty{
                                        HStack {
                                            Text("Next")
                                            Image(systemName: "arrowshape.turn.up.forward.fill")
                                        }
                                        .onTapGesture {
                                            if item.title != "Joined Group"{
                                                self.nextStage()
                                            }else{
                                                self.donePerson()
                                            }
                                        }
                                    }
                                    if item.title == "New Friend"{
                                        Spacer()
                                    }
                                }
                                .foregroundStyle(K.Colors.mainColor)
                            } header: {
                                Text("control-stages")
                            }
                        }
                        if 3 == 6{
                            Section {
                                HStack(spacing: 15){
                                    Image(systemName: "person.crop.circle")
                                        .font(.system(size: 30))
                                    Text("Someone From")
                                        .font(.title3)
                                }
                                .padding(.vertical, 2)
                                HStack(spacing: 15){
                                    Image(systemName: "person.crop.circle")
                                        .font(.system(size: 30))
                                    Text("Someone Else")
                                        .font(.title3)
                                }
                                .padding(.vertical, 2)
                            } header: {
                                Text("praying-with")
                            }
                        }
                    }else{
                        Section (header: Text("iinfo")){
                            HStack{
                                TextField("name", text: $item.name)
                                    .textInputAutocapitalization(.words)
                                    .focused($focus, equals: .name)
                                Spacer()
                                Image(systemName: "person")
                            }
                            HStack{
                                TextField("notes", text: $item.notes, axis: .vertical)
                                    .textInputAutocapitalization(.sentences)
                                    .focused($focus, equals: .notes)
                                Spacer()
                                Image(systemName: "list.bullet")
                            }
                        }
                        Section (header: Text("ccontacts")){
                            HStack{
                                TextField("eemail", text: $item.email)
                                    .keyboardType(.emailAddress)
                                    .focused($focus, equals: .email)
                                    .textInputAutocapitalization(.never)
                                Spacer()
                                Image(systemName: "envelope")
                            }
                            HStack{
                                TextField("pphone", text: $item.phone)
                                    .keyboardType(.phonePad)
                                    .focused($focus, equals: .phone)
                                Spacer()
                                Image(systemName: "phone")
                            }
                        }
                        if !item.imageData.isEmpty{
                            Section{
                                HStack{
                                    Image(systemName: anonymously ? "checkmark.square.fill" : "square")
                                        .foregroundColor(.primary)
                                    Text("rremove-iimage")
                                }
                                .onTapGesture {
                                    anonymously.toggle()
                                }
                            }
                        }
                        Section{
                            Text("save")
                                .foregroundStyle(Color.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(K.Colors.mainColor)
                                .cornerRadius(10)
                                .onTapGesture {
                                    withAnimation {
                                        update()
                                    }
                                }
                                .listRowInsets(EdgeInsets())
                        }
                    }
                }
            }
            .onAppear {
                UIScrollView.appearance().showsVerticalScrollIndicator = false
                UIScrollView.appearance().showsHorizontalScrollIndicator = false
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
                        self.focus = .phone
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
    
    private func donePerson(){
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
    
    private func update(){
        self.edit = false
        if item.name == ""{
            item.name = self.name
        }
        
        if anonymously{
            viewModel.deleteImageFromPerson(item.documentId)
            item.imageData = ""
            image = nil
        }
        
        viewModel.editPerson(documentId: item.documentId, name: item.name, email: item.email, phone: item.phone, notes: item.notes, image: image)
        if let _ = image{
            self.anonymously = false
        }
    }
    
    enum FocusedField:Hashable{
        case name,email,phone,notes
    }
}


