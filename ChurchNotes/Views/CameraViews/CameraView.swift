//
//  CameraView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 8/12/23.
//

import SwiftUI

struct CameraView: View {
    @StateObject var camera = CameraModel()
    
    var body: some View {
        ZStack(alignment: .bottom){
            GeometryReader{ proxy in
                let size = proxy.size
                CameraPreview(size: size)
                    .environmentObject (camera)
            }
            ZStack{
                Button(action: {
                    
                }){
                    Image(systemName: "video")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(Color(K.Colors.mainColor))
                        .padding(10)
                        .frame(width: 60, height: 60)
                        .background(
                            Circle()
                                .stroke(.black)
                        )
                        .padding (6)
                        .background{
                            Circle()
                                .fill(.white)
                        }
                }
                
                Button(action:  {
                    
                }){
                    Label {
                        Image (systemName: "chevron.right")
                            .font (.callout)
                    } icon:{
                        Text ("Preview")
                    }
                    .foregroundColor (.black)
                    .padding(.horizontal,20)
                    .padding (.vertical,8)
                    .background{
                        Capsule()
                            .fill(.white)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, 10)
                .padding(.bottom, 30)
        }
        .onAppear{
            camera.check()
        }
    }
}

#Preview {
    CameraView()
}
