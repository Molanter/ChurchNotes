//
//  CameraView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 8/12/23.
//

import SwiftUI
import AVKit


struct CameraView: View {
    var recipients: [String]
    var message: String
    var size: GeometryProxy
    @Bindable var item: Items

    @StateObject var cameraModel = CameraModel()
    
    
    var body: some View {
        Group{
            if let url = cameraModel.previewURL, cameraModel.showPreview{
                FinalPreview(recipients: recipients, message: message, url: url, item: item, showPreview: $cameraModel.showPreview)
            }else{
                ZStack(alignment: .bottom){
                    GeometryReader{ proxy in
                        let size = proxy
                        CameraPreview(size: size)
                            .background(
                                Text("Background Text")
                            )
                            .environmentObject(cameraModel)
                        
                        ZStack(alignment: .leading) {
                            Rectangle ()
                                .fill(.black.opacity (0.25))
                            Rectangle()
                                .fill(Color(K.Colors.mainColor))
                                .frame(width: size.size.width * (cameraModel.recordedDuration / cameraModel.maxDuration))
                        }
                        .onReceive(Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()) {_ in
                            if cameraModel.recordedDuration <= cameraModel.maxDuration && cameraModel.isRecording{
                                cameraModel.recordedDuration += 0.01
                            }
                            
                            if cameraModel.recordedDuration >= cameraModel.maxDuration && cameraModel.isRecording{
                                cameraModel.stopRecording()
                                cameraModel.isRecording = false
                                cameraModel.recordedDuration = 0
                            }
                        }
                        .frame(height: 8)
                        .frame (maxHeight: .infinity, alignment: .top)
                    }
                    ZStack{
                        Button(action: {
                            if cameraModel.isRecording{
                                cameraModel.stopRecording()
                            } else{
                                cameraModel.startRecording()
                            }
                        }){
                            Image(systemName: /*cameraModel.isRecording ? "" : */"video")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(Color(K.Colors.mainColor))
                                .padding(10)
                                .frame(width: 60, height: 60)
                                .background(
                                    Circle()
                                        .stroke(cameraModel.isRecording ? .clear : .black)
                                )
                                .padding (6)
                                .background{
                                    Circle()
                                        .fill(cameraModel.isRecording ? .red : .white)
                                }
                        }
                        
                        Button(action:  {
                            if let _ = cameraModel.previewURL{
                                cameraModel.showPreview.toggle()
                            }
                        }){
                            Group{
                                if cameraModel.previewURL == nil && cameraModel.recordedURLs.isEmpty{
                                    // Merging Videos
                                    ProgressView()
                                        .tint(.black)
                                }else{
                                    Label {
                                        Image (systemName: "chevron.right" )
                                            .font (.callout)
                                    } icon: {
                                        Text ("Preview")
                                    }
                                }
                            }
                            .foregroundColor (Color(K.Colors.mainColor))
                            .padding(.horizontal,20)
                            .padding (.vertical,8)
                            .background{
                                Capsule()
                                    .fill(.white)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing)
                        .opacity ((cameraModel.previewURL == nil && cameraModel.recordedURLs.isEmpty) ||
                                  cameraModel.isRecording ? 0 : 1)
                    }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .padding(.bottom, 10)
                    .padding(.bottom, 30)
                    
                    if cameraModel.previewURL != nil{
                        Button {
                            cameraModel.recordedDuration = 0
                            cameraModel.previewURL = nil
                            cameraModel.recordedURLs.removeAll()
                        } label: {
                            Image (systemName: "xmark" )
                                .font(.title)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .padding()
                        .padding(.top)
                    }
//                    Button {
//                        if cameraModel.camera == 1{
//                            cameraModel.camera = 0
//                        }else if cameraModel.camera == 0{
//                            cameraModel.camera = 1
//                        }
//                        print(cameraModel.camera)
//                        cameraModel.setUp()
//                    } label: {
//                        Image (systemName: "arrow.triangle.2.circlepath.camera" )
//                            .font(.title)
//                            .foregroundColor(.white)
//                    }
//                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
//                    .padding()
//                    .padding(.top)
                }
            }
        }
        .onAppear{
            cameraModel.check()
        }
        .animation(.easeInOut, value: cameraModel.showPreview)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
