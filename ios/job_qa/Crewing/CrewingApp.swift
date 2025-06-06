import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import GoogleSignIn
import NaverThirdPartyLogin
import FirebaseCore
import UserNotifications
import Foundation
import FirebaseMessaging


@main
struct CrewingApp: App {
    var body: some Scene {
        WindowGroup {
//            MainTabView()   
            ContentView()
        }
    }
}

class FCMTokenManager: ObservableObject {
    static let shared = FCMTokenManager.init()
    
    @Published var fcmToken: String = ""
    
    private init() {}
}
