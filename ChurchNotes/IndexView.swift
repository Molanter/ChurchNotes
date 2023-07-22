//
//  IndexView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/16/23.
//

import SwiftUI

struct IndexView: View {
    @EnvironmentObject var viewModel: AppViewModel

    var body: some View {
        ZStack{
            if viewModel.signedIn{
                AppView()
            }else{
                LoginPage()
            }
        }
        .onAppear{
            viewModel.signedIn = viewModel.isSignedIn
        }    }
}

#Preview {
    IndexView()
}
