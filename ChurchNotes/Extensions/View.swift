//
//  View.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 3/14/24.
//

import SwiftUI

extension View {
    func navigationBarBackground(_ background: Color = K.Colors.mainColor) -> some View {
    return self
      .modifier(ColoredNavigationBar(background: background))
  }
}

struct ColoredNavigationBar: ViewModifier {
  var background: Color
  
  func body(content: Content) -> some View {
    content
      .toolbarBackground(
        background,
        for: .navigationBar
      )
      .toolbarBackground(.visible, for: .navigationBar)
  }
}
