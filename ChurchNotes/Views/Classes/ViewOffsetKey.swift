//
//  ViewOffsetKey.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 11/15/23.
//

import SwiftUI

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}
