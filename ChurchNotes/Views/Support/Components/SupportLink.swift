//
//  SupportLink.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/13/24.
//

import SwiftUI
import SwiftData

struct SupportLink: View {
    @EnvironmentObject var published: PublishedVariebles

    @Query var ints: [IntDataModel]

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
        case String(localized: "ssend-mmail"):
            return Color.indigo
        case String(localized: "no-answer-report"):
            return Color.purple
        default:
            return Color.black
        }
    }
    
    var body: some View {
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
                Spacer()
                Image(systemName: "chevron.forward")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                    .opacity(0.5)
                    .bold()
            }
        }else {
            VStack{
                HStack(spacing: 15){
                    Image(systemName: systemImageName)
                        .font(.system(size: 25))
                        .fontWeight(.light)
                    VStack(alignment: .leading, spacing: 5){
                        Text(name)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.primary)
                        Text(info)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.forward")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                        .opacity(0.5)
                        .bold()
                }
                .accentColor(Color(K.Colors.lightGray))
            }
        }
    }
}

//#Preview {
//    SupportLink()
//}
