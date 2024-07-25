//
//  SendButtons.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 11/25/23.
//

import SwiftUI

struct SendButtons: View {
    var text: String
    var imageName: String
    var backgroundColor: Color
    var itemColor: Color
    var body: some View {
        VStack(alignment: .center, spacing: 10){
            ZStack(alignment: .center){
                Circle()
                    .fill(backgroundColor)
                    .frame(width: 60)
                Image(systemName: imageName)
                    .font(.system(size: 24))
                    .foregroundStyle(itemColor)
                    .cornerRadius(.infinity)
            }
            Text(text)
                .font(.body)
                .foregroundStyle(Color(K.Colors.text))
        }
    }
}

struct FinalPreviewButtons: View {
    var imageName: String
    var backgroundColor: Color
    var itemColor: Color
    var opacity: Double
    var paddingBottom: CGFloat
    var body: some View {
        VStack(alignment: .center, spacing: 10){
            ZStack(alignment: .center){
                Circle()
                    .fill(backgroundColor)
                    .opacity(opacity)
                    .frame(width: 60)
                Image(systemName: imageName)
                    .font(.system(size: 24))
                    .foregroundStyle(itemColor)
                    .padding(.bottom, paddingBottom)
                    .cornerRadius(.infinity)
            }
        }
    }
}

struct SupportButton: View{
    var text: String
    var systemImage: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 5){
            if text.isEmpty{
                Image(systemName: systemImage)
    //                .font(.system(size: 24))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 24)
                    .foregroundStyle(Color(K.Colors.text))
            }else{
                Text(text)
                    .font(.system(size: 12))
                    .foregroundStyle(Color(K.Colors.text))
            }
            
        }
        //        .padding(10)
        .padding(.vertical, 7)
        .frame(minHeight: 50)
        .frame(maxWidth: .infinity)
        .background{
//            Color(K.Colors.mainColor).opacity(0.5)
            TransparentBlurView(removeAllFilters: true)
                .blur(radius: 9, opaque: true)
                .background(Color(K.Colors.text).opacity(0.1))
                .cornerRadius(7)
        }
        .cornerRadius(15)
    }
}

