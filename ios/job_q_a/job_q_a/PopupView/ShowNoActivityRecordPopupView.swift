import SwiftUI

struct ShowNoActivityRecordPopupView: View {
    var body: some View {
        VStack {
            Text("동아리에서 활동한 기록이 없어요.")
                .font(.system(size: 18))
                .bold()
            Image("noActivityImage")
                .padding(30)
            Text("리뷰 작성 권한을 얻으려면\n동아리 운영진에게 문의하세요.")
                .font(.system(size: 12))
                .foregroundStyle(Color("gray-100"))
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

#Preview {
    ShowNoActivityRecordPopupView()
}
