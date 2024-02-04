//
//  SupportChatView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 1/19/24.
//

import SwiftUI
import PhotosUI

struct SupportChatView: View {
    var support: Bool = false
    
    @StateObject var imagePicker = ImagePickerViewModel()
    
    @EnvironmentObject var published: PublishedVariebles
    @EnvironmentObject var viewModel: AppViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var sendType = "message"
    @State private var message = ""
    @State private var messageType: String?
    @State private var messageTypeImage: String?
    @State private var showType = false
    @State private var imagePickerOpened = false
    @State private var showSendMail = false
    @State private var showRemoveAll = false

    private var from: String{
        return support ? "support" : viewModel.currentUser?.uid ?? ""
    }
    private var count: Int{
        return messages.count
    }
    private var messages: [MessageModel]{
        return viewModel.messagesArray.sorted { $0.time < $1.time }
    }
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading, spacing: 0){
                VStack(spacing: -5){
                    ScrollViewReader { scrollView in
                        ScrollView{
                            ForEach(messages.indices, id: \.self) { index in
                                let msg = messages[index]
                                ZStack{
                                    if index < messages.count - 1, messages[index + 1].from == msg.from{
                                        HStack{
                                            if msg.from == from{
                                                Spacer()
                                            }
                                            if msg.image.isEmpty{
                                                VStack(alignment: .leading){
                                                    if !msg.type.isEmpty, msg.type != "/image"{
                                                        Text(msg.type)
                                                            .font(.system(size: 16))
                                                            .foregroundStyle(.secondary)
                                                    }
                                                    Text(msg.message.count <= 3 ? " \(msg.message) " : msg.message)
                                                }
                                                    .padding(.vertical, 10)
                                                    .padding(.leading, 7)
                                                    .padding(.trailing, 13)
//                                                    .frame(maxWidth: UIScreen.main.bounds.width - 100)
                                                    .foregroundColor(msg.from == from ? Color.white : Color(K.Colors.text))
                                                    .background{
                                                        if msg.from != from {
                                                            TransparentBlurView(removeAllFilters: true)
                                                                .blur(radius: 9, opaque: true)
                                                                .background(Color(K.Colors.text).opacity(0.1))
                                                        }else{
                                                            Color(K.Colors.mainColor)
                                                        }
                                                    }
                                                    .clipShape(.rect(cornerRadius: 20))
                                            }else{
                                                AsyncImage(url: URL(string: msg.image)){image in
                                                    image.resizable()
                                                    
                                                }placeholder: {
                                                    ProgressView()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: 100, height: 100)
                                                }
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: UIScreen.main.bounds.width - 100)
                                                .clipShape(.rect(cornerRadius: 20))
                                            }
                                            if msg.from != from{
                                                Spacer()
                                            }
                                        }
                                    }else{
                                        if msg.from == from{
                                            if msg.image.isEmpty{
                                                ChatBubble(direction: .right) {
                                                    VStack(alignment: .leading){
                                                        if !msg.type.isEmpty, msg.type != "/image"{
                                                            Text(msg.type)
                                                                .font(.system(size: 16))
                                                                .foregroundStyle(.secondary)
                                                        }
                                                        Text(msg.message.count <= 3 ? " \(" \(msg.message)") " : msg.message)
                                                    }
                                                        .padding(.vertical, 10)
                                                        .padding(.leading, 7)
                                                        .padding(.trailing, 13)
                                                        .foregroundColor(Color.white)
                                                        .background(Color(K.Colors.mainColor))
                                                }
                                            }else{
                                                ChatBubble(direction: .right) {
                                                    AsyncImage(url: URL(string: msg.image)){image in
                                                        image.resizable()
                                                        
                                                    }placeholder: {
                                                        ProgressView()
                                                            .aspectRatio(contentMode: .fill)
                                                            .frame(width: 100, height: 100)
                                                    }
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: UIScreen.main.bounds.width - 100)
                                                }
                                            }
                                        }else{
                                            if msg.image.isEmpty{
                                                ChatBubble(direction: .left) {
                                                    VStack(alignment: .leading){
                                                        if !msg.type.isEmpty, msg.type != "/image"{
                                                            Text(msg.type)
                                                                .font(.system(size: 16))
                                                                .foregroundStyle(.secondary)
                                                        }
                                                        Text(msg.message.count <= 3 ? (msg.message.count <= 2 ? "  \(" \(msg.message)") " : " \(msg.message) ") : msg.message)
                                                    }
                                                        .padding(.vertical, 10)
                                                        .padding(.leading, 8)
                                                        .padding(.trailing, 13)
                                                        .foregroundColor(Color(K.Colors.text))
                                                        .background{
                                                            TransparentBlurView(removeAllFilters: true)
                                                                .blur(radius: 9, opaque: true)
                                                                .background(Color(K.Colors.text).opacity(0.1))
                                                        }
                                                }
                                            }else{
                                                ChatBubble(direction: .left) {
                                                    AsyncImage(url: URL(string: msg.image)){image in
                                                        image.resizable()
                                                        
                                                    }placeholder: {
                                                        ProgressView()
                                                            .aspectRatio(contentMode: .fill)
                                                            .frame(width: 100, height: 100)
                                                    }
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: UIScreen.main.bounds.width - 100)
                                                }
                                            }
                                        }
                                    }
                                }
                                .id(msg.id)
                                .onChange(of: count) { _ in
                                    // When messages change, scroll to the last message
                                    withAnimation {
                                        scrollView.scrollTo(messages[messages.count - 1].id, anchor: .bottom)
                                    }
                                }
                            }
                        }
                        .onAppear {
                            if !messages.isEmpty{
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                    withAnimation {
                                            scrollView.scrollTo(messages[messages.count - 1].id, anchor: .bottom)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 10)
                VStack{
                    if let messageType = messageType, let messageTypeImage = messageTypeImage{
                        VStack{
                            Divider()
                                .frame(height: 3)
                                .foregroundStyle(Color(K.Colors.justLightGray))
                            HStack(spacing: 10){
                                Image(systemName: messageTypeImage)
                                    .foregroundStyle(Color(K.Colors.mainColor))
                                    .font(.system(size: 22))
                                RoundedRectangle(cornerRadius: .infinity)
                                    .frame(width: 2, height: 22)
                                    .foregroundStyle(.secondary)
                                Text(messageType)
                                    .foregroundStyle(Color(K.Colors.mainColor))
                                    .font(.system(size: 18))
                                Spacer()
                                Image(systemName: "xmark")
                                    .foregroundStyle(.secondary)
                                    .font(.system(size: 22))
                                    .onTapGesture {
                                        withAnimation{
                                            self.messageType = nil
                                            self.messageTypeImage = nil
                                        }
                                    }
                            }
                            .padding(.horizontal, 15)
                        }
                        .frame(height: 35)
                    }
//                    if messages.last?.from == from, messages.last?.image == "", from != "support"{
//                        Text("wait-for-answer-from-support")
//                            .foregroundStyle(.secondary)
//                    }else{
                    Divider()
                        .frame(height: 3)
                        .foregroundStyle(Color(K.Colors.justLightGray))
                        .padding(.bottom, 5)
                        HStack(spacing: 10){
                                Image(systemName: imagePicker.showImagePicker ? "xmark" : "photo.on.rectangle.angled")
                                    .font(.system(size: 20))
                                    .foregroundStyle(Color(K.Colors.mainColor))
                                    .onTapGesture {
                                        withAnimation{
                                            imagePickerOpened.toggle()
                                            imagePicker.openImagePicker()
                                            self.showType = false
                                        }
                                    }
                            Button{
                                withAnimation{
                                    if imagePickerOpened{
                                        imagePicker.openImagePicker()
                                    }
                                    self.imagePickerOpened = false
                                    self.showType.toggle()
                                }
                            }label:{
                                Image(systemName: "chevron.left.forwardslash.chevron.right")
                                    .font(.system(size: 20))
                                    .foregroundStyle(Color(K.Colors.mainColor))
                            }
                            HStack{
                                ZStack(alignment: .leading){
                                    if message.isEmpty {
                                        Text("message")
                                            .padding(.leading)
                                            .foregroundColor(Color(K.Colors.lightGray))
                                    }
                                    TextField("message", text: $message, onEditingChanged: { (opened) in
                                        
                                        if opened && imagePicker.showImagePicker{
                                            
                                            // Closing Picker...
                                            imagePicker.showImagePicker.toggle()
                                        }
                                    })
                                    .submitLabel(.return)
                                    .textInputAutocapitalization(.sentences)
                                    .keyboardType(.default)
                                    .padding(.leading)
                                    .lineLimit(5)
                                }
                                if !message.isEmpty{
                                    Button{
                                        if sendType == "message", let msgType = messageType{
                                            viewModel.sentMessage(message: message, image: nil, type: messageType ?? "", from: from)
                                            viewModel.setLastMessage(message: message, image: false, type: msgType)
                                        }else if sendType == "mail"{
                                            self.showSendMail = true
                                        }
                                        self.messageType = nil
                                        self.messageTypeImage = nil
                                        self.message = ""
                                        viewModel.fetchMessages()
                                    }label:{
                                        Image(systemName: "paperplane.fill")
                                            .font(.system(size: 20))
                                            .foregroundStyle(Color(K.Colors.mainColor))
                                            .padding(10)
                                    }
                                    .contextMenu(menuItems: {
                                        Button{
                                            self.sendType = "message"
                                        }label:{
                                            Label(String(localized: "ssend-mmessage"), systemImage: "message")
                                                .font(.system(size: 20))
                                                .foregroundStyle(Color(K.Colors.mainColor))
                                        }
                                        Button{
                                            self.sendType = "mail"
                                        }label:{
                                            Label(String(localized: "ssend-mmail"), systemImage: "envelope")
                                                .font(.system(size: 20))
                                                .foregroundStyle(Color(K.Colors.mainColor))
                                        }
                                    })
                                }
                            }
                            .frame(height: 35)
                            .overlay(
                                RoundedRectangle(cornerRadius: .infinity)
                                    .stroke(Color(K.Colors.lightGray).opacity(0.5), lineWidth: 1)
                            )
                        }
                        .padding(.horizontal, 15)
                        .padding(.bottom, 5)
//                    }
                    if showType{
                        Divider()
                            .foregroundStyle(Color(K.Colors.justLightGray))
                        HStack{
                            if messages.last?.from != "support"{
                                Button{
                                    withAnimation{
                                        self.messageTypeImage = "slider.horizontal.3"
                                        self.messageType = "/support"
                                        self.showType = false
                                    }
                                }label:{
                                    SupportButton(text: String(localized: ""), systemImage: "slider.horizontal.3")
                                }
                                Spacer()
                                Button{
                                    withAnimation{
                                        self.messageTypeImage = "exclamationmark.warninglight"
                                        self.messageType = "/issue"
                                        self.showType = false
                                    }
                                }label:{
                                    SupportButton(text: String(localized: ""), systemImage: "exclamationmark.warninglight")
                                }
                                Spacer()
                                Button{
                                    withAnimation{
                                        self.messageTypeImage = "exclamationmark.bubble"
                                        self.messageType = "/report"
                                        self.showType = false
                                    }
                                }label:{
                                    SupportButton(text: String(localized: ""), systemImage: "exclamationmark.bubble")
                                }
                            }else{
                                Button{
//                                    aask-mmore
                                    withAnimation{
                                        self.messageTypeImage = "questionmark"
                                        self.messageType = "/ask or describe more"
                                        self.showType = false
                                    }
                                }label:{
                                    SupportButton(text: String(localized: ""), systemImage: "questionmark.bubble")
                                }
                                Button{
//                                    hhelped
                                    self.showRemoveAll.toggle()
                                }label:{
                                    SupportButton(text: String(localized: ""), systemImage: "hand.thumbsup")
                                }
                            }
                        }
                        .padding([.top, .horizontal],15)
                    }
                    if imagePickerOpened{
                        Divider()
                            .foregroundStyle(Color(K.Colors.justLightGray))
                        ScrollView(.horizontal, showsIndicators: false, content: {
                            
                            LazyHStack(spacing: 10){
                                
                                // Images...
                                
                                ForEach(imagePicker.fetchedPhotos){photo in
                                    
                                    Button(action: {
                                        imagePicker.extractPreviewData(asset: photo.asset)
                                        imagePicker.showPreview.toggle()
                                    }, label: {
                                        
                                        ThumbnailView(photo: photo)
                                    })
                                }
                                
                                // More Or Give Access Button...
                                
                                if imagePicker.library_status == .denied || imagePicker.library_status == .limited{
                                    
                                    VStack(spacing: 15){
                                        
                                        Text(imagePicker.library_status == .denied ? String(localized: "allow-access-for-photos") : String(localized: "select-more-photos") )
                                            .foregroundColor(.gray)
                                        
                                        Button(action: {
                                            // Go to Settings
                                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                                        }, label: {
                                            
                                            Text(imagePicker.library_status == .denied ? String(localized: "allow-access") : String(localized: "select-more"))
                                                .foregroundColor(.white)
                                                .fontWeight(.bold)
                                                .padding(.vertical,10)
                                                .padding(.horizontal)
                                                .background(Color.blue)
                                                .cornerRadius(5)
                                        })
                                    }
                                    .frame(width: 150)
                                }
                            }
                            .padding()
                        })
                        // Showing When Button Clicked...
                        .frame(height: imagePicker.showImagePicker ? 200 : 0)
                        .background(Color(K.Colors.darkGray).opacity(0.04).ignoresSafeArea(.all, edges: .bottom))
                        .opacity(imagePicker.showImagePicker ? 1 : 0)
                    }
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .background(Color(K.Colors.darkGray).ignoresSafeArea(.all, edges: [.bottom, .horizontal]))

            }
            .navigationBarTitleDisplayMode(.inline)
            .background {
                ZStack{
//                    LinearGradient(
//                        gradient: Gradient(colors: [Color(K.Colors.mainColor), Color(K.Colors.blackAndWhite)]),
//                                        startPoint: .topLeading,
//                                        endPoint: .bottomTrailing)
                    Image("LogoPng")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: UIScreen.screenWidth - 75)
                        .ignoresSafeArea(.keyboard, edges: .all)
                        .opacity(0.85)
                        .padding(.bottom, 50)
                }
            }
            .actionSheet(isPresented: $showRemoveAll) {
                ActionSheet(title: Text("close-this-conversation"),
                            message: Text("done-support-delete-all-messages"),
                            buttons: [
                                .cancel(),
                                .destructive(
                                    Text("rresume")
                                ){
                                    for msg in messages{
                                        viewModel.deleteMessage(documentId: msg.documentId)
                                        if !msg.image.isEmpty{
                                            viewModel.deleteImage(docId: msg.documentId)
                                        }
                                    }
                                    viewModel.deleteSupportConversation()
                                    viewModel.fetchChatList()
                                    presentationMode.wrappedValue.dismiss()
                                }
                            ]
                )
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    
                }
                ToolbarItem(placement: .principal) {
                    HStack{
                        Text("ssupport")
                            .bold()
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(Color(K.Colors.mainColor))
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: {
                        SupportChatInfoView()
                    }, label: {
                        Image("LogoPng")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40)
                    })
                }
            }
            .sheet(isPresented: $showSendMail) {
                ImageMailComposeView(recipients: ["prayer.navigator@gmail.com"], message: "from: \(from)- '\(message)'", image: nil)
                    .onDisappear {
                        self.sendType = "message"
                        self.message = ""
                    }
            }
            .sheet(isPresented: $imagePicker.showPreview, onDismiss: {
                // Clearing Content...
                imagePicker.selectedVideoPreview = nil
                imagePicker.selectedImagePreview = nil
            }, content: {
                
                PreviewView(show: $imagePicker.showPreview, from: from)
                    .environmentObject(imagePicker)
                    .onDisappear {
                        if imagePicker.showPreview == false{
                            imagePicker.showImagePicker = false
                        }
                    }
            })
            .modifier(DismissingKeyboard())
            .onAppear(perform: {
                viewModel.fetchMessages()
            })
        }
    }
}

//#Preview {
//    SupportChatView()
//}


