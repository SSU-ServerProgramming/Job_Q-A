import SwiftUI

struct RemoveApplicantsPopupView: View {
    var clubID: Int
    var applicantsName: String
    var applicantsId: Int
    var onApplicantsRemoved: () -> Void
    @Binding var isShowingRemoveApplicantsPopup: Bool
    
    @State private var error: Error?
    @EnvironmentObject var accesstokenStored: _UserAccessToken
    
    // 회원 삭제 API 호출
    private func deleteApplicants() {
        NetworkManager.deleteApplicants(clubId: clubID, deleteList: [applicantsId], content: "탈락 처리", accessToken: _UserAccessToken.shared.accessTokenStored) { result in
            switch result {
            case .success(let responseString):
                onApplicantsRemoved()
                isShowingRemoveApplicantsPopup = false
                print("지원자 삭제 성공: \(responseString)")
            case .failure(let error):
                print("지원자 삭제 실패: \(error)")
            }
        }
        
    }
    
    var body: some View {
        VStack {
            Text("지원자 삭제")
                .font(.system(size: 18))
                .bold()
            
            Text("\(applicantsName)님을 지원자 목록에서 삭제할까요?")
                .padding()
                .font(.system(size: 16))
            
            HStack {
                Button(action: {
                    deleteApplicants()
                }) {
                    ZStack {
                        RoundedRectangle (cornerRadius: 10)
                            .stroke(Color("accent"), lineWidth: 1)
                            .frame(width: 120, height: 40)
                        Text("지원자 삭제")
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                            .bold()
                    }
                    .padding(5)
                }
                Button(action: {
                    isShowingRemoveApplicantsPopup = false
                }) {
                    ZStack {
                        RoundedRectangle (cornerRadius: 10)
                            .stroke(Color("accent"), lineWidth: 1)
                            .frame(width: 120, height: 40)
                        Text("지원자 유지")
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
