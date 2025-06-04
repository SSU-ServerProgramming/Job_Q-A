import SwiftUI

struct RemoveMemberPopupView: View {
    var memberName: String
    var memberId: Int
    var onMemberRemoved: () -> Void
    
    @Binding var isShowingRemoveMemberPopup: Bool
    @State private var error: Error?
    @EnvironmentObject var accesstokenStored: _UserAccessToken
    
    // 회원 삭제 API 호출
    private func deleteMember() {
        NetworkManager.deleteMember(memberId: memberId, accessToken: _UserAccessToken.shared.accessTokenStored) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("회원 삭제 성공")
                    onMemberRemoved()
                    isShowingRemoveMemberPopup = false
                case .failure(let error):
                    self.error = error
                    print(memberId)
                    print("회원 삭제 오류: \(error)")
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("회원 탈퇴")
                .font(.system(size: 18))
                .bold()
            
            Text("\(memberName) 회원을 탈퇴 처리 할까요?")
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
                        Text("회원 탈퇴")
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                            .bold()
                    }
                    .padding(5)
                }
                Button(action: {
                    isShowingRemoveMemberPopup = false
                }) {
                    ZStack {
                        RoundedRectangle (cornerRadius: 10)
                            .stroke(Color("accent"), lineWidth: 1)
                            .frame(width: 120, height: 40)
                        Text("회원 유지")
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
