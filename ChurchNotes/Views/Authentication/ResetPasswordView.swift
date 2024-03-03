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
        NavigationStack{
            List{
                Section(header: Text("eemail")){
                    HStack{
                        TextField("eemail", text: $email)
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .onChange(of: email, perform: { newValue in
                                if email != ""{
                                    email = String(newValue.filter { !restrictedEmaileSet.contains($0) })
                                }
                            })
                        Spacer()
                        Image(systemName: "envelope")
                    }
                    }
                    Section{
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
                            .background(K.Colors.mainColor)
                    .cornerRadius(10)
                    .opacity(published.sended ? 0.5 : 1)
                    .disabled(published.sended)
                    .onTapGesture {
                        if email != "" && published.sended == false{
                            timerSend()
                        }
                    }
                    .listRowInsets(EdgeInsets())
                    if let str = viewModel.passwordReseted{
                        Text(str)
                            .foregroundStyle(.secondary)
                            .font(.title2)
                            .fontWeight(.bold)
                        }
                    }
            }
            .navigationTitle("send-reset-password-email")
            .onAppear {
                if published.minute != 60{
                    published.sended = true
                }
                self.email = self.loginEmail
            }
            .accentColor(K.Colors.mainColor)
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
                        .foregroundStyle(K.Colors.mainColor)
                    }
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
