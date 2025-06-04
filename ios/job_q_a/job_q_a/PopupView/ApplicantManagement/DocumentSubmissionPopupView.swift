import SwiftUI

struct DocumentSubmissionPopupView: View {
    
    var clubID: Int
    var selectedApplicants: [Int]
    var firstApplicantName: String
    var callApplucantsAPI: () -> Void
    
    @Binding var isShowingDocumentSubmissionPopup: Bool
    @Binding var isShowingContentPopup: Bool
    
    @EnvironmentObject var accesstokenStored: _UserAccessToken
    
    
    var body: some View {
        VStack {
            Text("상태 변경")
                .font(.system(size: 18))
                .bold()
            
            if selectedApplicants.count > 1 {
                Text("\(firstApplicantName) 님 외 \(selectedApplicants.count - 1)명의 상태를 '서류접수'으로 변경할까요?")
                    .padding()
                    .font(.system(size: 16))
            } else {
                Text("\(firstApplicantName) 님의 상태를 '서류접수'로 변경할까요?")
                    .padding()
                    .font(.system(size: 16))
            }
            
            HStack {
                Button(action: {
                    self.isShowingContentPopup = true
                    self.isShowingDocumentSubmissionPopup = false
                }) {
                    ZStack {
                        RoundedRectangle (cornerRadius: 10)
                            .stroke(Color("accent"), lineWidth: 1)
                            .frame(width: 120, height: 40)
                        Text("네")
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                            .bold()
                    }
                    .padding(5)
                }
                Button(action: {
                    self.isShowingDocumentSubmissionPopup = false
                }) {
                    ZStack {
                        RoundedRectangle (cornerRadius: 10)
                            .stroke(Color("accent"), lineWidth: 1)
                            .frame(width: 120, height: 40)
                        Text("아니오")
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


