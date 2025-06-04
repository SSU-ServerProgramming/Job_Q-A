import SwiftUI

struct CheckForBirthGenderPopupView: View {

    @Binding var isShowingCheckForBirthGenderPopup: Bool
    @Binding var navigateToNext: Bool

    
    var body: some View {
        VStack {
            Text("안내")
                .font(.system(size: 18))
                .bold()
            
            Text("출생년도와 성별을 입력하시면\n맞춤형 연합동아리 추천을 받으실 수 있습니다.\n입력하시겠습니까?")
                .padding()
                .font(.system(size: 16))
            
            HStack {
                Button(action: {
                    self.isShowingCheckForBirthGenderPopup = false
                    self.navigateToNext = true
                }) {
                    ZStack {
                        RoundedRectangle (cornerRadius: 10)
                            .stroke(Color("accent"), lineWidth: 1)
                            .frame(width: 120, height: 40)
                        Text("아니오")
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                            .bold()
                    }
                    .padding(5)
                }
                Button(action: {
                    self.isShowingCheckForBirthGenderPopup = false
                    self.navigateToNext = false
                }) {
                    ZStack {
                        RoundedRectangle (cornerRadius: 10)
                            .stroke(Color("accent"), lineWidth: 1)
                            .frame(width: 120, height: 40)
                        Text("네")
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                            .bold()
                    }
                    .padding(5)
                }
            }
            
        }
        .frame(width: 340, height: 200, alignment: .center)
    }
}

