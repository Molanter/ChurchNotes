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

//#Preview {
//    SendButtons()
//}
