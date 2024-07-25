//
//  AppSecureView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 5/13/24.
//

import SwiftUI
import SwiftData
import LocalAuthentication
import FirebaseAuth
import FirebaseFirestore

struct AppSecureView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var published: PublishedVariebles
    @EnvironmentObject var viewModel: AppViewModel
    
    @Query var strings: [StringDataModel]
    @Query var bools: [BoolDataModel]
    @Query var ints: [IntDataModel]

    @State var appSecurityisOn = false
    @State var pass = ""
    @State var createPass = ""
    @State var wrongPass = 0
    @State var error = String(localized: "current-password")
    @State var showSheet = false
    @State var passType = 1
    @State var passStage = 0
    @State var bioAuthEnabled = false
    
    let width = UIScreen.screenWidth / 5
    var db = Firestore.firestore()
    var auth = Auth.auth()
    
    var appPass: String {
        if let strModel = strings.first(where: { $0.name == "appPass" }), let str = published.decrypt(strModel.string) {
            return str
        } else {
            return ""
        }
    }
    
    var secure: Bool {
        if let boolModel = bools.first(where: { $0.name == "appSecure" }) {
            return boolModel.bool
        } else {
            return false
        }
    }
    
    var appPassType: Int {
        if let intModel = ints.first(where: { $0.name == "appPassType" }) {
            return Int(intModel.int)
        }else {
            return 1
        }
    }
        
    var backgroundType: String {
        if let strModel = strings.first(where: { $0.name == "backgroundType" }) {
            return strModel.string
        }else {
            return "none"
        }
    }
    
    var body: some View {
        NavigationStack {
            if !published.closed {
                mainView
                    .navigationTitle("app-secure")
                    .navigationBarTitleDisplayMode(.large)
            }else {
                PassOrBiometricView(
                    isPresented: $published.closed,
                    pass: $pass,
                    wrongPass: $wrongPass,
                    appPass: appPass,
                    appPassType: appPassType,
                    width: width,
                    addToCheckPass: addToCheckPass,
                    tryBiom: bioAuthEnabled
                )
            }
        }
        .onAppear{
            checkSecure()
            if let boolModel = bools.first(where: { $0.name == "bioAuthEnabled" }) {
                bioAuthEnabled = boolModel.bool
            }else {
                let newBool = BoolDataModel(name: "bioAuthEnabled", bool: false)
                modelContext.insert(newBool)
                bioAuthEnabled = false
            }
            if secure {
                error = String(localized: "current-password")
                published.closed = true
            }else {
                published.closed = false
                error = String(localized: "create-password")
            }
        }
        .onChange(of: bioAuthEnabled) { oldValue, newValue in
            if newValue {
                if let boolModel = bools.first(where: { $0.name == "bioAuthEnabled" }) {
                    boolModel.bool = true
                }else {
                    let newBool = BoolDataModel(name: "bioAuthEnabled", bool: true)
                    modelContext.insert(newBool)
                }
            }else {
                if let boolModel = bools.first(where: { $0.name == "bioAuthEnabled" }) {
                    boolModel.bool = false
                }else {
                    let newBool = BoolDataModel(name: "bioAuthEnabled", bool: false)
                    modelContext.insert(newBool)
                }
            }
        }
    }
    
    var mainView: some View {
        List{
            if appSecurityisOn {
                Text("turn-off-app-pass")
                    .foregroundStyle(K.Colors.mainColor)
                    .onTapGesture {
                        appSecurityisOn = false
                    }
                    .listRowBackground (
                        GlassListRow()
                    )
            }else {
                Text("turn-on-app-pass")
                    .foregroundStyle(K.Colors.mainColor)
                    .onTapGesture {
                        appSecurityisOn = true
                    }
                    .listRowBackground (
                        GlassListRow()
                    )
            }
            Toggle("bioauth-enabled", isOn: $bioAuthEnabled)
                .disabled(!appSecurityisOn)
                .listRowBackground (
                    GlassListRow()
                )
            HStack{
                Text("change-password")
                Spacer()
                Image(systemName: "chevron.right")
            }
            .contentShape(.rect)
            .onTapGesture {
                if appSecurityisOn {
                    showSheet = true
                }
            }
            .listRowBackground (
                GlassListRow()
            )
            .disabled(!appSecurityisOn)
            .foregroundStyle(!appSecurityisOn ? Color.secondary : Color(K.Colors.text))
            .onChange(of: appSecurityisOn) { oldValue, newValue in
                if newValue != secure {
                    if !newValue {
                        if let passModel = strings.first(where: { $0.name == "appPass" }) {
                            modelContext.delete(passModel)
                        }
                        if let typeModel = strings.first(where: { $0.name == "appPappPassTypeass" }) {
                            modelContext.delete(typeModel)
                        }
                        if let appSecure = bools.first(where: { $0.name == "appSecure" }) {
                            modelContext.delete(appSecure)
                        }
//                        viewModel.changeAppSecure(false)
                    }else if newValue {
                        showSheet = true
                    }
                }
            }
        }
        .scrollContentBackground(backgroundType == "none" ? .visible : .hidden)
        .background {
            ListBackground()
        }
        .sheet(isPresented: $showSheet, onDismiss: {}, content: {
            VStack {
                if passStage == 1 {
                    PassOrBiometricView(
                        isPresented: $published.closed,
                        pass: $pass,
                        wrongPass: $wrongPass,
                        appPass: appPass,
                        appPassType: appPassType,
                        width: width,
                        addToCheckPass: checkCurrent,
                        tryBiom: false,
                        text: error
                    )
                }else if passStage == 2 {
                    HStack {
                        Text(String(localized: "pass-type"))
                        Spacer()
                        Menu {
                            Button {
                                passType = 1
                                pass = ""
                            }label: {
                                Label("4-number", systemImage: "4.circle")
                            }
                            Button {
                                passType = 2
                                pass = ""
                            }label: {
                                Label("6-number", systemImage: "6.circle")
                            }
                            Button {
                                passType = 3
                                pass = ""
                            }label: {
                                Label("alphanumeric-passcode", systemImage: "ellipsis.rectangle")
                            }
                        }label: {
                            Text(returnLabel())
                            Image(systemName: "chevron.up.chevron.down")
                        }
                        .accentColor(Color(K.Colors.lightGray))
                    }
                    .padding(.horizontal, 15)
                    .padding([.bottom, .top], 20)
                    PassOrBiometricView(
                        isPresented: $published.closed,
                        pass: $pass,
                        wrongPass: $wrongPass,
                        appPass: appPass,
                        appPassType: passType,
                        width: width,
                        addToCheckPass: checkCreate,
                        tryBiom: false,
                        text: error
                    )
                }else if passStage == 3 {
                    PassOrBiometricView(
                        isPresented: $published.closed,
                        pass: $pass,
                        wrongPass: $wrongPass,
                        appPass: appPass,
                        appPassType: passType,
                        width: width,
                        addToCheckPass: checkRepeat,
                        tryBiom: false,
                        text: error
                    )
                }
            }
            .onAppear(perform: {
                checkSecure()
                if secure {
                    error = String(localized: "current-password")
                    passStage = 1
                }else {
                    error = String(localized: "create-password")
                    passStage = 2
                }
            })
        })
    }
    func checkCurrent(_ str:  String) {
        let limit = appPassType == 1 ? 4 : (appPassType == 2 ? 6 : 100)
        error = String(localized: "current-password")
        if limit == 100 || str == "123" {
            if pass == appPass {
                passStage += 1
                pass = ""
            }else {
                wrongPass += 1
                Toast.shared.present(
                    title: String(localized: "wrong-current-pass"),
                    symbol: "wrongwaysign",
                    isUserInteractionEnabled: true,
                    timing: .short
                )
                pass = ""
            }
        }else {
            if pass.count < limit - 1 {
                pass += str
            } else if pass.count == limit - 1 {
                pass += str
                if pass == appPass {
                    passStage += 1
                    pass = ""
                    wrongPass = 0
                }else {
                    if wrongPass <= 9 {
                        wrongPass += 1
                        Toast.shared.present(
                            title: String(localized: "wrong-current-pass"),
                            symbol: "wrongwaysign",
                            isUserInteractionEnabled: true,
                            timing: .short
                        )
                        pass = ""
                    }else {
                        pass = ""
                        if let userId = viewModel.currentUser?.uid {
                            viewModel.updateStatus(status: "block", uid: userId)
                        }
                        Toast.shared.present(
                            title: String(localized: "Ooops... You blocked!"),
                            symbol: "person.badge.minus",
                            isUserInteractionEnabled: true,
                            timing: .long
                        )
                    }
                }
            }
        }
    }
    
    func checkCreate(_ str:  String) {
        let limit = passType == 1 ? 4 : (passType == 2 ? 6 : 100)
        error = String(localized: "create-password")
        if limit == 100 || str == "123" {
            createPass = pass
            pass = ""
            passStage += 1
            error = String(localized: "repeat-password")
        }else {
            if pass.count < limit - 1 {
                pass += str
            } else if pass.count == limit - 1 {
                pass += str
                createPass = pass
                pass = ""
                passStage += 1
                error = String(localized: "repeat-password")
            }
        }
    }
    
    func checkRepeat(_ str:  String) {
        let limit = passType == 1 ? 4 : (passType == 2 ? 6 : 100)
        error = String(localized: "repeat-password")
        if limit == 100 || str == "123" {
            if createPass == pass, passStage == 3 {
                setPass()
                pass = ""
                passStage = 0
            }else {
                Toast.shared.present(
                    title: String(localized: "passwords-do-not-match"),
                    symbol: "lock.trianglebadge.exclamationmark",
                    isUserInteractionEnabled: true,
                    timing: .long
                )
                error = String(localized: "create-password")
                pass = ""
                createPass = ""
                passStage = 2
            }
        }else {
            if pass.count < limit - 1 {
                pass += str
            } else if pass.count == limit - 1 {
                pass += str
                if createPass == pass, passStage == 3 {
                    setPass()
                    pass = ""
                    passStage = 0
                }else {
                    Toast.shared.present(
                        title: String(localized: "passwords-do-not-match"),
                        symbol: "lock.trianglebadge.exclamationmark",
                        isUserInteractionEnabled: true,
                        timing: .long
                    )
                    error = String(localized: "create-password")
                    pass = ""
                    createPass = ""
                    passStage = 2
                }
            }
        }
    }
    //    private func addToPass(_ str: String) {
    
    
    private func setPass() {
        if let strModel = strings.first(where: { $0.name == "appPass" }), let str = published.encrypt(pass, key: K.key()) {
            strModel.string = str
        }else {
            if let str = published.encrypt(pass, key: K.key()) {
                let newModel = StringDataModel(name: "appPass", string: str)
                modelContext.insert(newModel)
            }
        }
        if let boolModel = bools.first(where: { $0.name == "appSecure" }) {
            boolModel.bool = true
        }else {
            let newModel = BoolDataModel(name: "appSecure", bool: true)
            modelContext.insert(newModel)
        }
//        viewModel.changeAppSecure(true)
        showSheet = false
        appSecurityisOn = true
        Toast.shared.present(
            title: String(localized: "pass-is-set"),
            symbol: "lock",
            isUserInteractionEnabled: true,
            timing: .long
        )
        if let intModel = ints.first(where: { $0.name == "appPassType" }) {
            intModel.int = passType
        }else {
            let newModel = IntDataModel(name: "appPassType", int: passType)
            modelContext.insert(newModel)
        }
    }
    
    private func returnLabel() -> String {
        if passType == 1 {
            return String(localized: "4-number")
        }else if passType == 2 {
            return String(localized: "6-number")
        }else {
            return String(localized: "alphanumeric-passcode")
        }
    }
    
    @MainActor
    func addToCheckPass(_ str: String) {
        print("cheekiing...")
        let limit = appPassType == 1 ? 4 : (appPassType == 2 ? 6 : 100)
        if limit == 100 || str == "123" {
            if pass == appPass {
                pass = ""
                published.closed = false
                wrongPass = 0
            }else {
                if wrongPass <= 9 {
                    wrongPass += 1
                    Toast.shared.present(
                        title: String(localized: "wrong-current-pass"),
                        symbol: "wrongwaysign",
                        isUserInteractionEnabled: true,
                        timing: .short
                    )
                    pass = ""
                }else {
                    if let userId = viewModel.currentUser?.uid {
                        viewModel.updateStatus(status: "block", uid: userId)
                    }
                }
            }
        }else {
            if pass.count < limit - 1 {
                pass += str
            }else if pass.count == limit - 1 {
                pass += str
                if pass == appPass {
                    pass = ""
                    published.closed = false
                }else {
                    print(wrongPass + 1)
                    if wrongPass <= 9 {
                        wrongPass += 1
                        Toast.shared.present(
                            title: String(localized: "wrong-current-pass"),
                            symbol: "wrongwaysign",
                            isUserInteractionEnabled: true,
                            timing: .short
                        )
                    }else {
                        if let userId = viewModel.currentUser?.uid {
                            viewModel.updateStatus(status: "block", uid: userId)
                        }
                    }
                }
            }
        }
    }
    
    func checkSecure() {
        appSecurityisOn = secure
    }
}

#Preview {
    AppSecureView()
}
