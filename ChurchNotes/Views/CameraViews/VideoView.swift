//
//  VideoView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 8/12/23.
//

import Foundation
import AVFoundation
import SwiftUI


class CameraModel: ObservableObject{
    @Published var isTaken = false
    @Published var session = AVCaptureSession()
    @Published var alert = false
    @Published var output = AVCaptureMovieFileOutput()
    @Published var preview : AVCaptureVideoPreviewLayer!
     
    func check(){
        
        switch AVCaptureDevice.authorizationStatus(for: .video){
        case .authorized:
            setUp()
            return
        case .notDetermined:
            // retusting for permission...
            AVCaptureDevice.requestAccess(for: .video){(status) in
                if status{
                    self.setUp ()
                }
            }
        case .denied:
            self.alert.toggle()
            return
        default:
            return
        }
    }
    
    func setUp(){
        
        
        do{
            
            self.session.beginConfiguration ()
            
            let cameraDevice = AVCaptureDevice.default(for: .video)
            let cameraInput = try AVCaptureDeviceInput (device: cameraDevice!)
            let audioDevice = AVCaptureDevice.default(for: .audio)
            let audioInput = try AVCaptureDeviceInput (device: audioDevice!)
            
            if self.session.canAddInput (cameraInput) && self.session.canAddInput (audioInput){
                self.session.addInput (cameraInput)
                self.session.addInput (audioInput)
            }
            
            if self.session.canAddOutput (self.output) {
                self.session.addOutput (self.output)
            }
            self.session.commitConfiguration ()
        }
        catch{
            print(error.localizedDescription)
        }
    }
}


struct CameraPreview: UIViewRepresentable {
    @EnvironmentObject var camera : CameraModel
    var size: CGSize
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        camera.preview = AVCaptureVideoPreviewLayer (session: camera.session)
        camera.preview.frame.size = size
        
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer (camera.preview)
        
        camera.session.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
