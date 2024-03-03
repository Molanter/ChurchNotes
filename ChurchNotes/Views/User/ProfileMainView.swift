//
//  ProfileMainView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 12/26/23.
//

import SwiftUI
import UserNotifications

struct ProfileMainView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var published: PublishedVariebles
    
    @State private var position = 0
    @State var blur = 0.0
    @State var copied = false
    @State private var selection: Int? = nil
    @State private var currentItem: Person?
    
    private var gridItemLayout = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack{
            ZStack(alignment: .top){
                ScrollView{
                    ZStack(alignment: .top){
                        if let profileImage = viewModel.currentUser?.profileImageUrl, !profileImage.isEmpty{
                            AsyncImage(url: URL(string: profileImage)){image in
                                image.resizable()
                            }placeholder: {
                                ProgressView()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: UIScreen.screenHeight / 3.5)
                            }
                            .aspectRatio(contentMode: .fill)
                            .frame(height: UIScreen.screenHeight / 3.5)
                            .clipped()
                        }else{
                            Image(systemName: "person.and.background.dotted")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: UIScreen.screenHeight / 3.5)
                                .clipped()
                                .symbolRenderingMode(.multicolor)
                                .foregroundColor(Color(K.Colors.justLightGray))
                        }
                    }
                    VStack(spacing: 0){
                        VStack(alignment: .leading, spacing: 0){
                            VStack(spacing: 0){
                                ZStack(alignment: .bottomTrailing){
                                    if let profileImage = viewModel.currentUser?.profileImageUrl, !profileImage.isEmpty{
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
                                            Circle().stroke(Color(K.Colors.darkGray).opacity(0.6), lineWidth: 2)
                                        )
                                    }else{
                                        Image(systemName: "person.circle.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 80, height: 80)
                                            .symbolRenderingMode(.multicolor)
                                            .foregroundColor(Color(K.Colors.justLightGray))
                                            .overlay(
                                                Circle().stroke(Color(K.Colors.background), lineWidth: 2)
                                            )
                                    }
                                    ZStack{
                                        if let badg = viewModel.currentUser?.badge{
                                            if let b = K.Badges().getBadgeArray()[badg] as? Badge{
                                                if b.string != ""{
                                                    Text(b.string)
                                                        .foregroundStyle(Color.white)
                                                        .font(.system(size: 18))
                                                        .padding(7)
                                                        .background(
                                                            Circle()
                                                                .fill(K.Colors.mainColor)
                                                                .opacity(0.7)
                                                        )                                            }else{
                                                            Image(systemName: b.image)
                                                                .foregroundStyle(Color.white)
                                                                .font(.system(size: 18))
                                                                .padding(7)
                                                                .background(
                                                                    Circle()
                                                                        .fill(K.Colors.mainColor)
                                                                        .opacity(0.7)
                                                                )
                                                        }
                                            }
                                        }
                                    }
                                }
                                //                            .frame(alignment: .bottomTrailing)
                                .offset(x: 0, y: -35)
                                VStack(alignment: .center, spacing: 10){
                                    Text(viewModel.currentUser?.name ?? "")
                                        .font(.title2)
                                    if !(viewModel.currentUser?.notes.isEmpty ?? true){
                                        Text(viewModel.currentUser?.notes ?? "")
                                            .font(.footnote)
                                            .foregroundStyle(.secondary)
                                    }else{
                                        Menu{
                                            Button {
                                                UIPasteboard.general.string = viewModel.currentUser?.email ?? ""
                                                self.copyToClipboard()
                                                Toast.shared.present(
                                                    title: String(localized: "ccopiedd"),
                                                    symbol: "envelope",
                                                    isUserInteractionEnabled: true,
                                                    timing: .long
                                                )
                                            }label: {
                                                Label("ccoppy-email", systemImage: "envelope")
                                            }
                                            Button{
                                                UIPasteboard.general.string = viewModel.currentUser?.username ?? ""
                                                self.copyToClipboard()
                                                Toast.shared.present(
                                                    title: String(localized: "ccopiedd"),
                                                    symbol: "at",
                                                    isUserInteractionEnabled: true,
                                                    timing: .long
                                                )
                                            }label: {
                                                Label("ccoppy-username", systemImage: "at")
                                            }
                                        }label:{
                                            if copied{
                                                Label("ccopiedd", systemImage: "checkmark")
                                            }else{
                                                Text("\(viewModel.currentUser?.email ?? "") ∙ @\(viewModel.currentUser?.username ?? "")")
                                            }
                                        }
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                    }
                                    
                                }
                            }
                            .padding(.horizontal, 15)
                            .padding(.bottom, 10)
                            .frame(maxWidth: .infinity, alignment: .center)
                            Divider()
                                .padding(.horizontal, 25)
                            ScrollView(.horizontal){
                                HStack(spacing: 15){
                                    NavigationLink(destination: AllPeopleView()
                                                   
                                        .onAppear(perform: {
                                            published.tabsAreHidden = true
                                        })
//                                            .toolbar(.hidden, for: .tabBar)
                                                   
                                    ){
                                        VStack(alignment: .leading, spacing: 5){
                                            
                                            Text(String(viewModel.peopleArray.count))
                                                .font(.headline)
                                                .fontWeight(.semibold)
                                            Text("people")
                                                .font(.footnote)
                                        }
                                        .foregroundStyle(Color(K.Colors.text))
                                    }
                                    Divider()
                                    NavigationLink(destination: AchievementsMainView()
                                        .onAppear(perform: {
                                            published.tabsAreHidden = true
                                        })
//                                            .toolbar(.hidden, for: .tabBar)
                                                   
                                    ){
                                        VStack(alignment: .leading, spacing: 5){
                                            Text(String(viewModel.badgesArray.count))
                                                .font(.headline)
                                                .fontWeight(.semibold)
                                            Text("bbadges")
                                                .font(.footnote)
                                        }
                                        .foregroundStyle(Color(K.Colors.text))
                                    }
                                    Divider()
                                    Button(action: {
                                        self.published.showEditProfileSheet = true
                                    }){
                                        Image(systemName: "square.and.pencil")
                                            .font(.system(size: 22))
                                            .foregroundStyle(Color.white)
                                            .padding(10)
                                            .background(K.Colors.mainColor)
                                            .cornerRadius(7)
                                    }
                                }
                                .padding(.horizontal, 25)
                                .padding(.vertical, 20)
                            }
                            .scrollIndicators(.hidden)
                            Divider()
                                .padding(.horizontal, 25)
                                .padding(.bottom, 10)
                            //                        List{
                            //                            Button(action: {
                            //                                UIApplication.shared.applicationIconBadgeNumber = 0
                            //                            }) {
                            //                                Text("Clean Messages")
                            //                            }
                            //                            ForEach(1..<16){ num in
                            //                                Text("\(num)")
                            //                            }
                            //                        }
                            //                        .frame(height: 900, alignment: .top)
                            LazyVGrid(columns: gridItemLayout, alignment: .center, spacing: 15) {
                                ForEach(viewModel.peopleArray.sorted(by: { $0.orderIndex < $1.orderIndex }).sorted(by: { $0.isLiked && !$1.isLiked })) { item in
                                    Button(action: {
                                        currentItem = item
                                    }){
                                        ZStack(alignment: .center){
                                            if item.imageData != ""{
                                                AsyncImage(url: URL(string: item.imageData)){image in
                                                    image.resizable()
                                                }placeholder: {
                                                    ProgressView()
                                                        .aspectRatio(contentMode: .fill)
                                                }
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: (UIScreen.screenWidth / 2) - 45, height: 150)
                                            }else{
                                                Text(viewModel.twoNames(name: item.name))
                                                    .textCase(.uppercase)
                                                    .bold()
                                                    .font(.system(size: 48))
                                                    .foregroundColor(Color(K.Colors.text))
                                                    .padding(.bottom, 20)
                                            }
                                                VStack{
                                                    Spacer()
                                                    ZStack{
                                                        Rectangle()
                                                            .fill(Color(K.Colors.whiteGray))
                                                            .frame(height: 60, alignment: .bottom)
                                                        VStack(alignment: .leading){
                                                            Text(item.name)
                                                                .font(.title3)
                                                                .bold()
                                                                .foregroundColor(Color(K.Colors.text))
                                                                .lineLimit(1)
                                                                .multilineTextAlignment(.leading)
                                                            HStack(spacing: 1){
                                                                Text(item.timestamp, format: .dateTime.month(.wide))
                                                                Text(item.timestamp, format: .dateTime.day())
                                                                Text(", \(item.timestamp, format: .dateTime.year()), ")
                                                                Text(item.timestamp, style: .time)
                                                            }
                                                            .font(.caption)
                                                            .foregroundStyle(Color(K.Colors.lightGray))
                                                        }
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                        .padding(.horizontal, 10)
                                                        .padding(.bottom, 5)
                                                    }
                                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                                                }
                                            Image(systemName: item.isLiked ? "\(K.favouriteSign).fill" : "")
                                                .foregroundStyle(Color.white)
                                                .contentTransition(.symbolEffect(.replace))
                                                .padding(10)
                                                .onTapGesture {
                                                    withAnimation{
                                                        viewModel.likePerson(documentId: item.documentId, isLiked: false)
                                                    }
                                                }
                                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                        }
                                        .frame(height: 150)
                                        .frame(maxWidth: .infinity, alignment: .bottom)
                                        .background(Color(K.Colors.darkGray))
                                        .cornerRadius(10)
                                        .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.08), radius: 14, x: 0, y: 22)
                                        .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.08), radius: 6, x: 0, y: 14)
                                        .padding(.horizontal, 5)
                                    }
                                    
                                }
                            }
                            .padding(.horizontal, 15)
                        }
                    }
                    .background{
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(K.Colors.blackAndWhite))
                    }
                    .background(GeometryReader {
                        Color.clear.preference(key: ViewOffsetKey.self,
                                               value: -$0.frame(in: .named("scroll")).origin.y)
                    })
                    .onPreferenceChange(ViewOffsetKey.self) {
                        let offset = $0
                        print(offset)
                        self.blur = max(min(-offset / (97 - 10), 0), 1)
                        print(blur)
                        if $0 >= 215 && UIScreen.screenHeight >= 920 && UIScreen.screenHeight <= 1000 {
                            
                        }else if $0 >= 190 && UIScreen.screenHeight >= 780 && UIScreen.screenHeight <= 919{
                            self.blur = 0
                        }else if $0 >= 166 && UIScreen.screenHeight <= 779{
                            self.blur = 0
                        }else{
                            self.blur = 0
                        }
                        
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
            }
            .onAppear(perform: {
                published.tabsAreHidden = false
            })
            .onDisappear(perform: {
                if published.currentTabView == 2{
                    published.tabsAreHidden = true
                }
            })
            .toolbar(content: {
                if viewModel.currentUser?.role == "volunteer" || viewModel.currentUser?.role == "developer" || viewModel.currentUser?.role == "jedai" {
                    ToolbarItem(placement: .topBarTrailing, content: {
                        Button(action: {
                            viewModel.logOut()
                            
                        }){
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .foregroundStyle(K.Colors.mainColor)
                        }
                    })
                }
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button {
                        published.currentProfileMainView = 1
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(K.Colors.mainColor)
                    }
                    .navigationDestination(
                        isPresented: Binding(
                            get: { published.currentProfileMainView == 1 },
                            set: { newValue in
                                published.currentProfileMainView = newValue ? 1 : nil
                            }
                        )
                    ) {
                        SettingsView()
                            .onAppear(perform: {
                                published.tabsAreHidden = true
                            })
//                            .toolbar(.hidden, for: .tabBar)
                    }
                    
                })
            })
            .sheet(item: $currentItem, onDismiss: nil){ item in
                NavigationStack{
                    ItemPersonView(item: item, currentItem: $currentItem)
                        .toolbar{
                            ToolbarItem(placement: .topBarLeading){
                                Button(action: {
                                    currentItem = nil
                                }){
                                    Text("cancel")
                                }
                            }
                        }
                }
                .accentColor(Color.white)
            }
            .sheet(isPresented: $published.showEditProfileSheet, onDismiss: {}, content: {
                NavigationStack{
                    EditProfileView(showingEditingProfile: $published.showEditProfileSheet)
                        .toolbar(content: {
                            ToolbarItem(placement: .topBarLeading) {
                                Button(action: {self.published.showEditProfileSheet = false}){
                                    Text("cancel")
                                        .foregroundStyle(K.Colors.mainColor)
                                }
                            }
                        })
                }
            })
        }
    }
    
    func copyToClipboard() {
        withAnimation{
            self.copied = true
            // self.text = "" // clear the text after copy
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.copied = false
            }
        }
    }
}

//#Preview {
//    ProfileMainView()
//}
