//
//  FinalPreview.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 8/14/23.
//

import SwiftUI
import AVKit
import MessageUI
import UIKit
import Photos

struct FinalPreview: View{
    var recipients: [String]
    var message: String
    var url: URL
    @Bindable var item: Items

    @Binding var showPreview: Bool
    
    @State var showMessageComposeView = false
    @State var showMailComposeView = false
    @State var presrntAlert = false
    @State var emailAlert = false
    
    var body: some View{
        GeometryReader{proxy in
            let size = UIScreen.screenSize
            VStack(){
                VideoPlayer(player: AVPlayer (url: url))
                    .aspectRatio (contentMode: .fit)
                    .frame(width: size.width)
                    .clipShape(RoundedRectangle (cornerRadius: 0, style: .continuous))
                
                    .overlay(alignment: .topLeading) {
                        Button(action: {
                            showPreview = false
                        }){
                            Label {
                                Text ("Васк")
                            } icon: {
                                Image(systemName: "chevron.left")
                                    .foregroundColor (.white)
                            }
                            .padding(.leading)
                            .padding(.top, 22)
                        }
                    }
                Spacer()
                HStack(alignment: .center, spacing: 10){
                    Button(action:  {
                        
                        saveMessage()

                    }){
                        Label {
                            Image (systemName: "square.and.arrow.down")
                                .font (.callout)
                        } icon:{
                            Text ("Save")
                                .font(.system(size: 20))
                        }
                        .foregroundColor(Color(K.Colors.mainColor))
                        .padding(.horizontal,20)
                        .padding (.vertical,10)
                        .frame(height: 60)
                    }
                    .frame(maxWidth: .infinity)
                    .background{
                        RoundedRectangle(cornerRadius: 7)
                            .fill(.white)
                    }
                    Button(action:  {
                        let canSendAtachtment = MFMessageComposeViewController.canSendAttachments()
                        if canSendAtachtment == true{
                            sendMessage()
                        }else{
                            cantSend()
                        }

                    }){
                        Label {
                            Image (systemName: "chevron.right")
                                .font (.callout)
                        } icon:{
                            Text ("Send")
                                .font(.system(size: 20))
                        }
                        .foregroundColor(Color(K.Colors.mainColor))
                        .padding(.horizontal,20)
                        .padding (.vertical,10)
                        .frame(height: 60)
                    }
                    .frame(maxWidth: .infinity)
                    .background{
                        RoundedRectangle(cornerRadius: 7)
                            .fill(.white)
                    }
                }
                .padding(.horizontal, 15)
                .padding(.bottom)
                .frame(maxWidth: size.width)
                Spacer()
            }
        }
        .alert("You can't send attachments!", isPresented: $presrntAlert) {
            Button("Cancel", role: .cancel) {}
            Button(action: {
                emailAlert.toggle()
            }) {
                Text("Send by email")
            }
            
        }message: {
            Text("You can send video by email, or save it.")
        }
        .alert("Send By email.", isPresented: $emailAlert) {
            TextField("Email", text: $item.email)
            Button("Cancel", role: .cancel) {}
            Button(action: {
                showMailComposeView.toggle()
            }) {
                Text("Send")
            }
            
        }message: {
            Text("Check or add email to send.")
        }
        .sheet(isPresented: $showMessageComposeView) {
            MessageComposeView(recipients: [item.phone], message: "", url: url)
                .toolbar{
                    ToolbarItem(placement: .topBarTrailing){
                        Button(action: {
                            self.showMessageComposeView.toggle()
                        }){
                            Text("Cancel")
                                .foregroundColor(Color(K.Colors.mainColor))
                        }
                    }
                }
        }
        .sheet(isPresented: $showMailComposeView) {
            MessageComposeView(recipients: [item.email], message: "", url: url)
                .toolbar{
                    ToolbarItem(placement: .topBarTrailing){
                        Button(action: {
                            self.showMailComposeView.toggle()
                        }){
                            Text("Cancel")
                                .foregroundColor(Color(K.Colors.mainColor))
                        }
                    }
                }
        }
    }
        
    func cantSend(){
        presrntAlert.toggle()
    }
    
    func saveMessage(){
        DispatchQueue.global(qos: .background).async {
            if let urlData = NSData(contentsOf: url) {
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
                let filePath="\(documentsPath)/tempFile.mp4"
                DispatchQueue.main.async {
                    urlData.write(toFile: filePath, atomically: true)
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
                    }) { completed, error in
                        if completed {
                            print("Video is saved!")
                        }
                    }
                }
            }
        }
    }
    func sendMessage(){
        showMessageComposeView.toggle()
    }
}


struct MessageComposeView: UIViewControllerRepresentable {
    var recipients: [String]
    var message: String
    var url: URL
    private let messageComposeDelegate = MessageDelegate()

    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let vc = MFMessageComposeViewController()
        vc.recipients = self.recipients
        vc.addAttachmentURL(url, withAlternateFilename: "video.mov")
//        vc.delegate = context.coordinator
        vc.messageComposeDelegate = messageComposeDelegate
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {
        uiViewController.recipients = recipients
    }
    
    private class MessageDelegate: NSObject, MFMessageComposeViewControllerDelegate {
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            // Customize here
            controller.dismiss(animated: true)
        }
        
    }
}

struct MailComposeView: UIViewControllerRepresentable {
    var recipients: [String]
    var message: String
    var url: URL
    private let mailComposeDelegate = MailDelegate()

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.setToRecipients(self.recipients)
        let videoData = try? Data(contentsOf: url)
        vc.addAttachmentData(videoData!, mimeType: "video/quicktime", fileName: "video.mov")
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

//#Preview {
//    FinalPreview()
//}
