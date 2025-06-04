import SwiftUI

struct DemoteManagerErrorPopupView: View {
    
    var body: some View {
        VStack {
            Text("일반회원 전환이 불가능해요.")
                .font(.system(size: 18))
                .bold()
            Image("noActivityImage")
                .padding(30)
            Text("동아리를 운영하기 위해서는 최소 1명의 운영진이 필요해요.\n다른 운영진을 추가한 후 다시 시도해 주세요.")
                .font(.system(size: 12))
                .foregroundStyle(Color("gray-100"))
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

#Preview {
    DemoteManagerErrorPopupView()
}
