import SwiftUI

struct PointsShortagePopupView: View {
    
    var body: some View {
        VStack {
            Text("포인트가 부족해서\n후기를 열람할 수 없어요.")
                .font(.system(size: 18))
                .bold()
                .multilineTextAlignment(.center) // 텍스트의 줄바꿈 시 중앙 정렬
            Image("noActivityImage")
                .padding(30)
            Text("동아리 후기를 작성하면 5포인트를 얻을 수 있어요.\n(현재 포인트: 0, 최초 후기 작성시 20포인트)")
                .font(.system(size: 12))
                .foregroundStyle(Color("gray-100"))
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

