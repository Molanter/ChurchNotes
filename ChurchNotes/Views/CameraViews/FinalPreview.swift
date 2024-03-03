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

struct FinalPreview: View {
    var recipients: [String]
    var message: String
    var url: URL
    @State var item: Person
    
    @StateObject var frontCameraModel = FrontCameraModel()
    
    var player: AVPlayer?{
        return AVPlayer (url: url)
    }
    @State private var saved = false
    @State private var isShareSheetPresented = false
    @State private var showSend = false
    @State private var showMessageComposeView = false
    @State private var showMailComposeView = false
    @State private var presrntAlert = false
    @State private var emailAlert = false
    
    var body: some View {
        NavigationStack{
            ZStack(alignment: .top){
                VideoPlayer(player: player)
                    .onDisappear(perform: {
                        print("hcgvjb")
                        NotificationCenter.default.post(name: .AVPlayerItemDidPlayToEndTime, object: nil)
                        NotificationCenter.default.removeObserver(self)
                        player?.pause()
                    })
                VStack(alignment: .leading, spacing: 15){
                    Text("recipient: \(item.name)")
                        .font(.body)
                        .padding(.top, 30)
                        .foregroundStyle(Color(K.Colors.text))
                    Button(action: {self.saveMessage()}){
                        FinalPreviewButtons(imageName: saved ? "checkmark" : "square.and.arrow.down", backgroundColor: Color(K.Colors.blackAndWhite), itemColor: Color(K.Colors.text), opacity: 0.5, paddingBottom: saved ? 0 : 5)
                    }
                    Button(action: {self.showSend = true}){
                        FinalPreviewButtons(imageName: "ellipsis", backgroundColor: Color(K.Colors.blackAndWhite), itemColor: Color(K.Colors.text), opacity: 0.5, paddingBottom: 0)
                    }
                    Button(action: {self.showMessageComposeView = true}){
                        FinalPreviewButtons(imageName: "paperplane", backgroundColor: Color(K.Colors.blackAndWhite), itemColor: Color(K.Colors.text), opacity: 0.5, paddingBottom: 0)
                    }
                    Spacer()
                }
                .padding(.horizontal, 15)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            .background(
                Color(K.Colors.blackAndWhite)
            )
            .alert("you-can-not-send-attachments", isPresented: $presrntAlert) {
                Button("Cancel", role: .cancel) {}
                Button(action: {
                    self.emailAlert = true
                }) {
                    Text("send-by-email")
                }
                
            } message: {
                Text("you-can-send-email-or-save-it")
            }
            .alert("send-by-email", isPresented: $emailAlert) {
                TextField("eemail", text: $item.email)
                Button("cancel", role: .cancel) {}
                Button(action: {
                    self.showMailComposeView = true
                }) {
                    Text("send")
                }
                
            } message: {
                Text("check-or-add-email-to-send")
            }
            .sheet(isPresented: $isShareSheetPresented) {
                ShareSheet(activityItems: [url])
                    .onDisappear(perform: {
                        self.isShareSheetPresented = false
                    })
                    .presentationDetents([.medium])
            }
            .sheet(isPresented: $showMessageComposeView) {
                MessageComposeView(recipients: [item.phone], message: "", url: url)
                    .onDisappear(perform: {
                        self.showMessageComposeView = false
                    })
            }
            .sheet(isPresented: $showMailComposeView) {
                MailComposeView(recipients: [item.email], message: "", url: url)
                    .onDisappear(perform: {
                        self.showMailComposeView = false
                    })
            }
            .sheet(isPresented: $showSend, content: {
                NavigationStack{
                    ScrollView(.horizontal){
                        HStack(spacing: 15){
                            Button(action: {self.saveMessage()}){
                                SendButtons(text: "save", imageName: "square.and.arrow.down", backgroundColor: K.Colors.mainColor, itemColor: Color.white)
                            }
                            Button(action: {self.showMailComposeView = true}){
                                SendButtons(text: "eemail", imageName: "envelope.fill", backgroundColor: Color.lightBlue, itemColor: Color.white)
                            }
                            Button(action: {
                                let canSendAtachtment = MFMessageComposeViewController.canSendAttachments()
                                if canSendAtachtment == true {
                                    sendMessage()
                                } else {
                                    cantSend()
                                }
                            }){
                                SendButtons(text: "message", imageName: "message.badge.filled.fill", backgroundColor: Color.lightGreen, itemColor: Color.white)
                            }
                            Button(action: {self.isShareSheetPresented = true}){
                                SendButtons(text: "another", imageName: "square.and.arrow.up", backgroundColor: K.Colors.mainColor, itemColor: Color.white)
                            }
                        }
                        .padding(.horizontal, 15)
                    }
                    .onDisappear(perform: {
                        self.showSend = false
                    })
                }
                .presentationDetents([.height(150)])
            })
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        frontCameraModel.deleteAllVideos()
                        self.dismissViewController()
                    }){
                        Text("done")
                            .foregroundStyle(K.Colors.mainColor)
                    }
                }
            })
        }
    }
    
    private func dismissViewController() {
               // Dismiss the view controller
               UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true)
           }
    
    func cantSend() {
        self.presrntAlert = true
    }
    
    func saveMessage() {
        DispatchQueue.global(qos: .background).async {
            if let urlData = NSData(contentsOf: url) {
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                let filePath = "\(documentsPath)/tempFile.mp4"
                DispatchQueue.main.async {
                    urlData.write(toFile: filePath, atomically: true)
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
                    }) { completed, error in
                        if completed {
                            self.saved = true
                            print("Video is saved!")
                        }
                    }
                }
            }
        }
    }
    
    func sendMessage() {
        self.showMessageComposeView = true
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

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    class Coordinator: NSObject, UIActivityItemSource {
        var parent: ShareSheet

        init(parent: ShareSheet) {
            self.parent = parent
        }

        func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
            return ""
        }

        func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
            return parent.activityItems.first
        }

        func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
            return "Subject" // Change this as needed
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        controller.excludedActivityTypes = [.addToReadingList, .assignToContact, .openInIBooks] // You can exclude specific activities if needed
        controller.completionWithItemsHandler = { _, _, _, _ in
            // Handle completion if needed
        }
        controller.popoverPresentationController?.sourceView = UIApplication.shared.windows.first
        controller.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // Update the view controller if needed
    }
}



//#Preview {
//    FinalPreview()
//}
