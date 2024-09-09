//
//  DefaultStyleNL.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 8/13/24.
//
import SwiftUI

struct DefaultStyleNL: View {
    @EnvironmentObject var viewModel: AppViewModel

    let name: String
    let info: String
    let systemImageName: String
    let leading: Bool = false
    
    var title: String{
        return String(localized: String.LocalizationValue(name))
    }
    var body: some View {
        HStack(alignment: .top, spacing: name == "people" ? 15 : 29){
            if name == "notifications" {
                if viewModel.notificationArray.isEmpty {
                    Image(systemName: viewModel.notificationArray.isEmpty ? "bell.badge" : "bell")
                        .overlay(viewModel.notificationArray.isEmpty ? nil : BadgeCount(count: viewModel.notificationArray.count).padding(.trailing, 8))
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color(K.Colors.mainColor), Color(K.Colors.text))
                        .font(.system(size: 29))
                        .fontWeight(.light)
                }else {
                    Image(systemName: systemImageName)
                        .overlay(viewModel.notificationArray.isEmpty ? nil : BadgeCount(count: viewModel.notificationArray.count).padding(.trailing, 8))
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color(K.Colors.text))
                        .font(.system(size: 29))
                        .fontWeight(.light)
                }
            }else if name == "reminders" {
                Image(systemName: systemImageName)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(name == "reminders" ? Color(K.Colors.text) : K.Colors.mainColor, Color(K.Colors.text))
                    .font(.system(size: 29))
                    .fontWeight(.light)
            }else if name == "people" {
                Image(systemName: systemImageName)
                    .font(.system(size: 25))
                    .fontWeight(.light)
            }else {
                Image(systemName: systemImageName)
                    .font(.system(size: 29))
                    .fontWeight(.light)
            }
            VStack(alignment: .leading, spacing: 5){
                Text(name)
                    .fontWeight(.semibold)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                Text(info)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.leading, leading ? 4 : 0)
    }
}
