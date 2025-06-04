import SwiftUI

struct ProfileView: View {
    
    @State private var isEditingInterests = false
    @State private var user: UserInfoResponse?
    @EnvironmentObject var accesstokenStored: _UserAccessToken
    @State private var myClubsList: [MyClub] = []
    @State private var myAppliedClubsList: [AppliedClub] = []
    @State private var showPointInfo = false
    
    let categories = ["IT/데이터", "사진/촬영", "인문학/독서", "여행", "스포츠", "문화/예술", "언어/외국어", "음악/악기", "댄스", "봉사활동", "기타"]
    
    // getUserInfo API 호출
    private func fetchUserInfo() {
        if let accessToken = loadAccessToken() {
            NetworkManager.getUserInfo(accessToken: accessToken) { result in
                switch result {
                case .success(let userInfoResponse):
                    self.user = userInfoResponse
                    
                case .failure(let error):
                    print("유저 정보 조회 실패: \(error)")
                }
            }
        }
    }
    
    
    var body: some View {
        VStack(alignment: .center){
            Spacer().frame(height: 31)
            Text("마이페이지").font(.system(size: 22)).padding(.bottom, 24).foregroundColor(.black)
            Image("profile").frame(width: 149, height: 149).padding(.bottom, 27)
            
//            HStack() {
//                NavigationLink(destination: PostView()) {
//                    HStack(spacing: 12) {
//                        // 첫 번째 아이콘
//                        RoundedRectangle(cornerRadius: 4)
//                            .fill(Color.blue.opacity(0.5))
//                            .frame(width: 20, height: 20)
//                            .overlay(
//                                Image(systemName: "line.horizontal.3")
//                                    .foregroundColor(.white)
//                                    .font(.system(size: 14))
//                            )
//                        
//                        Text("내가 쓴 글")
//                            .font(.system(size: 12, weight: .bold))
//                            .foregroundColor(.black)
//                    }
//                    .padding()
//                    .frame(width: .infinity)
//                    .background(
//                        RoundedRectangle(cornerRadius: 20)
//                            .stroke(Color.blue, lineWidth: 2)
//                    )
//                    
//                }
//                NavigationLink(destination: PostView()) {
//                    HStack(spacing: 12) {
//                        // 두 번째 아이콘
//                        Circle()
//                            .fill(Color.cyan.opacity(0.8))
//                            .frame(width: 24, height: 24)
//                            .overlay(
//                                Image(systemName: "ellipsis.bubble")
//                                    .foregroundColor(.white)
//                                    .font(.system(size: 14))
//                            )
//                        
//                        Text("댓글 단 글")
//                            .font(.body)
//                            .foregroundColor(.black)
//                    }
//                    .padding()
//                    .frame(width: .infinity)
//                    .background(
//                        RoundedRectangle(cornerRadius: 20)
//                            .stroke(Color.blue, lineWidth: 2)
//                    )
//                    
//                }
//            }
//            .padding(.top, 8)
            
            VStack(alignment: .leading, spacing: 22){
                Divider()
                HStack(){
                    Text("이름").font(.system(size: 15)).foregroundColor(.black)
                    Spacer()
                    Text(user?.nickname ?? "x").font(.system(size: 15)).foregroundColor(.black)
                }
                Divider()
                
                HStack(){
                    Text("회사명").font(.system(size: 15)).foregroundColor(.black)
                    Spacer()
                    Text(user?.company_name ?? "x").font(.system(size: 15)).foregroundColor(.black)
                }
                Divider()
                
                HStack(){
                    Text("이메일").font(.system(size: 15)).foregroundColor(.black)
                    Spacer()
                    Text(user?.email ?? "x").font(.system(size: 15)).foregroundColor(.black)
                }
                Divider()
                NavigationLink(destination: MyPostView()) {
                    HStack(spacing: 12) {
                        // 첫 번째 아이콘
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.blue.opacity(0.5))
                            .frame(width: 20, height: 20)
                            .overlay(
                                Image(systemName: "line.horizontal.3")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14))
                            )
                        
                        Text("내가 쓴 글")
                            .font(.system(size: 15)).foregroundColor(.black)
                    }
                }
                
