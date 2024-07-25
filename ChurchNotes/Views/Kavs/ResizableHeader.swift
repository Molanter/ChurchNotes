//
//  ResizableHeader.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 1/19/24.
//

import SwiftUI

struct ResizableHeader: View {
    var size: CGSize
    var safeArea: EdgeInsets
    var item: Person
    /// View Properties
    @State private var offsetY: CGFloat = 0
    @State var phoneError = false
    @State var phoneNumber = ""

    @EnvironmentObject var viewModel: AppViewModel

    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    HeaderView()
                    /// Making to Top
                        .zIndex(1000)
                    
                    SampleCardsView()
                }
                .id("SCROLLVIEW")
                .background {
                    ScrollDetector { offset in
                        offsetY = -offset
                    } onDraggingEnd: { offset, velocity in
                        /// Resetting to Intial State, if not Completely Scrolled
                        let headerHeight = (size.height * 0.3) + safeArea.top
                        let minimumHeaderHeight = 65 + safeArea.top
                        
                        let targetEnd = offset + (velocity * 45)
                        if targetEnd < (headerHeight - minimumHeaderHeight) && targetEnd > 0 {
                            withAnimation(.interactiveSpring(response: 0.55, dampingFraction: 0.65, blendDuration: 0.65)) {
                                scrollProxy.scrollTo("SCROLLVIEW", anchor: .top)
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// Header View
    @ViewBuilder
    func HeaderView() -> some View {
        let headerHeight = (size.height * 0.3) + safeArea.top
        let minimumHeaderHeight = 65 + safeArea.top
        /// Converting Offset into Progress
        /// Limiting it to 0 - 1
        let progress = max(min(-offsetY / (headerHeight - minimumHeaderHeight), 1), 0)
        GeometryReader { _ in
            ZStack {
                    Rectangle()
                    .fill(Color.black)
//                        .blur(radius: progress * 5)
                VStack(spacing: 15) {
                    /// Profile Image
                    GeometryReader {
                        let rect = $0.frame(in: .global)
                        /// Since Scaling of the Image is 0.3 (1 - 0.7)
                        let halfScaledHeight = (rect.height * 0.3) * 0.5
                        let midY = rect.midY
                        let bottomPadding: CGFloat = 15
                        let resizedOffsetY = (midY - (minimumHeaderHeight - halfScaledHeight - bottomPadding))
                        
                        ZStack(alignment: .bottomTrailing){
                            if item.imageData != ""{
                                AsyncImage(url: URL(string: item.imageData)){image in
                                    image.resizable()
                                    
                                }placeholder: {
                                    ProgressView()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height: 100)
                                }
                                .aspectRatio(contentMode: .fill)
                                .frame(width: rect.width, height: rect.height)
                                .clipShape(Circle())
                                .scaleEffect(1 - (progress * 0.7), anchor: .leading)
                                .offset(x: -(rect.minX - 15) * progress, y: -resizedOffsetY * progress)
                            }else{
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .foregroundStyle(Color.white)
                                    .frame(width: rect.width, height: rect.height)
                                    .clipShape(Circle())
                                    /// Scaling Image
                                    .scaleEffect(1 - (progress * 0.7), anchor: .leading)
                                    /// Moving Scaled Image to Center Leading
                                    .offset(x: -(rect.minX - 15) * progress, y: -resizedOffsetY * progress)
                                
                            }
                            //                                                Circle()
                            //                                                    .overlay(
                            //                                                        Circle().stroke(.white, lineWidth: 1)
                            //                                                    )
                            //                                                    .frame(width: 15)
                            //                                                    .foregroundColor(Color(K.Colors.green))
                        }
                    }
                    .frame(width: headerHeight * 0.5, height: headerHeight * 0.5)
                    
                    Text(item.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        /// Advanced Method (Same as the Profile Image)
                        .moveText(progress, headerHeight, minimumHeaderHeight)
                }
                .padding(.top, safeArea.top)
                .padding(.bottom, 15)
                }
            /// Resizing Header
            .frame(height: (headerHeight + offsetY) < minimumHeaderHeight ? minimumHeaderHeight : (headerHeight + offsetY), alignment: .bottom)
            /// Sticking to the Top
            .offset(y: -offsetY)
        }
        .frame(height: headerHeight)
    }
    
    /// Sample Cards
    @ViewBuilder
    func SampleCardsView() -> some View {
        VStack(alignment: .leading){
            VStack(alignment: .leading, spacing: 15){
                HStack(spacing: 20){
                    ZStack{
                        Circle()
                            .foregroundStyle(Color(K.Colors.gray).opacity(0.5))
                            .frame(width: 40, height: 40)
                        Image(systemName: "person")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20)
                            .foregroundStyle(K.Colors.mainColor)
                            .fontWeight(.light)
                    }
                    Text(item.name.isEmpty ? "name" : item.name)
                        .font(.title3)
                        .fontWeight(.light)
                        .font(.system(size: 20))
                }
                .padding(.top, 50)
                Divider()
                if item.email != ""{
                    VStack(alignment: .leading, spacing: 15){
                        HStack(spacing: 20){
                            ZStack{
                                Circle()
                                    .foregroundStyle(Color(K.Colors.gray).opacity(0.5))
                                    .frame(width: 40, height: 40)
                                Image(systemName: "envelope")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20)
                                    .foregroundStyle(K.Colors.mainColor)
                                    .fontWeight(.light)
                            }
                            Text(item.email)
                                .font(.title3)
                                .fontWeight(.light)
                                .font(.system(size: 20))
                        }
                        Divider()
                        
                    }
                }
                if item.phone != ""{
                    HStack(spacing: 20){
                        ZStack{
                            Circle()
                                .foregroundStyle(Color(K.Colors.gray).opacity(0.5))
                                .frame(width: 40, height: 40)
                            Image(systemName: "phone")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20)
                                .foregroundStyle(K.Colors.mainColor)
                                .fontWeight(.light)
                        }
                        HStack(alignment: .center, spacing: 0.0){
                            Text(item.phone)
                                .font(.title3)
                                .fontWeight(.light)
                                .font(.system(size: 18))
                        }
                        .frame(height: 45)
                    }
                    Divider()
                }
                VStack(alignment: .leading, spacing: 15){
                    HStack(spacing: 18){
                        ZStack{
                            Circle()
                                .foregroundStyle(Color(K.Colors.gray).opacity(0.5))
                                .frame(width: 40, height: 40)
                            Image(systemName: "folder")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20)
                                .foregroundStyle(K.Colors.mainColor)
                                .fontWeight(.light)
                        }
                        Text(item.title)
                            .font(.title3)
                            .fontWeight(.light)
                            .font(.system(size: 18))
                    }
                    Divider()
                }
                if item.birthDay != item.timestamp{
                    HStack(spacing: 20){
                        ZStack{
                            Circle()
                                .foregroundStyle(Color(K.Colors.gray).opacity(0.5))
                                .frame(width: 40, height: 40)
                            Image(systemName: "gift")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20)
                                .foregroundStyle(K.Colors.mainColor)
                                .fontWeight(.light)
                        }
                        HStack(spacing: 1){
                            Text(item.birthDay, format: .dateTime.month(.twoDigits))
                            Text("/\(item.birthDay, format: .dateTime.day())/")
                            Text(item.birthDay, format: .dateTime.year())
                        }
                        .font(.title3)
                        .fontWeight(.light)
                        .font(.system(size: 18))
                    }
                    Divider()
                }
                if item.notes != ""{
                    VStack(alignment: .leading, spacing: 15){
                        HStack(spacing: 18){
                            ZStack{
                                Circle()
                                    .foregroundStyle(Color(K.Colors.gray).opacity(0.5))
                                    .frame(width: 40, height: 40)
                                Image(systemName: "square.and.pencil")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20)
                                    .foregroundStyle(K.Colors.mainColor)
                                    .fontWeight(.light)
                            }
                            Text(item.notes)
                                .multilineTextAlignment(.leading)
                                .lineLimit(10)
                                .font(.title3)
                                .fontWeight(.light)
                                .font(.system(size: 18))
                        }
                        Divider()
                    }
                }
                VStack(alignment: .leading, spacing: 15){
                    HStack(spacing: 20){
                        ZStack{
                            Circle()
                                .foregroundStyle(Color(K.Colors.gray).opacity(0.5))
                                .frame(width: 40, height: 40)
                            Image(systemName: "person.badge.clock")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25)
                                .foregroundStyle(K.Colors.mainColor)
                                .fontWeight(.light)
                                .offset(x: 2)
                        }
                        HStack(spacing: 1){
                            Text(item.timestamp, format: .dateTime.month(.twoDigits))
                            Text("/\(item.timestamp, format: .dateTime.day())/")
                            Text(item.timestamp, format: .dateTime.year())
                        }
                        .font(.title3)
                        .fontWeight(.light)
                        .font(.system(size: 18))
                    }
                    Divider()
                }
                Spacer()
            }
            if !item.phone.isEmpty{
                NavigationLink{
                        CameraView(recipients: [item.phone], message: "", item: item)
                } label:{
                    HStack(spacing: 20){
                        ZStack{
                            Circle()
                                .foregroundStyle(Color(K.Colors.gray).opacity(0.5))
                                .frame(width: 40, height: 40)
                            Image(systemName: "video.badge.plus")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30)
                                .foregroundStyle(K.Colors.mainColor)
                                .fontWeight(.light)
                        }
                        HStack(spacing: 0.0){
                            Text("record-video-for \(Text(item.name.capitalized).bold())")
                                .foregroundStyle(Color("text-appearance"))
                                .font(.title3)
                                .fontWeight(.light)
                                .font(.system(size: 18))
                                .lineLimit(3)
                                .multilineTextAlignment(.leading)
                        }
                    }
                }
            }else{
                Button{
                    phoneIsEmpty()
                } label:{
                    HStack(spacing: 20){
                        ZStack{
                            Circle()
                                .foregroundStyle(Color(K.Colors.gray).opacity(0.5))
                                .frame(width: 40, height: 40)
                            Image(systemName: "video.badge.plus")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30)
                                .foregroundStyle(K.Colors.mainColor)
                                .fontWeight(.light)
                        }
                        HStack(spacing: 0.0){
                            Text("record-video-for \(Text(item.name.capitalized).bold())")
                                .foregroundStyle(K.Colors.appearance >= 1 ? (K.Colors.appearance == 2 ? Color.black : Color.white) : Color("text-appearance"))
                                .font(.title3)
                                .fontWeight(.light)
                                .font(.system(size: 18))
                                .lineLimit(3)
                                .multilineTextAlignment(.leading)
                        }
                    }
                }
            }
            Divider()
        }
        .padding(15)
        .alert("phone-number-is-empty", isPresented: $phoneError) {
            TextField("pphone", text: $phoneNumber)
            Button("cancel", role: .cancel) {}
            Button(action: {
                viewModel.editPerson(documentId: item.documentId, name: item.name, email: item.email, phone: phoneNumber, notes: item.notes, image: nil)
            }) {
                Text("add-number")
            }
        }message: {
            Text("add-person-phone-number-for-recording-video")
        }
    }
    private func phoneIsEmpty(){
        withAnimation{
            self.phoneError.toggle()
        }
    }
}

