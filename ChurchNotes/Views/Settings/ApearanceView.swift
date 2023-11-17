//
//  ApearanceView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 8/15/23.
//

import SwiftUI

struct AppearanceView: View {
    @State var presentAlert = false
    @State var presentingPreview = false
    @State var oldColor = ""
    @State var appearance = 0
    @State var showColor = false
    @State var toggle = false
    @State var dark = false
    @State var favouriteSignNow = ""
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
                List{
                    Section(header: Text("App appearance:")){
                            Toggle(isOn: Binding(
                                get: { !self.showColor },
                                set: { self.showColor = !$0 }
                            )) {
                                Text("System Apearance")
                            }
                            Toggle(isOn: $dark) {
                                Text("Dark Apearance")
                            }
                            .disabled(!showColor)
                            .pickerStyle(.segmented)
                    }
                    .listRowBackground(Color.clear)
                    Section(header: Text("Accent color:")){
                        ScrollViewReader{ scrollProxy in
                            ScrollView(.horizontal){
                                HStack{
                                    ForEach(K.Colors.colorsDictionary.sorted(by: >), id:\.value){ order, value in
                                        HStack(spacing: 10){
                                            Button(action: {
                                                changeMainColor(value)
                                            }){
                                                VStack(spacing: 15){
                                                    RoundedRectangle(cornerRadius: 15)
                                                        .fill(Color(value))
                                                        .frame(width: 60, height: 60)
                                                        .shadow(color: Color(K.Colors.bluePurple), radius: 2)
                                                        .opacity(K.Colors.mainColor == value ? 1 : 0.3)
                                                    Text(order)
                                                        .lineLimit(0)
                                                        .font(.system(size: 20))
                                                        .foregroundStyle(Color(K.Colors.lightGray))
                                                }
                                                .frame(height: 100, alignment: .top)
                                            }
                                            .frame(width: 100)
                                            .padding(.vertical, 5)
                                            .padding(5)
                                            Divider()
                                        }
                                    }
                                    .frame(height: 150)
                                    .onAppear {
                                        withAnimation{
                                            let col = K.Colors.mainColor
                                            scrollProxy.scrollTo(col, anchor: .center)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .listRowBackground(Color.clear)
                    Section{
                        HStack{
                            Text("Favourite sign:")
                            Picker("", selection: $favouriteSignNow) {
                                Label("Heart", systemImage: "heart").tag("heart")
                                Label("Star", systemImage: "star").tag("star")
                            }
                            .accentColor(Color(K.Colors.mainColor))
                        }
                    }
                    .listRowBackground(Color.clear)
                    .onChange(of: favouriteSignNow){
                        K.Colors.favouriteSignColor = favouriteSignNow == "heart" ? "redd" : "yelloww"
                        K.favouriteSign = favouriteSignNow
                    }
                }
                .listStyle(.grouped)
            }
            Spacer()
                .navigationTitle("Appearance")
            //            .frame(minWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity)
        .onAppear{
            favouriteSignNow = K.favouriteSign
            appearance = K.Colors.appearance
            if appearance == 0{
                showColor = false
                dark = false
            }else if appearance == 1{
                dark = true
                showColor = true
            }else if appearance == 2{
                dark = false
                showColor = true
            }
        }
        .onChange(of: showColor){
            if showColor{
                K.Colors.appearance = 1
                utilities.overrideDisplayMode()
            }else if !showColor{
                K.Colors.appearance = 0
                utilities.overrideDisplayMode()
            }}
        .onChange(of: dark){
            if dark{
                K.Colors.appearance = 1
                utilities.overrideDisplayMode()
            }else if !dark && showColor{
                K.Colors.appearance = 2
                utilities.overrideDisplayMode()
            }
        }
        .alert("Color has changed", isPresented: $presentAlert) {
            Button("Cancel", role: .cancel) {}
        }message: {
            Text("Restart the app, or go to the Notes List - to see the changes.")
        }
        .sheet(isPresented: $presentingPreview, content: {
            NavigationStack{
                CurrentPersonView(cristian: true, name: name, phone: phone, email: email, country: country, notes: notes, profileImage: profileImage, username: username, timeStamp: timeStamp)
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
//    AppearanceView()
//}


