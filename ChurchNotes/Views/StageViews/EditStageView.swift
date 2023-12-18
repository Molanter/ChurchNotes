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
    @State private var nameIsEmpty = false
    @State private var showActionSheet = false
    
    @Binding var stage: Stage?
    
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
                            .onSubmit {
                                editStage()
                            }
                    }
                }
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 5.0).stroke(Color(K.Colors.darkGray), lineWidth: 1)
                )
                
                HStack(spacing: 10){
                    Button(action: {self.showActionSheet = false}){
                        Label("delete", systemImage: "trash")
                            .foregroundColor(Color.white)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(Color(K.Colors.red).opacity(0.65))
                            .cornerRadius(7)
                    }
                    Button(action: {editStage()}){
                        Label("save", systemImage: "checkmark.circle")
                            .foregroundColor(Color.white)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(Color(K.Colors.mainColor))
                            .cornerRadius(7)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            Spacer()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: {
                        self.stage = nil
                    }){
                        Text("cancel")
                            .foregroundColor(Color(K.Colors.mainColor))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {editStage()}){
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
    
    private func nameError(){
        withAnimation{
            nameIsEmpty = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            withAnimation{
                nameIsEmpty = false
            }
            }
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
