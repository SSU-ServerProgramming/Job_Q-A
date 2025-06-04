import SwiftUI

struct RecruitmentCardView: View {
    
    var clubId: Int
    var name: String
    var profile: String
    var clubOneLiner: String
    var reviewAvg: Double
    var reviewNum: Int
    var category: Int
    var isRecruit: Bool
    var recruitmentPeriod: String
    
    let categories = ["IT/데이터", "사진/촬영", "인문학/독서", "여행", "스포츠", "문화/예술", "언어/외국어", "음악/악기", "댄스", "봉사활동", "기타"]
    
    @EnvironmentObject var accesstokenStored: _UserAccessToken
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color("gray-10"))
            
            HStack {
                // * 동아리 프로필 이미지
                AsyncImage(url: URL(string: profile)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 68, height: 68)
                        .cornerRadius(8)
                        .padding(EdgeInsets(top: 14, leading: 14, bottom: 14, trailing: 0))
                } placeholder: {
                    ProgressView()
                        .frame(width: 68, height: 68)
                        .cornerRadius(8)
                        .padding(EdgeInsets(top: 14, leading: 14, bottom: 14, trailing: 0))
                }
                
                VStack {
                    // * 동아리 이름
                    HStack {
                        Text(name)
                            .font(.system(size: 12))
                            .bold()
                            .foregroundColor(.black)
                        Spacer()
                    }
                    
                    // * 별점 및 동아리 소개글
                    HStack(spacing: 4) {
                        Image("starIcon")
                            .resizable()
                            .frame(width: 10, height: 10)
                        Text(String(format: "%.1f", reviewAvg))
                            .font(.system(size: 9))
                            .foregroundColor(.black)
                        Text(clubOneLiner)
                            .font(.system(size: 9))
                            .foregroundColor(.black)
                        Spacer()
                    }
                    
                    // * 관심항목 및 후기 개수
                    HStack(spacing: 3) {
                        Text(categories[category])
                            .font(.system(size: 9))
                            .padding(3)
                            .background(Color.white)
                            .foregroundColor(Color("secondary_"))
                            .cornerRadius(5)
                        if isRecruit {
                            Text("\(recruitmentPeriod)")
                                .font(.system(size: 9))
                                .padding(3)
                                .background(Color.white)
                                .foregroundColor(Color("secondary_"))
                                .cornerRadius(5)
                        }
                        Spacer()
                        Image("reviewIcon")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("\(reviewNum)")
                            .font(.system(size: 10))
                            .foregroundColor(.black)
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 10))
            }
        }
        .frame(height: 90, alignment: .leading)
        .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
    }
}


