//
//  CurrentPersonView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/19/23.
//

import SwiftUI

struct CurrentPersonView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var cristian: Bool
    var name: String
    var phone: String
    var email: String
    var country: String
    var notes: String
    var profileImage: String
    var username: String
    var timeStamp: Date
    
    var body: some View {
            VStack{
                
                VStack{
                    ZStack(alignment: .bottom){
                        ZStack(alignment: .top){
                            Ellipse()
                                .foregroundColor(Color(K.Colors.mainColor))
                                .frame(width: 557.89917, height: 206.48558)
                                .cornerRadius(500)
                                .shadow( radius: 30)
                            Rectangle()
                                .foregroundColor(Color(K.Colors.mainColor))
                                .frame(width: 557.89917, height: 90)
                        }
                        VStack(alignment: .center){
                            Text(name)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .font(.title2)
                                .fontWeight(.medium)
                                .font(.system(size: 24))
                            if email != ""{
                                Text(email)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .font(.callout)
                                    .fontWeight(.light)
                                    .padding(.bottom)
                            }else{
                                HStack(spacing: 1){
                                    Text(timeStamp, format: .dateTime.month(.wide))
                                    Text(timeStamp, format: .dateTime.day())
                                    Text(", \(timeStamp, format: .dateTime.year()), ")
                                    Text(timeStamp, style: .time)
                                }
                                .multilineTextAlignment(.center)
                                .font(.callout)
                                .fontWeight(.light)
                                .foregroundColor(.white)
                                .foregroundStyle(.secondary)
                                .font(.system(size: 15))
                                .padding(.bottom)
                            }
                            if profileImage != ""{
                                AsyncImage(url: URL(string: profileImage)){image in
                                    image.resizable()
                                }placeholder: {
                                    ProgressView()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 40, height: 40)
                                }
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .cornerRadius(40)
                                .overlay(
                                    Circle().stroke(.white, lineWidth: 2)
                                )
                            }else{
                                ZStack(alignment: .center){
                                    Circle()
                                        .foregroundColor(Color(K.Colors.darkGray))
                                        .frame(width: 80, height: 80)
                                    Text(String(name.components(separatedBy: " ").compactMap { $0.first }).count >= 3 ? String(String(name.components(separatedBy: " ").compactMap { $0.first }).prefix(2)) : String(name.components(separatedBy: " ").compactMap { $0.first }))
                                        .font(.system(size: 35))
                                        .textCase(.uppercase)
                                        .foregroundColor(Color.white)
                                }
                                .overlay(
                                    Circle().stroke(.white, lineWidth: 2)
                                )
                            }
                            
                            
                        }
                        .offset(y: 35)
                    }
                    VStack(alignment: .leading, spacing: 15){
                        HStack(spacing: 20){
                            ZStack{
                                Circle()
                                    .foregroundStyle(Color(K.Colors.gray).opacity(0.5))
                                    .frame(width: 40, height: 40)
                                Image(systemName: "person")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20)
                                    .foregroundStyle(Color(K.Colors.mainColor))
                                    .fontWeight(.light)
                            }
                            Text(name.isEmpty ? "Name" : name)
                                .font(.title3)
                                .fontWeight(.light)
                                .font(.system(size: 20))
                        }
                        Divider()
                        HStack(spacing: 20){
                            ZStack{
                                Circle()
                                    .foregroundStyle(Color(K.Colors.gray).opacity(0.5))
                                    .frame(width: 40, height: 40)
                                Image(systemName: "clock")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20)
                                    .foregroundStyle(Color(K.Colors.mainColor))
                                    .fontWeight(.light)
                            }
                            HStack(spacing: 1){
                                Text(timeStamp, format: .dateTime.month(.twoDigits))
                                Text("/\(timeStamp, format: .dateTime.day())/")
                                Text(timeStamp, format: .dateTime.year())
                            }
                            .font(.title3)
                            .fontWeight(.light)
                            .font(.system(size: 18))
                        }
                        Divider()
                        HStack(spacing: 18){
                            ZStack{
                                Circle()
                                    .foregroundStyle(Color(K.Colors.gray).opacity(0.5))
                                    .frame(width: 40, height: 40)
                                Image(systemName: "phone")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20)
                                    .foregroundStyle(Color(K.Colors.mainColor))
                                    .fontWeight(.light)
                            }
                            Text(phone.isEmpty ? "Phone" : phone)
                                .multilineTextAlignment(.leading)
                                .lineLimit(10)
                                .font(.title3)
                                .fontWeight(.light)
                                .font(.system(size: 18))
                        }
                        Divider()
                        Spacer()
                    }
                    .padding(.top, 50)
                    .padding(.horizontal, 15)
                    .frame(maxHeight: .infinity)
                    Spacer()
                }
            }
        .navigationBarBackButtonHidden(false)
    }
}

//#Preview {
//    CurrentPersonView()
//}
