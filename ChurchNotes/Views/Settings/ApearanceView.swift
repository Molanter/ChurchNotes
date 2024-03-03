//
//  ApearanceView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 8/15/23.
//

import SwiftUI

struct AppearanceView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    @State var presentAlert = false
    @State var presentingPreview = false
    @State var oldColor = Color(K.Colors.bluePurple)
    @State private var oldColorValue = ""
    @State var appearance = 0
    @State var showColor = false
    @State var toggle = false
    @State var dark = false
    @State var favouriteSignNow = ""
    @State private var favSignColor = ""
    @State private var mainColorNow = K.Colors.mainColor
    @State var pickerColor = K.Colors.mainColor
    @State var isExpanded = true
    @State var testFeatures = false
    @State var emailPush = ""
    
    let restrictedEmaileSet = "" //"!#$%^&*()?/>,<~`±§}{[]|\"÷≥≤µ˜∫√ç≈Ω`åß∂ƒ©˙∆˚¬…æ«‘“πøˆ¨¥†®´∑œ§¡™£¢∞§¶•ªº≠"

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
        NavigationStack {
            VStack(alignment: .leading, spacing: 15) {
                List {
                    Section(header: Text("app-appearance")) {
                        Toggle(isOn: Binding(
                            get: { !self.showColor },
                            set: { self.showColor = !$0 }
                        )) {
                            Text("system-apearance")
                        }
                        Toggle(isOn: $dark) {
                            Text("dark-appearance")
                        }
                        .disabled(!showColor)
                        .pickerStyle(.segmented)
                    }
                    
                    Section(header: Text("accent-color")) {
                        ScrollViewReader { scrollProxy in
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(K.Colors.colorsDictionary.sorted(by: >), id: \.value) { text, value in
                                        HStack(spacing: 10) {
                                            Button(action: {
                                                changeMainColor(value)
                                            }) {
                                                VStack(spacing: 15) {
                                                    RoundedRectangle(cornerRadius: 15)
                                                        .fill(Color(value))
                                                        .frame(width: 60, height: 60)
                                                        .shadow(color: Color(value), radius: 2)
                                                        .opacity(K.Colors.mainColor == Color(value) ? 1 : 0.3)
                                                    Text(text)
                                                        .lineLimit(2)
                                                        .font(.body)
                                                        .foregroundStyle(Color(K.Colors.lightGray))
                                                }
                                                .frame(height: 100, alignment: .top)
                                            }
                                            .frame(width: 100)
                                            .padding(.vertical, 5)
                                            .padding(5)
                                            .disabled(mainColorNow == Color(value))
                                            Divider()
                                        }
                                    }
                                    .frame(height: 150)
                                    if K.Colors.color == "color"{
                                        HStack(spacing: 10) {
                                                VStack(spacing: 15) {
                                                    RoundedRectangle(cornerRadius: 15)
                                                        .fill(K.Colors.mainColor)
                                                        .frame(width: 60, height: 60)
                                                        .shadow(color: K.Colors.mainColor, radius: 2)
                                                        .opacity(K.Colors.color == "color" ? 1 : 0.3)
                                                    Text("custom-color")
                                                        .lineLimit(2)
                                                        .font(.body)
                                                        .foregroundStyle(Color(K.Colors.lightGray))
                                                }
                                                .frame(height: 100, alignment: .top)
                                            .frame(width: 100)
                                            .padding(.vertical, 5)
                                            .padding(5)
                                        }
                                        .id("color")
                                    }
                                }
                                .onAppear {
                                    withAnimation {
                                        scrollProxy.scrollTo(K.Colors.color, anchor: .center)
                                    }
                                }
                            }
                        }
                        .listRowInsets(EdgeInsets())
                        NavigationLink {
                            VStack(alignment: .center, spacing: 15){
                                List{
                                    Section{
                                        ColorPicker("choose-yor-own", selection: $pickerColor, supportsOpacity: false)
                                            .tint(K.Colors.mainColor)
                                    }
                                    Section{
                                        Text("save")
                                            .foregroundStyle(Color.white)
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(K.Colors.mainColor)
                                            .cornerRadius(10)
                                            .onTapGesture {
                                                self.oldColor = K.Colors.mainColor
                                                oldColorValue = K.Colors.color
                                                print("changed")
                                                K.Colors.color = "color"
                                                K.Colors.mainColor = pickerColor
                                                self.presentingPreview = true
                                            }
                                            .listRowInsets(EdgeInsets())
                                    }
                                }
                            }
                            
                        } label: {
                            Text("choose-yor-own")
                        }
                    }
                    
                    Section(header: Text("favourite-sign")){
                        HStack{
                            Text("favourite-sign")
                            Spacer()
                            Menu{
                                Button{
                                    K.Colors.favouriteSignColor = "redd"
                                    favouriteSignNow = "heart"
                                    K.favouriteSign = favouriteSignNow
                                    favSignColor = "redd"
                                }label: {
                                    Label("heart", systemImage: "heart")
                                }
                                Button{
                                    K.Colors.favouriteSignColor = "yelloww"
                                    favouriteSignNow = "star"
                                    K.favouriteSign = favouriteSignNow
                                    favSignColor = "yelloww"
                                }label: {
                                    Label("star", systemImage: "star")
                                }
                            }label: {
                                Image(systemName: "\(favouriteSignNow).fill")
                            }
                        }
                            .accentColor(Color(favSignColor))
                        
                        
                        HStack{
                            Text("favourite-sign-color")
                            Spacer()
                            Menu{
                                ForEach(K.Colors.colorsDictionary.sorted(by: >), id: \.value) { text, value in
                                    Button{
                                        K.Colors.favouriteSignColor = value
                                        favSignColor = value
                                    }label: {
                                        HStack{
                                            Text(text)
                                            Spacer()
                                            RoundedRectangle(cornerRadius: 2)
                                                .fill(Color(K.Colors.favouriteSignColor))
                                        }
                                    }
                                }
                            }label: {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color(favSignColor))
                                    .frame(width: 20, height: 20)
                            }
                        }
                    }
                    Section(header: Text("aapp-ssettings")){
                        HStack{
                            Text("llanguage")
                            Spacer()
                            Link(String(localized: "open-in-settings"), destination: URL(string: UIApplication.openSettingsURLString)!)
                                .accentColor(mainColorNow)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .onAppear {
                mainColorNow = K.Colors.mainColor
                let color = K.Colors.favouriteSignColor
                favouriteSignNow = K.favouriteSign
                favSignColor = color
                
                appearance = K.Colors.appearance
                if appearance == 0 {
                    showColor = false
                    dark = false
                } else if appearance == 1 {
                    dark = true
                    showColor = true
                } else if appearance == 2 {
                    dark = false
                    showColor = true
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        self.showColor = true
                        if dark || colorScheme == .dark{
                            dark = false
                        }else{
                            dark = true
                        }
                    }){
                        Image(systemName: dark || colorScheme == .dark ? "sun.max" : "moon")
                            .foregroundStyle(Color(mainColorNow))
                            .symbolEffect(.bounce, value: dark)

                    }
                }
            })
            .onChange(of: showColor) {
                updateAppearance()
            }
            .onChange(of: dark) {
                updateAppearance()
            }
