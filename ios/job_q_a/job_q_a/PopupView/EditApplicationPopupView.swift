import SwiftUI

struct EditApplicationPopupView: View {
    
    @Binding var clubApplication: String
    @Binding var isShowingPopup: Bool
    
    var body: some View {
        VStack {
            Text("지원서 링크")
                .font(.system(size: 18))
                .bold()
            
            ZStack (alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color("content-secondary"), lineWidth: 0.5)
                    .frame(width: 300, height: 170)
                TextField("링크를 입력해주세요.", text: $clubApplication)
                    .padding(5)
                    .foregroundColor(.black)
                    .font(.system(size: 12))
                    .frame(width: 300, height: 170, alignment: .top)
            }
            .frame(width: 300, height: 170)
            .padding()
            
            Button(action: {
                isShowingPopup = false
            }) {
                ZStack {
                    RoundedRectangle (cornerRadius: 10)
                        .stroke(Color("accent"), lineWidth: 1)
                        .frame(width: 200, height: 40)
                    Text("지원서 링크 등록하기")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .bold()
                }
            }
            
        }
    }
}
