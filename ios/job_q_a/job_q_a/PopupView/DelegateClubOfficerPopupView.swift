import SwiftUI

struct DelegateClubOfficerPopupView: View {
    
    var memberName: String
    var memberId: Int
    var onMemberOfficer: () -> Void
    
    @Binding var isShowingDelegateClubOfficerPopup: Bool
    
    @EnvironmentObject var accesstokenStored: _UserAccessToken
    
    // 매니저 임명 API
    private func appointManager() {
        NetworkManager.appointManager(memberId: memberId, accessToken: _UserAccessToken.shared.accessTokenStored) { result in
            switch result {
            case .success(let response):
                onMemberOfficer()
                print("매니저 지정 성공: \(response)")
                isShowingDelegateClubOfficerPopup = false
            case .failure(let error):
                print(memberId)
                print("매니저 지정 실패: \(error)")
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("운영진 위임")
                .font(.system(size: 18))
                .bold()
            
            Text("\(memberName) 회원을 운영진으로 등록할까요?")
                .padding()
                .font(.system(size: 16))
            
            HStack {
                Button(action: {
                    appointManager()
                }) {
                    ZStack {
                        RoundedRectangle (cornerRadius: 10)
                            .stroke(Color("accent"), lineWidth: 1)
                            .frame(width: 120, height: 40)
                        Text("운영진 등록")
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                            .bold()
                    }
                    .padding(5)
                }
                Button(action: {
                    isShowingDelegateClubOfficerPopup = false
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
        .frame(width: 340, height: 300, alignment: .center)
    }
}
