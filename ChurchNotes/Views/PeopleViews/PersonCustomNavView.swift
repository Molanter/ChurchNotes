//
//  PersonCustomNavView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 1/19/24.
//

import SwiftUI

struct PersonCustomNavView: View {
    var item: Person
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            ResizableHeader(size: size, safeArea: safeArea, item: item)
                .ignoresSafeArea(.all, edges: .top)
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

//#Preview {
//    PersonCustomNavView()
//}
