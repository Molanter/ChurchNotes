//
//  RowPersonModel.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 12/7/23.
//

import SwiftUI

struct RowPersonModel: View {
    @EnvironmentObject var viewModel: AppViewModel
    var item: Person

    var body: some View{
            HStack{
                ZStack(alignment: .bottomTrailing){
                    if item.imageData != ""{
                        AsyncImage(url: URL(string: item.imageData)){image in
                            image.resizable()
                            
                        }placeholder: {
                            ProgressView()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                        }
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .cornerRadius(20)
                        .overlay(
                            Circle().stroke(.gray.opacity(0.6), lineWidth: 1)
                        )
                    }else{
                        ZStack(alignment: .center){
                            Circle()
                                .foregroundColor(Color(K.Colors.darkGray))
                                .frame(width: 40, height: 40)
                            Text(viewModel.twoNames(name: item.name))
                                .textCase(.uppercase)
                                .foregroundColor(Color.white)
                        }
                        
                    }
                    //                                                Circle()
                    //                                                    .overlay(
                    //                                                        Circle().stroke(.white, lineWidth: 1)
                    //                                                    )
                    //                                                    .frame(width: 15)
                    //                                                    .foregroundColor(Color(K.Colors.green))
                }
                VStack(alignment: .leading, spacing: 3){
                    Text(item.name.capitalized )
                        .padding(.vertical, 3)
                        .fontWeight(.medium)
                        .foregroundStyle(.primary)
                        .font(.system(size: 13))
                    HStack(spacing: 1){
                        Text(item.timestamp, format: .dateTime.month(.wide))
                        Text(item.timestamp, format: .dateTime.day())
                        Text(", \(item.timestamp, format: .dateTime.year()), ")
                        Text(item.timestamp, style: .time)
                    }
                    .font(.system(size: 11))
                    .foregroundStyle(Color(K.Colors.lightGray))
                }
                Spacer()
                Image(systemName: item.isLiked ? "\(K.favouriteSign).fill" : "")
                    .foregroundStyle(Color(K.Colors.favouriteSignColor))
                    .contentTransition(.symbolEffect(.replace))
                    .padding()
                    .onTapGesture {
                        withAnimation{
                            viewModel.likePerson(documentId: item.documentId, isLiked: false)
                        }
                    }
            }

    }
}

//#Preview {
//    RowPersonModel()
//}
