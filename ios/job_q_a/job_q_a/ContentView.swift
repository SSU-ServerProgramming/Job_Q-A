import SwiftUI

struct ContentView: View {
    
    //@EnvironmentObject var notificationManager: NotificationManager
    @State private var showMainView = false
    
    var body: some View {
        ZStack {
            if showMainView {
                OnBoardingScreenView()
                    .environmentObject(_UserAccessToken.shared)
            } else {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation {
                                showMainView = true
                            }
                        }
                    }
            }
        }
    }
}

//struct NotificationListView: View {
//    @EnvironmentObject var notificationManager: NotificationManager
//
//    var body: some View {
//        List(notificationManager.notifications, id: \.self) { notification in
//            Text(notification)
//        }
//        .frame(width: 300, height: 50)
//    }
//}

