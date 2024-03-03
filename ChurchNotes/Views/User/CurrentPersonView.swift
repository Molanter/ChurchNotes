//
//  CurrentPersonView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/19/23.
//

import SwiftUI

struct CurrentPersonView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        NavigationStack{
            
                List{
                    Section(header: VStack{
                        RectOvalPath()
                            .fill(K.Colors.mainColor)
                        VStack(alignment: .center){
                            Text(viewModel.currentUser?.name ?? "name")
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .font(.title2)
                                .fontWeight(.medium)
                            if let email = viewModel.currentUser?.email{
                                Text(email)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .font(.callout)
                                    .fontWeight(.light)
                                    .padding(.bottom)
                            }
                            if let profileImage = viewModel.currentUser?.profileImageUrl{
                                AsyncImage(url: URL(string: profileImage)){image in
                                    image.resizable()
                                }placeholder: {
                                    ProgressView()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 80, height: 80)
                                }
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .cornerRadius(.infinity)
                                .overlay(
                                    Circle().stroke(Color(K.Colors.darkGray).opacity(0.6), lineWidth: 1)
                                )
                                .background(
                                    Color(K.Colors.background)
                                        .cornerRadius(.infinity)
                                )
                            }else{
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80, height: 80)
                                    .symbolRenderingMode(.multicolor)
                                    .foregroundColor(Color(K.Colors.justLightGray))
                                    .overlay(
                                        Circle().stroke(Color(K.Colors.darkGray).opacity(0.6), lineWidth: 1)
                                    )
                            }
                            
                            
                        }
                        .offset(y: 35)
                    }
                        .textCase(nil)
                        .listRowInsets(EdgeInsets())
                        .frame(width: UIScreen.main.bounds.width,alignment: .center)
                    ) {
                        
                    }
                    .frame(height: 200)
                    .padding(.bottom, 15)
                    Section(header: Text("iinfo")){
                        VStack(alignment: .leading){
                            Text("name-low")
                                .font(.subheadline)
                            Text(viewModel.currentUser?.name ?? "name")
                                .font(.headline)
                        }
                        VStack(alignment: .leading){
                            Text("username-low")
                                .font(.subheadline)
                            Menu{
                                Button{
                                    UIPasteboard.general.string = viewModel.currentUser?.username ?? ""
                                    Toast.shared.present(
                                        title: String(localized: "ccopiedd"),
                                        symbol: "at",
                                        isUserInteractionEnabled: true,
                                        timing: .long
                                    )
                                }label: {
                                    Label("ccoppy-username", systemImage: "at")
                                }
                            }label: {
                                Text("@\(viewModel.currentUser?.username ?? "username")")
                                    .font(.headline)
                                    .foregroundStyle(K.Colors.mainColor)
                            }
                        }
                        if !(viewModel.currentUser?.notes ?? "").isEmpty {
                            VStack(alignment: .leading){
                                Text("notes-low")
                                    .font(.subheadline)
                                Text(viewModel.currentUser?.notes ?? "notes")
                                    .font(.headline)
                            }
                        }
                        if !(viewModel.currentUser?.role ?? "").isEmpty {
                            VStack(alignment: .leading){
                                Text("role-low")
                                    .font(.subheadline)
                                Text(viewModel.currentUser?.role ?? "user")
                                    .font(.headline)
                            }
                        }
                        if !(viewModel.currentUser?.country ?? "").isEmpty {
                            VStack(alignment: .leading){
                                Text("country-low")
                                    .font(.subheadline)
                                Text(viewModel.currentUser?.country.capitalized ?? "country")
                                    .font(.headline)
                            }
                        }
                    }
                    Section(header: Text("achievements")){
                        VStack(alignment: .leading){
                            Text("next-low")
                                .font(.subheadline)
                            Text(String(viewModel.currentUser?.next ?? 0))
                                .font(.headline)
                        }
                        VStack(alignment: .leading){
                            Text("done-low")
                                .font(.subheadline)
                            Text(String(viewModel.currentUser?.done ?? 0))
                                .font(.headline)
                        }
                    }
                    if !(viewModel.currentUser?.email ?? "").isEmpty || !(viewModel.currentUser?.phoneNumber ?? "").isEmpty {
                        Section(header: Text("ccontacts")){
                            VStack(alignment: .leading){
                                Text("eemail-low")
                                    .font(.subheadline)
                                Menu{
                                    Button{
                                        UIPasteboard.general.string = viewModel.currentUser?.email ?? ""
                                        Toast.shared.present(
                                            title: String(localized: "ccopiedd"),
                                            symbol: "envelope",
                                            isUserInteractionEnabled: true,
                                            timing: .long
                                        )
                                    }label: {
                                        Label("ccoppy-email", systemImage: "envelope")
                                    }
                                }label: {
                                    Text(viewModel.currentUser?.email ?? "")
                                        .font(.headline)
                                        .foregroundStyle(K.Colors.mainColor)
                                }
                            }
                            VStack(alignment: .leading){
                                Text("phone-low")
                                    .font(.subheadline)
                                Menu{
                                    Button{
                                        UIPasteboard.general.string = viewModel.currentUser?.phoneNumber ?? ""
                                        Toast.shared.present(
                                            title: String(localized: "ccopiedd"),
                                            symbol: "phone",
                                            isUserInteractionEnabled: true,
                                            timing: .long
                                        )
                                    }label: {
                                        Label("ccoppy-phone", systemImage: "phone")
                                    }
                                }label: {
                                    Text(viewModel.currentUser?.phoneNumber ?? "")
                                        .font(.headline)
                                        .foregroundStyle(K.Colors.mainColor)
                                }
                            }
                        }
                    }
                    //                    if let notes = viewModel.currentUser?.notes{
                    //                        VStack(alignment: .leading, spacing: 15){
                    //                            HStack(spacing: 20){
                    //                                ZStack{
                    //                                    Circle()
                    //                                        .foregroundStyle(Color(K.Colors.gray).opacity(0.5))
                    //                                        .frame(width: 40, height: 40)
                    //                                    Image(systemName: "at")
                    //                                        .resizable()
                    //                                        .aspectRatio(contentMode: .fit)
                    //                                        .frame(width: 20)
                    //                                        .foregroundStyle(Color(K.Colors.mainColor))
                    //                                        .fontWeight(.light)
                    //                                }
                    //                                Text(notes)
                    //                                    .font(.title3)
                    //                                    .fontWeight(.light)
                    //                                    .font(.system(size: 20))
                    //                            }
                    //                            Divider()
                    //
                    //                        }
                    //                    }
                }
                .background(Color(K.Colors.listBg))
                .navigationBarBackButtonHidden(false)
            }
        
    }
}

#Preview {
    CurrentPersonView()
}
