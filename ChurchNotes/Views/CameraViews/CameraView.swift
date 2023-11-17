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
    @State var camera = 0
    var item: Person

    @StateObject var frontCameraModel = FrontCameraModel()

    
    var body: some View {
        Group{
            if let url = frontCameraModel.previewURL, frontCameraModel.showPreview{
                FinalPreview(recipients: recipients, message: message, url: url, item: item, showPreview: $frontCameraModel.showPreview)
            }else{
                ZStack(alignment: .bottom){
                    GeometryReader{ proxy in
                        let size = proxy
                        Group{
                                FrontCameraPreview(size: size)
                        }
                            .background(
                                Text("Background Text")
                            )
                            .environmentObject(frontCameraModel)
                        ZStack(alignment: .leading) {
                            Rectangle ()
                                .fill(.black.opacity (0.25))
                            Rectangle()
                                .fill(Color(K.Colors.mainColor))
                                .frame(width: (size.size.width * (frontCameraModel.recordedDuration / frontCameraModel.maxDuration)))
                        }
                        .onReceive(Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()) {_ in
                                if frontCameraModel.recordedDuration <= frontCameraModel.maxDuration && frontCameraModel.isRecording{
                                    frontCameraModel.recordedDuration += 0.01
                                }
                                
                                if frontCameraModel.recordedDuration >= frontCameraModel.maxDuration && frontCameraModel.isRecording{
                                    frontCameraModel.stopRecording()
                                    frontCameraModel.isRecording = false
                                    frontCameraModel.recordedDuration = 0
                                }
                        }
                        .frame(height: 8)
                        .frame (maxHeight: .infinity, alignment: .top)
                    }
                    ZStack{
                        Button(action: {
                                if frontCameraModel.isRecording{
                                    frontCameraModel.stopRecording()
                                } else{
                                    frontCameraModel.startRecording()
                                }
                        }){
                            Image(systemName: /*frontCameraModel.isRecording ? "" : */"video")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(Color(K.Colors.mainColor))
                                .padding(10)
                                .frame(width: 60, height: 60)
                                .background(
                                    Circle()
                                        .stroke((frontCameraModel.isRecording ? .clear : .black))
                                )
                                .padding (6)
                                .background{
                                    Circle()
                                        .fill((frontCameraModel.isRecording ? .red : .white))
                                }
                        }
                        
                        Button(action:  {
                                if let _ = frontCameraModel.previewURL{
                                    frontCameraModel.showPreview.toggle()
                                }
                        }){
                            Group{
                                if frontCameraModel.previewURL == nil && frontCameraModel.recordedURLs.isEmpty{
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
                        .opacity (((frontCameraModel.previewURL == nil && frontCameraModel.recordedURLs.isEmpty) ||
                                                 frontCameraModel.isRecording ? 0 : 1))
                    }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .padding(.bottom, 10)
                    .padding(.bottom, 30)
                    
                    if frontCameraModel.previewURL != nil{
                        Button {
                                frontCameraModel.recordedDuration = 0
                                frontCameraModel.previewURL = nil
                                frontCameraModel.recordedURLs.removeAll()
                        } label: {
                            Image (systemName: "xmark" )
                                .font(.title)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .padding()
                        .padding(.top)
                    }
                    if frontCameraModel.previewURL == nil{
                        //                        if frontCameraModel.isRecording == false && backCameraModel.isRecording == false{
                        //                            Button {
                        //                                if camera == 0{
                        //                                    camera = 1
                        //                                }else if camera == 1{
                        //                                    camera = 0
                        //                                }
                        //                            } label: {
                        //                                Image (systemName: "arrow.triangle.2.circlepath.camera" )
                        //                                    .font(.title)
                        //                                    .foregroundColor(.white)
                        //                            }
                        //                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        //                            .padding()
                        //                            .padding(.top)
                        //                        }
                        Button {
                            frontCameraModel.switchCamera()
                        } label: {
                            Image (systemName: "arrow.triangle.2.circlepath.camera" )
                                .font(.title)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        .padding()
                        .padding(.top)
                    }
                }
            }
        }
        .onAppear{
            frontCameraModel.check()
        }
        .animation(.easeInOut, value: frontCameraModel.showPreview)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
