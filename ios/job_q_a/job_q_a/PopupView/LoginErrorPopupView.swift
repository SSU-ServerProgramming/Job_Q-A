import SwiftUI

struct LoginErrorPopupView: View {
    
    @Binding var isShowingLoginErrorPopup: Bool
    
    var body: some View {
        VStack {
            Text("로그인 오류")
                .font(.system(size: 18))
                .bold()
            
            Text("아이디, 패스워드를 다시 한 번 입력해주세요.")
                .padding()
                .font(.system(size: 16))
            
            
            Button(action: {
                self.isShowingLoginErrorPopup = false
            }) {
                ZStack {
                    RoundedRectangle (cornerRadius: 10)
                        .stroke(Color("accent"), lineWidth: 1)
                        .frame(width: 230, height: 50)
                    Text("확인")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .bold()
                }
            }
        }
        .frame(width: 340, height: 200, alignment: .center)
    }
}
