//
//  ApearanceView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 8/15/23.
//

import SwiftUI

struct AppearanceView: View {
    @EnvironmentObject var viewModel: AppViewModel

    @State var presentAlert = false
    @State var presentingPreview = false
    @State var oldColor = ""
    @State var appearance = 0
    @State var showColor = false
    @State var toggle = false
    @State var dark = false
    @State var favouriteSignNow = ""
    @State var isExpanded = true
    @State var testFeatures = false
    @State var swipeStage = false
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
//                    .listRowBackground(Color.clear)
                    
                    Section(header: Text("accent-color")) {
                        ScrollViewReader { scrollProxy in
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(K.Colors.colorsDictionary.sorted(by: >), id: \.value) { order, value in
                                        HStack(spacing: 10) {
                                            Button(action: {
                                                changeMainColor(value)
                                            }) {
                                                VStack(spacing: 15) {
                                                    RoundedRectangle(cornerRadius: 15)
                                                        .fill(Color(value))
                                                        .frame(width: 60, height: 60)
                                                        .shadow(color: Color(K.Colors.bluePurple), radius: 2)
                                                        .opacity(K.Colors.mainColor == value ? 1 : 0.3)
                                                    Text(order)
                                                        .lineLimit(2)
                                                        .font(.body)
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
                                        withAnimation {
                                            let col = K.Colors.mainColor
                                            scrollProxy.scrollTo(col, anchor: .center)
                                        }
                                    }
                                }
                            }
                        }
                    }
//                    .listRowBackground(Color.clear)
                    
                    Section {
                        HStack {
                            Text("favourite-sign")
                            Picker("", selection: $favouriteSignNow) {
                                Label("heart", systemImage: "heart").tag("heart")
                                Label("star", systemImage: "star").tag("star")
                            }
                            .accentColor(Color(K.Colors.mainColor))
                        }
                    }
//                    .listRowBackground(Color.clear)
                    .onChange(of: favouriteSignNow) {
                        K.Colors.favouriteSignColor = favouriteSignNow == "heart" ? "redd" : "yelloww"
                        K.favouriteSign = favouriteSignNow
                    }
                    Section {
//                        HStack {
//                            Text("llanguage")
//                            Picker("", selection: $languageManager.currentLanguage) {
//                                ForEach(K.Languages.languagesArray){ lan in
//                                    HStack(spacing: 3){
////                                        Text(lan.image)
//                                        Text(lan.name)
//                                    }.tag(lan.short)
//                                }
//                            }
//                            .accentColor(Color(K.Colors.mainColor))
//                        }
                        HStack{
                            Text("llanguage")
                            Spacer()
                            Link(String(localized: "open-in-settings"), destination: URL(string: UIApplication.openSettingsURLString)!)
                                .accentColor(Color(K.Colors.mainColor))
                        }
                    }
//                    .listRowBackground(Color.clear)
                    Section(header: Text("test-eatures")) {
                        Toggle(isOn: $testFeatures) {
                            Text("test-eatures")
                        }
                        .onChange(of: testFeatures) { old, new in
                            K.testFeatures = new
                        }
                        if testFeatures == true{
                            Label("Double tap on List / Settings icons on tab bar", systemImage: "hand.tap")
                            Label("App Support", systemImage: "wrench.and.screwdriver")
                        }
                    }
//                    .listRowBackground(Color.clear)
                }
//                .listStyle(.grouped)
            }
            .frame(maxWidth: .infinity)
            .onAppear {
                self.swipeStage = K.swipeStage
                self.testFeatures = K.testFeatures
                favouriteSignNow = K.favouriteSign
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
                        self.dark.toggle()
                    }){
                        Image(systemName: dark ? "sun.max" : "moon")
                            .foregroundStyle(Color(K.Colors.mainColor))
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
            .alert("color-has-changed", isPresented: $presentAlert) {
                Button(K.Hiden.ok.randomElement()!, role: .cancel) {}
            } message: {
                Text("restart-the-app-to-see-the-changes")
            }
            .navigationTitle("appearance")
            .sheet(isPresented: $presentingPreview) {
                NavigationStack {
                    CurrentPersonView()
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button(role: .destructive) {
                                    self.presentingPreview.toggle()
                                    K.Colors.mainColor = oldColor
                                } label: {
                                    Image(systemName: "xmark.circle")
                                }
                            }
                            ToolbarItem(placement: .topBarTrailing) {
                                Button {
                                    colorChanged()
                                } label: {
                                    Image(systemName: "checkmark.circle")
                                }
                            }
                        }
                }
                .accentColor(Color(K.Colors.mainColor))
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
    private func reload() {
           let newState = UUID().uuidString
           self.state = newState
        print("changed")
       }
    @State private var state = UUID().uuidString
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
