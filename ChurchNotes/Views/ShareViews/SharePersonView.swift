//
//  SharePersonView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 3/14/24.
//

import SwiftUI
import SwiftData

struct SharePersonView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var published: PublishedVariebles
    @Environment(\.dismiss) private var dismiss
    
    @Query var strings: [StringDataModel]
    
    @State var people: [Person]
    
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
                Section(header: Text("Whom")){
                    ForEach(people) { person in
                        HStack{
                            if !person.imageData.isEmpty{
                                AsyncImage(url: URL(string: person.imageData)){image in
                                    image.resizable()
                                    
                                }placeholder: {
                                    ProgressView()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 35, height: 35)
                                }
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 35, height: 35)
                                .cornerRadius(.infinity)
                            }else{
                                Image(systemName: "person.crop.circle.fill")
                                    .symbolRenderingMode(.palette)
                                    .resizable()
                                    .foregroundStyle(.white, Color(K.Colors.lightGray))
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 35)
                            }
                            Text(person.name)
                                .foregroundStyle(.primary)
                                .font(.title3)
                                .bold()
                        }
                        .frame(height: 40)
                    }
                    .onDelete { index in
                        people.remove(atOffsets: index)
                        if people.isEmpty{
                            dismiss()
                        }
                    }
                }
                .listRowBackground(
                    GlassListRow()
                )
                Section(header:
                            Image(systemName: "arrow.down")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 30)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    .foregroundStyle(.secondary)
                    .foregroundStyle(Color(K.Colors.text))
                    .listRowInsets(EdgeInsets())
                    .textCase(.none)
                    .frame(maxWidth: .infinity)
                ){}
                    .listRowBackground(
                        GlassListRow()
                    )
                Section(header: Text("With")){
                    ForEach(published.usersToShare){ user in
                        HStack{
                            ZStack(alignment: .bottomTrailing){
                                if !user.profileImageUrl.isEmpty{
                                    AsyncImage(url: URL(string: user.profileImageUrl)){image in
                                        image.resizable()
                                        
                                    }placeholder: {
                                        ProgressView()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 35, height: 35)
                                    }
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 35, height: 35)
                                    .cornerRadius(.infinity)
                                }else{
                                    Image(systemName: "person.crop.circle.fill")
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(.white, Color(K.Colors.lightGray))
                                        .font(.largeTitle)
                                        .frame(width: 35, height: 35)
                                }
                                ZStack{
                                    if let b = Badges().getBadgeArray()[user.badge] as? Badge{
                                        if b.string != ""{
                                            Text(b.string)
                                                .foregroundStyle(Color.white)
                                                .font(.system(size: 10))
                                                .padding(3)
                                                .background(
                                                    Circle()
                                                        .fill(K.Colors.mainColor)
                                                        .opacity(0.7)
                                                )
                                        }else{
                                            Image(systemName: b.image)
                                                .foregroundStyle(Color.white)
                                                .font(.system(size: 10))
                                                .padding(3)
                                                .background(
                                                    Circle()
                                                        .fill(K.Colors.mainColor)
                                                        .opacity(0.7)
                                                )
                                        }
                                    }
                                }
                            }
                            VStack(alignment: .leading){
                                Text(user.name.capitalized)
                                    .foregroundStyle(.primary)
                                    .font(.title3)
                                    .bold()
                                Text("\(user.email) • \(user.username)")
                                    .foregroundStyle(.secondary)
                                    .font(.body)
                            }
                        }
                        .frame(height: 40)
                    }
                    .onDelete { index in
                        published.usersToShare.remove(atOffsets: index)
                        if published.usersToShare.isEmpty {
                            dismiss()
                        }
                    }
                }
                .listRowBackground(
                    GlassListRow()
                )
                .listSectionSpacing(15)
                Section{
                    Label(people.count > 1 ? "Share People" : "share-person", systemImage: "square.and.arrow.up")
                        .foregroundStyle(Color.white)
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(K.Colors.mainColor)
                        .cornerRadius(10)
                        .listRowInsets(EdgeInsets())
                        .onTapGesture {
                            print("share pressed")
                            for user in published.usersToShare{
                                viewModel.createNotification(date: Date.now, message: " want to share person with you. Press the buttons below to do any actions.", type: "share-person", people: people.map { $0.id }, uid: user.uid, from: viewModel.currentUser?.uid ?? "app")
                            }
                            published.isEditing = false
                            self.dismiss()
                        }
                }
                .listRowBackground(
                    GlassListRow()
                )
            }
            .scrollContentBackground(backgroundType == "none" ? .visible : .hidden)
            .background {
                ListBackground()
            }
            .onAppear{
                print("people  :", people)
            }
            .navigationBarBackground()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button{
                        published.showShare = false
                    }label: {
                        Text("cancel")
                            .foregroundStyle(Color.white)
                    }
                }
            }
        }
    }
}

//#Preview {
//    SharePersonView()
//}
