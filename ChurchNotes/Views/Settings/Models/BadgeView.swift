//
//  BadgeView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 5/8/24.
//

import SwiftUI

struct BadgeView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    let width: Int
    
    var body: some View {
        if let badg = viewModel.currentUser?.badge{
            if let b = Badges().getBadgeArray()[badg] as? Badge{
                if b.type == "string" {
                    Text(b.string)
                        .foregroundStyle(Color.white)
                        .font(.system(size: CGFloat(width)))
                        .padding(4)
                        .background(
                            Circle()
                                .fill(K.Colors.mainColor)
                                .opacity(0.7)
                        )
                }else if b.type == "sfSymbol" {
                    Image(systemName: b.image)
                        .foregroundStyle(Color.white)
                        .font(.system(size: CGFloat(width)))
                        .padding(4)
                        .background(
                            Circle()
                                .fill(K.Colors.mainColor)
                                .opacity(0.7)
                        )
                }else if b.type == "image" {
                    Image(systemName: b.image)
                        .foregroundStyle(Color.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: CGFloat(width))
                        .padding(4)
                        .background(
                            Circle()
                                .fill(K.Colors.mainColor)
                                .opacity(0.7)
                        )
                }
            }
        }
    }
}

//#Preview {
//    BadgeView()
//}
