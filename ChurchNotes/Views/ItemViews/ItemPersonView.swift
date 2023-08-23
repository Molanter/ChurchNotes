//
//  ItemPersonView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/6/23.
//

import SwiftUI
import SwiftData
import iPhoneNumberField

struct ItemPersonView: View {
    @Bindable var item: Items
    @State var edit = false
    @Query (sort: \ItemsTitle.timeStamp, order: .forward) var titles: [ItemsTitle]
    @State var selectedTheme = ""
    @Environment(\.modelContext) private var modelContext
    @State var shouldShowImagePicker = false
    @State var image: UIImage?
    @EnvironmentObject var viewModel: AppViewModel
    @State var showMessageComposeView = false
    @State var phoneError = false
    @State private var offset = CGFloat.zero

    var body: some View {
        VStack{
            VStack{
                if edit{
                    editView
                }else{
                    profileView
                }
            }
            .edgesIgnoringSafeArea(.top)
        }
        .modifier(DismissingKeyboard())
        .toolbar{
            ToolbarItem(placement: .topBarLeading){
                Button(action: {
                    self.edit.toggle()
                }){
                    Text(edit ? "Done" : "Edit")
                }
            }
        }
        .sheet(isPresented: $shouldShowImagePicker) {
            ImagePicker(image: $image)
                .onDisappear{
                    if image != nil{
                        guard let imageSelected = image else{return}
                        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else{return}
                        item.imageData = imageData
                    }
                }
        }
    }
    
