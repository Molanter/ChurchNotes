/*
See the License.txt file for this sample’s licensing information.
*/

import AVFoundation
import CoreImage
import UIKit
import os.log

class Camera: NSObject, ObservableObject, AVCaptureFileOutputRecordingDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    private let captureSession = AVCaptureSession()
    private var isCaptureSessionConfigured = false
    private var deviceInput: AVCaptureDeviceInput?
    private var photoOutput: AVCapturePhotoOutput?
    private var videoOutput: AVCaptureVideoDataOutput?
    private var sessionQueue: DispatchQueue!
    @Published var output = AVCaptureMovieFileOutput()
    @Published var isRecording: Bool = false
    @Published var recordedURLs: [URL] = []
    @Published var previewURL: URL?
    @Published var showPreview: Bool = false
    @Published var recordedDuration: CGFloat = 0
    @Published var maxDuration: CGFloat = 30
    @Published var session = AVCaptureSession()
    @Published var preview : AVCaptureVideoPreviewLayer!

    
    private var allCaptureDevices: [AVCaptureDevice] {
        AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTrueDepthCamera, .builtInDualCamera, .builtInDualWideCamera, .builtInWideAngleCamera, .builtInDualWideCamera], mediaType: .video, position: .unspecified).devices
    }
    
    private var frontCaptureDevices: [AVCaptureDevice] {
        allCaptureDevices
            .filter { $0.position == .front }
    }
    
    private var backCaptureDevices: [AVCaptureDevice] {
        allCaptureDevices
            .filter { $0.position == .back }
    }
    
    private var captureDevices: [AVCaptureDevice] {
        var devices = [AVCaptureDevice]()
        #if os(macOS) || (os(iOS) && targetEnvironment(macCatalyst))
        devices += allCaptureDevices
        #else
        if let backDevice = backCaptureDevices.first {
            devices += [backDevice]
        }
        if let frontDevice = frontCaptureDevices.first {
            devices += [frontDevice]
        }
        #endif
        return devices
    }
    
    private var availableCaptureDevices: [AVCaptureDevice] {
        captureDevices
            .filter( { $0.isConnected } )
            .filter( { !$0.isSuspended } )
    }
    
    private var captureDevice: AVCaptureDevice? {
        didSet {
            guard let captureDevice = captureDevice else { return }
            logger.debug("Using capture device: \(captureDevice.localizedName)")
            sessionQueue.async {
                self.updateSessionForCaptureDevice(captureDevice)
            }
        }
    }
    
    var isRunning: Bool {
        session.isRunning
    }
    
    var isUsingFrontCaptureDevice: Bool {
        guard let captureDevice = captureDevice else { return false }
        return frontCaptureDevices.contains(captureDevice)
    }
    
    var isUsingBackCaptureDevice: Bool {
        guard let captureDevice = captureDevice else { return false }
        return backCaptureDevices.contains(captureDevice)
    }

    private var addToPhotoStream: ((AVCapturePhoto) -> Void)?
    
    private var addToPreviewStream: ((CIImage) -> Void)?
    
    var isPreviewPaused = false
    
    lazy var previewStream: AsyncStream<CIImage> = {
        AsyncStream { continuation in
            addToPreviewStream = { ciImage in
                if !self.isPreviewPaused {
                    continuation.yield(ciImage)
                }
            }
        }
    }()
    
    lazy var photoStream: AsyncStream<AVCapturePhoto> = {
        AsyncStream { continuation in
            addToPhotoStream = { photo in
                continuation.yield(photo)
            }
        }
    }()
        
    override init() {
        super.init()
        initialize()
    }
    
    private func initialize() {
        sessionQueue = DispatchQueue(label: "session queue")
        
        captureDevice = availableCaptureDevices.first ?? AVCaptureDevice.default(for: .video)
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(updateForDeviceOrientation), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    private func configureCaptureSession(completionHandler: (_ success: Bool) -> Void) {
        
        var success = false
        
        self.captureSession.beginConfiguration()
        
        defer {
            self.captureSession.commitConfiguration()
            completionHandler(success)
        }
        
        guard
            let captureDevice = captureDevice,
            let deviceInput = try? AVCaptureDeviceInput(device: captureDevice)
        else {
            logger.error("Failed to obtain video input.")
            return
        }
        
//        let photoOutput = AVCapturePhotoOutput()
                        
        session.sessionPreset = AVCaptureSession.Preset.photo

        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "VideoDataOutputQueue"))
  
        guard session.canAddInput(deviceInput) else {
            logger.error("Unable to add device input to capture session.")
            return
        }