//            .alert("color-has-changed", isPresented: $presentAlert) {
//                Button(K.Hiden.ok.randomElement()!, role: .cancel) {}
//            } message: {
//                Text("restart-the-app-to-see-the-changes")
//            }
            .navigationTitle("appearance")
            .sheet(isPresented: $presentingPreview) {
                NavigationStack {
                    CurrentPersonView()
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button(role: .destructive) {
                                    self.presentingPreview.toggle()
                                    K.Colors.mainColor = oldColor
                                    pickerColor = oldColor
                                    K.Colors.color = oldColorValue
                                } label: {
                                    Image(systemName: "xmark.circle")
                                }
                                .foregroundStyle(K.Colors.mainColor)
                            }
                            ToolbarItem(placement: .topBarTrailing) {
                                Button {
                                    colorChanged()
                                } label: {
                                    Image(systemName: "checkmark.circle")
                                }
                                .foregroundStyle(K.Colors.mainColor)
                            }
                        }
                }
                .accentColor(Color(mainColorNow))
            }
            
        }
    }
    
    private func updateAppearance() {
        if showColor {
            K.Colors.appearance = dark ? 1 : 2
            utilities.overrideDisplayMode()
        } else {
            K.Colors.appearance = 0
            utilities.overrideDisplayMode()
        }
    }
    
    private func changeMainColor(_ color: String) {
        self.oldColor = K.Colors.mainColor
        oldColorValue = K.Colors.color
        
        pickerColor = Color(color)
        K.Colors.color = color
        K.Colors.mainColor = Color(color)
        self.presentingPreview = true
    }
    private func colorChanged(){
        mainColorNow = K.Colors.mainColor
        self.presentingPreview = false
        if oldColor != K.Colors.mainColor{
            Toast.shared.present(
                title: String(localized: "color-has-changed"),
                symbol: "paintpalette",
                isUserInteractionEnabled: true,
                timing: .long
            )
        }
    }
}



//#Preview {
//    AppearanceView()
//}



struct LocalizedStrings {
    static func helloWorld() -> String {
        return NSLocalizedString("Hello, World!", comment: "")
    }
}

//class LanguageManager: ObservableObject {
//    static let shared = LanguageManager()
//
//    @Published var currentLanguage: String {
//        didSet {
//            UserDefaults.standard.set([currentLanguage], forKey: "AppleLanguages")
//            UserDefaults.standard.synchronize()
//        }
//    }
//
//    private init() {
//        self.currentLanguage = UserDefaults.standard.stringArray(forKey: "AppleLanguages")?.first ?? "en"
//    }
//
//    func setLanguage(_ language: String) {
//        currentLanguage = language
//    }
//}


