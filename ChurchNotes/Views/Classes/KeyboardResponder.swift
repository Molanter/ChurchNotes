//
//  KeyboardResponder.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 12/10/23.
//

import SwiftUI

class KeyboardResponder: ObservableObject {
    @Published var keyboardHeight: CGFloat = 0

    var keyboardWillShow: NotificationCenter.Publisher {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
    }

    var keyboardWillHide: NotificationCenter.Publisher {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
    }

    init() {
        keyboardWillShow
            .map { notification in
                (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
            }
            .assign(to: \.keyboardHeight, on: self)

        keyboardWillHide
            .map { _ in CGFloat(0) }
            .assign(to: \.keyboardHeight, on: self)
    }
}
