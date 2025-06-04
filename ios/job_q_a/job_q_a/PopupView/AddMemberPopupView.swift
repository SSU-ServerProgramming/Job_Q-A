import SwiftUI

struct AddMemberPopupView: View {
    
    var clubId: Int
    var onMemberAdded: () -> Void
    @Binding var isShowingAddMemberPopup: Bool
    @State private var linkText: String = ""
    @EnvironmentObject var accesstokenStored: _UserAccessToken
    @Binding var isShowingNoExistentMemberPopup: Bool
    
    let writeLinkText = "등록하고자 하는 회원의 코드를 입력해주세요."
    
    // 회원 생성 API
    func createMember(clubId: Int, userId: Int, accessToken: String) {
        NetworkManager.createMember(clubId: clubId, userId: userId, accessToken: _UserAccessToken.shared.accessTokenStored) { result in
            switch result {
            case .success(let response):
                print("회원 생성 완료: \(response)")
                isShowingAddMemberPopup = false
                onMemberAdded()
            case .failure(let error):
                print("회원 생성 실패: \(error)")
                isShowingAddMemberPopup = false
                isShowingNoExistentMemberPopup = true
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("회원 등록")
                .font(.system(size: 18))
                .bold()
            ZStack (alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color("content-secondary"), lineWidth: 0.5)
                    .frame(width: 300, height: 35)
                TextEditor(text: $linkText)
                    .padding(5)
                    .foregroundColor(.black)
                    .font(.system(size: 12))
                    .frame(width: 300, height: 35, alignment: .top)
                if linkText.isEmpty {
                    Text(writeLinkText)
                        .foregroundColor(.gray)
                        .padding(10)
                        .font(.system(size: 12))
                }
            }
            .frame(width: 300, height: 35)
            .padding(50)
            
            Button(action: {
                if let userId = Int(linkText) {
                    createMember(clubId: clubId, userId: userId, accessToken: accesstokenStored.accessTokenStored)
                } else {
                    print("유효하지 않은 사용자 코드")
                }
            }) {
                ZStack {
                    RoundedRectangle (cornerRadius: 10)
                        .stroke(Color("accent"), lineWidth: 1)
                        .frame(width: 200, height: 40)
                    Text("회원 등록하기")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .bold()
                }
            }
            
        }
        .frame(width: 340, height: 300, alignment: .center)
    }
}
