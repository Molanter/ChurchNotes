//
//  CreateStageView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 11/5/23.
//

import SwiftUI

struct CreateStageView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State var title = ""
    @Binding var presentSheet: Bool
    @State private var nameIsEmpty = false

    var body: some View {
        ZStack(alignment: .bottom){
            VStack(alignment: .leading, spacing: 20){
                Text("write-new-stage-name")
                    .font(.title2)
                    .fontWeight(.medium)
                HStack{
                    ZStack(alignment: .leading){
                        if title.isEmpty {
                            Text("have-coffee")
                                .foregroundStyle(.secondary)
                        }
                        TextField("", text: $title)
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                            .opacity(0.75)
                            .padding(0)
                            .textContentType(.countryName)
                            .onSubmit {
                                addItemTitle()
                            }
                    }
                }
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 5.0).stroke(Color(K.Colors.darkGray), lineWidth: 1)
                )
                Button(action: {addItemTitle()}){
                    Text("add")
                        .foregroundColor(Color.white)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(Color(K.Colors.mainColor))
                        .cornerRadius(7)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            Spacer()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: {
                        presentSheet.toggle()
                    }){
                        Text("cancel")
                            .foregroundColor(Color(K.Colors.mainColor))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {addItemTitle()}){
                        Text("save")
                            .foregroundColor(Color(K.Colors.mainColor))
                    }
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            Spacer()
            if nameIsEmpty{
                HStack(alignment: .center){
                    Text("stage-name-is-empty")
                        .foregroundStyle(Color(K.Colors.justDarkGray))
                }
                .frame(height: 40)
                .frame(maxWidth: .infinity)
                .background(Color(K.Colors.justLightGray))
                .cornerRadius(7)
                .onTapGesture(perform: {
                    withAnimation{
                        nameIsEmpty = false
                    }
                })
                .offset(y: nameIsEmpty ? -20 : 150)
            }
        }
        .padding(.horizontal, 15)
    }
    
    func nameError(){
        withAnimation{
            nameIsEmpty = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            withAnimation{
                nameIsEmpty = false
            }
            }
    }
    
    func addItemTitle(){
        if title != ""{
            viewModel.saveStages(name: title)
            self.presentSheet.toggle()
            title = ""
        }else{
            nameError()
        }
    }
}

//#Preview {
//    CreateStageView()
//}
