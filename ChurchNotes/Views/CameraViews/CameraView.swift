//
//  CameraView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 8/12/23.
//

import SwiftUI
import AVKit
import Photos


struct CameraView: View {
    @StateObject var frontCameraModel = FrontCameraModel()
    
    @State var camera = 0
    @State private var isShowingVideoPicker = false
    @State private var lastVideoThumbnail: UIImage?
    
    var recipients: [String]
    var message: String
    var item: Person
    
    var body: some View {
        ZStack(alignment: .bottom){
            GeometryReader{ proxy in
                let size = proxy.size
                FrontCameraPreview()
                    .background(
                        Color(K.Colors.blackAndWhite)
                    )
                    .environmentObject(frontCameraModel)
                //                ZStack(alignment: .leading) {
                //                    Rectangle ()
                //                        .fill(.black.opacity (0.25))
                //                    Rectangle()
                //                        .fill(K.Colors.mainColor)
                //                        .frame(width: (size.width * (frontCameraModel.recordedDuration / frontCameraModel.maxDuration)))
                //                }
                //                .onReceive(Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()) {_ in
                //                    if frontCameraModel.recordedDuration <= frontCameraModel.maxDuration && frontCameraModel.isRecording{
                //                        frontCameraModel.recordedDuration += 0.01
                //                    }
                //
                //                    if frontCameraModel.recordedDuration >= frontCameraModel.maxDuration && frontCameraModel.isRecording{
                //                        frontCameraModel.stopRecording()
                //                        frontCameraModel.isRecording = false
                //                        frontCameraModel.recordedDuration = 0
                //                    }
                //                }
                //                .frame(height: 8)
                //                .frame (maxHeight: .infinity, alignment: .top)
            }
            ZStack{
                Button {
                    self.isShowingVideoPicker = true
                }label: {
                    if let thumbnail = lastVideoThumbnail {
                        Image(uiImage: thumbnail)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 70, height: 70)
                    } else {
                        Image(systemName: "photo.stack")
                            .aspectRatio(contentMode: .fit)
                            .font(.system(size: 30))
                    }
                }
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, alignment: .leading)
                .cornerRadius(10)
                .padding(.leading, 25)
                Button(action: {
                    if frontCameraModel.isRecording {
                        frontCameraModel.stopRecording()
                    } else {
                        frontCameraModel.startRecording()
                    }
                }) {
                    ZStack {
                        Image(systemName: frontCameraModel.isRecording ? "stop.circle" : "circle")
                            .font(.system(size: 70))
                            .foregroundColor(frontCameraModel.isRecording ? Color.red : Color.white)
                        if !frontCameraModel.isRecording {
                            Image(systemName: "circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(Color.red)
                        }
                    }
                }
                if !frontCameraModel.isRecording{
                    Button {
                        frontCameraModel.switchCamera()
                    } label: {
                        Image (systemName: "arrow.triangle.2.circlepath" )
                            .foregroundStyle(Color(K.Colors.text))
                            .padding()
                    }
                    .font(.system(size: 30))
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 25)
                }
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 10)
            .padding(.bottom, 30)
            
            
            if frontCameraModel.previewURL != nil{
                Button {
                    frontCameraModel.deleteAllVideos()
                    frontCameraModel.recordedDuration = 0
                    frontCameraModel.previewURL = nil
                    frontCameraModel.recordedURLs.removeAll()
                } label: {
                    Image (systemName: "video.slash" )
                        .foregroundStyle(Color(K.Colors.text))
                }
                .font(.system(size: 30))
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.leading, 25)
                .padding(.top)
            }
            VStack(alignment: .center){
                Text("recording-for")
                    .foregroundStyle(.primary)
                Text("'\(item.name)'")
                    .foregroundStyle(.secondary)
            }
            .foregroundStyle(Color(K.Colors.text))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.top)
            Button(action:  {
                if let _ = frontCameraModel.previewURL{
                    frontCameraModel.showPreview.toggle()
                }
            }){
                if frontCameraModel.previewURL != nil, !frontCameraModel.recordedURLs.isEmpty {
                    HStack{
                        Text("preview")
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(Color(K.Colors.text))
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                    .background(Color(K.Colors.blackAndWhite).opacity(0.4))
                    .cornerRadius(.infinity)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(.top)
            .opacity (((frontCameraModel.previewURL == nil && frontCameraModel.recordedURLs.isEmpty) ||
                       frontCameraModel.isRecording ? 0 : 1))
            .navigationDestination(isPresented: $frontCameraModel.showPreview) {
                if let url = frontCameraModel.previewURL {
                    FinalPreview(recipients: recipients, message: message, url: url, item: item)
                }
            }
        }
        .onAppear{
            frontCameraModel.check()
            fetchLastVideoThumbnail()
        }
        .sheet(isPresented: $isShowingVideoPicker) {
            VideoPicker(selectedVideoURL: $frontCameraModel.previewURL)
        }
        .animation(.easeInOut, value: frontCameraModel.showPreview)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("ccamera")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func fetchLastVideoThumbnail() {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        options.fetchLimit = 1
        let fetchResult = PHAsset.fetchAssets(with: .video, options: options)
        
        if let asset = fetchResult.firstObject {
            let manager = PHImageManager.default()
            manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: nil) { image, _ in
                if let image = image {
                    self.lastVideoThumbnail = image
                }
            }
        }
    }
}


extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}

