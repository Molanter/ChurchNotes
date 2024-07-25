//
//  AccountSettingsLink.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 6/28/24.
//

import SwiftUI
import SwiftData

struct AccountSettingsLink<Destination: View>: View {
    @Query var ints: [IntDataModel]

    let destination: Destination
    let name: String
    let info: String
    let systemImageName: String
    
    var rowStyle: Int {
        if let intModel = ints.first(where: { $0.name == "rowStyle" }) {
            return intModel.int
        }else {
            return 0
        }
    }
    
    var color: Color {
        switch name {
        case String(localized: "change-password"):
            return Color.teal
        case String(localized: "change-email"):
            return Color.mint
        case String(localized: "edit-profile"):
            return Color.yellow
        case String(localized: "delete-account-view"):
            return Color.red
        default:
            return Color.black
        }
    }
    
    var body: some View {
        NavigationLink(destination: destination){
            if rowStyle == 1 {
                HStack(spacing: 20) {
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(color)
                            .frame(width: 30, height: 30)
                        Image(systemName: systemImageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(Color.white)
                            .frame(width: 20, height: 20)
                    }
                    Text(name)
                        .font(.body)
                }
            }else {
                HStack(spacing: 29){
                    Image(systemName: systemImageName)
                        .font(.system(size: 29))
                        .fontWeight(.light)
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
                .padding(.leading, 5)
            }
        }
    }
}

//#Preview {
//    AccountSettingsLink()
//}
