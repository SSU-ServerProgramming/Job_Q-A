import SwiftUI

struct ReviewDisplayPopupView: View {
    
    var clubID: Int
    var clubName: String
    @Binding var isOpenReview: Bool
    @Binding var isShowingReviewDisplayPopup: Bool
    @Binding var isShowingPointsShortagePopup: Bool
    
    @EnvironmentObject var accesstokenStored: _UserAccessToken
  
    // 리뷰 열람 권한 포인트 구매 API
    private func purchaseReviewAccess() {
        NetworkManager.purchaseReviewAccess(clubId: clubID, accessToken: _UserAccessToken.shared.accessTokenStored) { result in
            switch result {
            case .success():
                print("후기 열람 권한을 성공적으로 획득했습니다.")
                self.isOpenReview = true
                DispatchQueue.main.async {
                    self.isShowingReviewDisplayPopup = false
                }
            case .failure(let error):
                print("후기 열람 권한 획득 실패: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.isShowingReviewDisplayPopup = false
                    self.isShowingPointsShortagePopup = true
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("후기 열람")
                .font(.system(size: 18))
                .bold()
            
            Text("\(clubName)의 후기를 열람할까요?")
                .multilineTextAlignment(.center)
                .lineSpacing(5)
                .font(.system(size: 15))
                .padding(20)
            
            HStack {
                Button(action: {
                    purchaseReviewAccess()
                }) {
                    ZStack {
                        RoundedRectangle (cornerRadius: 10)
                            .stroke(Color("accent"), lineWidth: 1)
                            .frame(width: 130, height: 45)
                        Text("후기 열람")
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                            .bold()
                    }
                }
                Button(action: {
                    self.isShowingReviewDisplayPopup = false
                }) {
                    ZStack {
                        RoundedRectangle (cornerRadius: 10)
                            .stroke(Color("accent"), lineWidth: 1)
                            .frame(width: 130, height: 45)
                        Text("취소")
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                            .bold()
                    }
                }
            }
            .frame(width: 340)
            
        }
        .frame(width: 340, height: 180, alignment: .center)
    }
}
