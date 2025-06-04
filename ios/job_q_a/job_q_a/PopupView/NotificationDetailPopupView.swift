import SwiftUI

struct NotificationDetailPopupView: View {
    var notification: NotificationResponse.Notification
    @EnvironmentObject var accesstokenStored: _UserAccessToken
    @Binding var isShowingNotification: Bool
    var notificationType: String
    @Binding var isShowingFinalStepPopup: Bool
    
    // 알림 확인 체크 API
    private func checkNotification(notificationId: Int) {
        NetworkManager.checkNotification(notificationId: notificationId, accessToken: _UserAccessToken.shared.accessTokenStored) { result in
            switch result {
            case .success(let message):
                print("알림 확인 성공: \(message)")
            case .failure(let error):
                print("알림 확인 실패: \(error)")
            }
        }
    }
    
    var body: some View {
        VStack {
            Text(notification.title)
                .font(.system(size: 18))
                .bold()
            
            ScrollView {
                Text(notification.content)
                    .font(.system(size: 15))
                    .padding(20)
            }
            .frame(height: 200)
            
            Spacer()
            
            if notificationType == "FINAL_RESULT_PASS" {
                Button(action: {
                    checkNotification(notificationId: notification.notificationId)
                    self.isShowingNotification = false
                    self.isShowingFinalStepPopup = true
                }) {
                    ZStack {
                        RoundedRectangle (cornerRadius: 10)
                            .stroke(Color("accent"), lineWidth: 1)
                            .frame(width: 230, height: 45)
                        
                        Text("동아리원으로 최종 등록")
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                            .bold()
                    }
                }
            }
            else {
                Button(action: {
                    checkNotification(notificationId: notification.notificationId)
                    self.isShowingNotification = false
                }) {
                    ZStack {
                        RoundedRectangle (cornerRadius: 10)
                            .stroke(Color("accent"), lineWidth: 1)
                            .frame(width: 230, height: 45)
                        
                        Text("확인")
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                            .bold()
                    }
                }
            }
        }
        .frame(width: 340, height: 300, alignment: .center)
    }
}
