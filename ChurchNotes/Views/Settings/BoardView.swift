//
//  OnBoardView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 1/1/24.
//

import SwiftUI

struct OnBoardView: View {
    
    
    var body: some View {
        VStack(alignment: .center, spacing: 15){
            ZStack(alignment: .center){
                Image(systemName: "trophy")
                    .font(.system(size: 55))
                    .fontWeight(.medium)
                    .foregroundStyle(Color("orangee"))
            }
        }
    }
}

//#Preview {
//    OnBoardView()
//}
