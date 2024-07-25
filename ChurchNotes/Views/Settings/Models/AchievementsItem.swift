//
//  AchievementsItem.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 11/28/23.
//

import SwiftUI

struct AchievementsItem: View {
    var text: String
    var backgroundImage: String
    var image: String
    var imageSize: CGFloat
    var score: String
    var image2: String?
    var imageColor: Color?
    
    var body: some View {
        VStack(alignment: .center, spacing: 0){
            ZStack(alignment: .center){
                Image(systemName: backgroundImage)
                    .foregroundStyle(.secondary)
                    .font(.system(size: 120))
                    .fontWeight(.thin)
                VStack(alignment: .center, spacing: 5){
                    if image2 == ""{
                        Image(systemName: image)
                            .foregroundStyle(imageColor == nil ? .primary : imageColor ?? Color.black)
                            .font(.system(size: imageSize))
                    }else{
                        ZStack(alignment: .center){
                            Image(systemName: image)
                                .foregroundStyle(imageColor == nil ? .primary : imageColor ?? Color.black)
                                .font(.system(size: imageSize))
                            Text(image2 ?? "")
                                .padding(.bottom, 18)
                                .foregroundStyle(imageColor == nil ? .primary : imageColor ?? Color.black)
                                .bold()
                        }
                    }
                    Text(score)
                        .fontWeight(.medium)
                }
            }
            Text(text)
                .foregroundStyle(.primary)
                .fontWeight(.bold)
        }
    }
}

#Preview {
    AchievementsItem(text: "Done", backgroundImage: "shield.fill", image: "trophy", imageSize: 40, score: "5/10", image2: "1")
}
