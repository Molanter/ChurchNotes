import SwiftUI
import GoogleSignIn
import SwiftData
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct ChurchNotesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var utilities = Utilities()

    var body: some Scene {
        WindowGroup {
            let published = PublishedVariebles()
            let viewModel = AppViewModel()
            let googleModel = AuthenticationViewModel()

            IndexView()
                .environmentObject(viewModel)
                .environmentObject(published)
                .environmentObject(googleModel)
                .onAppear{
                    utilities.overrideDisplayMode()
                }
        }
    }
}
