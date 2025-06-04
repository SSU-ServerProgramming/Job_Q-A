import SwiftUI

struct ClubCardForManagerView: View {
    
    var clubId: Int
    var name: String
    var profile: String
    var reviewAvg: Double
    var reviewNum: Int
    var category: Int
    var isRecruit: Bool
    var recruitmentPeriod: String
    var status: String
    
    let categories = ["전체", "IT/데이터", "사진/촬영", "인문학/독서", "여행", "스포츠", "문화/예술", "댄스", "음악/악기", "봉사활동", "기타"]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color("gray-10"))
            
            HStack {
                AsyncImage(url: URL(string: profile)) { image in
                    image
                        .resizable()
                        .frame(width: 68, height: 68)
                        .padding(EdgeInsets(top: 14, leading: 14, bottom: 14, trailing: 0))
                } placeholder: {
                    ProgressView()
                        .frame(width: 68, height: 68)
                        .padding(EdgeInsets(top: 14, leading: 14, bottom: 14, trailing: 0))
                }
                
                VStack {
                    HStack {
                        Text(name)
                            .font(.system(size: 12))
                            .bold()
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 100)
                                .foregroundColor(Color("accent"))
                                .frame(width: 45, height: 20)
                            
                            Text(status)
                                .font(.system(size: 9))
                                .bold()
                                .foregroundColor(.white)
                        }
                    }
                    
                    HStack(spacing: 4) {
                        Image("starIcon")
                            .resizable()
                            .frame(width: 10, height: 10)
                        
                        Text("0.0")
                            .font(.system(size: 9))
                            .foregroundColor(.black)
                        
                        Text("")
                            .font(.system(size: 9))
                            .foregroundColor(.black)
                        
                        Spacer()
                    }
                    
                    HStack(spacing: 3) {
                        Text(categories[category])
                            .font(.system(size: 9))
                            .padding(3)
                            .background(Color.white)
                            .foregroundColor(Color("secondary_"))
                            .cornerRadius(5)
                        Text("\(recruitmentPeriod)")
                            .font(.system(size: 9))
                            .padding(3)
                            .background(Color.white)
                            .foregroundColor(Color("secondary_"))
                            .cornerRadius(5)
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
        .frame(width: 350, height: 90, alignment: .leading)
        .padding(5)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
