import SwiftUI

struct ApplicationSubmitPopupView: View {
    
    var clubId: Int
    
    @Binding var isShowingApplicationSubmitPopup: Bool
    @Binding var isShowSuccessApplicationPopup: Bool
    
    @EnvironmentObject var accesstokenStored: _UserAccessToken
    
    // 동아리 지원 API
    private func submitClubApplication() {
        NetworkManager.submitClubApplication(clubId: clubId, accessToken: _UserAccessToken.shared.accessTokenStored) { result in
            switch result {
            case let .success(message):
                print("동아리 지원 API 호출 성공: \(message)")
                self.isShowingApplicationSubmitPopup = false
                self.isShowSuccessApplicationPopup = true
            case let .failure(error):
                print("동아리 지원 API 호출 실패: \(error)")
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("동아리 지원")
                .font(.system(size: 18))
                .bold()
            
            Text("지원서를 제출하셨나요?\n“네”를 클릭하여 지원을 최종 마무리하고,\n지원과정 알림 기능을 이용해보세요.")
                .multilineTextAlignment(.center)
                .lineSpacing(5)
                .font(.system(size: 15))
                .padding(15)
            
            HStack {
                Button(action: {
                    submitClubApplication()
                }) {
                    ZStack {
                        RoundedRectangle (cornerRadius: 10)
                            .stroke(Color("accent"), lineWidth: 1)
                            .frame(width: 130, height: 40)
                        Text("네")
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                            .bold()
                    }
                }
                Button(action: {
                    self.isShowingApplicationSubmitPopup = false
                }) {
                    ZStack {
                        RoundedRectangle (cornerRadius: 10)
                            .stroke(Color("accent"), lineWidth: 1)
                            .frame(width: 130, height: 40)
                        Text("아니오")
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                            .bold()
                    }
                }
            }
            
        }
        .frame(width: 340, height: 200, alignment: .center)
    }
}

