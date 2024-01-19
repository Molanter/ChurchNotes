import SwiftUI
import FirebaseMessaging
import GoogleSignIn
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import UserNotifications
import Combine


class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    var viewModel: AppViewModel!
    var published: PublishedVariebles!

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                if granted {
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                    }
                } else {
                    // Handle authorization denial
                }
            }
        viewModel = AppViewModel()
        published = PublishedVariebles()
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Handle the remote notification
        print("recived fzrefve    ewrestgdyth    vcdwsefdr")
        // Extract information from the notification payload
        UIApplication.shared.applicationIconBadgeNumber += 1

        // Perform background tasks (e.g., fetching new content)
        // ...

        // Call the completion handler when you're done with the background tasks
        completionHandler(.newData)
    }
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        print("Notification received")
//        UIApplication.shared.applicationIconBadgeNumber += 1
//        print("Badge count incremented to: \(UIApplication.shared.applicationIconBadgeNumber)")
//        completionHandler()
//    }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
//        UIApplication.shared.applicationIconBadgeNumber += 1
//        print("Badge count incremented to: \(UIApplication.shared.applicationIconBadgeNumber)gvhjiok")
//        return [.sound, .badge, .banner, .list]
//    }
    
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Handle notification, if needed

        // Increment the current badge count by 1
        let currentBadgeCount = UIApplication.shared.applicationIconBadgeNumber
        UIApplication.shared.applicationIconBadgeNumber = currentBadgeCount + 1

        // Customize the presentation options (e.g., show alert and play sound)
        let presentationOptions: UNNotificationPresentationOptions = [.alert, .sound]
        completionHandler(presentationOptions)
    }
        // Handle remote notification received when app is in the background or terminated
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle notification, if needed
        completionHandler()

        let currentBadgeCount = UIApplication.shared.applicationIconBadgeNumber
        UIApplication.shared.applicationIconBadgeNumber = currentBadgeCount + 1
        
        // Increment badge count by 1
//        if let aps = response.notification.request.content.userInfo["aps"] as? [String: Any],
//               let badgeCount = aps["badge"] as? Int {
//                // Update badge count
//                UIApplication.shared.applicationIconBadgeNumber = badgeCount
//            }
    }
    
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcm = Messaging.messaging().fcmToken {
            print("🚨 FCM Token:", fcm)
//            if let _ = Auth.auth().currentUser{
                viewModel.updateFcmToken(token: fcm)
                published.fcm = fcm
//            }
        }
    }
    
    
    // Handle device token registration for remote notifications
       func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
           let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
           print("Device Token: \(token)")
           // Send the device token to your server for further handling
       }
       
       func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
           print("Failed to register for remote notifications: \(error.localizedDescription)")
       }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        UserDefaults(suiteName: "group.com.yourApp.bundleId")?.set(1, forKey: "count")
        UIApplication.shared.applicationIconBadgeNumber = 0
        print("foregraund")
    }
    
}




@main
struct ChurchNotesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var published: PublishedVariebles = .init()
    @StateObject private var viewModel: AppViewModel = .init()

    var utilities = Utilities()
    
    var body: some Scene {
        WindowGroup {
            let googleModel = AuthenticationViewModel()
            
            IndexView()
                .environmentObject(published)
                .environmentObject(viewModel)
                .environmentObject(googleModel)
                .onAppear{
                    //                    if K.showStatus{
                    //                        viewModel.updateStatus(status: "online", uid: Auth.auth().currentUser?.uid ?? "")
                    //                        print("ok")
                    //                    }
                    utilities.overrideDisplayMode()
                }
                .onOpenURL { url in
                    let string = url.absoluteString.replacingOccurrences(of: "prayernavigator://", with: "")
                    print(string)

                    let components = string.components(separatedBy: "?")

                    for component in components {
                        if component.contains("tab=") {
                            let tabRawValue = component.replacingOccurrences(of: "tab=", with: "")
                            if let requestedTab = Int(tabRawValue) {
                                if requestedTab == 0 || requestedTab == 1 {
                                    published.currentTabView = requestedTab
                                } else {
                                    published.currentTabView = 0
                                }
                                print(requestedTab)
                            }
                        }else if component.contains("profile-tag=") {
                            let tabRawValue = component.replacingOccurrences(of: "profile-tag=", with: "")
                            if let requestedTab = Int(tabRawValue) {
                                if requestedTab == 1{
                                    published.currentProfileMainView = requestedTab
                                }else if requestedTab == 2{
                                    published.showEditProfileSheet = true
                                }else {
                                    published.currentProfileMainView = nil
                                }
                                print(requestedTab)
                            }
                        }else if component.contains("settings-nav=") {
                            let tabRawValue = component.replacingOccurrences(of: "settings-nav=", with: "")
                            let requestedTab = String(tabRawValue)
                                
                                // Check if requestedTab is not an empty string
                                if !requestedTab.isEmpty {
                                    if requestedTab == "profile-info" || requestedTab == "people" || requestedTab == "achievements" || requestedTab == "notifications" || requestedTab == "appearance" || requestedTab == "settings" {
                                        published.currentSettingsNavigationLink = requestedTab
                                    }else if requestedTab == "allpeople-view" || requestedTab == "allstages-view" || requestedTab == "donepeople-view" || requestedTab == "likedpeople-view"{
                                        published.currentSettingsNavigationLink = "people"
                                        published.currentPeopleNavigationLink = requestedTab
                                    } else {
                                        published.currentSettingsNavigationLink = nil
                                    }
                                    print(requestedTab)
                                }
                        }
                    }
                }
        }
    }
}

