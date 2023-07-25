//
//  ItemPersonView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/6/23.
//

import SwiftUI
import SwiftData

struct ItemPersonView: View {
    @Bindable var item: Items
//    @Bindable var itemTitles: ItemsTitle
    @State var edit = false
    @Query (sort: \ItemsTitle.timeStamp, order: .forward, animation: .spring) var titles: [ItemsTitle]
    @State var selectedTheme = ""
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack{
            VStack{
                if edit{
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
                            Text(item.name == "" ? "Name" : item.name)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .font(.title2)
                                .fontWeight(.medium)
                                .font(.system(size: 24))
                            if item.email != ""{
                                Text(item.email)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .font(.callout)
                                    .fontWeight(.light)
                                    .padding(.bottom)
                            }else{
                                HStack(spacing: 1){
                                    Text(item.timestamp, format: .dateTime.month(.wide))
                                    Text(item.timestamp, format: .dateTime.day())
                                    Text(", \(item.timestamp, format: .dateTime.year()), ")
                                    Text(item.timestamp, style: .time)
                                }
                                .multilineTextAlignment(.center)
                                .font(.callout)
                                .fontWeight(.light)
                                .foregroundColor(.white)
                                .foregroundStyle(.secondary)
                                .font(.system(size: 15))
                                .padding(.bottom)
                            }
                            if item.imageData != nil{
                                if let img = item.imageData{
                                    Image(uiImage: UIImage(data: img)!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 80, height: 80)
                                        .cornerRadius(40)
                                        .overlay(
                                            Circle().stroke(.white, lineWidth: 2)
                                        )
                                }
                            }else{
                                ZStack(alignment: .center){
                                    Circle()
                                        .foregroundColor(Color(K.Colors.darkGray))
                                        .frame(width: 80, height: 80)
                                    Text(String(item.name.components(separatedBy: " ").compactMap { $0.first }).count >= 3 ? String(String(item.name.components(separatedBy: " ").compactMap { $0.first }).prefix(2)) : String(item.name.components(separatedBy: " ").compactMap { $0.first }))
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
                            HStack{
                                TextField(item.name.isEmpty ? "Name" : item.name, text: $item.name)
                                    .font(.title3)
                                    .fontWeight(.light)
                                    .font(.system(size: 20))
                                    .padding(10)
                            }
                            .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.06), radius: 4, x: 0, y: 4)
                            .overlay(
                                RoundedRectangle(cornerSize: .init(width: 7, height: 7))
                                    .stroke(Color(K.Colors.justLightGray).opacity(0.5), lineWidth: 1)
                            )
                        }
                        Divider()
//                        HStack(spacing: 18){
//                            ZStack{
//                                Circle()
//                                    .foregroundStyle(Color(K.Colors.gray).opacity(0.5))
//                                    .frame(width: 40, height: 40)
//                                Image(systemName: "bell")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .frame(width: 20)
//                                    .foregroundStyle(Color(K.Colors.bluePurple))
//                                    .fontWeight(.light)
//                            }
//                            HStack{
//                                Picker("Item", selection: $selectedTheme) {
//                                    ForEach(titles, id: \.self) {item in
//                                        Text(item.name).tag(item.name)
//                                    }
//                                }
//                                .onChange(of: selectedTheme) {
//                                    selectedTheme = $0
//                                    let newItem = Items(name: self.item.name, isLiked: self.item.isLiked, isCheked: self.item.isCheked, notes: self.item.notes, imageData: self.item.imageData, email: self.item.email)
//                                    titles.name.contains(selectedTheme)
//                                    
//                                }
//                                .pickerStyle(.menu)
//                                .onAppear{
//                                    selectedTheme = itemTitle.name
//                                }
//                                .padding(7)
//                                Spacer()
//                            }
//                            .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.06), radius: 4, x: 0, y: 4)
//                            .overlay(
//                                RoundedRectangle(cornerSize: .init(width: 7, height: 7))
//                                    .stroke(Color(K.Colors.justLightGray).opacity(0.5), lineWidth: 1)
//                            )
//                            
//                        }
//                        Divider()
                        HStack(spacing: 20){
                            ZStack{
                                Circle()
                                    .foregroundStyle(Color(K.Colors.gray).opacity(0.5))
                                    .frame(width: 40, height: 40)
                                Image(systemName: "envelope")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20)
                                    .foregroundStyle(Color(K.Colors.mainColor))
                                    .fontWeight(.light)
                            }
                            HStack{
                                TextField(item.email.isEmpty ? "Email" : item.email, text: $item.email)
                                    .font(.title3)
                                    .fontWeight(.light)
                                    .font(.system(size: 20))
                                    .padding(10)
                                    .keyboardType(.emailAddress)
                                    .textContentType(.emailAddress)
                            }
                            .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.06), radius: 4, x: 0, y: 4)
                            .overlay(
                                RoundedRectangle(cornerSize: .init(width: 7, height: 7))
                                    .stroke(Color(K.Colors.justLightGray).opacity(0.5), lineWidth: 1)
                            )
                        }
                        Divider()
                        HStack(spacing: 20){
                            ZStack{
                                Circle()
                                    .foregroundStyle(Color(K.Colors.gray).opacity(0.5))
                                    .frame(width: 40, height: 40)
                                Image(systemName: "square.and.pencil")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20)
                                    .foregroundStyle(Color(K.Colors.mainColor))
                                    .fontWeight(.light)
                            }
                            HStack{
                                TextField(item.notes.isEmpty ? "Notes" : item.notes, text: $item.notes, axis: .vertical)
                                    .font(.title3)
                                    .fontWeight(.light)
                                    .font(.system(size: 20))
                                    .padding(10)
                            }
                            .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.06), radius: 4, x: 0, y: 4)
                            .overlay(
                                RoundedRectangle(cornerSize: .init(width: 7, height: 7))
                                    .stroke(Color(K.Colors.justLightGray).opacity(0.5), lineWidth: 1)
                            )
                        }
                        Divider()
                        HStack(spacing: 20){
                            Button(action: {
                                modelContext.delete(item)
                                try? modelContext.save()
                                
                            }){
                                Text("Delete")
                                    .foregroundStyle(Color.white)
                                    .padding()
                            }
                            .frame(maxWidth: .infinity)
                            .background(Color(K.Colors.pink))
                            .cornerRadius(7)
                            Button(action: {
                                self.edit.toggle()
                            }){
                                Text("Save")
                                    .foregroundStyle(Color.white)
                                    .padding()
                            }
                            .frame(maxWidth: .infinity)
                            .background(Color(K.Colors.mainColor))
                            .cornerRadius(7)
                        }
                        .frame(maxWidth: .infinity)
                        Spacer()
                    }
                    .padding(.top, 50)
                    .padding(.horizontal, 15)
                    .frame(maxHeight: .infinity)
                    Spacer()
                }else{
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
                                Text(item.name)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .font(.title2)
                                    .fontWeight(.medium)
                                    .font(.system(size: 24))
                                if item.email != ""{
                                    Text(item.email)
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .font(.callout)
                                        .fontWeight(.light)
                                        .padding(.bottom)
                                }else{
                                    HStack(spacing: 1){
                                        Text(item.timestamp, format: .dateTime.month(.wide))
                                        Text(item.timestamp, format: .dateTime.day())
                                        Text(", \(item.timestamp, format: .dateTime.year()), ")
                                        Text(item.timestamp, style: .time)
                                    }
                                    .multilineTextAlignment(.center)
                                    .font(.callout)
                                    .fontWeight(.light)
                                    .foregroundColor(.white)
                                    .foregroundStyle(.secondary)
                                    .font(.system(size: 15))
                                    .padding(.bottom)
                                }
                                if item.imageData != nil{
                                    if let img = item.imageData{
                                        Image(uiImage: UIImage(data: img)!)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 80, height: 80)
                                            .cornerRadius(40)
                                            .overlay(
                                                Circle().stroke(.white, lineWidth: 2)
                                            )
                                    }
                                }else{
                                    ZStack(alignment: .center){
                                        Circle()
                                            .foregroundColor(Color(K.Colors.darkGray))
                                            .frame(width: 80, height: 80)
                                        Text(String(item.name.components(separatedBy: " ").compactMap { $0.first }).count >= 3 ? String(String(item.name.components(separatedBy: " ").compactMap { $0.first }).prefix(2)) : String(item.name.components(separatedBy: " ").compactMap { $0.first }))
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
                                Text(item.name.isEmpty ? "Name" : item.name)
                                    .font(.title3)
                                    .fontWeight(.light)
                                    .font(.system(size: 20))
                            }
                            Divider()
                            HStack(spacing: 18){
                                ZStack{
                                    Circle()
                                        .foregroundStyle(Color(K.Colors.gray).opacity(0.5))
                                        .frame(width: 40, height: 40)
                                    Image(systemName: "bell")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20)
                                        .foregroundStyle(Color(K.Colors.mainColor))
                                        .fontWeight(.light)
                                }
                                Text("itemTitles.name")
                                    .font(.title3)
                                    .fontWeight(.light)
                                    .font(.system(size: 18))
                            }
                            Divider()
                            HStack(spacing: 20){
                                ZStack{
                                    Circle()
                                        .foregroundStyle(Color(K.Colors.gray).opacity(0.5))
                                        .frame(width: 40, height: 40)
                                    Image(systemName: "gift")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20)
                                        .foregroundStyle(Color(K.Colors.mainColor))
                                        .fontWeight(.light)
                                }
                                HStack(spacing: 1){
                                    Text(item.timestamp, format: .dateTime.month(.twoDigits))
                                    Text("/\(item.timestamp, format: .dateTime.day())/")
                                    Text(item.timestamp, format: .dateTime.year())
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
                                    Image(systemName: "square.and.pencil")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20)
                                        .foregroundStyle(Color(K.Colors.mainColor))
                                        .fontWeight(.light)
                                }
                                Text(item.notes.isEmpty ? "Notes" : item.notes)
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
            }
            .edgesIgnoringSafeArea(.top)
        }
        .toolbar{
            ToolbarItem(placement: .topBarLeading){
                Button(action: {
                    self.edit.toggle()
                }){
                    Text(edit ? "Done" : "Edit")
                }
            }
        }
    }
}

//#Preview {
//    ItemPersonView()
//}
