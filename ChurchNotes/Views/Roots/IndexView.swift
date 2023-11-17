//
//  IndexView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/16/23.
//

import SwiftUI

struct IndexView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @StateObject var networkMonitor = NetworkMonitor()
    var utilities = Utilities()

    var body: some View {
        ZStack{
            if viewModel.signedIn{
                AppView()
                    .onAppear{
                        viewModel.peopleArray.removeAll()
                        viewModel.stagesArray.removeAll()
                        viewModel.fetchStages()
                        viewModel.fetchPeople()
                        viewModel.fetchUser()
                    }
                    .accentColor(Color(K.Colors.mainColor))
                    .environmentObject(networkMonitor)
            }else{
                LoginPage()
                    .accentColor(Color(K.Colors.mainColor))
            }
        }
        .onAppear{
            utilities.overrideDisplayMode()
            print("apeaaarssss")
            viewModel.signedIn = viewModel.isSignedIn
        }    }
}

#Preview {
    IndexView()
}
