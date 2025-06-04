import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import GoogleSignInSwift
import GoogleSignIn
import Foundation
import NaverThirdPartyLogin
import FirebaseMessaging

// 다른 뷰에서도 액세스토큰을 사용할 수 있도록 전역 변수 생성
class _UserAccessToken: ObservableObject {
    static let shared =  _UserAccessToken.init()
    @Published var accessTokenStored: String = ""
    private init() {}
}


struct OnBoardingScreenView: View {
    @State var presentSheet: Bool = false
    @State private var toSignUpView = false
    @State private var toMainTabView = false
    @State private var toIDPWSignUpView = false
    @State private var isShowingLoginErrorPopup = false
    @State private var kakaoAccessToken: String? = nil
    @State private var googleAccessToken: String? = nil
    @State private var accessToken: String? = nil
    @State private var idText: String = ""
    let idWriteText = "ID"
    @State private var pwText: String = ""
    let pwWriteText = "PW"
    @ObservedObject var fcmTokenManager = FCMTokenManager.shared // FCM 토큰 관리 객체


    
    
    private func performLogin() {
        
        NetworkManager.idPwLogin(email: idText, password: pwText) { result in
            switch result {
            case .success(let response):
                print("ID/PW 로그인 성공: \(response)")
                toMainTabView = true
            case .failure(let error):
                self.isShowingLoginErrorPopup = true
                print("ID/PW 로그인 실패: \(error.localizedDescription)")
            }
        }
    }
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("onboardingImg")
                    .resizable()
                    .ignoresSafeArea(.keyboard)
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack (spacing:15) {
//                    Spacer()
                    
                    HStack {
                        Spacer()
                        Button {
                            toIDPWSignUpView = true
                        } label: {
                            Text("회원가입")
                                .font(.system(size: 16))
                                .underline()
                                .padding(.trailing, 20)
                                .foregroundColor(Color("secondary_"))
                        }
                    }.padding(.top, 400)
                    
                    ZStack (alignment: .leading) {
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color("content-secondary"), lineWidth: 0.5)
                            .padding(.horizontal, 20)
                        TextField(idWriteText, text: $idText)
                        .padding(10)
                        .padding(.horizontal, 20)
                        .foregroundColor(Color("secondary_"))
                        .bold()
                        .font(.system(size: 15))
                        
                    }
                    .frame(width: UIScreen.main.bounds.width, height: 50)
                    
                    
                    
                    ZStack (alignment: .leading) {
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color("content-secondary"), lineWidth: 0.5)
                            .padding(.horizontal, 20)
                        TextField(pwWriteText, text: $pwText)
                        .padding(10)
                        .padding(.horizontal, 20)
                        .foregroundColor(Color("secondary_"))
                        .bold()
                        .font(.system(size: 15))
                    }
                    .frame(width: UIScreen.main.bounds.width, height: 50)
                    
                    
                    Button {
                        performLogin()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 55)
                                .foregroundColor(Color("primary_"))
                                .padding(.horizontal, 25)
                            
                            Text("로그인")
                                .foregroundColor(Color("secondary_"))
                                .bold()
                        }
                    }
                    
    
                    NavigationLink(destination: MainTabView(), isActive: $toMainTabView) {
                        EmptyView()
                    }
                    NavigationLink(destination: IDPWSignUpView(), isActive: $toIDPWSignUpView) {
                        EmptyView()
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0))
                
            }
        }.navigationViewStyle(StackNavigationViewStyle())
            .navigationBarBackButtonHidden()
            .overlay(
                Group {
                    if isShowingLoginErrorPopup {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                        LoginErrorPopupView(isShowingLoginErrorPopup: $isShowingLoginErrorPopup)
                            .frame(width: 350, height: 200)
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(
                                Button(action: {
                                    withAnimation {
                                        self.isShowingLoginErrorPopup = false
                                    }
                                }) {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                        .foregroundColor(.black)
                                        .padding(20)
                                }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                            )
                    }
                }
            )
        
        
    }

}


#Preview {
    OnBoardingScreenView()
}
