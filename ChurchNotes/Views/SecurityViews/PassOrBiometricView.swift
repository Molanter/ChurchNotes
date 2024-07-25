//
//  PassOrBiometricView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 5/21/24.
//

import SwiftUI
import LocalAuthentication
import SwiftData

struct PassOrBiometricView: View {
    @EnvironmentObject var published: PublishedVariebles
    
    @Query var bools: [BoolDataModel]

    @State var biometricType: LABiometryType = .none
    
    @Binding var isPresented: Bool
    @Binding var pass: String
    @Binding var wrongPass: Int

    var appPass: String
    var appPassType: Int
    var width: CGFloat
    var addToCheckPass: (String) -> Void
    var tryBiom: Bool = true
    var text: String = String(localized: "pass-or-biometric")

    
    var bioAuthEnabled: Bool {
        if let boolModel = bools.first(where: { $0.name == "bioAuthEnabled" }) {
            return boolModel.bool
        }else {
            return false
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(text)
                .font(.title2)
                .multilineTextAlignment(.center)
                .bold()
            if wrongPass != 0 {
                Text(wrongPass <= 7 ? String(format: NSLocalizedString("wrong-attempts-pass %d", comment: ""), wrongPass) : String(format: NSLocalizedString("attempts-left-pass %d", comment: ""), 10 - wrongPass))
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.red)

            }
            if appPassType == 1 {
                HStack(alignment: .center, spacing: 10) {
                    Image(systemName: pass.count >= 1 ? "circle.fill" : "circle")
                    Image(systemName: pass.count >= 2 ? "circle.fill" : "circle")
                    Image(systemName: pass.count >= 3 ? "circle.fill" : "circle")
                    Image(systemName: pass.count >= 4 ? "circle.fill" : "circle")
                }
                .frame(maxWidth: .infinity)
            } else if appPassType == 2 {
                HStack(alignment: .center, spacing: 10) {
                    Image(systemName: pass.count >= 1 ? "circle.fill" : "circle")
                    Image(systemName: pass.count >= 2 ? "circle.fill" : "circle")
                    Image(systemName: pass.count >= 3 ? "circle.fill" : "circle")
                    Image(systemName: pass.count >= 4 ? "circle.fill" : "circle")
                    Image(systemName: pass.count >= 5 ? "circle.fill" : "circle")
                    Image(systemName: pass.count >= 6 ? "circle.fill" : "circle")
                }
                .frame(maxWidth: .infinity)
            } else if appPassType == 3 {
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 35)
                            .foregroundStyle(Color.clear)
                            .background {
                                TransparentBlurView(removeAllFilters: true)
                                    .blur(radius: 9, opaque: true)
                                    .background(Color(K.Colors.text).opacity(0.1))
                                    .cornerRadius(7)
                            }
                        SecureField("password", text: $pass)
                            .padding(.horizontal, 10)
                            .submitLabel(.continue)
                            .onSubmit {
                                if !tryBiom {
                                    addToCheckPass("123")
                                    print("aaddeed")
                                }else {
                                    if pass == appPass {
                                        print("pass is correct")
                                        addToCheckPass("123")
                                        isPresented = false
                                        published.closed = false
                                    }else if pass != appPass {
                                        print("pass is not correct")
                                        addToCheckPass("123")
                                    }
                                }
                            }
                    }
                    if tryBiom, bioAuthEnabled {
                        BiometricButton(biometricType: biometricType, width: width, tryBiometricAuthentication: tryBiometricAuthentication)
                            .padding(.vertical, 30)
                    }
                }
                .padding(.horizontal)
            }
            
            if appPassType == 1 || appPassType == 2 {
                VStack(spacing: 20) {
                    HStack(spacing: 20) {
                        ForEach(["1", "2", "3"], id: \.self) { number in
                            PassButton(number: number, letters: number == "1" ? " " : ["2": "ABC", "3": "DEF"][number] ?? "", width: width) {
                                addToCheckPass(number)
                            }
                        }
                    }
                    HStack(alignment: .center, spacing: 20) {
                        ForEach(["4", "5", "6"], id: \.self) { number in
                            PassButton(number: number, letters: ["4": "GHI", "5": "JKL", "6": "MNO"][number] ?? "", width: width) {
                                addToCheckPass(number)
                            }
                        }
                    }
                    HStack(spacing: 20) {
                        ForEach(["7", "8", "9"], id: \.self) { number in
                            PassButton(number: number, letters: ["7": "PQRS", "8": "TUV", "9": "WXYZ"][number] ?? "", width: width) {
                                addToCheckPass(number)
                            }
                        }
                    }
                    HStack(spacing: 20) {
                        if tryBiom, bioAuthEnabled {
                            BiometricButton(biometricType: biometricType, width: width, tryBiometricAuthentication: tryBiometricAuthentication)
                        }else {
                            Button {
                                
                            } label: {
                                VStack {
                                    Spacer()
                                }
                                .foregroundStyle(Color(K.Colors.text))
                                .frame(width: width, height: width, alignment: .top)
                                .padding(10)
                                .clipShape(Circle())
                            }
                        }
                        PassButton(number: "0", letters: "", width: width) {
                            addToCheckPass("0")
                        }
                        Button {
                            pass = String(pass.dropLast())
                        } label: {
                            VStack {
                                Spacer()
                                Image(systemName: "delete.backward")
                                    .font(.largeTitle)
                                Spacer()
                            }
                            .foregroundStyle(Color(K.Colors.text))
                            .frame(width: width, height: width, alignment: .top)
                            .padding(10)
                            .clipShape(Circle())
                        }
                    }
                }
                .padding(20)
                .padding(.top, 40)
            }
        }
        .onAppear {
            checkBiometricType()
            if tryBiom, bioAuthEnabled {
                tryBiometricAuthentication()
            }
        }
    }
    
    @MainActor
    func tryBiometricAuthentication() {
        let context = LAContext()
        var error: NSError?

        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "We need to unlock your data."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                Task { @MainActor in
                    if success {
                        self.published.closed = false
                        pass = appPass
                        addToCheckPass("123")
                        print("pass = appPass: passorbio")
                    } else {
                        self.published.closed = true
                    }
                }
            }
        } else {
            self.published.closed = true
        }
    }
    
    private func checkBiometricType() {
        let context = LAContext()
        var error: NSError?

        // Check if the device supports biometric authentication
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // Get the type of biometry supported by the device
            biometricType = context.biometryType
        } else {
            // Handle the error if necessary
            print(error?.localizedDescription ?? "Unknown error")
        }
    }
}



//#Preview {
//    PassOrBiometricView()
//}
