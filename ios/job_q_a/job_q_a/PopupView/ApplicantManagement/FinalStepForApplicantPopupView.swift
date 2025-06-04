import SwiftUI

struct FinalStepForApplicantPopupView: View {
    
    var clubName: String?
    var clubID: Int?
    @Binding var isShowingFinalStepPopup: Bool
    
    
    private func registerApplicant() {
        NetworkManager.registerApplicant(clubId: clubID ?? 0, accessToken: _UserAccessToken.shared.accessTokenStored) { result in
            switch result {
            case .success(let response):
                self.isShowingFinalStepPopup = false
                print("지원자 최종 등록 성공: \(response)")
            case .failure(let error):
                print("지원자 최종 등록 실패: \(error)")
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("회원 등록")
                .font(.system(size: 18))
                .bold()
            
            Text("\(clubName ?? "동아리 이름 없음")의 동아리원으로 최종 등록하시겠습니까?")
                .padding()
                .font(.system(size: 16))
            
            HStack {
                Button(action: {
                    registerApplicant()
                }) {
                    ZStack {
                        RoundedRectangle (cornerRadius: 10)
                            .stroke(Color("accent"), lineWidth: 1)
                            .frame(width: 120, height: 40)
                        Text("최종 등록")
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                            .bold()
                    }
                    .padding(5)
                }
                Button(action: {
                    self.isShowingFinalStepPopup = false
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
