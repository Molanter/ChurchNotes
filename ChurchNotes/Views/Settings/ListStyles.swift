//
//  ListStyles.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 6/27/24.
//

import SwiftUI
import SwiftData

struct ListStyles: View {
    @Environment(\.modelContext) var modelContext
    
    @Query var bools: [BoolDataModel]
    @Query var strings: [StringDataModel]
    @Query var ints: [IntDataModel]
    @Query var colors: [ColorDataModel]
    
    @State var styleSelected = 0
    @State var blur = false
    @State var colorTypeL = 0
    @State var colorTypeR = 0
    @State var pickerColorL1 = Color.black
    @State var pickerColorL2 = Color.black
    @State var pickerColorR1 = Color.black
    @State var pickerColorR2 = Color.black
    
    var blurListRow: Bool {
        return bools.first(where: { $0.name == "blurListRow" })?.bool ?? false
    }
    
    var backgroundType: String {
        if let strModel = strings.first(where: { $0.name == "backgroundType" }) {
            return strModel.string
        }else {
            return "none"
        }
    }
    
    var rowStyle: Int {
        if let intModel = ints.first(where: { $0.name == "rowStyle" }) {
            return intModel.int
        }else {
            return 0
        }
    }
    
    let colorArray: [Color] = [.greenn, .lightGreen, .yelloww, .yellow, .orange, .red, .pink, .purple, .indigo, .darkBlue, .bluee, .lightBlue, .cyan, .white, .gray, .black]
    let gradientArray: [[Color]] = [[.greenn, .lightGreen], [.yellow, .orange], [.yellow, .red], [.purple, .indigo], [.darkBlue, .lightBlue], [.yellow, .cyan], [.white, .black], [.gray, .black]]
    var body: some View {
        NavigationStack {
            List {
                Section {
                    if styleSelected == 0 {
                        HStack(alignment: .top, spacing: 20) {
                            Image(systemName: "gearshape")
                                .font(.system(size: 29))
                                .fontWeight(.light)
                            VStack(alignment: .leading, spacing: 5){
                                Text("Settinggs")
                                    .fontWeight(.semibold)
                                    .font(.subheadline)
                                    .foregroundStyle(.primary)
                                Text("Information about account settings")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }else if styleSelected == 1 {
                        HStack(spacing: 20) {
                            ZStack(alignment: .center) {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.black)
                                    .frame(width: 30, height: 30)
                                Image(systemName: "gearshape")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundStyle(Color.white)
                                    .frame(width: 20, height: 20)
                            }
                            Text("Settings")
                                .font(.body)
                        }
                    }
                }header: {
                    Text("Preview")
                }
                .listRowBackground(
                    GlassListRow()
                )
                Section {
                    HStack {
                        Text("Default")
                        Spacer()
                        Image(systemName: styleSelected == 0 ? "checkmark" : "xmark")
                            .foregroundStyle(styleSelected == 0 ? K.Colors.mainColor : Color.clear)
                            .symbolEffect(.bounce, value: styleSelected == 0)
                    }
                    .onTapGesture {
                        withAnimation {
                            styleSelected = 0
                        }
                    }
                    HStack {
                        Text("Apple style")
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
                    Text("Style")
                }
                .onChange(of: styleSelected) { newValue in
                    setStyle(newValue)
                }
                .listRowBackground(
                    GlassListRow()
                )
                Section {
                    Toggle(isOn: $blur) {
                        Text("Blur list row")
                    }
                }
                .onChange(of: blur) { newValue in
                    setBlur(newValue)
                }
                .listSectionSpacing(10)
                .listRowBackground(
                    GlassListRow()
                )
                Section {
                    ScrollView(.horizontal) {
                        HStack {
                            VStack {
                                Rectangle()
                                    .fill(Color.black)
                                    .contentShape(RoundedRectangle(cornerRadius: 10))
                                    .frame(width: 75, height: 150)
                                    .cornerRadius(10)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 15).stroke(Color.secondary, lineWidth: 5)
                                    }
                                    .padding(5)
                                Image(systemName: backgroundType == "none" ? "checkmark.circle.fill" : "circle")
//                                    .symbolEffect(.bounce, value: backgroundType == "SideGradient")
                                    .foregroundStyle(backgroundType == "none" ? K.Colors.mainColor : .white)

                            }
                                .onTapGesture {
                                    if let strModel = strings.first(where: { $0.name == "backgroundType" }) {
                                        strModel.string = "none"
                                    }else {
                                        modelContext.insert(StringDataModel(name: "backgroundType", string: "none"))
                                    }
                                }
                            VStack {
                                ColorSplash()
                                    .contentShape(RoundedRectangle(cornerRadius: 10))
                                    .frame(width: 75, height: 150)
                                    .cornerRadius(10)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 15).stroke(Color.secondary, lineWidth: 5)
                                    }
                                    .padding(5)
                                Image(systemName: backgroundType == "ColorSplash" ? "checkmark.circle.fill" : "circle")
//                                    .symbolEffect(.bounce, value: backgroundType == "ColorSplash")
                                    .foregroundStyle(backgroundType == "ColorSplash" ? K.Colors.mainColor : .white)
                            }
                                .onTapGesture {
                                    if let strModel = strings.first(where: { $0.name == "backgroundType" }) {
                                        strModel.string = "ColorSplash"
                                    }else {
                                        modelContext.insert(StringDataModel(name: "backgroundType", string: "ColorSplash"))
                                    }
                                }
                            VStack {
                                Circles2()
                                    .contentShape(RoundedRectangle(cornerRadius: 10))
                                    .frame(width: 75, height: 150)
                                    .cornerRadius(10)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 15).stroke(Color.secondary, lineWidth: 5)
                                    }
                                    .padding(5)
                                Image(systemName: backgroundType == "2Circles" ? "checkmark.circle.fill" : "circle")
//                                    .symbolEffect(.bounce, value: backgroundType == "2Circles")
                                    .foregroundStyle(backgroundType == "2Circles" ? K.Colors.mainColor : .white)
                            }
                                .onTapGesture {
                                    if let strModel = strings.first(where: { $0.name == "backgroundType" }) {
                                        strModel.string = "2Circles"
                                    }else {
                                        modelContext.insert(StringDataModel(name: "backgroundType", string: "2Circles"))
                                    }
                                }
                            VStack {
                                SideGradients()
                                    .contentShape(RoundedRectangle(cornerRadius: 10))
                                    .frame(width: 75, height: 150)
                                    .cornerRadius(10)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 15).stroke(Color.secondary, lineWidth: 5)
                                    }
                                    .padding(5)
                                Image(systemName: backgroundType == "SideGradient" ? "checkmark.circle.fill" : "circle")
//                                    .symbolEffect(.bounce, value: backgroundType == "SideGradient")
                                    .foregroundStyle(backgroundType == "SideGradient" ? K.Colors.mainColor : .white)

                            }
                                .onTapGesture {
                                    if let strModel = strings.first(where: { $0.name == "backgroundType" }) {
                                        strModel.string = "SideGradient"
                                    }else {
                                        modelContext.insert(StringDataModel(name: "backgroundType", string: "SideGradient"))
                                    }
                                }
                        }
                    }
                }header: {
                    Text("Backgrounds")
                }
                .listRowBackground(
                    GlassListRow()
                )
                if backgroundType != "none" && backgroundType != "" && backgroundType != "ColorSplash" {
                    Section {
                        HStack {
                            Text("Type")
                            Spacer()
                            Menu {
                                Button {
                                    colorTypeL = 0
                                }label: {
                                    Text("One color")
                                }
                                Button {
                                    colorTypeL = 1
                                }label: {
                                    Text("Color gradient")
                                }
                            } label: {
                                HStack {
                                    Text(colorTypeL == 0 ? "One color" : "Color gradient")
                                    Image(systemName: "chevron.up.chevron.down")
                                }
                            }
                            .foregroundStyle(K.Colors.mainColor)
                        }
                        ScrollView(.horizontal) {
                            HStack {
                                if colorTypeL == 0 {
                                    ForEach(colorArray, id: \.self) {color in
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(color)
                                            .frame(width: 50, height: 50)
                                            .overlay {
                                                if color == .white {
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(.black, lineWidth: 2)
                                                }
                                            }
                                            .padding(.vertical)
                                            .onTapGesture {
                                                setColorL(color, color)
                                            }
                                    }
                                }else if colorTypeL == 1 {
                                    ForEach(gradientArray, id: \.self) {color in
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(.linearGradient(colors: [
                                                color[0],
                                                color[1]
                                            ], startPoint: .top, endPoint: .bottom))
                                            .frame(width: 50, height: 50)
                                            .padding(.vertical)
                                            .onTapGesture {
                                                setColorL(color[0], color[1])
                                            }
                                    }
                                }
                            }
                        }
                        .scrollIndicators(.hidden)
                        NavigationLink {
                            VStack {
                                List{
                                    Section{
                                        ColorPicker("choose-yor-own", selection: $pickerColorL1, supportsOpacity: false)
                                            .tint(K.Colors.mainColor)
                                        if colorTypeL == 1 {
                                            ColorPicker("choose-yor-own", selection: $pickerColorL2, supportsOpacity: false)
                                                .tint(K.Colors.mainColor)
                                        }
                                    }
                                    .listRowBackground(
                                        GlassListRow()
                                    )
                                    Section(header:
                                    GeometryReader { gr in
                                        RoundedRectangle(cornerRadius: gr.size.width / 6)
                                            .fill(.linearGradient(colors: [
                                                pickerColorL1,
                                                colorTypeL == 1 ? pickerColorL2 : pickerColorL1
                                            ], startPoint: .top, endPoint: .bottom))
                                            .frame(maxWidth: .infinity)
                                            .frame(height: gr.size.width - 50)
                                            .padding(.horizontal, 25)
                                            .listRowInsets(EdgeInsets())
                                            

                                    }
                                    ) {}
                                }
                                .scrollContentBackground(backgroundType == "none" ? .visible : .hidden)
                                .background {
                                    ListBackground()
                                }
                                Spacer()
                                Text("save")
                                    .foregroundStyle(Color.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(K.Colors.mainColor)
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        if colorTypeL == 1 {
                                            setColorL(pickerColorL1, pickerColorL2)
                                        }else {
                                            setColorL(pickerColorL1, pickerColorL1)
                                        }
                                    }
                                    .padding(25)
                            }
                        } label: {
                            Text(colorTypeL == 0 ? "Choose own color" : "Choose own gradient")
                        }
                    }header: {
                        Text("Left")
                    }
                    .listRowBackground(
                        GlassListRow()
                    )
                    Section {
                        HStack {
                            Text("Type")
                            Spacer()
                            Menu {
                                Button {
                                    colorTypeR = 0
                                }label: {
                                    Text("One color")
                                }
                                Button {
                                    colorTypeR = 1
                                }label: {
                                    Text("Color gradient")
                                }
                            } label: {
                                HStack {
                                    Text(colorTypeR == 0 ? "One color" : "Color gradient")
                                    Image(systemName: "chevron.up.chevron.down")
                                }
                            }
                            .foregroundStyle(K.Colors.mainColor)
                        }
                        ScrollView(.horizontal) {
                            HStack {
                                if colorTypeR == 0 {
                                    ForEach(colorArray, id: \.self) {color in
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(color)
                                            .frame(width: 50, height: 50)
                                            .overlay {
                                                if color == .white {
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(.black, lineWidth: 2)
                                                }
                                            }
                                            .padding(.vertical)
                                            .onTapGesture {
                                                setColorL(color, color)
                                            }
                                    }
                                }else if colorTypeR == 1 {
                                    ForEach(gradientArray, id: \.self) {color in
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(.linearGradient(colors: [
                                                color[0],
                                                color[1]
                                            ], startPoint: .top, endPoint: .bottom))
                                            .frame(width: 50, height: 50)
                                            .padding(.vertical)
                                            .onTapGesture {
                                                setColorR(color[0], color[1])
                                            }
                                    }
                                }
                            }
                            .padding(.horizontal, 5)
                        }
                        .scrollIndicators(.hidden)
                        NavigationLink {
                            VStack {
                                List{
                                    Section{
                                        ColorPicker("choose-yor-own", selection: $pickerColorR1, supportsOpacity: false)
                                            .tint(K.Colors.mainColor)
                                        if colorTypeR == 1 {
                                            ColorPicker("choose-yor-own", selection: $pickerColorR2, supportsOpacity: false)
                                                .tint(K.Colors.mainColor)
                                        }
                                    }
                                    .listRowBackground(
                                        GlassListRow()
                                    )
                                    Section(header:
                                    GeometryReader { gr in
                                        RoundedRectangle(cornerRadius: gr.size.width / 6)
                                            .fill(.linearGradient(colors: [
                                                pickerColorR1,
                                                colorTypeR == 1 ? pickerColorR2 : pickerColorR1
                                            ], startPoint: .top, endPoint: .bottom))
                                            .frame(maxWidth: .infinity)
                                            .frame(height: gr.size.width - 50)
                                            .padding(.horizontal, 25)
                                            .listRowInsets(EdgeInsets())

                                    }
                                    ) {}
                                }
                                .scrollContentBackground(backgroundType == "none" ? .visible : .hidden)
                                .background {
                                    ListBackground()
                                }
                                Spacer()
                                Text("save")
                                    .foregroundStyle(Color.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(K.Colors.mainColor)
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        if colorTypeR == 1{
                                            setColorR(pickerColorR1, pickerColorR2)
                                        }else {
                                            setColorR(pickerColorR1, pickerColorR1)
                                        }
                                    }
                                    .padding(25)
                            }
                        } label: {
                            Text(colorTypeR == 0 ? "Choose own color" : "Choose own gradient")
                        }
                    }header: {
                        Text("Right")
                    }
                    .listRowBackground(
                        GlassListRow()
                    )
                    .listSectionSpacing(0)
                }
            }
            .scrollContentBackground(backgroundType == "none" ? .visible : .hidden)
            .background {
                ListBackground()
            }
            .refreshable {
                loadColors()
            }
            .onAppear {
                print("123")
                blur = blurListRow
                styleSelected = rowStyle
                loadColors()
            }
            .navigationTitle("List style")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    private func loadColors() {
        if let colorModel = colors.first(where: { $0.name == "backColorL" }) {
            pickerColorL1 = Color(red: colorModel.color1.red, green: colorModel.color1.green, blue: colorModel.color1.blue, opacity: colorModel.color1.alpha)
            pickerColorL2 = Color(red: colorModel.color2.red, green: colorModel.color2.green, blue: colorModel.color2.blue, opacity: colorModel.color2.alpha)
        }else {
            pickerColorL1 = Color.cyan
            pickerColorL2 = Color.yellow
        }
        if let colorModel = colors.first(where: { $0.name == "backColorR" }) {
            pickerColorR1 = Color(red: colorModel.color1.red, green: colorModel.color1.green, blue: colorModel.color1.blue, opacity: colorModel.color1.alpha)
            pickerColorR2 = Color(red: colorModel.color2.red, green: colorModel.color2.green, blue: colorModel.color2.blue, opacity: colorModel.color2.alpha)
        }else {
            pickerColorR1 = Color.green
            pickerColorR2 = Color.red
        }
        if pickerColorL1 != pickerColorL2 {
            colorTypeL = 1
        }else {
            colorTypeL = 0
        }
        if pickerColorR1 != pickerColorR2 {
            colorTypeR = 1
        }else {
            colorTypeR = 0
        }
    }
    func setBlur(_ newValue: Bool) {
        if let index = bools.firstIndex(where: { $0.name == "blurListRow" }) {
            bools[index].bool = newValue
        } else {
            modelContext.insert(BoolDataModel(name: "blurListRow", bool: newValue))
        }
        loadColors()
    }
    
    func setStyle(_ newValue: Int) {
        if let intModel = ints.first(where: { $0.name == "rowStyle" }) {
            intModel.int = newValue
        }else {
            modelContext.insert(IntDataModel(name: "rowStyle", int: newValue))
        }
        loadColors()
    }
    
    func setColorL(_ first: Color, _ second: Color) {
        if let colorModel = colors.first(where: { $0.name == "backColorL" }) {
            colorModel.color1 = .init(red: first.components.red, green: first.components.green, blue: first.components.blue, alpha: first.components.opacity)
            colorModel.color2 = .init(red: second.components.red, green: second.components.green, blue: second.components.blue, alpha: second.components.opacity)
        }else {
            let newColor = ColorDataModel(name: "backColorL", color1: .init(red: first.components.red, green: first.components.green, blue: first.components.blue, alpha: first.components.opacity), color2: .init(red: second.components.red, green: second.components.green, blue: second.components.blue, alpha: second.components.opacity))
            modelContext.insert(newColor)
        }
        Toast.shared.present(
            title: String(localized: "color-has-changed"),
            symbol: "paintpalette",
            isUserInteractionEnabled: true,
            timing: .long
        )
        print(String(localized: "color-has-changed"))
        loadColors()
    }
    
    func setColorR(_ first: Color, _ second: Color) {
        if let colorModel = colors.first(where: { $0.name == "backColorR" }) {
            colorModel.color1 = .init(red: first.components.red, green: first.components.green, blue: first.components.blue, alpha: first.components.opacity)
            colorModel.color2 = .init(red: second.components.red, green: second.components.green, blue: second.components.blue, alpha: second.components.opacity)
        }else {
            let newColor = ColorDataModel(name: "backColorR", color1: .init(red: first.components.red, green: first.components.green, blue: first.components.blue, alpha: first.components.opacity), color2: .init(red: second.components.red, green: second.components.green, blue: second.components.blue, alpha: second.components.opacity))
            modelContext.insert(newColor)
        }
        Toast.shared.present(
            title: String(localized: "color-has-changed"),
            symbol: "paintpalette",
            isUserInteractionEnabled: true,
            timing: .long
        )
        print(String(localized: "color-has-changed"))
        loadColors()
    }
}

#Preview {
    ListStyles()
        .modelContainer(for: [Credential.self, BoolDataModel.self, StringDataModel.self, IntDataModel.self, ReminderDataModel.self, ColorDataModel.self])

}
