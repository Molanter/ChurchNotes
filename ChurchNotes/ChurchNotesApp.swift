//
//  ChurchNotesApp.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 6/27/23.
//

import SwiftUI
import SwiftData
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct ChurchNotesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var utilities = Utilities()

    var body: some Scene {
        WindowGroup {
            let viewModel = AppViewModel()
                IndexView()
                .onAppear{
                    utilities.overrideDisplayMode()
                }
                .environmentObject(viewModel)
        }
        
        .modelContainer(for: [UserProfile.self, Items.self, ItemsTitle.self])
        
    }
}
