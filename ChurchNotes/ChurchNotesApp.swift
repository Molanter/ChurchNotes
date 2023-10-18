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
                .environmentObject(viewModel)
                .onAppear{
                    utilities.overrideDisplayMode()
                }
        }
    }
}
