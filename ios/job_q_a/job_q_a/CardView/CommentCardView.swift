import SwiftUI

struct CommentCardView: View {
    
    var reviewId: Int
    var review: String
    var totalCnt: Int
    var rate: Int
    var createDate: String
    var isUserReview: Bool
    var onRevieweDeleted: (() -> Void)
    
    @Binding var isShowingEditReviewPopup: Bool
    @Binding var isShowingReviewDisplayPopup: Bool
    @Binding var isReviewAccess: Bool
    
    @EnvironmentObject var accesstokenStored: _UserAccessToken
    
    private func deleteReview() {
        NetworkManager.deleteReview(reviewId: reviewId, accessToken: _UserAccessToken.shared.accessTokenStored) { result in
            switch result {
            case .success(let message):
                print("리뷰가 삭제되었습니다")
                print(message)
                onRevieweDeleted()
            case .failure(let error):
                print("리뷰 삭제 실패: \(error.localizedDescription)")
            }
        }
    }
    
    var body: some View {
        ZStack (alignment: .top) {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color("gray-10"))
            VStack(spacing:0) {
                HStack(spacing:1) {
                    Text("수료자")
                        .font(.system(size: 13))
                        .bold()
                        .padding(.trailing)
                    ForEach(0..<rate) { _ in
                        Image(systemName: "star.fill")
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundColor(Color("starColor"))
                    }
                    ForEach(0..<5-rate) { _ in
                        Image(systemName: "star.fill")
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundColor(Color(.gray))
                    }
                    Spacer()
                    if isUserReview  {
                        Image(systemName: "pencil")
                            .resizable()
                            .foregroundColor(Color("secondary_"))
                            .frame(width: 12, height: 12)
                            .padding(.trailing, 5)
                            .onTapGesture {
                                self.isShowingEditReviewPopup = true
                            }
                        
                        Image(systemName: "x.square")
                            .resizable()
                            .foregroundColor(Color("secondary_"))
                            .frame(width: 12, height: 12)
                            .onTapGesture {
                                deleteReview()
                            }
                    }
                }
                HStack {
                    Text("\(review)")
                        .font(.system(size: 10))
                        .frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    Spacer()
                }
                .frame(minHeight: 33, alignment: .top)
                .blur(radius: isReviewAccess ? 0 : 9)
                .overlay(
                    HStack {
                        if !isReviewAccess {
                            Text("이 동아리의 전체 후기를 보기 위해 5포인트가 차감됩니다.\n한 번 열람한 후에는 영구적으로 볼 수 있습니다.")
                                .font(.system(size: 10))
                            Spacer()
                        }
                    }
                        .padding(.top, 5)
                )
                
                Spacer()
                
                HStack {
                    if !isReviewAccess {
                        Button(action: {
                            self.isShowingReviewDisplayPopup = true
                        }) {
                            Text("열람하기")
                                .font(.system(size: 11))
                                .foregroundColor(Color("accent"))
                                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color("accent"), lineWidth: 2)
                                )
                                .cornerRadius(8)
                        }
                    }
                    
                    Spacer()
                    Text("\(createDate)")
                        .font(.system(size: 10))
                        .foregroundColor(Color("secondary_"))
                }
            }
            .padding(10)
            
        }
        .frame(alignment: .leading)
        .fixedSize(horizontal: false, vertical: true)
        .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
        
    }
}
