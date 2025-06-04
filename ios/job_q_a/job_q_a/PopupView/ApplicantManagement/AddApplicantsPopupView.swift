import SwiftUI

struct AddApplicantsPopupView: View {
    
    var clubId: Int
    var onApplicantsAdded: () -> Void
    @Binding var isShowingAddApplicantsPopup: Bool
    @State private var linkText: String = ""
    @EnvironmentObject var accesstokenStored: _UserAccessToken
    @Binding var isShowingNoExistentApplicantsPopup: Bool
    
    let writeLinkText = "등록하고자 하는 지원자의 코드를 입력해주세요."
    
    // 지원자 생성 API
    func createApplicantForManager(clubId: Int, userId: Int, accessToken: String) {
        NetworkManager.createApplicantForManager(clubId: clubId, userId: userId, accessToken: _UserAccessToken.shared.accessTokenStored) { result in
            switch result {
            case .success(let response):
                print("지원자 생성 완료: \(response)")
                isShowingAddApplicantsPopup = false
                onApplicantsAdded()
            case .failure(let error):
                print("지원자 생성 실패: \(error)")
            }
        }
    }
    
    
    var body: some View {
        VStack {
            Text("지원자 등록")
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
                    print("동아리 아이디: \(clubId)")
                    createApplicantForManager(clubId: clubId, userId: userId, accessToken: _UserAccessToken.shared.accessTokenStored)
                } else {
                    print("유효하지 않은 사용자 코드")
                }
            }) {
                ZStack {
                    RoundedRectangle (cornerRadius: 10)
                        .stroke(Color("accent"), lineWidth: 1)
                        .frame(width: 200, height: 40)
                    Text("지원자 등록하기")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .bold()
                }
            }
            
        }
        .frame(width: 340, height: 300, alignment: .center)
    }
}

