
import SwiftUI

struct NoExistentMemberPopupView: View {
    
    @Binding var isShowingNoExistentMemberPopup: Bool
    
    var body: some View {
        VStack {
            Text("회원 등록")
                .font(.system(size: 18))
                .bold()
            
            Text("존재하지 않는 회원입니다.")
                .font(.system(size: 15))
                .padding(20)
            
            Button(action: {
                isShowingNoExistentMemberPopup = false
            }) {
                ZStack {
                    RoundedRectangle (cornerRadius: 10)
                        .stroke(Color("accent"), lineWidth: 1)
                        .frame(width: 200, height: 35)
                    Text("확인")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .bold()
                }
            }
            
        }
        .frame(width: 340, height: 300, alignment: .center)
    }
}

