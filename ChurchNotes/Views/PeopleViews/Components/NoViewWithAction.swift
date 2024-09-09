//
//  NoViewWithAction.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/23/24.
//

import SwiftUI

struct NoViewWithAction: View {
    let image: String
    let title: String
    let description: String
    let buttonText: String
    let buttonAction: () -> Void
    let buttonImage: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            Image(systemName: image)
                .font(.largeTitle)
            Text(title)
                .font(.title)
                .bold()
            Text(description)
                .font(.title2)
            Button(action: {
                buttonAction()
            }){
                HStack{
                    Spacer()
                    Text(buttonText)
                        .foregroundColor(Color.white)
                        .padding(.vertical, 10)
                        .padding(.leading)
                    Image(systemName: buttonImage)
                        .foregroundColor(Color.white)
                        .padding(.leading)
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
            .background(K.Colors.mainColor)
            .cornerRadius(7)
        })
        .padding(.horizontal, 15)
    }
}

//#Preview {
//    NoViewWithAction()
//}
