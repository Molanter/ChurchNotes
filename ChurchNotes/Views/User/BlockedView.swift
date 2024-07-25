//
//  BlockedView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 5/25/24.
//

import SwiftUI

struct BlockedView: View {
    @EnvironmentObject var viewModel: AppViewModel

    @State var showSupport = false
    @State var showHelp = false
    
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(Color(K.Colors.blackAndWhite))
            VStack(alignment: .leading, spacing: 20){
                Spacer()
                Image(systemName: "nosign")
                    .font(.largeTitle)
                    .bold()

                Text("Ooops...")
                    .font(.title)
                    .bold()
                Text("your-ack-is-blocked")
                    .font(.title2)
                Spacer()
                HStack {
                    Button{
                        showSupport.toggle()
                    } label: {
                        Text("Support")
                            .font(.headline)
        .foregroundStyle(K.Colors.mainColor)
                    }
                    Spacer()
                    Button{
                        showHelp.toggle()
                    } label: {
                        Text("Help")
                            .font(.headline)
        .foregroundStyle(K.Colors.mainColor)
                    }
                }
            }
        }
        .padding(.horizontal, 25)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $showSupport, content: {
            SupportMainView()
                .presentationDetents([.height(300), .medium])
        })
        .sheet(isPresented: $showHelp, content: {
            VStack {
                HStack {
                    Text("your-ack-is-blocked")
                        .font(.title)
                        .bold()
                        .padding(.top, 10)
                    Spacer()
                }
                .padding(.top, 10)
                .padding(.horizontal, 15)
                .background(Color(K.Colors.listBg))
                List {
                    if let user = viewModel.currentUser {
                        Section {
                            Text(user.email)
                                .foregroundStyle(.secondary)
                            Text("blocket for: unlnown reason")
                        }header: {
                            Text("Reason")
                        }footer: {
                            Text(user.reason)
                        }
                    }
                    Section {
                        Text("If you think it was a mastake, or for any other help you can reach support.")
                        Label("Support", systemImage: "square.and.pencil")
                            .foregroundStyle(Color.white)
                            .padding(10)
                            .frame(maxWidth: .infinity)
                            .background(K.Colors.mainColor)
                            .cornerRadius(10)
                            .onTapGesture {
                                showHelp = false
                                showSupport = true
                            }
                    }header: {
                        Text("Help")
                    }
                }
            }
            .background(Color(K.Colors.listBg))
            .presentationDetents([.medium])
        })
    }
}

//#Preview {
//    BlockedView()
//}
