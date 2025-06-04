import SwiftUI

struct DeleteAccountPopupView: View {
    
    @Binding var isShowingDeleteAccountPopup: Bool
    @State private var userInfo: UserInfoResponse?
    
    private func deleteUser() {
        NetworkManager.deleteUser(accessToken: _UserAccessToken.shared.accessTokenStored) { result in
            switch result {
            case .success:
                print("유저 삭제 성공")
            case .failure(let error):
                print("유저 삭제 실패: \(error.localizedDescription)")
            }
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
        print("모든 토큰 삭제 완료")
    }
    
    private func goToRootView() {
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UIHostingController(rootView: OnBoardingScreenView())
            window.makeKeyAndVisible()
        }
    }
    
    var body: some View {
        VStack {
            Text("회원 탈퇴")
                .font(.system(size: 18))
                .bold()
            
            Text("탈퇴 시 계정은 삭제되며 복구되지 않습니다.")
                .padding()
                .font(.system(size: 16))
            
            HStack {
                Button(action: {
                    deleteAllTokens()
                    deleteUser()
                    goToRootView()
                }) {
                    ZStack {
                        RoundedRectangle (cornerRadius: 10)
                            .stroke(Color("accent"), lineWidth: 1)
                            .frame(width: 120, height: 40)
                        Text("탈퇴")
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                            .bold()
                    }
                    .padding(5)
                }
                Button(action: {
                    self.isShowingDeleteAccountPopup = false
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
