//
//  NoStageView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/23/24.
//

import SwiftUI

struct NoStageView: View {
    @Binding var presentStageSheet: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            Image(systemName: "questionmark.folder")
                .font(.largeTitle)
            Text("you-do-not-have-your-own-stages-yet")
                .font(.title)
                .bold()
            Text("create-your-first-stage-to-see-it-here")
                .font(.title2)
            Button(action: {
                self.presentStageSheet.toggle()
            }){
                HStack{
                    Spacer()
                    Text("create")
                        .foregroundColor(Color.white)
                        .padding(.vertical, 10)
                        .padding(.leading)
                    Image(systemName: "folder.badge.plus")
                        .foregroundColor(Color.white)
                        .padding(.leading)
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
            .background(K.Colors.mainColor)
            .cornerRadius(7)
        })
        .padding(.horizontal, 15)
        .padding(.horizontal, 15)
    }
}

//#Preview {
//    NoStageView()
//}
