import SwiftUI

struct ClubApprovalPopupView: View {
    
    @Binding var popupContent: String
    var onSubmit: (String) -> Void
    
    let maxLength = 30
    let writeReviewText = "동아리 등록이 승인되었습니다."
    
    var body: some View {
        VStack {
            Text("동아리 등록 승인")
                .font(.system(size: 18))
                .bold()
                .padding(.bottom, 20)
            
            ZStack (alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color("content-secondary"), lineWidth: 0.5)
                    .frame(width: 300, height: 50)
                TextEditor(text: $popupContent)
                    .padding(5)
                    .foregroundColor(.black)
                    .font(.system(size: 12))
                    .frame(width: 300, height: 50, alignment: .top)
                    .onChange(of: popupContent) { newValue in
                        if newValue.count > maxLength {
                            popupContent = String(newValue.prefix(maxLength))
                        }
                    }
                if popupContent.isEmpty {
                    Text(writeReviewText)
                        .foregroundColor(.gray)
                        .padding(10)
                        .font(.system(size: 12))
                }
            }
            
            HStack {
                Spacer()
                Text("\(popupContent.count)/30")
                    .font(.system(size: 10))
            }
            .frame(width: 300)
            .padding(.bottom, 10)
            
            
            Button(action: {
                onSubmit(popupContent)
            }) {
                ZStack {
                    RoundedRectangle (cornerRadius: 10)
                        .stroke(Color("accent"), lineWidth: 1)
                        .frame(width: 200, height: 40)
                    Text("확인")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .bold()
                }
            }
            
        }
    }
}
