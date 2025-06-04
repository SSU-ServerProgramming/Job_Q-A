import SwiftUI

struct ShowNoAccessPopupView: View {
    var body: some View {
        VStack {
            Text("이미 리뷰가 등록되어 있어요.")
                .font(.system(size: 18))
                .bold()
            Image("noActivityImage")
                .padding(30)
        }
        .padding()
    }
}

#Preview {
    ShowNoAccessPopupView()
}