//        guard captureSession.canAddOutput(photoOutput) else {
//            logger.error("Unable to add photo output to capture session.")
//            return
//        }
        guard session.canAddOutput(videoOutput) else {
            logger.error("Unable to add video output to capture session.")
            return
        }
        
        session.addInput(deviceInput)
//        captureSession.addOutput(photoOutput)
        session.addOutput(videoOutput)
        
        self.deviceInput = deviceInput
//        self.photoOutput = photoOutput
        self.videoOutput = videoOutput
        
        if self.session.canAddOutput (self.output) {
            self.session.addOutput (self.output)
        }
        
//        photoOutput.isHighResolutionCaptureEnabled = true
//        photoOutput.maxPhotoQualityPrioritization = .quality
        
        updateVideoOutputConnection()
        
        isCaptureSessionConfigured = true
        
        success = true
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
        
        print("outputfileURL:  -  \(outputfileURL)")
        self.recordedURLs.append(outputfileURL)
        self.previewURL = outputfileURL

//        if self.recordedURLs.count == 1{
//            self.previewURL = outputfileURL
//            return
//        }
        print("apendedfg : -- \(previewURL!)")

        let assets = recordedURLs.compactMap{ url -> AVURLAsset in
            return AVURLAsset (url: url)
            print("urlurl:  -  \(url)")
        }
        
        self.previewURL = nil
        
        mergeVideos(assets: assets) { exporter in
            exporter.exportAsynchronously {
                if exporter.status == .failed{
                    print (exporter.error!.localizedDescription)
                }else{
                    print("apended")
                    if let finalURL = exporter.outputURL {
                        print("finalURL:  -  \(finalURL)")
                        DispatchQueue.main.async {
                            self.previewURL = finalURL
                            print("previewURL22:  -  \(self.previewURL)")
                        }
                    }else{
                        print("apended34567")
                    }
                }
                print("apended234")

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
    
    
    
    
    
    
    
    private func checkAuthorization() async -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            logger.debug("Camera access authorized.")
            return true
        case .notDetermined:
            logger.debug("Camera access not determined.")
            sessionQueue.suspend()
            let status = await AVCaptureDevice.requestAccess(for: .video)
            sessionQueue.resume()
            return status
        case .denied:
            logger.debug("Camera access denied.")
            return false
        case .restricted:
            logger.debug("Camera library access restricted.")
            return false
        @unknown default:
            return false
        }
    }
    
    private func deviceInputFor(device: AVCaptureDevice?) -> AVCaptureDeviceInput? {
        guard let validDevice = device else { return nil }
        do {
            return try AVCaptureDeviceInput(device: validDevice)
        } catch let error {
            logger.error("Error getting capture device input: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func updateSessionForCaptureDevice(_ captureDevice: AVCaptureDevice) {
        guard isCaptureSessionConfigured else { return }
        
        session.beginConfiguration()
        defer { session.commitConfiguration() }

        for input in session.inputs {
            if let deviceInput = input as? AVCaptureDeviceInput {
                session.removeInput(deviceInput)
            }
        }
        
        if let deviceInput = deviceInputFor(device: captureDevice) {
            if !session.inputs.contains(deviceInput), session.canAddInput(deviceInput) {
                session.addInput(deviceInput)
            }
        }
        
        updateVideoOutputConnection()
    }
    
    private func updateVideoOutputConnection() {
        if let videoOutput = videoOutput, let videoOutputConnection = videoOutput.connection(with: .video) {
            if videoOutputConnection.isVideoMirroringSupported {
                videoOutputConnection.isVideoMirrored = isUsingFrontCaptureDevice
            }
        }
    }
    
    func start() async {
        let authorized = await checkAuthorization()
        guard authorized else {
            logger.error("Camera access was not authorized.")
            return
        }
        
        if isCaptureSessionConfigured {
            if !session.isRunning {
                sessionQueue.async { [self] in
                    self.session.startRunning()
                }
            }
            return
        }
        
        sessionQueue.async { [self] in
            self.configureCaptureSession { success in
                guard success else { return }
                self.session.startRunning()
            }
        }
    }
    
    func stop() {
        guard isCaptureSessionConfigured else { return }
        
        if session.isRunning {
            sessionQueue.async {
                self.session.stopRunning()
            }
        }
    }
    
    func switchCaptureDevice() {
        if let captureDevice = captureDevice, let index = availableCaptureDevices.firstIndex(of: captureDevice) {
            let nextIndex = (index + 1) % availableCaptureDevices.count
            self.captureDevice = availableCaptureDevices[nextIndex]
        } else {
            self.captureDevice = AVCaptureDevice.default(for: .video)
        }
    }

    private var deviceOrientation: UIDeviceOrientation {
        var orientation = UIDevice.current.orientation
        if orientation == UIDeviceOrientation.unknown {
            orientation = UIScreen.main.orientation
        }
        return orientation
    }
    
    @objc
    func updateForDeviceOrientation() {
        //TODO: Figure out if we need this for anything.
    }
    
    private func videoOrientationFor(_ deviceOrientation: UIDeviceOrientation) -> AVCaptureVideoOrientation? {
        switch deviceOrientation {
        case .portrait: return AVCaptureVideoOrientation.portrait
        case .portraitUpsideDown: return AVCaptureVideoOrientation.portraitUpsideDown
        case .landscapeLeft: return AVCaptureVideoOrientation.landscapeRight
        case .landscapeRight: return AVCaptureVideoOrientation.landscapeLeft
        default: return nil
        }
    }
    
//    func takePhoto() {
//        guard let photoOutput = self.photoOutput else { return }
//        
//        sessionQueue.async {
//        
//            var photoSettings = AVCapturePhotoSettings()
//
//            if photoOutput.availablePhotoCodecTypes.contains(.hevc) {
//                photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
//            }
//            
//            let isFlashAvailable = self.deviceInput?.device.isFlashAvailable ?? false
//            photoSettings.flashMode = isFlashAvailable ? .auto : .off
//            photoSettings.isHighResolutionPhotoEnabled = true
//            if let previewPhotoPixelFormatType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
//                photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPhotoPixelFormatType]
//            }
//            photoSettings.photoQualityPrioritization = .balanced
//            
//            if let photoOutputVideoConnection = photoOutput.connection(with: .video) {
//                if photoOutputVideoConnection.isVideoOrientationSupported,
//                    let videoOrientation = self.videoOrientationFor(self.deviceOrientation) {
//                    photoOutputVideoConnection.videoOrientation = videoOrientation
//                }
//            }
//            
//            photoOutput.capturePhoto(with: photoSettings, delegate: self)
//        }
//    }
}

//extension Camera: AVCapturePhotoCaptureDelegate {
//    
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        
//        if let error = error {
//            logger.error("Error capturing photo: \(error.localizedDescription)")
//            return
//        }
//        
//        addToPhotoStream?(photo)
//    }
//}

//extension Camera: AVCaptureVideoDataOutputSampleBufferDelegate {
//    
//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        guard let pixelBuffer = sampleBuffer.imageBuffer else { return }
//        
//        if connection.isVideoOrientationSupported,
//           let videoOrientation = videoOrientationFor(deviceOrientation) {
//            connection.videoOrientation = videoOrientation
//        }
//
//        addToPreviewStream?(CIImage(cvPixelBuffer: pixelBuffer))
//    }
//}

fileprivate extension UIScreen {

    var orientation: UIDeviceOrientation {
        let point = coordinateSpace.convert(CGPoint.zero, to: fixedCoordinateSpace)
        if point == CGPoint.zero {
            return .portrait
        } else if point.x != 0 && point.y != 0 {
            return .portraitUpsideDown
        } else if point.x == 0 && point.y != 0 {
            return .landscapeRight //.landscapeLeft
        } else if point.x != 0 && point.y == 0 {
            return .landscapeLeft //.landscapeRight
        } else {
            return .unknown
        }
    }
}

fileprivate let logger = Logger(subsystem: "com.apple.swiftplaygroundscontent.capturingphotos", category: "Camera")

