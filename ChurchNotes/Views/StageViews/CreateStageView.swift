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
    
    var body: some View {
        NavigationStack{
            List{
                Section(header: Text("write-new-stage-name")){
                    HStack{
                        TextField("have-coffee", text: $title)
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                            .onSubmit {
                                addItemTitle()
                            }
                        Spacer()
                        Image(systemName: "folder")
                    }
                }
                Section{
                    Text("add")
                        .foregroundColor(Color.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(K.Colors.mainColor)
                        .cornerRadius(10)
                        .onTapGesture {
                            addItemTitle()
                        }
                        .listRowInsets(EdgeInsets())
                }
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: {
                        presentSheet.toggle()
                    }){
                        Text("cancel")
                            .foregroundColor(K.Colors.mainColor)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {addItemTitle()}){
                        Text("add")
                            .foregroundColor(K.Colors.mainColor)
                    }
                }
            }
        }
    }
    
    func nameError(){
        Toast.shared.present(
            title: String(localized: "stage-name-is-empty"),
            symbol: "questionmark.square",
            isUserInteractionEnabled: true,
            timing: .long
        )
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
