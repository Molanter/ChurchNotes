//
//  PeopleListSettings.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 6/28/24.
//

import SwiftUI
import SwiftData

struct PeopleListSettings: View {
    @Environment(\.modelContext) var modelContext

    @Query var bools: [BoolDataModel]
    @Query var ints: [IntDataModel]

    var blurPeopleRow: Bool {
        return bools.first(where: { $0.name == "blurPeopleRow" })?.bool ?? false
    }
    
    var peopleRowStyle: Int {
        if let intModel = ints.first(where: { $0.name == "peopleRowStyle" }) {
            return intModel.int
        }else {
            return 0
        }
    }
    
    @State var styleSelected = 0
    @State var blur = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { gr in
                List {
                    Section {
                        ForEach(1..<4) { index in
                            HStack {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("Example Name")
                                        .padding(.vertical, 3)
                                        .fontWeight(.medium)
                                        .foregroundStyle(.primary)
                                        .font(.footnote)
                                    HStack(spacing: 1) {
                                        Text(Date.now, format: .dateTime.month(.wide))
                                        Text(Date.now, format: .dateTime.day())
                                        Text(", \(Date.now, format: .dateTime.year()), ")
                                        Text(Date.now, style: .time)
                                    }
                                    .font(.caption2)
                                    .foregroundStyle(Color(K.Colors.lightGray))
                                }
                                Spacer()
                                Image(systemName: "heart.fill")
                            }
                            .padding(.vertical, styleSelected == 0 ? 5 : 0)
                            .padding(.horizontal, styleSelected == 0 ? 15 : 0)
                        }
                        .listRowInsets(styleSelected == 0 ? .init() : .none)
                        .frame(width: gr.size.width)
                        
                    }header: {
                        Text("Example")
                    }
                    
                    Section {
                        HStack {
                            Text("Defult section")
                            Spacer()
                            Image(systemName: styleSelected == 0 ? "checkmark" : "xmark")
                                .foregroundStyle(styleSelected == 0 ? K.Colors.mainColor : Color.clear)
                                .symbolEffect(.bounce, value: styleSelected == 0)                    }
                        .onTapGesture {
                            withAnimation {
                                styleSelected = 0
                            }
                        }
                        HStack {
                            Text("Round section")
                            Spacer()
                            Image(systemName: styleSelected == 1 ? "checkmark" : "xmark")
                                .foregroundStyle(styleSelected == 1 ? K.Colors.mainColor : Color.clear)
                                .symbolEffect(.bounce, value: styleSelected == 1)
                        }
                        .onTapGesture {
                            withAnimation {
                                styleSelected = 1
                            }
                        }
                    }header: {
                        Text("Settings")
                    }
                    Section {
                        Toggle(isOn: $blur, label: {
                            Text("Blur")
                        })
                    }
                    .listSectionSpacing(10)
                }
                .navigationTitle("People List Settings")
                .navigationBarTitleDisplayMode(.large)
            }
        }
    }
}

#Preview {
    PeopleListSettings()
        .modelContainer(for: [Credential.self, BoolDataModel.self, StringDataModel.self, IntDataModel.self, ReminderDataModel.self])
}
