//
//  VideoPicker.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 5/17/24.
//

import SwiftUI
import Photos

struct VideoPicker: View {
    @StateObject var frontCameraModel = FrontCameraModel()

    @Binding var selectedVideoURL: URL?
    
    @State private var videos: [URL] = []
    @State private var videosWithThumbnails: [(URL, UIImage?)] = []

    var body: some View {
            NavigationView {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                        ForEach(videosWithThumbnails, id: \.0) { videoURL, thumbnail in
                            Button(action: {
                                selectedVideoURL = videoURL
                                frontCameraModel.previewURL = videoURL
                                frontCameraModel.showPreview = true
                            }) {
                                if let thumbnail = thumbnail {
                                    Image(uiImage: thumbnail)
                                        .resizable()
                                        .scaledToFit()
                                } else {
                                    VStack(alignment: .center, spacing: 5) {
                                        Image(systemName: "film")
                                            .resizable()
                                            .scaledToFit()
                                        Text(videoURL.lastPathComponent)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
                .navigationTitle("Select Video")
                .onAppear {
                    loadVideosWithThumbnails()
                }
                .navigationBarItems(trailing: Button("Done") {
                    selectedVideoURL = nil
                })
            }
        }
        
        func loadVideosWithThumbnails() {
            videosWithThumbnails.removeAll()
            
            let videoOptions: PHFetchOptions = PHFetchOptions()
            videoOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .video, options: videoOptions)
            
            fetchResult.enumerateObjects { asset, _, _ in
                if asset.mediaType == .video {
                    let options = PHVideoRequestOptions()
                    options.isNetworkAccessAllowed = true
                    options.version = .original
                    PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { avAsset, _, _ in
                        if let urlAsset = avAsset as? AVURLAsset {
                            let url = urlAsset.url
                            let thumbnail = generateThumbnail(for: url)
                            DispatchQueue.main.async {
                                videosWithThumbnails.append((url, thumbnail))
                            }
                        }
                    }
                }
            }
        }
        
        func generateThumbnail(for videoURL: URL) -> UIImage? {
            let asset = AVURLAsset(url: videoURL)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            
            do {
                let cgImage = try imageGenerator.copyCGImage(at: .zero, actualTime: nil)
                return UIImage(cgImage: cgImage)
            } catch {
                print("Error generating thumbnail: \(error)")
                return nil
            }
        }
    }


//#Preview {
//    VideoPicker()
//}
