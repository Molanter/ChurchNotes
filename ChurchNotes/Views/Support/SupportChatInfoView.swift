//
//  SupportChatInfoView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 1/22/24.
//

import SwiftUI

struct SupportChatInfoView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var copied = false
    @State private var showSendMail = false
    @State private var listHeight: CGFloat = 0
    
    private var messages: [MessageModel]{
        return viewModel.messagesArray.sorted { $0.time < $1.time }
    }
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(alignment: .center){
                    ZStack(alignment: .bottom){
                        Image("LogoPng")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 15)
                        HStack{
                            VStack(alignment: .leading){
                                HStack{
                                    Text("ssupport")
                                        .font(.title)
                                        .bold()
                                    Image(systemName: "checkmark.seal.fill")
                                        .font(.system(size: 16))
                                        .foregroundStyle(K.Colors.mainColor)
                                }
                                Text("Status: \(messages.last?.from == viewModel.currentUser?.uid ? "requested" : "answered")")
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.horizontal, 15)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 100, alignment: .leading)
                        .background {
                            TransparentBlurView(removeAllFilters: false)
                                .blur(radius: 10, opaque: false)
                                .background(.white.opacity(0.05))
                        }
                    }
                    List{
                        
                        Section {
                            Menu{
                                Button("ccoppy-email") {
                                    UIPasteboard.general.string = viewModel.currentUser?.email ?? ""
                                    self.copyToClipboard()
                                }
                                Button("ssend-eemail") {
                                    self.showSendMail = true
                                }
                            }label:{
                                if copied{
                                    Label("ccopiedd", systemImage: "checkmark")
                                }else{
                                    VStack(alignment: .leading){
                                        Text("eemail-low")
                                            .foregroundStyle(Color(K.Colors.lightGray))
                                        Text(verbatim: "prayer.navigator@gmail.com")
                                            .foregroundStyle(K.Colors.mainColor)
                                    }
                                    .font(.body)
                                }
                            }
                            VStack(alignment: .leading){
                                Text("cchat-low")
                                    .foregroundStyle(Color(K.Colors.lightGray))
                                Text("open-support-chat")
                                    .foregroundStyle(K.Colors.mainColor)
                                    .onTapGesture {
                                        presentationMode.wrappedValue.dismiss()
                                    }
                            }
                            .font(.body)
                        } header: {
                            Text("ccontacts")
                        }
                        Section {
                            HStack(alignment: .top){
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.system(size: 16))
                                    .foregroundStyle(K.Colors.mainColor)
                                Text("-vertification-checkmark-meaning")
                                    .foregroundStyle(Color(K.Colors.lightGray))
                                    .font(.body)
                            }
                            HStack(alignment: .top){
                                Image(systemName: "iphone")
                                    .font(.system(size: 16))
                                    .foregroundStyle(K.Colors.mainColor)
                                Text("-photo-rules-info")
                                    .foregroundStyle(Color(K.Colors.lightGray))
                                    .font(.body)
                            }
                            HStack(alignment: .top){
                                Image(systemName: "paperplane.fill")
                                    .font(.system(size: 16))
                                    .foregroundStyle(K.Colors.mainColor)
                                Text("-send-report-in-one-message")
                                    .foregroundStyle(Color(K.Colors.lightGray))
                                    .font(.body)
                            }
                        } header: {
                            Text("iinfo")
                        }
                    }
                    .scrollIndicators(.hidden)
                    .scrollDisabled(true)
                    .frame(height: 450)
                }
            }
            .background(
                Color(K.Colors.listBg)
            )
            .sheet(isPresented: $showSendMail) {
                ImageMailComposeView(recipients: ["prayer.navigator@gmail.com"], message: "", image: nil)
            }
        }
    }
    
    private func copyToClipboard() {
        withAnimation{
            self.copied = true
            // self.text = "" // clear the text after copy
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.copied = false
            }
        }
    }
}

//#Preview {
//    SupportChatInfoView()
//}
