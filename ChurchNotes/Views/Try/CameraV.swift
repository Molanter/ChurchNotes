/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

struct CameraV: View {
    @StateObject private var model = DataModel()
    @StateObject private var cam = Camera()

    private static let barHeightFactor = 0.15
    
    
    var body: some View {
        Group{
            if let url = cam.previewURL{
                FinalPreview(recipients: ["3235953205"], message: "Let's goo!", url: url, showPreview: $cam.showPreview)
                    .onAppear{
                        print("Why")
                    }
            }else{
                NavigationStack {
                    GeometryReader { geometry in
                        CameraPreview(size: geometry.size)

//                        ViewfinderView(image:  $model.viewfinderImage )
                        //                    .sheet(isPresented: $cam.showPreview, content: {
                        //                        if let url = cam.previewURL{
//                                                    FinalPreview(recipients: ["3235953205"], message: "Let's goo!", url: url, showPreview: $cam.showPreview)
                        //                        }
                        //                    })
                            .overlay(alignment: .top) {
                                upView()
                                    .frame(height: geometry.size.height * Self.barHeightFactor)
                                    .background(.black.opacity(0.75))
                            }
                            .overlay(alignment: .bottom) {
                                buttonsView()
                                    .frame(height: geometry.size.height * Self.barHeightFactor)
                                    .background(.black.opacity(0.75))
                            }
                            .overlay(alignment: .center)  {
                                Color.clear
                                    .frame(height: geometry.size.height * (1 - (Self.barHeightFactor * 2)))
                                    .accessibilityElement()
                                    .accessibilityLabel("View Finder")
                                    .accessibilityAddTraits([.isImage])
                            }
                            .onChange(of: cam.previewURL, {
                                print("Why  2345 ")
                            })
                            .background(.black)
                    }
                    .task {
                        await model.camera.start()
                        await model.loadPhotos()
                        await model.loadThumbnail()
                    }
                    .navigationTitle("Camera")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarHidden(true)
                    .ignoresSafeArea()
                    .statusBar(hidden: true)
                    
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    private func upView() -> some View {
        HStack{
            Button {
                cam.recordedDuration = 0
                cam.previewURL = nil
                cam.recordedURLs.removeAll()
            } label: {
                Image (systemName: "xmark" )
                    .font(.title)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding()
            
            Spacer()
            
            Button {
                model.camera.switchCaptureDevice()
            } label: {
                Label("Switch Camera", systemImage: "arrow.triangle.2.circlepath")
                    .font(.system(size: 36))
                    .foregroundColor(.white)
            }
            
        
        }
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
        .padding()
    }

    
    private func buttonsView() -> some View {
        HStack{
            
            
            NavigationLink {
                PhotoCollectionView(photoCollection: model.photoCollection)
                    .onAppear {
                        model.camera.isPreviewPaused = true
                    }
                    .onDisappear {
                        model.camera.isPreviewPaused = false
                    }
            } label: {
                Label {
                    Text("Gallery")
                } icon: {
                    ThumbnailView(image: model.thumbnailImage)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            
            Button {
                if model.camera.isRecording{
                    model.camera.stopRecording()
                }else{
                    model.camera.startRecording()
                }
            } label: {
                Label {
                    Text("Take Photo")
                } icon: {
                    ZStack {
                        Circle()
                            .strokeBorder(.white, lineWidth: 3)
                            .frame(width: 62, height: 62)
                        Circle()
                            .fill(model.camera.isRecording ? .red : .white)
                            .frame(width: 50, height: 50)
                        Image(systemName: "video")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(Color(K.Colors.mainColor))
                            .padding(10)
                            .frame(width: 60, height: 60)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)

            Button{
                if let _ = model.camera.previewURL{
                    print("show")
                    cam.showPreview.toggle()
                }
            } label: {
                Group{
                    if model.camera.previewURL == nil && model.camera.recordedURLs.isEmpty{
                        // Merging Videos
                        ProgressView()
                            .tint(.black)
                    }else{
                        Label {
                        Image (systemName: "chevron.right" )
                            .font (.callout)
                    } icon: {
                        Text ("Preview")
                            .lineLimit(1)
                    }
                                    }
                }
                .onChange(of: cam.previewURL, {
                    print("cam.recordedURLs:  -  \(cam.recordedURLs)")
                })

                .foregroundColor (.black)
                .padding(.horizontal,20)
                .padding (.vertical,8)
                .background{
                    Capsule()
                        .fill(.white)
                }
            }
            .onChange(of: cam.showPreview, {
                print("Why  222 ")
            })
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing)
            .opacity ((model.camera.previewURL == nil && model.camera.recordedURLs.isEmpty) ||
                      model.camera.isRecording ? 0 : 1)
            
        
        }
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
        .padding()
    }
    
}
