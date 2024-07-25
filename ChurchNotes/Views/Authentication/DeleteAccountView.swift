//
//  DeleteAccountView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 3/4/24.
//

import SwiftUI
import SwiftData

struct DeleteAccountView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) var modelContext
    
    @Query var reminders: [ReminderDataModel]
    @Query var strings: [StringDataModel]

    @State private var showDeleteText = false
    @State private var showAction = false

    var backgroundType: String {
        if let strModel = strings.first(where: { $0.name == "backgroundType" }) {
            return strModel.string
        }else {
            return "none"
        }
    }
    
    var body: some View {
        NavigationStack{
            List{
                Section{
                    Text(showDeleteText ? "are-you-sure-that-you-want-to-delete-account" : "do-you-want-to-delete-account")
                        .bold()
                        .font(.title)
                    if showDeleteText {
                        Text("all-account-information-will-be-deleted")
                            .font(.title2)
                        Text("bullet-list-profile")
                        Text("bullet-list-people-list")
                        Text("bullet-list-notifications")
                        Text("bullet-list-other-info")

                    }
                }
                .listRowBackground(
                    GlassListRow()
                )
                Section{
                    Label("delete", systemImage: "trash")
                        .foregroundStyle(Color.white)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                        .onTapGesture {
                            withAnimation{
                                if !showDeleteText{
                                    self.showDeleteText = true
                                }else{
                                    self.showAction.toggle()
                                }
                            }
                        }
                        .listRowInsets(EdgeInsets())
                        .actionSheet(isPresented: $showAction) {
                            ActionSheet(title: Text("delete-acount"),
                                        message: Text("delete-account-action-text"),
                                        buttons: [
                                            .cancel(),
                                            .destructive(
                                                Text("delete")
                                            ){
                                                delete()
                                            }
                                        ]
                            )
                        }
                }
                .listRowBackground(
                    GlassListRow()
                )
                Section{
                    Label("cancel", systemImage: "xmark")
                        .foregroundStyle(Color.white)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(K.Colors.mainColor)
                        .cornerRadius(10)
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .listRowInsets(EdgeInsets())
                }
                .listRowBackground(
                    GlassListRow()
                )
                .listSectionSpacing(10)
            }
            .scrollContentBackground(backgroundType == "none" ? .visible : .hidden)
            .background {
                ListBackground()
            }
        }
    }
    
    func delete(){
        deletePeople()
        for r in reminders {
            modelContext.delete(r)
        }
        viewModel.deleteProfile(modelContext: modelContext)
        viewModel.deleteUserAccount()
        viewModel.logOut()
    }
    
    func deletePeople(){
        for person in viewModel.peopleArray{
            viewModel.deletePerson(documentId: person.documentId)
        }
    }
}

#Preview {
    DeleteAccountView()
}
