//
//  test.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 2/10/24.
//

import SwiftUI

struct test: View {
    @State var edit = false
    @State private var nameTextField = ""
    @State private var notesTextField = "Man that lives near my work, and always wear blue hat"
    @State private var emailTextField = "email@example.com"
    @State private var phoneTextField = "+12345678900"
    
    @State var shouldShowImagePicker = false
    @State var image: UIImage?

    
    var body: some View {
        NavigationStack{
            List{
                Section(header:
                            Button (action: {
                                shouldShowImagePicker.toggle()
                            }){
                                VStack(alignment: . center){
                                    if let image = self.image{
                                        Image(uiImage: image)
                                            .resizable()
                                            .frame(width: 100, height: 100)
                                            .cornerRadius(50)
                                            .overlay(
                                                Circle().stroke(K.Colors.mainColor, lineWidth: 2)
                                            )
                                            .padding(15)
                                        
                                    }else{
                                        Image(systemName: "person.fill.viewfinder")
                                            .resizable()
                                            .frame(width: 100, height: 100)
                                            .foregroundColor(K.Colors.mainColor)
                                            .padding(15)
                                        
                                        
                                    }
                                    Text("tap-to-change-image")
                                        .foregroundStyle(.secondary)
                                        .foregroundStyle(K.Colors.mainColor)
                                }
                                .padding(15)
                            }
                    .textCase(nil)
                    .listRowInsets(EdgeInsets())
                    .frame(maxWidth: .infinity)
                ){
                    
                }
                Section{
                    HStack{
                        TextField("name", text: $nameTextField)
                            .lineLimit(1)
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.words)
                            .keyboardType(.default)
                            .textSelection(.enabled)
                            .textContentType(.name)
                        Spacer()
                        Image(systemName: "person.fill")
                    }
                }header: {
                    Text("full-name")
                }footer: {
                    Text("rrequired")
                }
            }
        }
    }
}

#Preview {
    test()
}
