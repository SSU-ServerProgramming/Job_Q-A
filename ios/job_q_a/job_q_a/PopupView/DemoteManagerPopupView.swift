import SwiftUI

struct DemoteManagerPopupView: View {
    var memberName: String
    var memberId: Int
    var onManagerDemoted: () -> Void
    
    @Binding var isShowingDemoteManagerPopup: Bool
    @Binding var isShowDemoteManagerErrorPopup: Bool
    
    @EnvironmentObject var accesstokenStored: _UserAccessToken
    @State private var error: Error?
    
    // 매니저 삭제 API 호출
    private func deleteMember() {
        NetworkManager.demoteManager(memberId: memberId, accessToken: _UserAccessToken.shared.accessTokenStored) { result in
            switch result {
            case .success(let member):
                print("일반 회원으로 전환: \(member)")
                onManagerDemoted()
                isShowingDemoteManagerPopup = false
            case .failure(let error):
                isShowDemoteManagerErrorPopup = true
                isShowingDemoteManagerPopup = false
                print("매니저 강등 실패: \(error.localizedDescription)")
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("일반회원 전환")
                .font(.system(size: 18))
                .bold()
            Text("\(memberName) 회원을 일반회원으로 변경할까요?")
                .padding()
                .font(.system(size: 16))     
            HStack {
                Button(action: {
                    deleteMember()
                }) {
                    ZStack {
                        RoundedRectangle (cornerRadius: 10)
                            .stroke(Color("accent"), lineWidth: 1)
                            .frame(width: 120, height: 40)
                        Text("변경")
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                            .bold()
                    }
                    .padding(5)
                }
                Button(action: {
                    isShowingDemoteManagerPopup = false
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

