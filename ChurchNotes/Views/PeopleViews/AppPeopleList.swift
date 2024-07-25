//
//  AppPeopleList.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 4/25/24.
//

import SwiftUI

struct AppPeopleList: View {
    @EnvironmentObject var published: PublishedVariebles
    @EnvironmentObject var viewModel: AppViewModel
    
    let stage: Int
    
    var people: [Person] {
        return viewModel.peopleArray.filter { $0.titleNumber == stage }.sorted(by: { $0.orderIndex < $1.orderIndex }).sorted(by: { $0.isLiked && !$1.isLiked })
    }
    var body: some View {
        List{
            ForEach(people) { person in
                RowPersonModel(item: person)
            }
        }
    }
}

//#Preview {
//    AppPeopleList()
//}
