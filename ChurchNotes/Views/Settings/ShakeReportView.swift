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
        VStack(alignment: .leading){
            VStack(alignment: .leading, spacing: 20){
                Text("Write Issue Report")
                    .font(.title2)
                    .fontWeight(.medium)
                HStack{
                    TextField("Write here...", text: $errorText)
                        .frame(height: 100, alignment: .topLeading)
                        .onSubmit {
                            viewModel.shakeReport(anonymously, errorText: errorText)
                            self.errorText = ""
                        }
                }
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 5.0).stroke(Color(K.Colors.darkGray), lineWidth: 1)
                )
                HStack{
                    Image(systemName: anonymously ? "checkmark.square.fill" : "square")
                        .contentTransition(.symbolEffect(.replace))
                        .onTapGesture {
                            self.anonymously.toggle()
                        }
                    Text("Write anonymously")
                }
                Button(action: {
                    viewModel.shakeReport(anonymously, errorText: errorText)
                    self.errorText = ""
                }){
                    Text("Add")
                        .foregroundColor(Color.white)
                }
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(Color(K.Colors.mainColor))
                .cornerRadius(7)
            }
            .padding(15)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ShakeReportView()
}
