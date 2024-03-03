//
//  EditStageView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 11/21/23.
//

import SwiftUI

struct EditStageView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State private var title = ""
    @State private var showActionSheet = false
    
    @Binding var stage: Stage?
    
    var body: some View {
        NavigationStack{
            List{
                Section(header: Text("edit-stage-name")){
                    HStack{
                        TextField("have-coffee", text: $title)
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                            .onSubmit {
                                editStage()
                            }
                        Spacer()
                        Image(systemName: "folder")
                    }
                }
                
                Section{
                    Label("delete", systemImage: "trash")
                        .foregroundColor(Color.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(K.Colors.red).opacity(0.65))
                        .cornerRadius(10)
                        .onTapGesture {
                            self.showActionSheet = false
                        }
                        .listRowInsets(EdgeInsets())
                }
                Section{
                    Label("save", systemImage: "checkmark.circle")
                        .foregroundColor(Color.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(K.Colors.mainColor)
                        .cornerRadius(10)
                        .onTapGesture {
                            editStage()
                        }
                        .listRowInsets(EdgeInsets())
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: {
                        self.stage = nil
                    }){
                        Text("cancel")
                            .foregroundColor(K.Colors.mainColor)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {editStage()}){
                        Text("save")
                            .foregroundColor(K.Colors.mainColor)
                    }
                }
            }
            .onAppear(perform: {
                self.title = stage?.name ?? ""
            })
            .actionSheet(isPresented: $showActionSheet) {
                ActionSheet(title: Text("you-want-to-remove-this-stage '\(stage?.name ?? "")'?"),
                            message: Text("press-remove-to-resume"),
                            buttons: [
                                .cancel(),
                                .destructive(
                                    Text("remove")
                                ){
                                    viewModel.deleteStage(documentId: stage?.documentId ?? "")
                                }
                            ]
                )
            }
            .navigationTitle("edit \(stage?.name ?? "")")
        }
    }
    
    private func nameError(){
        Toast.shared.present(
            title: String(localized: "stage-name-is-empty"),
            symbol: "questionmark.square",
            isUserInteractionEnabled: true,
            timing: .long
        )
    }
    
    private func editStage(){
        if title != ""{
            viewModel.editStage(name: title, documentId: stage?.documentId ?? "")
            title = ""
            self.stage = nil
        }else{
            nameError()
        }
    }
}

//#Preview {
//    EditStageView()
//}
