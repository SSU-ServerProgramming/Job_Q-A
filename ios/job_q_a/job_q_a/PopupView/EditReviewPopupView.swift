import SwiftUI

struct EditReviewPopupView: View {
    var reviewId: Int
    @Binding var isShowingEditReviewPopup: Bool
    
    
    @State private var reviewText: String = ""
    @State private var rate: Int = 0
    
    let maxLength = 200
    let writeReviewText = "후기를 입력해주세요."
    
    @EnvironmentObject var accesstokenStored: _UserAccessToken
    
    // 후기 수정 API
    private func updateReview() {
        NetworkManager.updateReview(reviewId: reviewId, review: reviewText, rate: rate, accessToken: _UserAccessToken.shared.accessTokenStored) { result in
            switch result {
            case .success(let response):
                self.isShowingEditReviewPopup = false
                print("후기 수정 성공: \(response)")
            case .failure(let error):
                print("후기 수정 실패: \(error.localizedDescription)")
                print(reviewId)
            }
        }
    }

    var body: some View {
        VStack {
            Text("후기 수정하기")
                .font(.system(size: 18))
                .bold()
            
            HStack {
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: "star.fill")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundColor(index <= rate ? Color("starColor") : .gray)
                        .onTapGesture {
                            self.rate = index
                        }
                }
            }
            .padding(.bottom)
            
            ZStack (alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color("content-secondary"), lineWidth: 0.5)
                    .frame(width: 300, height: 170)
                TextEditor(text: $reviewText)
                    .padding(5)
                    .foregroundColor(.black)
                    .font(.system(size: 12))
                    .frame(width: 300, height: 170, alignment: .top)
                    .onChange(of: reviewText) { newValue in
                        if newValue.count > maxLength {
                            reviewText = String(newValue.prefix(maxLength))
                        }
                    }
                if reviewText.isEmpty {
                    Text(writeReviewText)
                        .foregroundColor(.gray)
                        .padding(10)
                        .font(.system(size: 12))
                }
            }
            .frame(width: 300, height: 170)
            
            HStack {
                Spacer()
                Text("\(reviewText.count)/200")
                    .font(.system(size: 10))
            }
            .frame(width: 300)
            .padding(.bottom)
            
            Button(action: {
                updateReview()
            }) {
                ZStack {
                    RoundedRectangle (cornerRadius: 10)
                        .stroke(Color("accent"), lineWidth: 1)
                        .frame(width: 200, height: 40)
                    Text("후기 재등록하기")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .bold()
                }
            }
        }
    }
}

