//
//  SettingsView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 8/15/23.
//

import SwiftUI

struct SettingsView: View {
    @State var presentAlert = false
    @State var presentingPreview = false
    @State var oldColor = ""
    @State var appearance = 0
    @State var showColor = false
    @State var toggle = false
    
    let profileImage: String
    let name: String
    let email: String
    let username: String
    let phone: String
    let country: String
    let notes: String
    let timeStamp: Date
    var utilities = Utilities()

    var body: some View {
            NavigationStack{
                VStack(alignment: .leading, spacing: 15){
                    Text("Choose main color:")
                        .padding(.leading, 5)
                        .padding(5)
                        .font(.title2)
                        .fontWeight(.bold)
                    ScrollView(.horizontal){
                        HStack(spacing: 10){
                            Button(action: {
                                changeMainColor("blue-purple")
                            }){
                                    VStack(spacing: 15){
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(Color(K.Colors.bluePurple))
                                            .frame(width: 60, height: 60)
                                            .shadow(color: Color(K.Colors.bluePurple), radius: 2)
                                        Text("Purple")
                                            .font(.title3)
                                            .foregroundStyle(Color(K.Colors.lightGray))
                                    }
                                    .padding(20)
                                    .background{
                                        if K.Colors.mainColor == "blue-purple"{
                                            RoundedRectangle(cornerRadius: 20).fill(Color(K.Colors.darkGray).opacity(0.7)).shadow(color: Color(K.Colors.darkGray),radius: 10)
                                        }
                                    }
                            }
                            .frame(width: 100)
                            .padding(.vertical, 5)
                            .padding(5)
                            Divider()
                            Button(action: {
                                changeMainColor("light-blue")
                            }){
                                VStack(spacing: 15){
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color(K.Colors.lightBlue))
                                        .frame(width: 60, height: 60)
                                        .shadow(color: Color(K.Colors.lightBlue), radius: 2)
                                    Text("Light Blue")
                                        .font(.title3)
                                        .foregroundStyle(Color(K.Colors.lightGray))
                                }
                                .padding(20)
                                .background{
                                    if K.Colors.mainColor == "light-blue"{
                                        RoundedRectangle(cornerRadius: 20).fill(Color(K.Colors.darkGray).opacity(0.7)).shadow(color: Color(K.Colors.darkGray),radius: 10)
                                    }
                                }
                            }
                            .frame(width: 100)
                            .padding(.vertical, 5)
                            .padding(5)
                            Divider()
                            Button(action: {
                                changeMainColor("bluee")
                            }){
                                VStack(spacing: 15){
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color(K.Colors.blue))
                                        .frame(width: 60, height: 60)
                                        .shadow(color: Color(K.Colors.blue), radius: 2)
                                    Text("Blue")
                                        .font(.title3)
                                        .foregroundStyle(Color(K.Colors.lightGray))
                                }
                                .padding(20)
                                .background{
                                    if K.Colors.mainColor == "bluee"{
                                        RoundedRectangle(cornerRadius: 20).fill(Color(K.Colors.darkGray).opacity(0.7)).shadow(color: Color(K.Colors.darkGray),radius: 10)
                                    }
                                }
                            }
                            .frame(width: 100)
                            .padding(.vertical, 5)
                            .padding(5)
                            Divider()
                            Button(action: {
                                changeMainColor("dark-blue")
                            }){
                                VStack(spacing: 15){
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color(K.Colors.darkBlue))
                                        .frame(width: 60, height: 60)
                                        .shadow(color: Color(K.Colors.darkBlue), radius: 2)
                                    Text("Dark Blue")
                                        .font(.title3)
                                        .foregroundStyle(Color(K.Colors.lightGray))
                                }
                                .padding(20)
                                .background{
                                    if K.Colors.mainColor == "dark-blue"{
                                        RoundedRectangle(cornerRadius: 20).fill(Color(K.Colors.darkGray).opacity(0.7)).shadow(color: Color(K.Colors.darkGray),radius: 10)
                                    }
                                }
                            }
                            .frame(width: 100)
                            .padding(.vertical, 5)
                            .padding(5)
                            Divider()
                            Button(action: {
                                changeMainColor("orangee")
                            }){
                                VStack(spacing: 15){
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color(K.Colors.orange))
                                        .frame(width: 60, height: 60)
                                        .shadow(color: Color(K.Colors.orange), radius: 2)
                                    Text("Orange")
                                        .font(.title3)
                                        .foregroundStyle(Color(K.Colors.lightGray))
                                }
                                .padding(20)
                                .background{
                                    if K.Colors.mainColor == "orangee"{
                                        RoundedRectangle(cornerRadius: 20).fill(Color(K.Colors.darkGray).opacity(0.7)).shadow(color: Color(K.Colors.darkGray),radius: 10)
                                    }
                                }
                            }
                            .frame(width: 100)
                            .padding(.vertical, 5)
                            .padding(5)
                            Divider()
                            Button(action: {
                                changeMainColor("greenn")
                            }){
                                VStack(spacing: 15){
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color(K.Colors.green))
                                        .frame(width: 60, height: 60)
                                        .shadow(color: Color(K.Colors.green), radius: 2)
                                    Text("Green")
                                        .font(.title3)
                                        .foregroundStyle(Color(K.Colors.lightGray))
                                }
                                .padding(20)
                                .background{
                                    if K.Colors.mainColor == "greenn"{
                                        RoundedRectangle(cornerRadius: 20).fill(Color(K.Colors.darkGray).opacity(0.7)).shadow(color: Color(K.Colors.darkGray),radius: 10)
                                    }
                                }
                            }
                            .frame(width: 100)
                            .padding(.vertical, 5)
                            .padding(5)
                            Divider()
                            Button(action: {
                                changeMainColor("yelloww")
                            }){
                                VStack(spacing: 15){
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color(K.Colors.yellow))
                                        .frame(width: 60, height: 60)
                                        .shadow(color: Color(K.Colors.yellow), radius: 2)
                                    Text("Yellow")
                                        .font(.title3)
                                        .foregroundStyle(Color(K.Colors.lightGray))
                                }
                                .padding(20)
                                .background{
                                    if K.Colors.mainColor == "yelloww"{
                                        RoundedRectangle(cornerRadius: 20).fill(Color(K.Colors.darkGray).opacity(0.7)).shadow(color: Color(K.Colors.darkGray),radius: 10)
                                    }
                                }
                            }
                            .frame(width: 100)
                            .padding(.vertical, 5)
                            .padding(5)
                            Divider()
                            Button(action: {
                                changeMainColor("redd")
                            }){
                                VStack(spacing: 15){
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color(K.Colors.red))
                                        .frame(width: 60, height: 60)
                                        .shadow(color: Color(K.Colors.red), radius: 2)
                                    Text("Red")
                                        .font(.title3)
                                        .foregroundStyle(Color(K.Colors.lightGray))
                                }
                                .padding(20)
                                .background{
                                    if K.Colors.mainColor == "redd"{
                                        RoundedRectangle(cornerRadius: 20).fill(Color(K.Colors.darkGray).opacity(0.7)).shadow(color: Color(K.Colors.darkGray),radius: 10)
                                    }
                                }
                            }
                            .frame(width: 100)
                            .padding(.vertical, 5)
                            .padding(5)
                            Divider()
                        }
                        .frame(height: 150)
                    }
                    Divider()
                        .padding(.vertical, 15)
                    VStack(alignment: .leading){
                        Text("Choose app appearance:")
                            .padding(.leading, 5)
                            .padding(5)
                            .font(.title2)
                            .fontWeight(.bold)
                        ZStack(alignment: .center){
                            RoundedRectangle(cornerRadius: 7)
                                .frame(width: 300, height: 35)
                                .foregroundStyle(Color(K.Colors.background))
                            RoundedRectangle(cornerRadius: 7)
                                .frame(width: 145, height: 30)
                                .foregroundStyle(Color(K.Colors.whiteGray))
                                .offset(x: appearance == 0 ? -75 : 75)
                            HStack(alignment: .center, spacing: 1){
                                Text("Automatic")
                                    .font(.system(size: 18))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 5)
                                    .onTapGesture(perform: {
                                        withAnimation{
                                            self.appearance = 0
                                            utilities.overrideDisplayMode()
                                            showColor = false
                                        }
                                    })
                                    .cornerRadius(7)
                                Text("Manualy")
                                    .font(.system(size: 18))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 5)
                                    .onTapGesture(perform: {
                                        withAnimation{
                                            if appearance != 1 && appearance != 2{
                                                self.appearance = 1
                                                utilities.overrideDisplayMode()
                                                showColor = true
                                            }
                                        }
                                    })
                                    .cornerRadius(7)

                            }
                            .padding(2)
                            .frame(maxWidth: 300)
                            .cornerRadius(7)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 15)
