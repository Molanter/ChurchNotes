//
//  IndexView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/16/23.
//

import SwiftUI
import SwiftData
import LocalAuthentication

struct IndexView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var published: PublishedVariebles

    @StateObject var networkMonitor = NetworkMonitor()
    
    @Query var credentials: [Credential]
    @Query var bools: [BoolDataModel]
    @Query var strings: [StringDataModel]
    @Query var ints: [IntDataModel]

//    @State private var viewModel = AuthViewModel()
    @State private var isUnlocked = false
    @State private var closed = true
    @State var wrongPass = 0
    @State var pass = ""
    
    let width = UIScreen.screenWidth / 5
    
    var bioAuthEnabled: Bool {
        if let boolModel = bools.first(where: { $0.name == "bioAuthEnabled" }) {
            return boolModel.bool
        }else {
            return false
        }
    }
    
    var appPass: String {
        if let boolModel = strings.first(where: { $0.name == "appPass" }), let str = published.decrypt(boolModel.string) {
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
    
    var secureApp: Bool {
        if let boolModel = bools.first(where: { $0.name == "secureApp" }) {
            return boolModel.bool
        }else {
            return false
        }
    }
    
    var appPassType: Int {
        if let intModel = ints.first(where: { $0.name == "appPassType" }) {
            return intModel.int
        }else {
            return 1
        }
    }
    
    var limit: Int {
        if appPassType == 1 {
            return 4
        }else if appPassType == 2 {
            return 6
        }else {
            return 100
        }
    }
    
    var utilities = Utilities()
    
    init() {
        print("iiinniitt")
    }
    
    var body: some View {
//        NavigationStack {
            ZStack {
                if viewModel.signedIn {
                    if isUnlocked || !secureApp {
                        ContentView()
                    }else {
                        PassOrBiometricView(
                            isPresented: $published.closed,
                            pass: $pass,
                            wrongPass: $wrongPass,
                            appPass: appPass,
                            appPassType: appPassType,
                            width: width,
                            addToCheckPass: addToPass,
                            tryBiom: bioAuthEnabled
                        )
                        .onChange(of: published.closed) { oldValue, newValue in
                            isUnlocked = !newValue
                        }
                    }
                }else{
                    LoginPage()
                        .accentColor(K.Colors.mainColor)
                }
            }
                    .fullScreenCover(isPresented: Binding(
                        get: { viewModel.currentUser?.status == "block" },
                        set: { _ in }
                    )) {
                        BlockedView()
                    }
            .onAppear {
                if published.device == .phone {
                    if secure {
                        if secureApp {
                            closed = published.closed
                        }
                    }else {
                        isUnlocked = true
                    }
                }else {
                    isUnlocked = true
                    published.closed = false
                }
                viewModel.credentials = self.credentials
                print("viewModel.credentials.count: \(viewModel.credentials.count)")
                print("viewModel.credentials.count: \(credentials.count)")
                utilities.overrideDisplayMode()
                print("apeaaarssss")
                viewModel.signedIn = viewModel.isSignedIn
            }
//        }
    }
    
    @MainActor
    func addToPass(_ str: String) {
        print("func")
        if limit == 100 || str == "123" {
            if pass == appPass {
                print("maybe 123 pass = appPass")
                pass = ""
                published.closed = false
                wrongPass = 0
            }else {
                print("wrong")
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
            print("else")
            if pass.count < limit - 1 {
                pass += str
            }else if pass.count == limit - 1 {
                pass += str
                if pass == appPass {
                    pass = ""
                    self.isUnlocked = true
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
            }
        }
    }
}

//#Preview {
//        IndexView()
//            .environmentObject(AppViewModel())
//            .environmentObject(PublishedVariebles())
//
//}
