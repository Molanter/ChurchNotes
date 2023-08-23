//
//  CornerRotateModifier.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 8/21/23.
//

import Foundation
import SwiftUI

struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint

    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: 180, anchor: .center),
            identity: CornerRotateModifier(amount: 0, anchor: .center)
        )
    }
}