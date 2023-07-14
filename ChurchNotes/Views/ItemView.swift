//
//  ItemView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/2/23.
//

import SwiftUI
import SwiftData

struct ItemView: View {
    @Bindable var itemTitles: ItemsTitle
    @Environment(\.modelContext) private var modelContext
    
    @State var name = ""
    @State var isLiked = false
    @State var isCheked = false
    @State private var showingAlert = false
    @State var notes = ""
    @State var presentSheet = false
    @State var shouldShowImagePicker = false
    @State var image: UIImage?
    @State var finishImage: Data?
    @State var sheetPesonInfo = false
    @State var email = ""
    var body: some View {
        ZStack(alignment: .bottom){
            List{
                if !itemTitles.items.isEmpty{
                    
                    ForEach(itemTitles.items){item in
                            Button(action: {self.sheetPesonInfo.toggle()}){
                                    HStack{
                                        ZStack(alignment: .bottomTrailing){
                                            if item.imageData != nil{
                                                if let img = item.imageData{
                                                    Image(uiImage: UIImage(data: img)!)
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: 50, height: 50)
                                                        .cornerRadius(25)

                                                }
                                            }else{
                                                ZStack(alignment: .center){
                                                    Circle()
                                                        .foregroundColor(Color(K.Colors.darkGray))
                                                        .frame(width: 50, height: 50)
                                                    Text(String(item.name.components(separatedBy: " ").compactMap { $0.first }).count >= 3 ? String(String(item.name.components(separatedBy: " ").compactMap { $0.first }).prefix(2)) : String(item.name.components(separatedBy: " ").compactMap { $0.first }))
                                                        .textCase(.uppercase)
                                                        .foregroundColor(Color.white)
                                                }

                                            }
                                            Circle()
                                                .overlay(
                                                    Circle().stroke(.white, lineWidth: 1)
                                                )
                                                .frame(width: 15)
                                                .foregroundColor(Color(K.Colors.green))
                                        }
                                        VStack(alignment: .leading){
                                            Text(item.name.capitalized)
                                                .fontWeight(.medium)
                                                .foregroundStyle(.primary)
                                                .font(.system(size: 17))
                                            HStack(spacing: 1){
                                                Text(item.timestamp, format: .dateTime.month(.wide))
                                                Text(item.timestamp, format: .dateTime.day())
                                                Text(", \(item.timestamp, format: .dateTime.year()), ")
                                                Text(item.timestamp, style: .time)
                                            }
                                            .font(.system(size: 15))
                                            .foregroundStyle(.secondary)
                                        }
                                    }
//                                    .swipeActions(edge: .trailing) {
//                                        Button(role: .destructive, action: { modelContext.delete(item) } ) {
//                                            Label("Delete", systemImage: "trash")
//                                        }
//                                    }
//                                    .contextMenu {
//                                        Button(role: .destructive) {
//                                            modelContext.delete(item)
//                                        } label: {
//                                            Label("Delete", systemImage: "trash")
//                                        }
//                                    }
                                    .sheet(isPresented: $sheetPesonInfo){
                                        NavigationStack{
                                            ItemPersonView(item: item, itemTitle: self.itemTitles)
                                                .toolbar{
                                                    ToolbarItem(placement: .topBarTrailing){
                                                        Button(action: {
                                                            self.sheetPesonInfo.toggle()
                                                        }){
                                                            Image(systemName: "xmark.circle")
                                                        }
                                                    }
                                                }
                                        }
                                            .accentColor(Color.white)
                                        
                                    }
                                }
                        }
//                        .onDelete(perform: delete)
                    .onDelete { indexes in
                        for index in indexes {
//                            deleteItem(itemTitles.items[index])
                            modelContext.delete(itemTitles.items[index])
                        }
                    }
                }else{
                    Section(header: Label(
                        title: { Text("Example Title")
                                .font(.title2)
                                .fontWeight(.bold)
                            .foregroundColor(Color(K.Colors.lightGray))},
                        icon: { Image(systemName: "text.line.first.and.arrowtriangle.forward")
                                .font(.title3)
                            .foregroundColor(Color(K.Colors.lightGray))}
                    )){
                        Text("Example Line")

                        
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
            .padding(.top)
            .frame(maxHeight: .infinity)
            HStack{
                EditButton()
                Spacer()
                Image(systemName: "note.text.badge.plus")
                    .onTapGesture(perform: {
                        self.presentSheet.toggle()
                    })
                    .padding(15)
                    .font(.title2)
                    .foregroundColor(Color(K.Colors.bluePurple))
            }

        }
        .sheet(isPresented: $presentSheet){
            NavigationStack{
                VStack(alignment: .center){
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
                                        Circle().stroke(Color(K.Colors.bluePurple), lineWidth: 2)
                                    )
                                    .padding(15)
                                
                            }else{
                                Image(systemName: "person.fill.viewfinder")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(Color(K.Colors.bluePurple))
                                    .padding(15)
                                
                                
                            }
                            Text("tap to change Image")
                                .foregroundStyle(.secondary)
                                .foregroundStyle(Color(K.Colors.bluePurple))
                        }
                        .padding(15)
                    }
                    VStack(alignment: .leading, spacing: 20){
                        Text("Write Person Name")
                            .font(.title2)
                            .fontWeight(.medium)
                        HStack{
                            TextField("Name", text: $name)
                                .onSubmit {
                                    if !name.isEmpty{
                                       addItem()
                                    }
                                }
                        }
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5.0).stroke(Color(K.Colors.darkGray), lineWidth: 1)
                        )
                        Button(action: {
                            if !name.isEmpty{
                                addItem()
                            }
                        }){
                            Text("Add")
                                .foregroundColor(Color.white)
                        }
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(Color(K.Colors.bluePurple))
                        .cornerRadius(7)
                    }
                    .padding(15)
                }
                Spacer()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading){
                        Button(action: {
                            self.presentSheet.toggle()
                        }){
                            Text("Cancel")
                                .foregroundColor(Color(K.Colors.lightBlue))
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            if !name.isEmpty{
                                addItem()
                            }
                        }){
                            Text("Save")
                                .foregroundColor(Color(K.Colors.lightBlue))
                        }
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
            }
            .sheet(isPresented: $shouldShowImagePicker) {
                ImagePicker(image: $image)
            }
            .edgesIgnoringSafeArea(.bottom)
            .presentationDetents([.medium, .large])
        }
        .frame(maxHeight: .infinity)
    }
    
    private func ischked(){
        
    }
    
    private func addItem() {
        withAnimation {
            if image != nil{
                guard let imageSelected = image else{
                    return
                }
                guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else{
                    print("Avata is nil")
                    return
                }
                
                let newItem = Items(name: name, isLiked: false, isCheked: false, notes: notes, imageData: imageData, email: email, birthDay: Date.now)
                itemTitles.items.append(newItem)
                email = ""
                name = ""
                notes = ""
                image = nil
                self.presentSheet.toggle()
            }else{
                let newItem = Items(name: name, isLiked: false, isCheked: false, notes: notes, imageData: nil, email: email, birthDay: Date.now)
                itemTitles.items.append(newItem)
                email = ""
                name = ""
                notes = ""
                image = nil
                self.presentSheet.toggle()
            }
        }
    }
    
    private func delete(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                itemTitles.items.remove(at: index)
            }
        }
    }
    func deleteItem(_ item: Items) {
        modelContext.delete(item)
    }
}

//#Preview {
//    @Query var itemTitles: [ItemsTitle]
//    ItemView()
//    .modelContainer(for: [UserProfile.self, Items.self, ItemsTitle.self])
//
//}

struct ImagePicker: UIViewControllerRepresentable{
    @Binding var image: UIImage?
    
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = context.coordinator
        return picker
    }
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    
    //    private let controler = UIImagePickerController()
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
        
        
        let parent: ImagePicker
        init(parent: ImagePicker) {
            self.parent = parent
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage{
                parent.image = image
                picker.dismiss(animated: true)
            }else{
                //Error
                
            }
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
    
    
}
