//
//  ItemPersonView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/6/23.
//

import SwiftUI
import SwiftData
import iPhoneNumberField

struct ItemPersonView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var published: PublishedVariebles

    @Query var strings: [StringDataModel]

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
    @State private var showRecord = false
    @State private var showSearchView = false
    
    @Binding var currentItem: Person?
    
    var showEditButton: Bool = true
    
    var backgroundType: String {
        if let strModel = strings.first(where: { $0.name == "backgroundType" }) {
            return strModel.string
        }else {
            return "none"
        }
    }
    var body: some View {
        profileView
            .navigationBarBackground()
            .navigationBarTitleDisplayMode(.inline)
            .edgesIgnoringSafeArea(.top)
            .modifier(DismissingKeyboard())
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    if published.showEditButtonInIPV{
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
                ToolbarItem(placement: .bottomBar) {
                    HStack(alignment: .center, content: {
                        if item.title == "Joined Group" && item.isDone == false {
                            Spacer()
                        }
                        if item.title != "New Friend" && item.isDone == false && !AppStages.stagesArray.filter({$0.name.contains(item.title)}).isEmpty {
                            Label("previous-stage", systemImage: "arrowshape.turn.up.left.fill")
                                .foregroundStyle(K.Colors.mainColor)
                                .onTapGesture {
                                    previousStage()
                                }
                        }
                        Spacer()
                        Label("share-person", systemImage: "square.and.arrow.up.fill")
                            .foregroundStyle(K.Colors.mainColor)
                            .onTapGesture {
                                self.showSearchView = true
                                print("people  :", [item])
                            }
                        Spacer()
                        if item.phone.isEmpty{
                            Label("record-video-for \(Text(item.name.capitalized).bold())", systemImage: "video.fill")
                                .foregroundStyle(K.Colors.mainColor)
                                .onTapGesture {
                                    phoneIsEmpty()
                                }
                        }else {
                                Label("record-video-for \(Text(item.name.capitalized).bold())", systemImage: "video.fill")
                                    .foregroundStyle(K.Colors.mainColor)
                                    .onTapGesture {
                                        self.showRecord.toggle()
                                    }
                        }
                        Spacer()
                        Label("favourite", systemImage: item.isLiked ? "\(K.favouriteSign).fill" : "\(K.favouriteSign)")
                            .foregroundStyle(K.Colors.mainColor)
                            .symbolEffect(.bounce, value: item.isLiked)
                            .onTapGesture {
                                let isLiked = item.isLiked ? false : true
                                viewModel.likePerson(documentId: item.documentId, isLiked: isLiked)
                                withAnimation{
                                    item.isLiked = isLiked
                                    viewModel.fetchPeople()
                                }
                            }
                        Spacer()
                        if item.title != "Joined Group" && item.isDone == false && !AppStages.stagesArray.filter({$0.name.contains(item.title)}).isEmpty {
                            Label("next-stage", systemImage: "arrowshape.turn.up.right.fill")
                                .foregroundStyle(K.Colors.mainColor)
                                .onTapGesture {
                                    if item.title != "Joined Group"{
                                        self.nextStage()
                                    }else{
                                        self.donePerson()
                                    }
                                }
                        }
                        if item.title == "New Friend" && item.isDone == false {
                            Spacer()
                        }
                    })
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
            .onChange(of: currentItem) { oldValue, newValue in
                if let newValue = newValue {
                    item = newValue
                }
            }
            .onDisappear(perform: {
                if viewModel.moved == 1{
                    withAnimation{
                        published.currentTab += 1
                        viewModel.moved = 0
                    }
                }else if viewModel.moved == 2{
                    withAnimation{
                        published.currentTab -= 1
                        viewModel.moved = 0
                    }
                }
            })
            .accentColor(Color.white)
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
                                            if let img = image {
                                                Image(uiImage: img)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 80, height: 80)
                                                    .clipShape(.circle)
                                                    .background(Color(K.Colors.blackAndWhite))
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
                                                .background(Color(K.Colors.blackAndWhite))
                                                .clipShape(.circle)
                                                .overlay(
                                                    Circle().stroke(.white, lineWidth: 2)
                                                )
                                            }
                                        }else if let img = image{
                                            Image(uiImage: img)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 80, height: 80)
                                                .background(Color(K.Colors.blackAndWhite))
                                                .clipShape(.circle)
                                                .overlay(
                                                    Circle().stroke(.white, lineWidth: 2)
                                                )
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
                        
                        .listRowBackground(
                            GlassListRow()
                        )
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
    //                            VStack(alignment: .leading){
    //                                Text("birthday-low")
    //                                    .font(.subheadline)
    //                                HStack(spacing: 1){
    //                                    Text(item.birthDay, format: .dateTime.month(.twoDigits))
    //                                    Text("/\(item.birthDay, format: .dateTime.day())/")
    //                                    Text(item.birthDay, format: .dateTime.year())
    //                                }
    //                                .font(.headline)
    //                            }
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
                            .listRowBackground(
                                GlassListRow()
                            )
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
                                .listRowBackground(
                                    GlassListRow()
                                )
                            }
                            if published.device == .phone {
                                Section {
                                    if item.phone.isEmpty{
                                        Label("record-video-for \(Text(item.name.capitalized).bold())", systemImage: "video.fill")
                                            .foregroundStyle(K.Colors.mainColor)
                                            .onTapGesture {
                                                phoneIsEmpty()
                                            }
                                    }else {
                                            Label("record-video-for \(Text(item.name.capitalized).bold())", systemImage: "video.fill")
                                                .foregroundStyle(K.Colors.mainColor)
                                                .onTapGesture {
                                                    self.showRecord.toggle()
                                                }
                                                .navigationDestination(isPresented: $showRecord) {
                                                    CameraView(recipients: [item.phone], message: "", item: item)
                                                }
                                    }
                                } header: {
                                    Text("video")
                                }
                                .listRowBackground(
                                    GlassListRow()
                                )
                            }
                            if !AppStages.stagesArray.filter({$0.name.contains(item.title)}).isEmpty && !item.isDone{
                                Section {
                                    HStack{
                                        if item.title != "New Friend" && item.isDone == false && !AppStages.stagesArray.filter({$0.name.contains(item.title)}).isEmpty{
                                            HStack {
                                                Image(systemName: "arrowshape.turn.up.backward.fill")
                                                Text("Previous")
                                            }
                                            .onTapGesture {
                                                self.previousStage()
                                            }
                                        }
                                        Spacer()
                                        if item.isDone == false && !AppStages.stagesArray.filter({$0.name.contains(item.title)}).isEmpty{
                                            HStack {
                                                Text(item.title == "Joined Group" ? "Done" : "Next")
                                                Image(systemName: item.title == "Joined Group" ? "person.fill.checkmark" : "arrowshape.turn.up.forward.fill")
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
                                .listRowBackground(
                                    GlassListRow()
                                )
                            }
                            Section(header: Text("praying-with")){
                                ForEach(viewModel.prayingWithArray){ person in
                                    HStack(alignment: .top){
                                    ZStack(alignment: .bottomTrailing){
                                            if !person.profileImageUrl.isEmpty{
                                                AsyncImage(url: URL(string: person.profileImageUrl)){image in
                                                    image.resizable()
                                                    
                                                }placeholder: {
                                                    ProgressView()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: 35, height: 35)
                                                }
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 35, height: 35)
                                                .cornerRadius(.infinity)
                                            }else{
                                                Image(systemName: "person.crop.circle.fill")
                                                    .symbolRenderingMode(.palette)
                                                    .foregroundStyle(.white, Color(K.Colors.lightGray))
                                                    .font(.largeTitle)
                                                    .frame(width: 35, height: 35)                                        }
                                        ZStack{
                                                if let b = Badges().getBadgeArray()[person.badge] as? Badge{
                                                    if b.string != ""{
                                                        Text(b.string)
                                                            .foregroundStyle(Color.white)
                                                            .font(.system(size: 10))
                                                            .padding(3)
                                                            .background(
                                                                Circle()
                                                                    .fill(K.Colors.mainColor)
                                                                    .opacity(0.7)
                                                            )
                                                    }else{
                                                        Image(systemName: b.image)
                                                            .foregroundStyle(Color.white)
                                                            .font(.system(size: 10))
                                                            .padding(3)
                                                            .background(
                                                                Circle()
                                                                    .fill(K.Colors.mainColor)
                                                                    .opacity(0.7)
                                                            )
                                                    }
                                                }
                                            }
                                        }
                                        VStack(alignment: .leading){
                                            Text(person.name.capitalized)
                                                .foregroundStyle(.primary)
                                                .font(.title3)
                                                .bold()
                                            Text("\(person.email) • \(person.username)")
                                                .foregroundStyle(.secondary)
                                                .font(.body)
                                        }
                                    }
                                }
                                Label("share-person", systemImage: "square.and.arrow.up.fill")
                                    .foregroundStyle(K.Colors.mainColor)
                                    .onTapGesture {
                                        self.showSearchView.toggle()
                                    }
                                    .navigationDestination(isPresented: $showSearchView) {
                                        SearchPersonView()
                                    }
                            }
                            .listRowBackground(
                                GlassListRow()
                            )
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
                            .listRowBackground(
                                GlassListRow()
                            )
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
                                    iPhoneNumberField(String(localized: "pphone"), text: $item.phone)
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
                                .listRowBackground(
                                    GlassListRow()
                                )
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
                            .listRowBackground(
                                GlassListRow()
                            )
                        }
                    }
                
                .scrollContentBackground(backgroundType == "none" ? .visible : .hidden)
                .background {
                    ListBackground()
                }
            }
            .onAppear {
                UIScrollView.appearance().showsVerticalScrollIndicator = false
                UIScrollView.appearance().showsHorizontalScrollIndicator = false
                viewModel.prayingWithArray.removeAll()
                for uid in item.userId{
                    viewModel.fethPrayingWith(userId: uid)
                }
            }
            .sheet(isPresented: $published.showShare, content: {
                NavigationStack{
                    SharePersonView(people: [item])
                        .navigationBarBackground()
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button{
                                    published.showShare = false
                                }label: {
                                    Text("cancel")
                                        .foregroundStyle(Color.white)
                                }
                            }
                        }
                }
            })
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
        let newName = AppStages.stagesArray.sorted(by: { $0.orderIndex < $1.orderIndex })[item.titleNumber + 1].name
        item.title = newName
        if let user = viewModel.currentUser{
            if user.next == 4{
                viewModel.addBadge(name: "nNext")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.published.currentBadge = Badges().nNext
                }
                viewModel.getFcmByEmail(email: user.email, messageText: "You received a new badge 'Next'", subtitle: "Congratulations", title: "New Badge", imageURL: "", link: "", badgeCount: 5)
            }else if user.next == 19{
                viewModel.addBadge(name: "nGoing")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.published.currentBadge = Badges().nGoing
                }
                viewModel.getFcmByEmail(email: user.email, messageText: "You received a new badge 'Going'", subtitle: "Congratulations", title: "New Badge", imageURL: "", link: "", badgeCount: 5)
            }else if user.next == 49{
                viewModel.addBadge(name: "nnext")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.published.currentBadge = Badges().nnext
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
        let newName = AppStages.stagesArray.sorted(by: { $0.orderIndex < $1.orderIndex })[item.titleNumber - 1].name
        item.title = newName
        self.currentItem = nil
    }
    
    private func donePerson(){
        viewModel.isDonePerson(documentId: item.documentId, isDone: true)
        self.viewModel.addAchiv(name: "done", int: (viewModel.currentUser?.done ?? 0) + 1)
        if let user = viewModel.currentUser{
            if user.done == 0{
                viewModel.addBadge(name: "dDone")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.published.currentBadge = Badges().dDone
                }
                viewModel.getFcmByEmail(email: user.email, messageText: "You received a new badge 'Done'", subtitle: "Congratulations", title: "New Badge", imageURL: "", link: "", badgeCount: 5)
            }else if user.done == 4{
                viewModel.addBadge(name: "dCongrats")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.published.currentBadge = Badges().dCongrats
                }
                viewModel.getFcmByEmail(email: user.email, messageText: "You received a new badge 'Congrats'", subtitle: "Congratulations", title: "New Badge", imageURL: "", link: "", badgeCount: 5)
                
            }else if user.done == 14{
                viewModel.addBadge(name: "ddone")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.published.currentBadge = Badges().ddone
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


