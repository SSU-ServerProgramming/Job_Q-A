import SwiftUI

struct ApplicantCardView: View {
    
    var memberName: String
    var userId: Int
    var memberId: Int
    var isSelected: Bool
    var status: String 
    var onSelect: () -> Void
    
    
    // 상태에 따른 텍스트 반환 함수
    private func statusText(for status: String) -> String {
        switch status {
        case "WAIT":
            return "서류접수"
        case "DOC":
            return "서류합격"
        case "DOC_FAIL":
            return "서류불합격"
        case "INTERVIEW":
            return "최종합격"
        case "FINAL_FAIL":
            return "최종불합격"
        default:
            return "상태알수없음"
        }
    }
    
    // 상태에 따른 색상 반환 함수
    private func statusColor(for status: String) -> Color {
        switch status {
        case "WAIT":
            return Color("tertiary_dark") // 서류접수
        case "DOC":
            return Color("accent") // 서류합격
        case "DOC_FAIL":
            return Color("accent") // 서류 불합격
        case "INTERVIEW":
            return Color("tertiary") // 최종 합격
        case "FINAL_FAIL":
            return Color("tertiary") // 최종 불합격
        default:
            return Color.gray // 상태알수없음
        }
    }
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(.white)
            
            HStack(spacing:0) {
                Button(action: {
                    onSelect()
                }) {
                    Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                        .resizable()
                        .foregroundColor(Color("content-secondary"))
                        .frame(width: 20, height: 20)
                        .padding(.leading)
                }
                
                Text(memberName)
                    .bold()
                    .font(.system(size: 16))
                    .padding()
                Text("#")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                Text(String(format: "%04d", userId))
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 100)
                        .foregroundColor(statusColor(for: status)) // 상태에 따른 색상 적용
                        .frame(width: 60, height: 20)
                    
                    Text(statusText(for: status))
                        .font(.system(size: 9))
                        .bold()
                        .foregroundColor(.white)
                }
                .padding()
            } // HStack
        } // ZStack
        .frame(height: 50, alignment: .leading)
    } // body
}

