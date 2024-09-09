//
//  AppleStyleNL.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 8/13/24.
//
import SwiftUI

struct AppleStyleNL: View {
    @EnvironmentObject var viewModel: AppViewModel
    let name: String
    let color: Color
    let systemImageName: String
    
    var title: String{
        return String(localized: String.LocalizationValue(name))
    }
    
    var body: some View{
        HStack(spacing: 20) {
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 5)
                    .fill(title == String(localized: "appearance") ? .linearGradient(colors: [
                        .bluePurple,
                        .yelloww
                    ], startPoint: .topLeading, endPoint: .bottomTrailing) : .linearGradient(colors: [
                        color,
                        color
                    ], startPoint: .top, endPoint: .bottom))
                    .frame(width: 30, height: 30)
                Image(systemName: systemImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(Color.white)
                    .frame(width: 20, height: 20)
                    .padding(.leading, name == "reminders" ? 3 : 0)
            }
            Text(title)
                .font(.body)
        }
        .badge(title == String(localized: "notifications-title") ? viewModel.notificationArray.count : 0)
    }
}
