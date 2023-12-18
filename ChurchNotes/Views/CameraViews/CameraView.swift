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
        ZStack(alignment: .bottom){
            GeometryReader{ proxy in
                let size = proxy
                Group{
                    FrontCameraPreview(size: size)
                }
                .background(
                    Color(K.Colors.blackAndWhite)
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
                Rectangle()
                    .fill(Color.black)
                    .opacity(0.5)
                    .frame(width: UIScreen.screenWidth, height: 100, alignment: .top)
            }
            ZStack{
                Button(action: {
                    if frontCameraModel.isRecording {
                        frontCameraModel.stopRecording()
                    } else {
                        frontCameraModel.startRecording()
                    }
                }) {
                    ZStack {
                        Circle()
                            .stroke(Color.clear, lineWidth: 3)
                            .background(Circle().foregroundColor(frontCameraModel.isRecording ? .red : .white))
                            .frame(width: 72, height: 72)
                        
                        Image(systemName: frontCameraModel.isRecording ? "stop.circle.fill" : "circle.fill")
                            .font(.system(size: 63))
                            .foregroundColor(frontCameraModel.isRecording ? .white : .red)
                    }
                }
                
                Button(action:  {
                    if let _ = frontCameraModel.previewURL{
                        frontCameraModel.showPreview.toggle()
                    }
                }){
                    if frontCameraModel.previewURL != nil && !frontCameraModel.recordedURLs.isEmpty {
                        NavigationLink(destination: FinalPreview(recipients: recipients, message: message, url: frontCameraModel.previewURL!, item: item), label: {
                            HStack{
                                Text("preview")
                                Image(systemName: "chevron.right")
                            }
                            .foregroundColor(Color(K.Colors.text))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(Color(K.Colors.blackAndWhite).opacity(0.5))
                            .cornerRadius(.infinity)
                            
                        })
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
                    frontCameraModel.deleteAllVideos()
                    frontCameraModel.recordedDuration = 0
                    frontCameraModel.previewURL = nil
                    frontCameraModel.recordedURLs.removeAll()
                } label: {
                    Image (systemName: "video.slash" )
                        .font(.title)
                        .foregroundColor(Color(K.Colors.red).opacity(0.85))
                        .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
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
            .padding(.top)
            if !frontCameraModel.isRecording{
                Button {
                    frontCameraModel.switchCamera()
                } label: {
                    Image (systemName: "arrow.triangle.2.circlepath.camera" )
                        .font(.title)
                        .foregroundStyle(Color(K.Colors.text))
                        .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(.top)
            }
        }
        .onAppear{
            frontCameraModel.check()
        }
        .animation(.easeInOut, value: frontCameraModel.showPreview)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("ccamera")
    }
    
}


extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}

