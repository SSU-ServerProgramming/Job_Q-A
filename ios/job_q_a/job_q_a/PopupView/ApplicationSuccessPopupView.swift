import SwiftUI

struct ApplicationSuccessPopupView: View {
    
    @Binding var isShowSuccessApplicationPopup: Bool
    
    var body: some View {
        VStack {
            Text("동아리 지원이 완료되었습니다.")
                .font(.system(size: 18))
                .bold()
                .padding(40)
            Image("noActivityImage")
                .padding(10)
            
            Button(action: {
                self.isShowSuccessApplicationPopup = false
            }) {
                ZStack {
                    RoundedRectangle (cornerRadius: 10)
                        .stroke(Color("accent"), lineWidth: 1)
                        .frame(width: 250, height: 50)
                    Text("확인")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .bold()
                }
                .padding(EdgeInsets(top: 60, leading: 0, bottom: 20, trailing: 0))
            }
        }
    }
}
