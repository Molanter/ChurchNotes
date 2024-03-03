//
//  RowPersonModel.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 12/7/23.
//

import SwiftUI

struct RowPersonModel: View {
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var published: PublishedVariebles
    
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
                }
                
                VStack(alignment: .leading, spacing: 3){
                    Text(item.name.capitalized )
                        .padding(.vertical, 3)
                        .fontWeight(.medium)
                        .foregroundStyle(.primary)
                        .font(.footnote)
                    HStack(spacing: 1){
                        Text(item.timestamp, format: .dateTime.month(.wide))
                        Text(item.timestamp, format: .dateTime.day())
                        Text(", \(item.timestamp, format: .dateTime.year()), ")
                        Text(item.timestamp, style: .time)
                    }
                    .font(.caption2)
                    .foregroundStyle(Color(K.Colors.lightGray))
                }
                Spacer()
                if !published.isEditing{
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
//            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .contentShape(RoundedRectangle(cornerRadius: 10))
            .onTapGesture(count: 2, perform: {
                if !published.isEditing{
                    published.deletePeopleArray.removeAll()
                    viewModel.likePerson(documentId: item.documentId, isLiked: true)
                }
            })
            .onTapGesture(count: 1, perform: {
                if !published.isEditing{
                    published.deletePeopleArray.removeAll()
                    published.currentItem = item
                }
            })
    }
}

//#Preview {
//    RowPersonModel()
//}
