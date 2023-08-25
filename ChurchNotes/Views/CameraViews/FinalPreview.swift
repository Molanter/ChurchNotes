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
    @Binding var showPreview: Bool
    @State var showMessageComposeView = false

    var body: some View{
        GeometryReader{proxy in
            let size = proxy.size
            ZStack(alignment: .bottomTrailing){
                VideoPlayer(player: AVPlayer (url: url))
                    .onAppear{
                        print("asdfghjkjhgfdx:    -\(url)")
                    }
                    .aspectRatio (contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipShape(RoundedRectangle (cornerRadius: 0, style: .continuous))
                
                    .overlay(alignment: .topLeading) {
                        Button(action: {
                            showPreview.toggle()
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
                Button(action:  {
                    
                    sendMessage()

                }){
                    Label {
                        Image (systemName: "chevron.right")
                            .font (.callout)
                    } icon:{
                        Text ("Send")
                    }
                    .foregroundColor (.black)
                    .padding(.horizontal,20)
                    .padding (.vertical,8)
                    .background{
                        Capsule()
                            .fill(.white)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing)
            }
        }
        .sheet(isPresented: $showMessageComposeView) {
            MessageComposeView(recipients: ["3235953205"], message: "cv", url: url)
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
    }
        
    func sendMessage(){
        showMessageComposeView.toggle()
                
//        PHPhotoLibrary.shared().performChanges({
//            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
//        }) { saved, error in
//            if saved {
//                let alertController = UIAlertController(title: "Your video was successfully saved", message: nil, preferredStyle: .alert)
//                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                alertController.addAction(defaultAction)
//                self.present(alertController, animated: true, completion: nil)
//            }
//        }
    }
}

func saveVideoToAlbum(_ outputURL: URL, _ completion: ((Error?) -> Void)?) {
        requestAuthorization {
            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetCreationRequest.forAsset()
                request.addResource(with: .video, fileURL: outputURL, options: nil)
            }) { (result, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("Saved successfully")
                    }
                    completion?(error)
                }
            }
        }
    }

func requestAuthorization(completion: @escaping ()->Void) {
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization { (status) in
                DispatchQueue.main.async {
                    completion()
                }
            }
        } else if PHPhotoLibrary.authorizationStatus() == .authorized{
            completion()
        }
    }

struct MessageComposeView: UIViewControllerRepresentable {
    var recipients: [String]
    var message: String
    var url: URL
    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let vc = MFMessageComposeViewController()
        vc.recipients = self.recipients
        vc.addAttachmentURL(url, withAlternateFilename: "video.mov")
//        let videoData = try? Data(contentsOf: url as URL)
//        if let vData = videoData{
//            vc.addAttachmentData(vData, typeIdentifier: "video/mov", filename: "video.mov")
//        }
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {
        uiViewController.recipients = recipients
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            switch (result) {
            case .cancelled:
                print("Message cancelled")
            case .failed:
                print("Message failed")
            case .sent:
                print("Message sent")
            default:
                         break
            }
        controller.dismiss(animated: true, completion: nil)
        }
}


//#Preview {
//    FinalPreview()
//}
