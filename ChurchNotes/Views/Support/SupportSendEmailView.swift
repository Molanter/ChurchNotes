//
//  SupportSendEmailView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 1/21/24.
//

import SwiftUI
import MessageUI

struct SupportSendEmailView: View {
    @EnvironmentObject var viewModel: AppViewModel

    @State var image: UIImage?
    @State var showImagePicker = false
    @State var mailMessage = ""
    @State private var anonymously = false
    @State var showSendMail = false

    var body: some View {
        VStack{
            HStack(alignment: .center){
                VStack(alignment: .center){
                    Button{
                        self.showImagePicker = true
                    }label:{
                        if let image = self.image{
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: (UIScreen.screenWidth / 4) - 15)
                                .cornerRadius(10)
                                .onTapGesture {
                                    self.showImagePicker = true
                                }                    }else{
                            Image(systemName: "iphone")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 75)
                                .foregroundColor(K.Colors.mainColor)
                                .padding(15)
                                .fontWeight(.regular)
                                .onTapGesture {
                                    self.showImagePicker = true
                                }
                        }
                    }
                    .frame(width: (UIScreen.screenWidth / 4) - 15, height: (((UIScreen.screenWidth / 4) - 15) / 3) * 5)
                    Text("tap-to-change-image")
                        .multilineTextAlignment(.center)
                        .foregroundColor(K.Colors.mainColor)
                        .font(.system(size: 14))
                        .fontWeight(.regular)
                        .onTapGesture {
                            self.showImagePicker = true
                        }
                }
                VStack(alignment: .leading){
                    HStack{
                        TextField("write-here", text: $mailMessage, axis: .vertical)
                            .lineLimit(10)
                            .frame(alignment: .topLeading)
                    }
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5.0).stroke(Color(K.Colors.gray), lineWidth: 1)
                    )
                    HStack{
                        Image(systemName: anonymously ? "checkmark.square.fill" : "square")
                            .contentTransition(.symbolEffect(.replace))
                            .onTapGesture {
                                self.anonymously.toggle()
                            }
                        Text("write-anonymously")
                    }
                    Button(action: {
                        self.showSendMail = true
                    }){
                        Text("send")
                            .foregroundColor(Color.white)
                    }
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(K.Colors.mainColor)
                    .cornerRadius(7)
                }
            }
            .sheet(isPresented: $showImagePicker) {
                HoleImagePicker(image: $image, isImagePickerPresented: $showImagePicker)
            }
            .sheet(isPresented: $showSendMail) {
                ImageMailComposeView(recipients: ["prayer.navigator@gmail.com"], message: "from: \(anonymously ? "" : viewModel.currentUser?.email ?? "")- '\(mailMessage)'", image: image)
                    .onDisappear {
                        self.anonymously = false
                        self.mailMessage = ""
                        self.image = nil
                    }
            }
            Spacer()
        }
    }
}

//#Preview {
//    SupportSendEmailView()
//}


struct ImageMailComposeView: UIViewControllerRepresentable {
    var recipients: [String]
    var message: String
    var image: UIImage?
    private let mailComposeDelegate = MailDelegate()

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.setToRecipients(self.recipients)
        vc.setSubject("Mail Report")
        vc.setMessageBody(message, isHTML: false)
        if let image = image,
           let imageData = image.jpegData(compressionQuality: 1.0) { // Change to pngData if you prefer PNG format
            vc.addAttachmentData(imageData, mimeType: "image/jpeg", fileName: "image.jpg")
        }
        
        vc.mailComposeDelegate = mailComposeDelegate
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {
        uiViewController.setToRecipients(self.recipients)
    }

    private class MailDelegate: NSObject, MFMailComposeViewControllerDelegate {

        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {

            controller.dismiss(animated: true)
        }
    }
}

