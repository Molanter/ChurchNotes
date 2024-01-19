//
//  ResetPasswordView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 11/8/23.
//

import SwiftUI

struct ResetPasswordView: View{
    @State var email: String = ""
    
    var loginEmail: String
    
    let restrictedEmaileSet = "!#$%^&*()?/>,<~`±§}{[]|\"÷≥≤µ˜∫√ç≈Ω`åß∂ƒ©˙∆˚¬…æ«‘“πøˆ¨¥†®´∑œ§¡™£¢∞§¶•ªº≠"
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @EnvironmentObject var published: PublishedVariebles
    @EnvironmentObject var viewModel: AppViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            Text("send-reset-password-email")
                .foregroundStyle(.primary)
                .font(.largeTitle)
                .fontWeight(.bold)
            ZStack(alignment: .leading){
                if email.isEmpty {
                    Text("eemail")
                        .padding(.leading)
                        .foregroundStyle(.secondary)
                }
                TextField("", text: $email)
                    .padding(.leading)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
                    .opacity(0.75)
                    .padding(0)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .onChange(of: email, perform: { newValue in
                        if email != ""{
                            email = String(newValue.filter { !restrictedEmaileSet.contains($0) })
                        }
                    })
            }
            .frame(height: 50)
            .overlay(
                RoundedRectangle(cornerSize: .init(width: 7, height: 7))
                    .stroke(Color(K.Colors.justLightGray).opacity(0.5), lineWidth: 1)
            )
            Button(action: {
                if email != "" && published.sended == false{
                    timerSend()
                }
            }){
                Text(published.sended ? "send-again-after: \(published.minute)s" : "send")
                    .foregroundStyle(published.sended ? Color(K.Colors.lightGray) : Color.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .onReceive(timer) { firedDate in
                        if published.sended && published.minute != 0{
                            print("timer fired")
                            published.minute -= 1
                        }else if published.minute == 0 {
                            published.sended = false
                            published.minute = 60
                        }
                    }
            }
            .background(Color(K.Colors.mainColor))
            .cornerRadius(7)
            .opacity(published.sended ? 0.5 : 1)
            .disabled(published.sended)
            Text(viewModel.passwordReseted ?? "")
                .foregroundStyle(.secondary)
                .font(.title2)
                .fontWeight(.bold)
            Spacer()
        }
        .onAppear {
            if published.minute != 60{
                published.sended = true
            }
            self.email = self.loginEmail
        }
        .padding(.horizontal, 15)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .accentColor(Color(K.Colors.mainColor))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text("Back")
                    }
                    .foregroundStyle(Color(K.Colors.mainColor))
                }
            }
        }
    }
    func timerSend(){
        published.sended = true
        viewModel.resetPassword(email: email)
        
    }
}

//#Preview {
//    let viewModel = AppViewModel()
//    ResetPasswordView()
//        .environmentObject(viewModel)
//}