//                        Picker("What appearance do you whant?", selection: $appearance) {
//                            Text("Automatic").tag(0)
//                            Text("Manualy").tag(1)
//                        }
//                        .padding(.horizontal, 15)
                        .onChange(of: appearance, perform: { value in
                            if value == 1{
                                K.Colors.appearance = 1
                                utilities.overrideDisplayMode()
                                showColor = true
                            }else if value == 2{
                                K.Colors.appearance = 2
                                showColor = true
                                utilities.overrideDisplayMode()
                            }else if value == 0{
                                K.Colors.appearance = 0
                                showColor = false
                                utilities.overrideDisplayMode()
                            }
                        })
                        .pickerStyle(.segmented)
                        if showColor{
                            HStack{
                                Text("Choose app appearance:")
                                    .padding(.leading, 5)
                                    .padding(5)
                                    .font(.title3)
                                    .fontWeight(.medium)
                                Spacer()
                                ZStack {
                                    Capsule()
                                        .frame(width:80,height:44)
                                        .foregroundColor(Color(appearance == 2 ? K.Colors.justLightGray : K.Colors.justDarkGray))
                                    ZStack{
                                        Circle()
                                            .frame(width:40, height:40)
                                            .foregroundColor(Color(appearance == 2 ? K.Colors.blackAndWhite : K.Colors.gray))
                                        Image(systemName: appearance == 2 ? "sun.max.fill" : "moon.fill")
                                    }
                                    .shadow(color: .black.opacity(0.14), radius: 4, x: 0, y: 2)
                                    .offset(x: appearance == 2 ? 18 : -18)
                                    .padding(24)
                                    .animation(.spring())
                                }
                                .padding(.trailing, 15)
                                .onTapGesture {
                                    if appearance == 1{
                                        appearance = 2
                                    }else if appearance == 2{
                                        appearance = 1
                                    }
                                }
                                
                            }
                        }
                    }

                }
                .onAppear{
                    appearance = K.Colors.appearance
                    if appearance == 0{
                        showColor = false
                    }else if appearance == 1{
                        showColor = true
                    }else if appearance == 2{
                        showColor = true
                    }
                }
                Divider()
                    .padding(.top, 15)
                Spacer()
            .navigationTitle("Settings")
