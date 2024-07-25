//
//  ShakeReportView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 10/20/23.
//

import SwiftUI

struct ShakeReportView: View {
    @State private var errorText = ""
    @State private var anonymously = false
    @EnvironmentObject var viewModel: AppViewModel

    var body: some View {
            List {
                Text("write-issue-report")
                    .font(.title2)
                    .fontWeight(.medium)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden, edges: .all)
                    Section {
                        TextField("write-here", text: $errorText, axis: .vertical)
                            .lineLimit(10)
                            .onSubmit {
                                viewModel.shakeReport(anonymously, errorText: errorText)
                                self.errorText = ""
                            }
                    }
                    .listSectionSpacing(5)
                Section {
                    HStack{
                        Image(systemName: anonymously ? "checkmark.square.fill" : "square")
                            .contentTransition(.symbolEffect(.replace))
                            .onTapGesture {
                                self.anonymously.toggle()
                            }
                        Text("write-anonymously")
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden, edges: .all)
                        Text("report")
                        .disabled(errorText.isEmpty)
                            .foregroundColor(Color.white)
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(K.Colors.mainColor)
                    .cornerRadius(10)
                    .onTapGesture {
                        viewModel.shakeReport(anonymously, errorText: errorText)
                        self.errorText = ""
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden, edges: .all)
                }
            }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ShakeReportView()
}
