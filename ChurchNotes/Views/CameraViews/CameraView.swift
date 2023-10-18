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
    @StateObject var backCameraModel = BackCameraModel()

    
    var body: some View {
        Group{
            if let url = frontCameraModel.previewURL, frontCameraModel.showPreview{
                FinalPreview(recipients: recipients, message: message, url: url, item: item, showPreview: $frontCameraModel.showPreview)
            }else if let url = backCameraModel.previewURL, backCameraModel.showPreview{
                FinalPreview(recipients: recipients, message: message, url: url, item: item, showPreview: $backCameraModel.showPreview)
            }else{
                ZStack(alignment: .bottom){
                    GeometryReader{ proxy in
                        let size = proxy
                        Group{
                            if camera == 0{
                                FrontCameraPreview(size: size)
                            }else if camera == 1{
                                BackCameraPreview(size: size)
                            }
                        }
                            .background(
                                Text("Background Text")
                            )
                            .environmentObject(frontCameraModel)
                            .environmentObject(backCameraModel)
                        ZStack(alignment: .leading) {
                            Rectangle ()
                                .fill(.black.opacity (0.25))
                            Rectangle()
                                .fill(Color(K.Colors.mainColor))
                                .frame(width: camera == 0 ? (size.size.width * (frontCameraModel.recordedDuration / frontCameraModel.maxDuration)) : (size.size.width * (backCameraModel.recordedDuration / backCameraModel.maxDuration)))
                        }
                        .onReceive(Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()) {_ in
                            if camera == 0{
                                if frontCameraModel.recordedDuration <= frontCameraModel.maxDuration && frontCameraModel.isRecording{
                                    frontCameraModel.recordedDuration += 0.01
                                }
                                
                                if frontCameraModel.recordedDuration >= frontCameraModel.maxDuration && frontCameraModel.isRecording{
                                    frontCameraModel.stopRecording()
                                    frontCameraModel.isRecording = false
                                    frontCameraModel.recordedDuration = 0
                                }
                            }else if camera == 1{
                                if backCameraModel.recordedDuration <= backCameraModel.maxDuration && backCameraModel.isRecording{
                                    backCameraModel.recordedDuration += 0.01
                                }
                                
                                if backCameraModel.recordedDuration >= backCameraModel.maxDuration && backCameraModel.isRecording{
                                    backCameraModel.stopRecording()
                                    backCameraModel.isRecording = false
                                    backCameraModel.recordedDuration = 0
                                }
                            }
                        }
                        .frame(height: 8)
                        .frame (maxHeight: .infinity, alignment: .top)
                    }
                    ZStack{
                        Button(action: {
                            if camera == 0{
                                if frontCameraModel.isRecording{
                                    frontCameraModel.stopRecording()
                                } else{
                                    frontCameraModel.startRecording()
                                }
                            }else if camera == 1{
                                if backCameraModel.isRecording{
                                    backCameraModel.stopRecording()
                                } else{
                                    backCameraModel.startRecording()
                                }
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
                                        .stroke(camera==0 ? (frontCameraModel.isRecording ? .clear : .black) : (backCameraModel.isRecording ? .clear : .black))
                                )
                                .padding (6)
                                .background{
                                    Circle()
                                        .fill(camera == 0 ? (frontCameraModel.isRecording ? .red : .white) : (backCameraModel.isRecording ? .red : .white))
                                }
                        }
                        
                        Button(action:  {
                            if camera == 0{
                                if let _ = frontCameraModel.previewURL{
                                    frontCameraModel.showPreview.toggle()
                                }
                            }else if camera == 1{
                                if let _ = backCameraModel.previewURL{
                                    backCameraModel.showPreview.toggle()
                                }
                            }
                        }){
                            Group{
                                if camera == 0 && frontCameraModel.previewURL == nil && frontCameraModel.recordedURLs.isEmpty{
                                    // Merging Videos
                                    ProgressView()
                                        .tint(.black)
                                }else if camera == 1 && backCameraModel.previewURL == nil && backCameraModel.recordedURLs.isEmpty{
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
                        .opacity (camera == 0 ? ((frontCameraModel.previewURL == nil && frontCameraModel.recordedURLs.isEmpty) ||
                                                 frontCameraModel.isRecording ? 0 : 1) : ((backCameraModel.previewURL == nil && backCameraModel.recordedURLs.isEmpty) ||
                                                                                          backCameraModel.isRecording ? 0 : 1))
                    }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .padding(.bottom, 10)
                    .padding(.bottom, 30)
                    
                    if frontCameraModel.previewURL != nil || backCameraModel.previewURL != nil{
                        Button {
                            if camera == 0{
                                frontCameraModel.recordedDuration = 0
                                frontCameraModel.previewURL = nil
                                frontCameraModel.recordedURLs.removeAll()
                            }else if camera == 1{
                                backCameraModel.recordedDuration = 0
                                backCameraModel.previewURL = nil
                                backCameraModel.recordedURLs.removeAll()
                            }
                        } label: {
                            Image (systemName: "xmark" )
                                .font(.title)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .padding()
                        .padding(.top)
                    }
//                    if frontCameraModel.previewURL == nil || backCameraModel.previewURL == nil{
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
//                    }
//                    Button {
//                        if frontCameraModel.camera == 1{
//                            frontCameraModel.camera = 0
//                        }else if frontCameraModel.camera == 0{
//                            frontCameraModel.camera = 1
//                        }
//                        print(frontCameraModel.camera)
//                        frontCameraModel.setUp()
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
            frontCameraModel.check()
            backCameraModel.check()
        }
        .animation(.easeInOut, value: frontCameraModel.showPreview)
        .animation(.easeInOut, value: backCameraModel.showPreview)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
