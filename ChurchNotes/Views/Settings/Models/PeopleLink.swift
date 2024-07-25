//
//  PeopleLink.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 6/28/24.
//

import SwiftUI
import SwiftData

struct PeopleLink<Destination: View>: View {
    @EnvironmentObject var published: PublishedVariebles
    
    @Query var ints: [IntDataModel]
    
    let destination: Destination
    let name: String
    let info: String
    let systemImageName: String
    let currentPeopleNavigationLink: String
    let leading: Bool
    
    var rowStyle: Int {
        if let intModel = ints.first(where: { $0.name == "rowStyle" }) {
            return intModel.int
        }else {
            return 0
        }
    }
    
    var color: Color {
        switch name {
        case String(localized: "all-people"):
            return Color(K.Colors.pink)
        case String(localized: "all-your-stages"):
            return Color.orange
        case String(localized: "done-people"):
            return Color.green
        case String(localized: "favourite-people"):
            return K.Colors.mainColor
        default:
            return Color.black
        }
    }
    
    var body: some View {
        NavigationLink(destination: destination
            .onAppear(perform: {
                if published.device == .phone {
                    published.tabsAreHidden = true
                }
            })
                .navigationBarTitleDisplayMode(.inline),
                       isActive: Binding(
                        get: { published.currentPeopleNavigationLink == currentPeopleNavigationLink },
                        set: { newValue in
                            published.currentPeopleNavigationLink = newValue ? currentPeopleNavigationLink : nil
                        }
                       )
        ){
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
                HStack(spacing: leading ? 34 : 29){
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
            }
        }
    }
}

//#Preview {
//    PeopleLink()
//}