                Divider()
                NavigationLink(destination: MyPostCommentView()) {
                    HStack(spacing: 12) {
                        // 두 번째 아이콘
                        Circle()
                            .fill(Color.cyan.opacity(0.8))
                            .frame(width: 20, height: 20)
                            .overlay(
                                Image(systemName: "ellipsis.bubble")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14))
                            )
                        
                        Text("댓글 단 글")
                            .font(.system(size: 15)).foregroundColor(.black)
                    }
                }

                
            }.padding(.horizontal, 46).padding(.vertical, 46).background(.white).cornerRadius(10)
                .padding(.horizontal, 20)
            Spacer()
        }.onAppear(perform: {
            fetchUserInfo()
        })
    }
}



struct ClubButton <Destination: View> : View {
    
    var imageName: String
    var clubName: String
    var destination: Destination
    
    private func truncateText(_ text: String, length: Int) -> String {
        if text.count > length {
            let truncated = text.prefix(length)
            return "\(truncated)..."
        } else {
            return text
        }
    }
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack {
                AsyncImage(url: URL(string: imageName)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 68, height: 68)
                        .cornerRadius(8)
                } placeholder: {
                    ProgressView()
                        .frame(width: 68, height: 68)
                        .cornerRadius(8)
                }
                Text(truncateText(clubName, length: 6))
                    .font(.system(size: 12))
                    .foregroundColor(Color.black)
                    .frame(width: 68)
            }
            .padding(8)
        }
    }
}


struct AppliedClubButton<Destination: View>: View {
    
    var imageName: String
    var clubName: String
    var destination: Destination
    var docDeadLine: String?
    var docResultDate: String?
    var interviewStartDate: String?
    var interviewEndDate: String?
    var finalResultDate: String?
    
    // 날짜 포맷터
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd-HH:mm"
        return formatter
    }
    
    // D-Day 계산
    private func calculateDday(from dateString: String?) -> Int? {
        guard let dateString = dateString,
              let endDate = dateFormatter.date(from: dateString) else {
            return nil
        }
        
        let currentDate = Date()
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.day], from: currentDate, to: endDate)
        
        return components.day
    }
    
    // 가장 가까운 날짜와 그에 따른 텍스트를 반환
    private var nearestEvent: (title: String, dDay: String) {
        let dates = [
            ("서류 마감", docDeadLine),
            ("서류 발표", docResultDate),
            ("면접 시작", interviewStartDate),
            ("면접 종료", interviewEndDate),
            ("최종 발표", finalResultDate)
        ]
        
        let filteredDates = dates.compactMap { title, dateString -> (title: String, daysRemaining: Int)? in
            if let daysRemaining = calculateDday(from: dateString) {
                return (title, daysRemaining)
            }
            return nil
        }
        
        if let nearestDate = filteredDates.min(by: { $0.daysRemaining < $1.daysRemaining }) {
            return (nearestDate.title, nearestDate.daysRemaining > 0 ? "D-\(nearestDate.daysRemaining)" : "D-DAY")
        } else {
            return ("", "마감")
        }
    }
    
    private func truncateText(_ text: String, length: Int) -> String {
        if text.count > length {
            let truncated = text.prefix(length)
            return "\(truncated)..."
        } else {
            return text
        }
    }
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack {
                ZStack {
                    AsyncImage(url: URL(string: imageName)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 68, height: 68)
                            .cornerRadius(8)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 68, height: 68)
                            .cornerRadius(8)
                    }
                    Color.black.opacity(0.5)
                        .frame(width: 68, height: 68)
                        .cornerRadius(8)
                    
                    LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.9), Color("gradationBlue").opacity(0.5)]), startPoint: .top, endPoint: .bottom)
                        .frame(width: 68, height: 68)
                        .cornerRadius(8)
                    
                    VStack {
                        Text(nearestEvent.title)
                            .bold()
                            .font(.system(size: 9))
                            .foregroundColor(Color.white)
                        Text(nearestEvent.dDay)
                            .bold()
                            .font(.system(size: 9))
                            .foregroundColor(Color.white)
                    }
                    .frame(width: 68)
                    
                }
                
                Text(truncateText(clubName, length: 6))
                    .font(.system(size: 12))
                    .foregroundColor(Color.black)
                    .frame(width: 68)
            }
            .padding(8)
        }
    }
}