    var editView: some View{
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
                    Text(item.name == "" ? "Name" : item.name)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .font(.title2)
                        .fontWeight(.medium)
                        .font(.system(size: 24))
                    if edit{
                        Button(action: {
                            self.shouldShowImagePicker.toggle()
                        }){
                            Text("tap to change image")
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .font(.callout)
                                .fontWeight(.light)
                                .padding(.bottom)
                        }
                    }else{
                        if item.email != ""{
                            Text(item.email.lowercased())
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .font(.callout)
                                .fontWeight(.light)
                                .padding(.bottom)
                        }else{
                            if let birthDay = item.birthDay{
                                HStack(spacing: 1){
                                    Text(birthDay, format: .dateTime.month(.wide))
                                    Text(birthDay, format: .dateTime.day())
                                    Text(", \(birthDay, format: .dateTime.year()), ")
                                    Text(birthDay, style: .time)
                                }
                                .multilineTextAlignment(.center)
                                .font(.callout)
                                .fontWeight(.light)
                                .foregroundColor(.white)
                                .foregroundStyle(.secondary)
                                .font(.system(size: 15))
                                .padding(.bottom)
                            }
                        }
                    }
                    Button(action: {
                        self.shouldShowImagePicker.toggle()
                    }){
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
                                Text(viewModel.twoNames(name: item.name))
                                    .font(.system(size: 35))
                                    .textCase(.uppercase)
                                    .foregroundColor(Color.white)
                            }
                            .overlay(
                                Circle().stroke(.white, lineWidth: 2)
                            )
                        }
                    }
                }
                .offset(y: 35)
            }
            ScrollView{
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
                                .autocorrectionDisabled(true)
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
                    .padding(.top, 50)
                    Divider()
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
                                .textCase(.lowercase)
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
                            Image(systemName: "phone")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20)
                                .foregroundStyle(Color(K.Colors.mainColor))
                                .fontWeight(.light)
                        }
                        HStack(alignment: .center, spacing: 0.0){
                            ZStack(alignment: .leading){
                                iPhoneNumberField("Phone Number", text: $item.phone)
                                    .maximumDigits(15)
                                    .prefixHidden(false)
                                    .flagHidden(false)
                                    .flagSelectable(true)
                                    .placeholderColor(Color(K.Colors.lightGray))
                                    .frame(height: 45)
                                    .disableAutocorrection(true)
                                    .textInputAutocapitalization(.never)
                                    .padding(0)
                                    .textContentType(.telephoneNumber)
                                    .foregroundStyle(Color.black)
                            }
                            .padding(.leading)
                            Spacer()
                        }
                        .frame(height: 50)
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
                        ZStack(alignment: .center){
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
                                modelContext.delete(item)
                                try? modelContext.save()
                                
                            }){
                                Text(" ")
                                    .foregroundStyle(Color.black)
                                    .padding()
                            }
                            .frame(maxWidth: .infinity)
                            .background(Color.black.opacity(0.25))
                            .cornerRadius(7)
                        }
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
            }
            .padding(.horizontal, 15)
            .frame(maxHeight: .infinity)
            Spacer()
        }
    }
    
    var profileView: some View{
        ZStack(alignment: .bottom){
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
                ScrollView{
                    VStack(alignment: .leading){
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
                            .padding(.top, 50)
                            Divider()
                            if item.email != ""{
                                VStack(alignment: .leading, spacing: 15){
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
                                        Text(item.email)
                                            .font(.title3)
                                            .fontWeight(.light)
                                            .font(.system(size: 20))
                                    }
                                    Divider()
                                    
                                }
                            }
                            if item.phone != ""{
                                HStack(spacing: 20){
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
                                    HStack(alignment: .center, spacing: 0.0){
                                        Text(item.phone)
                                            .font(.title3)
                                            .fontWeight(.light)
                                            .font(.system(size: 18))
                                    }
                                    .frame(height: 45)
                                }
                                Divider()
                            }
                            VStack(alignment: .leading, spacing: 15){
                                HStack(spacing: 18){
                                    ZStack{
                                        Circle()
                                            .foregroundStyle(Color(K.Colors.gray).opacity(0.5))
                                            .frame(width: 40, height: 40)
                                        Image(systemName: "folder")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20)
                                            .foregroundStyle(Color(K.Colors.mainColor))
                                            .fontWeight(.light)
                                    }
                                    Text(item.title)
                                        .font(.title3)
                                        .fontWeight(.light)
                                        .font(.system(size: 18))
                                }
                                Divider()
                            }
                            if let bday = item.birthDay{
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
                                        Text(bday, format: .dateTime.month(.twoDigits))
                                        Text("/\(bday, format: .dateTime.day())/")
                                        Text(bday, format: .dateTime.year())
                                    }
                                    .font(.title3)
                                    .fontWeight(.light)
                                    .font(.system(size: 18))
                                }
                                Divider()
                            }
                            VStack(alignment: .leading, spacing: 15){
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
                            }
                            VStack(alignment: .leading, spacing: 15){
                                HStack(spacing: 20){
                                    ZStack{
                                        Circle()
                                            .foregroundStyle(Color(K.Colors.gray).opacity(0.5))
                                            .frame(width: 40, height: 40)
                                        Image(systemName: "person.badge.clock")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 25)
                                            .foregroundStyle(Color(K.Colors.mainColor))
                                            .fontWeight(.light)
                                            .offset(x: 2)
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
                            }
                            Spacer()
                        }
                        if !item.phone.isEmpty{
                            NavigationLink{
                                CameraView(recipients: [item.phone], message: "Let's goo!", item: item)
                            } label:{
                                HStack(spacing: 20){
                                    ZStack{
                                        Circle()
                                            .foregroundStyle(Color(K.Colors.gray).opacity(0.5))
                                            .frame(width: 40, height: 40)
                                        Image(systemName: "video.badge.plus")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 30)
                                            .foregroundStyle(Color(K.Colors.mainColor))
                                            .fontWeight(.light)
                                    }
                                    HStack(spacing: 0.0){
                                        Text("Record video for  **\(item.name.capitalized)**")
                                            .foregroundStyle(Color("text-appearance"))
                                            .font(.title3)
                                            .fontWeight(.light)
                                            .font(.system(size: 18))
                                            .lineLimit(3)
                                            .multilineTextAlignment(.leading)
                                    }
                                }
                            }
                        }else{
                            Button{
                                    phoneIsEmpty()
                            } label:{
                                HStack(spacing: 20){
                                    ZStack{
                                        Circle()
                                            .foregroundStyle(Color(K.Colors.gray).opacity(0.5))
                                            .frame(width: 40, height: 40)
                                        Image(systemName: "video.badge.plus")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 30)
                                            .foregroundStyle(Color(K.Colors.mainColor))
                                            .fontWeight(.light)
                                    }
                                    HStack(spacing: 0.0){
                                        Text("Record video for  **\(item.name.capitalized)**")
                                            .foregroundStyle(K.Colors.appearance >= 1 ? (K.Colors.appearance == 2 ? Color.black : Color.white) : Color("text-appearance"))
                                            .font(.title3)
                                            .fontWeight(.light)
                                            .font(.system(size: 18))
                                            .lineLimit(3)
                                            .multilineTextAlignment(.leading)
                                    }
                                }
                            }
                        }
                        Divider()
                    }
                    
                }
                .padding(.horizontal, 15)
                .frame(maxHeight: .infinity)
                Spacer()
            }
            .alert("Phone number is empty!", isPresented: $phoneError) {
                Button("Cancel", role: .cancel) {}
                Button(action: {self.edit = true}) {
                    Text("Add number")
                }
                
            }message: {
                Text("Add person phone number for recording video.")
            }
//            if phoneError{
//                HStack(alignment: .center){
//                        Text("Phone is empty! Add phone to record video.")
//                    .foregroundStyle(Color(K.Colors.justDarkGray))
//                }
//                .frame(height: 40)
//                .background(Color(K.Colors.justLightGray))
//                .cornerRadius(7)
//                .onTapGesture(perform: {
//                    withAnimation{
//                        phoneError = false
//                    }
//                })
//                .offset(y: phoneError ? -20 : 150)
//            }
        }
    }
    
    private func phoneIsEmpty(){
        self.phoneError.toggle()
//        withAnimation{
//            phoneError = true
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
//            withAnimation{
//                phoneError = false
//            }
//            }
    }
}


