import SwiftUI

struct LogoutPopupView: View {
    
    @Binding var isShowingLogoutPopup: Bool
    @State private var userInfo: UserInfoResponse?
    
    private func goToRootView() {
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = UIHostingController(rootView: OnBoardingScreenView())
                window.makeKeyAndVisible()
            }
        }
    
    private func deleteAllTokens() {
        UserDefaults.standard.removeObject(forKey: "kakaoAccessToken")
        UserDefaults.standard.removeObject(forKey: "kakaoRefreshToken")
        UserDefaults.standard.removeObject(forKey: "naverAccessToken")
        UserDefaults.standard.removeObject(forKey: "naverRefreshToken")
        UserDefaults.standard.removeObject(forKey: "googleAccessToken")
        UserDefaults.standard.removeObject(forKey: "googleRefreshToken")
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
        UserDefaults.standard.removeObject(forKey: "savedUserID")
        UserDefaults.standard.removeObject(forKey: "savedUserPW")
        print("모든 토큰 삭제 완료")
    }
    
    var body: some View {
        VStack {
            Text("로그아웃")
                .font(.system(size: 18))
                .bold()
            
            Text("로그아웃하시겠습니까?")
                .padding()
                .font(.system(size: 16))
            
            HStack {
                Button(action: {
                    deleteAllTokens()
                    goToRootView()
                }) {
                    ZStack {
                        RoundedRectangle (cornerRadius: 10)
                            .stroke(Color("accent"), lineWidth: 1)
                            .frame(width: 120, height: 40)
                        Text("로그아웃")
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                            .bold()
                    }
                    .padding(5)
                }
                Button(action: {
                    self.isShowingLogoutPopup = false
                }) {
                    ZStack {
                        RoundedRectangle (cornerRadius: 10)
                            .stroke(Color("accent"), lineWidth: 1)
                            .frame(width: 120, height: 40)
                        Text("취소")
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                            .bold()
                    }
                    .padding(5)
                }
            }
            
        }
        .frame(width: 340, height: 200, alignment: .center)
    }
}
