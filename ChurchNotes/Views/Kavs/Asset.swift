//
//  Asset.swift
//  Signal_ImagePicker (iOS)
//
//  Created by Balaji on 09/02/21.
//

import SwiftUI
import Photos
import AVKit

struct Asset: Identifiable {
    var id = UUID().uuidString
    var asset: PHAsset
    var image: UIImage
}

struct PreviewView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var imagePicker: ImagePickerViewModel
    
    @Binding var show: Bool
    var from: String
    var uid: String
    
    var body: some View{
        
        // For Top Buttons...
        
        NavigationView{
            
            ZStack{
                
                if imagePicker.selectedVideoPreview != nil{
                    
                    VideoPlayer(player: AVPlayer(playerItem: AVPlayerItem(asset: imagePicker.selectedVideoPreview)))
                }
                
                if imagePicker.selectedImagePreview != nil{
                    
                    Image(uiImage: imagePicker.selectedImagePreview)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            .ignoresSafeArea(.all, edges: .bottom)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
            
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button(action: {
                        viewModel.sentMessage(message: "", image: imagePicker.selectedImagePreview, type: "/image", from: from)
                        viewModel.setLastMessage(message: "", image: true, type: "/image", uid: uid)
                        imagePicker.selectedImagePreview = nil
                        self.show = false
                    }, label: {
                        Text("Send")
                            .foregroundStyle(K.Colors.mainColor)
                    })
                }
            })
        }
    }
}

struct ThumbnailView: View {
    
    var photo: Asset
    
    var body: some View{
        
        ZStack(alignment: .bottomTrailing, content: {
            
            Image(uiImage: photo.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .cornerRadius(10)
            
            // If Its Video
            // Displaying Video Icon...
            
            if photo.asset.mediaType == .video{
                Image(systemName: "video.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(8)
            }
        })
    }
}
