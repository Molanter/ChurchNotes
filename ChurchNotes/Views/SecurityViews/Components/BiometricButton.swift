//
//  BiometricButton.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 5/21/24.
//

import SwiftUI
import LocalAuthentication

struct BiometricButton: View {
    let biometricType: LABiometryType
    let width: CGFloat
    let tryBiometricAuthentication: () -> Void

    var body: some View {
        Button(action: tryBiometricAuthentication) {
            VStack {
                Spacer()
                Image(systemName: biometricType == .none ? "" : (biometricType == .faceID ? "faceid" : "touchid"))
                    .font(.largeTitle)
                Spacer()
            }
            .foregroundStyle(Color(K.Colors.text))
            .frame(width: width, height: width, alignment: .top)
            .padding(10)
            .clipShape(Circle())
        }
    }
}
