import SwiftUI

struct RatingBarChartView: View {
    let ratings: [String: Double] // 각 별점 항목과 해당 수치
    
    var body: some View {
        VStack {
            let maxValue = ratings.values.max() ?? 1 // 최댓값, 0으로 나누는 것을 방지하기 위해 1로 설정
            ForEach(ratings.sorted(by: { $0.key < $1.key }), id: \.key) { (label, value) in
                HStack (spacing:1) {
                    // "1점", "2점", "3점", "4점", "5점"
                    Text(label)
                        .padding(.leading)
                        .font(.system(size: 10))
                        .bold()
                        .foregroundColor(Color("tertiary"))
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                    // 막대 바
                    BarView(value: value, maxValue: maxValue)
                    // 리뷰 개수
                    Text("\(Int(value))")
                        .font(.system(size: 10))
                        .bold()
                        .foregroundColor(Color("tertiary"))
                        .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                    Spacer()
                }
            }
        }
        .frame(width: 170, height: 150)
    }
}




// * 막대 그래프 그리기
struct BarView: View {
    let value: Double
    let maxValue: Double
    
    var body: some View {
        if value == 0 { // 모든 값이 0인 경우도 고려
            let barWidth = CGFloat(value / maxValue) * 80 // 최댓값을 기준으로 비율 계산
            return AnyView(
                HStack {
                    ZStack (alignment: .leading) {
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 80, height: 10)
                            .foregroundColor(.white)
                    }
                }
            )
        } else {
            let barWidth = CGFloat(value / maxValue) * 80 // 최댓값을 기준으로 비율 계산
            return AnyView(
                HStack {
                    ZStack (alignment: .leading) {
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 80, height: 10)
                            .foregroundColor(.white)
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: barWidth, height: 10)
                            .foregroundColor(Color("chartFill"))
                    }
                }
            )
        }
    }
}
