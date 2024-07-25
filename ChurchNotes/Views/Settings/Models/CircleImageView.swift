//
//  CircleImageView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 5/10/24.
//

import SwiftUI

struct CircleImageView: View {
    var image: UIImage
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .frame(width: 15, height: 15)
            .aspectRatio(contentMode: .fill)
            .cornerRadius(.infinity)
//            .clipShape(.circle)
    }
}

//#Preview {
//    CircleImageView()
//}