//struct Home_Previews: PreviewProvider {
//    static var previews: some View {
//        PersonCustomNavView()
//    }
//}

fileprivate extension View {
    func moveText(_ progress: CGFloat, _ headerHeight: CGFloat, _ minimumHeaderHeight: CGFloat) -> some View {
        self
            .hidden()
            .overlay {
                GeometryReader { proxy in
                    let rect = proxy.frame(in: .global)
                    let midY = rect.midY
                    /// Half Scaled Text Height (Since Text Scaling will be 0.85 (1 - 0.15))
                    let halfScaledTextHeight = (rect.height * 0.85) / 2
                    /// Profile Image
                    let profileImageHeight = (headerHeight * 0.5)
                    /// Since Image Scaling will be 0.3 (1 - 0.7)
                    let scaledImageHeight = profileImageHeight * 0.3
                    let halfScaledImageHeight = scaledImageHeight / 2
                    /// Applied VStack Spacing is 15
                    /// 15 / 0.3 = 4.5 (0.3 -> Image Scaling)
                    let vStackSpacing: CGFloat = 4.5
                    let resizedOffsetY = (midY - (minimumHeaderHeight - halfScaledTextHeight - vStackSpacing - halfScaledImageHeight))
                    
                    self
                        .scaleEffect(1 - (progress * 0.15))
                        .offset(y: -resizedOffsetY * progress)
                }
            }
    }
}
