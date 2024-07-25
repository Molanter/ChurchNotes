//
//  VideoThumbnailView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 5/17/24.
//

import SwiftUI
import Photos

struct VideoThumbnailView: View {
    let videoURL: URL
    
    var body: some View {
        if let thumbnail = fetchThumbnail() {
            VStack(alignment: .center, spacing: 5) {
                Image(uiImage: thumbnail)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                Text(videoURL.lastPathComponent)
            }
        } else {
            Image(systemName: "film")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
        }
    }
    
    func fetchThumbnail() -> UIImage? {
        let asset = AVURLAsset(url: videoURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        do {
            let cgImage = try imageGenerator.copyCGImage(at: .zero, actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch {
            print("Error fetching thumbnail: \(error)")
            return nil
        }
    }
}

//#Preview {
//    VideoThumbnailView()
//}
