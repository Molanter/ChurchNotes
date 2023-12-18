import SwiftUI
import FirebaseMessaging
import GoogleSignIn
import FirebaseCore
import FirebaseAuth

class AppDelegate:  NSObject, UIApplicationDelegate, ObservableObject, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    var app: ChurchNotesApp?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        

                FirebaseConfiguration.shared.setLoggerLevel(.debug)
                
                Messaging.messaging().delegate = self
                
                UNUserNotificationCenter.current().delegate = self
                
                application.registerForRemoteNotifications()
        
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
    //        let userInfo = response.notification.request.content.userInfo
    //        Messaging.messaging().appDidReceiveMessage(userInfo)
//            if let deepLink = response.notification.request.content.userInfo["link"] as? String,
//               let url = URL(string: deepLink) {
//                Task {
////                    await app?.handleDeeplinking(from: url)
//                }
//                print("✅ found deep link \(deepLink)")
//            }
        }
        
        func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
    //        let userInfo = notification.request.content.userInfo
    //        Messaging.messaging().appDidReceiveMessage(userInfo)
            return [.sound, .badge, .banner, .list]
        }
        
        func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {

            #if DEBUG
            print("🚨 FCM Token: \(fcmToken)")
            #endif
        }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
//    
    func application(_ application: UIApplication,
                         didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            Messaging.messaging().apnsToken = deviceToken
        }
}

//private extension ChurchNotesApp {
//    
//    func handleDeeplinking(from url: URL) async {
//        
//        let routeFinder = RouteFinder()
//        if let route = await routeFinder.find(from: url,
//                                              productsFetcher: fetcher) {
//            routerManager.push(to: route)
//        }
//    }
//}


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
