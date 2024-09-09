//
//  PeopleList.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 9/5/24.
//

import SwiftUI
import SwiftData

struct PeopleList: View {
    @Query var ints: [IntDataModel]
    
    var peopleList: [Person]
    
    var peopleListStyle: Int {
        if let intModel = ints.first(where: { $0.name == "peopleListStyle" }) {
            return intModel.int
        }else {
            return 1
        }
    }
    var body: some View {
//        if peopleList.isEmpty {
//            NoViewWithAction(image: <#T##String#>, title: <#T##String#>, description: <#T##String#>, buttonText: <#T##String#>, buttonAction: <#T##() -> Void#>, buttonImage: <#T##String#>)
//        }else {
            lists
//        }
    }
    
    @ViewBuilder
    var lists: some View {
        if peopleListStyle == 0 {
            PlainPeopleList(people: peopleList)
        }else if peopleListStyle == 1 {
            GroupedPeopleList(people: peopleList)
        }
    }
}