//            .frame(minWidth: .infinity, maxHeight: .infinity)
            }
            .alert("Color has changed", isPresented: $presentAlert) {
                Button("Cancel", role: .cancel) {}
            }message: {
                Text("Restart the app, or go to the Notes List - to see the changes.")
            }
            .sheet(isPresented: $presentingPreview, content: {
                NavigationStack{
                    CurrentPersonView(user: .init(name: name, phoneNumber: phone, email: email, cristian: true, notes: notes, country: country, profileImage: profileImage, username: username, timeStamp: timeStamp))
                        .toolbar{
                            ToolbarItem(placement: .topBarLeading){
                                Button(role: .destructive, action: {
                                    self.presentingPreview.toggle()
                                    K.Colors.mainColor = oldColor
                                }){
                                    Image(systemName: "xmark.circle")
                                }
                            }
                            ToolbarItem(placement: .topBarTrailing){
                                Button(action: {
                                    colorChanged()
                                }){
                                    Image(systemName: "checkmark.circle")
                                }
                            }
                        }
                }
                .accentColor(Color(K.Colors.mainColor))
                })
    }
    
    private func changeMainColor(_ color: String){
        self.oldColor = K.Colors.mainColor
        K.Colors.mainColor = color
        self.presentingPreview.toggle()
    }
    private func colorChanged(){
        self.presentingPreview.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation{
                self.presentAlert = true
            }
            }
    }
    
}

//#Preview {
//    SettingsView()
//}



