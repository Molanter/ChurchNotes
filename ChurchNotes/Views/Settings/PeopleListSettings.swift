//
//  PeopleListSettings.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 6/28/24.
//

import SwiftUI
import SwiftData

struct PeopleListSettings: View {
    @EnvironmentObject var viewModel: AppViewModel
    @Environment(\.modelContext) var modelContext

    @Query var bools: [BoolDataModel]
    @Query var ints: [IntDataModel]

    var blurPeopleRow: Bool {
        return bools.first(where: { $0.name == "blurPeopleRow" })?.bool ?? false
    }
    
    @State var peopleRowStyle: Int = 0
    
    var peopleList: [Person] {
        return viewModel.peopleArray.sorted(by: { $0.orderIndex < $1.orderIndex }).sorted(by: { $0.isLiked && !$1.isLiked })
    }
    
    @State var styleSelected = 0
    @State var blur = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollViewReader { reader in
                    ScrollView(.horizontal) {
                            HStack {
                                SmallViewForSelecting(view: PlainPeopleList(people: peopleList).disabled(true), isSelected: returnBinding(0), size: 1)
                                    .onTapGesture {
                                        setRowStyleType(0)
                                    }
                                SmallViewForSelecting(view: GroupedPeopleList(people: peopleList).disabled(true), isSelected: returnBinding(1), size: 1)
                                    .onTapGesture {
                                        setRowStyleType(1)
                                    }
                            }
    //                        TabView(selection: $peopleRowStyle) {
    //                            PlainPeopleList(people: peopleList)
    //                                .disabled(true)
    ////                                .onTapGesture {
    ////                                    setRowStyleType(0)
    ////                                }
    //                                .tag(0)
    //                            GroupedPeopleList(people: peopleList)
    //                                .disabled(true)
    ////                                .onTapGesture {
    ////                                    setRowStyleType(1)
    ////                                }
    //                                .tag(1)
    //                        }
    //                        .indexViewStyle(.page(backgroundDisplayMode: .always))
    //                        .frame(width: 500)
                        }
                }
                Spacer()
            }
                .navigationTitle("people-list-settings")
                .navigationBarTitleDisplayMode(.large)
                .onAppear {
                    loadListPowStyle()
                }
        }
    }
    
    func loadListPowStyle() {
        if let intModel = ints.first(where: { $0.name == "peopleListStyle" }) {
            self.peopleRowStyle = intModel.int
        }else {
            self.peopleRowStyle = 0
        }
    }
    
    func returnBinding(_ int: Int) -> Binding<Bool> {
        return Binding(
            get: { peopleRowStyle == int },
            set: { newValue in
                self.peopleRowStyle = newValue ? int : 0
            }
        )
    }
    
    func setRowStyleType(_ int: Int) {
        if let intModel = ints.first(where: { $0.name == "peopleListStyle" }) {
            intModel.int = int
        }else {
            modelContext.insert(IntDataModel(name: "peopleListStyle", int: int))
        }
        loadListPowStyle()
    }
}

//#Preview {
//    PeopleListSettings()
//        .modelContainer(for: [BoolDataModel.self, StringDataModel.self, IntDataModel.self])
//}
