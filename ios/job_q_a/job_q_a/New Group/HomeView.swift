import SwiftUI
import UIKit

struct HomeView: View {
    
    @State private var searchText: String = ""
    @State private var categoryName: String = ""
    @State private var categoryIndex: Int = 0
    @State private var recommendedClubsList: [Board] = []
//    @State private var boards: [Board] = []
    @EnvironmentObject var accesstokenStored: _UserAccessToken
    @State private var userInfo: UserInfoResponse?
    @State private var errorMessage: String?
    @State private var isLoading = false
    @State private var navigateToClubView = false
    @State private var navigateToUserInfoView = false
    @State var presentSheet: Bool = false
    
    @State private var notifications: [NotificationResponse.Notification] = []
    @State private var selectedNotification: NotificationResponse.Notification?
    @State private var isShowingNotification: Bool = false
    @State private var isShowingFinalStepPopup: Bool = false
    @State private var hasUncheckedNotification: Bool = false
    
    
    // 추천 동아리 목록 조회 API
    private func getRecommendedClubs() {
        NetworkManager.getRecommendedClubs() { result in
            switch result {
            case .success(let clubResponse):
                self.recommendedClubsList = clubResponse
                print("추천 동아리 목록: \(recommendedClubsList)")
            case .failure(let error):
                print("추천 동아리 API 호출 실패: \(error.localizedDescription)")
            }
        }
    }
    

    
    // getUserInfo API 호출
    private func fetchUserInfo() {
        NetworkManager.getUserInfo(accessToken: _UserAccessToken.shared.accessTokenStored) { result in
            switch result {
            case .success(let userInfoResponse):
                self.userInfo = userInfoResponse
                print("사용자 정보: \(userInfo)")
            case .failure(let error):
                print("유저 정보 조회 실패: \(error)")
            }
        }
    }
    
    // 알림 목록 조회 API 호출
    private func getNotifications() {
        isLoading = true
        NetworkManager.getNotifications(accessToken: _UserAccessToken.shared.accessTokenStored, page: 0, size: 100, sort: ["createdDate,desc"]) { result in
            isLoading = false
            switch result {
            case .success(let notificationResponse):
                self.notifications = notificationResponse.notifications
                
                let hasUncheckedNotification = self.notifications.contains { !$0.check }
                if hasUncheckedNotification {
                    self.hasUncheckedNotification = true
                    print("읽지 않은 알림이 있습니다.")
                }
                
                print("알림 목록 조회: \(notifications)")
            case .failure(let error):
                print("에러 발생: \(error)")
            }
        }
    }
    
    
    var body: some View {
        VStack (spacing: 0) {
            HStack() {
                Text("잡잡한 세상").font(.custom("AppleSDGothicNeo-Regular", size: 32))
                    .bold()
                    .padding(.trailing)
                Spacer()
            }
            .padding(.top, 30)
            
            // * 카테고리
            HStack {
                Text("카테고리")
                    .font(.custom("AppleSDGothicNeo-Regular", size: 16))
                        .bold()
                    .foregroundColor(Color("tertiary"))
                Spacer()
            }
            .padding(.top, 20)
            
            
            HStack(spacing: 5) {
                CategoryButton(imageName: "desktopcomputer", buttonName: "IT/데이터", destination: RealCategoryListView(categoryIndex: 1))
                Spacer()
                CategoryButton(imageName: "camera", buttonName: "사진/촬영", destination: RealCategoryListView(categoryIndex: 2))
                Spacer()
                CategoryButton(imageName: "text.book.closed", buttonName: "인문학/독서", destination: RealCategoryListView(categoryIndex: 3))
                Spacer()
                CategoryButton(imageName: "airplane", buttonName: "여행", destination: RealCategoryListView(categoryIndex: 4))
                Spacer()
                CategoryButton(imageName: "soccerball", buttonName: "스포츠", destination: RealCategoryListView(categoryIndex: 5))
            }
            .padding(.vertical, 10)

            HStack(spacing: 5) {
                CategoryButton(imageName: "text.below.photo", buttonName: "문화/예술", destination: RealCategoryListView(categoryIndex: 6))
                Spacer()
                CategoryButton(imageName: "figure.socialdance", buttonName: "댄스", destination: RealCategoryListView(categoryIndex: 7))
                Spacer()
                CategoryButton(imageName: "music.note.list", buttonName: "음악/악기", destination: RealCategoryListView(categoryIndex: 8))
                Spacer()
                CategoryButton(imageName: "figure.and.child.holdinghands", buttonName: "봉사활동", destination: RealCategoryListView( categoryIndex: 9))
                Spacer()
                CategoryButton(imageName: "ellipsis.circle", buttonName: "기타", destination: RealCategoryListView(categoryIndex: 10))
            }
            .padding(.vertical, 5)
            
            HStack(spacing: 0) {
                
                Text("실시간 인기글")
                    .font(.custom("AppleSDGothicNeo-Regular", size: 16))
                    .bold()
                    .foregroundColor(Color("tertiary"))
                Spacer()
                
//                NavigationLink(destination: RecommendedListView()) {
//                    Image(systemName: "chevron.forward")
//                        .padding(.horizontal)
//                        .foregroundColor(Color("tertiary"))
//                }
                
            }
            .padding(.top, 25)
            .padding(.bottom, 5)
            
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(recommendedClubsList) { board in
                        NavigationLink(destination: BoardDetailView(boardId: board.board_id)) {
                            BoardRowView(board: board)
                        }
                    }
                }
                .padding(.top, 10)
            }

            Spacer()
        }
        .padding(.horizontal, 15)
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear() {
            getRecommendedClubs()
            fetchUserInfo()
        }
    }
}


struct CategoryButton <Destination: View>: View {
    
    var imageName: String
    var buttonName: String
    var destination: Destination
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack {
                AngularGradient(gradient: Gradient(colors: [Color("accent"), Color("gradationBlue")]), center: .center)
                    .frame(width: 22, height: 22)
                    .mask(
                        Image(systemName: imageName)
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 22, height: 22)
                    )
                
                Text(buttonName)
                    .font(.system(size: 12))
                    .foregroundColor(Color("secondary_"))
                    .frame(width: 60, height: 15)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}



struct BoardRowView: View {
    let board: Board
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .frame(width: 50, height:50)
                    .foregroundColor(.white)
                Image(systemName: "person")
                    .resizable()
                    .frame(width: 35, height: 35)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(board.title)
                    .font(.system(size: 15, weight : .bold))
                    .foregroundColor(.black)
                    .lineLimit(2)
                
                Text(board.category_name)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("\(board.like)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    HStack(spacing: 4) {
                        Image(systemName: "bubble.right.fill")
                            .foregroundColor(.gray)
                        Text("\(board.comment_count)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 4)
            }
            
            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Color.gray10)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
