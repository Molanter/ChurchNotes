//
//  BackCameraView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 9/22/23.
//

import Foundation
import AVFoundation
import SwiftUI


class BackCameraModel: NSObject, ObservableObject, AVCaptureFileOutputRecordingDelegate{
    @Published var isTaken = false
    @Published var session = AVCaptureSession()
    @Published var alert = false
    @Published var output = AVCaptureMovieFileOutput()
    @Published var preview : AVCaptureVideoPreviewLayer!
    @Published var isRecording: Bool = false
    @Published var recordedURLs: [URL] = []
    @Published var previewURL: URL?
    @Published var showPreview: Bool = false
    @Published var recordedDuration: CGFloat = 0
    @Published var maxDuration: CGFloat = 30
    @Published var camera = 0
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
        print("setUPP")
        
        do{
            
            self.session.beginConfiguration ()
            
            
            if self.camera == 0{
                if let cameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                        for: .video, position: .front) {
                    let cameraInput = try AVCaptureDeviceInput (device: cameraDevice)
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
                } else if let cameraDevice = AVCaptureDevice.default(for: .video)  {
                    let cameraInput = try AVCaptureDeviceInput (device: cameraDevice)
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
                } else {
                    fatalError("Missing expected back camera device.")
                }
            }else if self.camera == 1{
                if let cameraDevice = AVCaptureDevice.default(for: .video) {
                    let cameraInput = try AVCaptureDeviceInput (device: cameraDevice)
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
                } else if let cameraDevice = AVCaptureDevice.default(.builtInDualCamera,
                                                               for: .video, position: .back) {
                    let cameraInput = try AVCaptureDeviceInput (device: cameraDevice)
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
                } else {
                    fatalError("Missing expected back camera device.")
                }
            }

        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    func startRecording (){
        let tempURL = NSTemporaryDirectory() + "\(Date ()).mov"
        output.startRecording(to: URL(fileURLWithPath: tempURL), recordingDelegate: self)
        isRecording = true
    }
    
    func stopRecording () {
        output.stopRecording()
        isRecording = false
    }
    
    func fileOutput (_ output: AVCaptureFileOutput, didFinishRecordingTo outputfileURL: URL, from connections:
                     [AVCaptureConnection], error: Error?) {
        if let error = error{
            print(error.localizedDescription)
            return
        }
        
        print(outputfileURL)
        self.recordedURLs.append (outputfileURL)
        if self.recordedURLs.count == 1{
            self.previewURL = outputfileURL
            return
        }
        
        let assets = recordedURLs.compactMap{ url -> AVURLAsset in
            return AVURLAsset (url: url)
        }
        
        self.previewURL = nil
        
        mergeVideos(assets: assets) { exporter in
            exporter.exportAsynchronously {
                if exporter.status == .failed{
                    print (exporter.error!.localizedDescription)
                }else{
                    if let finalURL = exporter.outputURL {
                        print(finalURL)
                        DispatchQueue.main.async {
                            self.previewURL = finalURL
                        }
                    }
                }
            }
        }
    }
    
    func mergeVideos(assets: [AVURLAsset], completion: @escaping (_ exporter: AVAssetExportSession) -> ()){
        let compostion = AVMutableComposition()
        let totalTime: CMTime = .zero
        var lastTime: CMTime = .zero
        
        guard let videoTrack = compostion.addMutableTrack(withMediaType: .video, preferredTrackID:
                                                            Int32(kCMPersistentTrackID_Invalid)) else{return}
        guard let audioTrack = compostion.addMutableTrack(withMediaType: .audio, preferredTrackID:
                                                            Int32(kCMPersistentTrackID_Invalid)) else{return}
        
        for asset in assets{
            do{
                try videoTrack.insertTimeRange(CMTimeRange (start: .zero, duration: asset.duration), of: asset.tracks (withMediaType: .video)[0], at: lastTime)
                // Safe Check if Video has Audio
                if !asset.tracks (withMediaType: .audio).isEmpty{
                    try audioTrack.insertTimeRange(CMTimeRange (start: .zero, duration: asset.duration), of: asset.tracks (withMediaType: .audio)[0], at: lastTime)
                }
            }
            catch{
                print (error.localizedDescription)
            }
            lastTime = CMTimeAdd (lastTime, asset.duration)
        }
        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory() + "Reel-\(Date()).mp4")

        let layerInstructions = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
        
        var transform = CGAffineTransform.identity
        transform = transform.rotated(by: 90 * (.pi / 180))
        transform = transform.translatedBy(x: 0, y: -videoTrack.naturalSize.height)
        layerInstructions.setTransform(transform, at: .zero)
        
        let instructions = AVMutableVideoCompositionInstruction()
        instructions.timeRange = CMTimeRange (start: .zero, duration: lastTime)
        instructions.layerInstructions = [layerInstructions]
        
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = CGSize(width: videoTrack.naturalSize.height, height:
        videoTrack.naturalSize.width)
        videoComposition.instructions = [instructions]
        videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        
        guard let exporter = AVAssetExportSession (asset: compostion, presetName:
        AVAssetExportPresetHighestQuality) else{return}
        exporter.outputFileType = .mp4
        exporter.outputURL = tempURL
        exporter.videoComposition = videoComposition
        completion(exporter)
    }
}

struct BackCameraPreview: UIViewRepresentable {
    @EnvironmentObject var camera : FrontCameraModel
    var size: GeometryProxy
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        if camera.camera == 0{
            camera.preview = AVCaptureVideoPreviewLayer (session: camera.session)
            camera.preview.frame.size = UIScreen.screenSize
            
            camera.preview.videoGravity = .resizeAspectFill
            view.layer.addSublayer (camera.preview)
            
            camera.session.startRunning()
        }else if camera.camera == 1{
            camera.preview = AVCaptureVideoPreviewLayer (session: camera.session)
            camera.preview.frame.size = UIScreen.screenSize
            
            camera.preview.videoGravity = .resizeAspectFill
            view.layer.addSublayer (camera.preview)
            
            camera.session.startRunning()
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
            
    }
}



