//
//  BadgeCount.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 4/4/24.
//

import SwiftUI

struct BadgeCount: View {
    let count: Int

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.clear
            Text(String(count >= 99 ? 99 : count))
                .font(.system(size: 14))
                .padding(5)
                .background(Color.red)
                .clipShape(Circle())
                .foregroundStyle(Color.white)
                .alignmentGuide(.top) { $0[.bottom] }
                .alignmentGuide(.trailing) { $0[.trailing] - $0.width * 0.25 }
        }
        .padding(.top, 5)
    }
}
