//
//  Reactions.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 10/20/23.
//

import Foundation
import SwiftUI

struct ReactionButtonsView: View {
    var body: some View {
        HStack {
            ReactionButton(imageName: "thumbsup.fill", fliped: false)
            ReactionButton(imageName: "arrowshape.bounce.right", fliped: true)
            ReactionButton(imageName: "arrowshape.bounce.right", fliped: false)
        }
    }
}

struct ReactionButton: View {
    let imageName: String
    let fliped: Bool
    var body: some View {
        Button(action: {
            // Handle the reaction action here
            print("You reacted with \(imageName)")
        }) {
            VStack {
                Image(systemName: imageName)
                    .resizable()
                    .scaleEffect(x: fliped ? -1 : 0, y: fliped ? 1 : 0)
                    .frame(width: 30, height: 30)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
