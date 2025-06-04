import SwiftUI

struct ContentPopupView: View {
    
    @State private var contentText: String = ""
    
    let maxLength = 1000
    let writeContentText = "전달할 메시지를 입력해주세요."
    
    
    var clubID: Int
    var selectedApplicants: [Int]
    var callApplucantsAPI: () -> Void
    var status: String
    
    @Binding var isShowingContentPopup: Bool
    @Binding var isSuccessChangeStatus: Bool
    
    @EnvironmentObject var accesstokenStored: _UserAccessToken
    
    
    private func changeStatus(newStatus: String) {
            let selectedIds = Array(selectedApplicants)
            
            print("Request Parameters:")
            print("Club ID: \(clubID)")
            print("Selected Applicants: \(selectedIds)")
            print("Status: \(newStatus)")
            print("Content: \(contentText)")
            print("Access Token: \(_UserAccessToken.shared.accessTokenStored)")
            
            NetworkManager.changeApplicantStatus(clubId: clubID, changeList: selectedIds, status: newStatus, content: contentText, accessToken: _UserAccessToken.shared.accessTokenStored) { result in
                switch result {
                case .success(let responseData):
                    do {
                        if let jsonString = String(data: responseData, encoding: .utf8) {
                            print("지원자 상태 변경 API 응답 데이터: \(jsonString)")
                        }
                        
                        // **** 응답 데이터를 Dictionary로 디코딩
                        if let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                            print("상태 변경 성공: \(jsonResponse)")
                        }
                        
                        self.isSuccessChangeStatus = true
                        callApplucantsAPI()
                        print("리스트: \(selectedIds)")
                        self.isShowingContentPopup = false
                    } catch {
                        print("지원자 상태 변경 API 디코딩 오류: \(error)")
                    }
                case .failure(let error):
                    print("지원자 상태 변경 API 상태 변경 실패: \(error)")
                    print("지원자 상태 변경 API 리스트: \(selectedIds)")
                }
            }
        }
    
    
    var body: some View {
        VStack {
            Text("메시지 보내기")
                .font(.system(size: 18))
                .bold()
                .padding(.bottom, 40)
            
            ZStack (alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color("content-secondary"), lineWidth: 0.5)
                    .frame(width: 300, height: 190)
                TextEditor(text: $contentText)
                    .padding(5)
                    .foregroundColor(.black)
                    .font(.system(size: 12))
                    .frame(width: 300, height: 190, alignment: .top)
                    .onChange(of: contentText) { newValue in
                        if newValue.count > maxLength {
                            contentText = String(newValue.prefix(maxLength))
                        }
                    }
                if contentText.isEmpty {
                    Text(writeContentText)
                        .foregroundColor(.gray)
                        .padding(10)
                        .font(.system(size: 12))
                }
            }
            .frame(width: 300, height: 190)
            
            HStack {
                Spacer()
                Text("\(contentText.count)/1000")
                    .font(.system(size: 10))
            }
            .frame(width: 300)
            .padding(.bottom, 30)
            
            Button(action: {
                changeStatus(newStatus: status)
            }) {
                ZStack {
                    RoundedRectangle (cornerRadius: 10)
                        .stroke(Color("accent"), lineWidth: 1)
                        .frame(width: 300, height: 50)
                    Text("확인")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .bold()
                }
            }
        }
    }
}
