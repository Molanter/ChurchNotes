//
//  NoPeopleView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/23/24.
//

import SwiftUI

struct NoPeopleView: View {
    @Binding var presentStageSheet: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            Image(systemName: "person.fill.questionmark")
                .font(.largeTitle)
            Text("you-do-not-have-people-yet")
                .font(.title)
                .bold()
            Text("add-your-first-person")
                .font(.title2)
            Button(action: {
                self.presentStageSheet.toggle()
            }){
                HStack{
                    Spacer()
                    Text("add")
                        .foregroundColor(Color.white)
                        .padding(.vertical, 10)
                        .padding(.leading)
                    Image(systemName: "person.fill.badge.plus")
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
    }
}

//#Preview {
//    NoPeopleView()
//}
