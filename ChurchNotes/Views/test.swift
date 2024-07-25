//
//  test.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 2/10/24.
//

import SwiftUI

struct test: View {
    //    @State var currentTab = 0
    @StateObject private var gifDownloader = GIFDownloader()
    
    var body: some View {
        //                SlideBarItem(currentTab: $currentTab, tab: 0, text: "First")
                Text("Hello World!")
        GifImageView("☃️")
            .aspectRatio(contentMode: .fit)
            .frame(width: 100)
            .onAppear {
                        gifDownloader.downloadGIF(name: "☃️")
                    }
    }
}


import FirebaseStorage
import SwiftData

class GIFDownloader: ObservableObject {
    @Published var gifData: Data?
    var storage = Storage.storage().reference(forURL: "gs://curchnote.appspot.com")

    func downloadGIF(name: String) {
        let storageRef = storage.child("emoji_gifs/\(name).gif")

        storageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error downloading GIF: \(error.localizedDescription)")
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    self.gifData = data
                    self.saveGIFToLocal(data: data, name: name)
                }
            }
        }
    }

    private func saveGIFToLocal(data: Data, name: String) {
        let fileManager = FileManager.default
        if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent("name.gif")
            do {
                try data.write(to: fileURL)
                print("GIF saved to \(fileURL)")
            } catch {
                print("Error saving GIF to local storage: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    test()
//        .environment(GIFDownloader())
}

//struct SlideBarItem: View {
//    @Binding var currentTab: Int
//
//    var tab: Int
//    let text: String
//
//    var body: some View {
//        Text(text)
//            .font(.footnote)
//            .fontWeight(.medium)
//            .foregroundColor(currentTab == tab ? Color.accentColor : Color.accentColor.opacity(0.5))
//            .padding(.horizontal, 20)
//    }
//}

