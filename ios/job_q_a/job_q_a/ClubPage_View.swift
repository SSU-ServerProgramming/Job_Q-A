import SwiftUI
import Charts

enum tapInfo : String, CaseIterable {
    case info = "소개"
    case comments = "후기"
}

// Identifiable 프로토콜을 준수하는 구조체 생성
struct IdentifiableImage: Identifiable {
    let id = UUID()
    let url: String
}


struct ClubPageView: View {
    
    var clubID: Int
    
    @State private var selectedPicker: tapInfo = .info
    @State private var clubDetail: ClubDetailResponse?
    @State private var reviewResponse: ReviewResponse?
    @State private var userInfo: UserInfoResponse?
    @State private var clubs: [Club] = []
    @State private var members: [Member] = []
    @State private var error: Error?
    
    @State private var isShowingPopup = false
    @State private var isShowingReviewPopup = false
    @State private var isShowingEditReviewPopup = false
    @State private var isShowNoAccessPopup = false
    @State private var isShowNoActivityRecordPopup = false
    @State private var isShowSuccessApplicationPopup = false
    @State private var isShowingDelegateClubOfficerPopup = false
    @State private var isShowingApplicationSubmitPopup = false
    @State private var isShowingReviewDisplayPopup = false
    @State private var isShowingPointsShortagePopup = false
    @State private var isEditing = false
    @State private var isLoading = false
    @State private var isNewReview: Bool = false
    @State private var isOpenReview: Bool = false
    @State private var navigateToDetailView = false
    @State private var userReviewId: Int = 0
    @State private var isReviewAccess: Bool = false
    
    @State private var clubName = ""
    @State private var clubDescription = ""
    @State private var clubIntroduction = ""
    @State private var clubProfile = ""
    @State private var clubApplication = ""
    @State private var clubCategory: Int = 0
    @State private var clubStatus = ""
    @State private var clubIsRecruit: Bool = false
    @State private var clubRecruitStartDate = ""
    @State private var clubrecruitEndDate = ""
    @State private var clubImages: [ClubImage] = []
    
    @State private var userRole: String?
    
    // 갤러리, 이미지 관련 변수
    @State private var openPhoto = false
    @State private var image = UIImage()
    @State private var isImageChanged = false
    @State private var selectedImage: IdentifiableImage? = nil
    @State private var isChangedNo = false
    
    @State private var ratings: [String: Double] = [:]
    @Namespace private var animation
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var accesstokenStored: _UserAccessToken
    
    
    @ViewBuilder // 뷰 생성시 전달받은 함수를 통해 하나 이상의 자식 뷰를 만드는데 사용
    private func animate() -> some View {
        HStack {
            ForEach(tapInfo.allCases, id: \.self) { item in
                VStack {
                    Text(item.rawValue)
                        .font(.system(size: 13))
                        .bold()
                        .padding(.top)
                        .frame(maxWidth: .infinity/2, minHeight: 30)
                        .foregroundColor(selectedPicker == item ? Color("accent") : .gray)
                    
                    if selectedPicker == item {
                        Capsule()
                            .foregroundColor(Color("accent"))
                            .frame(height: 3, alignment: .center)
                            .matchedGeometryEffect(id: "info", in: animation)
                    }
                    if selectedPicker != item {
                        Capsule()
                            .foregroundColor(Color("gray-60"))
                            .frame(height: 3, alignment: .center)
                    }
                }
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        self.selectedPicker = item
                    }
                }
            }
        }
        .padding(EdgeInsets(top: 10, leading: 15, bottom: 0, trailing: 15))
    }
    
    
    // 동아리 상세 조회 API 호출
    private func fetchClubDetail() {
        NetworkManager.getClubDetails(clubId: clubID, accessToken: _UserAccessToken.shared.accessTokenStored) { result in
            switch result {
            case .success(let clubDetailResponse):
                self.clubDetail = clubDetailResponse
                if let clubDetail = clubDetail {
                    self.clubName = "\(clubDetail.name)"
                    self.clubDescription = "\(clubDetail.oneLiner)"
                    self.clubIntroduction="\(clubDetail.introduction)"
                    self.clubProfile="\(clubDetail.profile)"
                    self.clubApplication = "\(clubDetail.application)"
                    self.clubCategory = clubDetail.category
                    self.clubStatus = clubDetail.status ?? ""
                    self.clubIsRecruit = clubDetail.isRecruit
                    self.clubImages = clubDetail.images
                    self.isReviewAccess = clubDetail.isReviewAccess
                }
                print("\n동아리 상세 정보: \(clubDetailResponse)\n")
            case .failure(let error):
                self.error = error
                print("동아리 상세 정보 가져오기 에러: \(error)")
            }
        }
    }
    
    // (유저의 MEMBER, MANAGER 구분을 위해) 회원 목록 조회 API 호출
    private func getClubMembers() {
        NetworkManager.getMembers(clubId: clubID, page: 0, size: 1000, sort: ["createdDate,desc"], accessToken: _UserAccessToken.shared.accessTokenStored) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("회원 목록 조회 API 호출 성공")
                    self.members = response.members
                    checkIfCurrentUserIsManager()
                case .failure(let error):
                    self.error = error
                    print(error)
                    print("회원 목록 조회 API 호출 실패")
                }
            }
        }
    }
    private func checkIfCurrentUserIsManager() {
        NetworkManager.getUserInfo(accessToken: _UserAccessToken.shared.accessTokenStored) { result in
//            switch result {
//            case .success(let userInfoResponse):
//                print("사용자 정보 조회 호출 성공")
//                let currentUserId = userInfoResponse.id
//                for member in self.members {
//                    if member.user.userId == currentUserId && member.role == "MANAGER" {
//                        self.userRole = member.role
//                        print("현재 사용자는 운영진입니다.")
//                    }
//                }
//            case .failure(let error):
//                self.error = error
//                print("사용자 정보 조회 오류: \(error)")
//            }
        }
    }
    
    
    // 내가 작성한 리뷰가 있는지 확인하는 함수
    private func fetchUserInfo() {
        NetworkManager.getUserInfo(accessToken: "\(_UserAccessToken.shared.accessTokenStored)") { result in
            switch result {
            case .success(let userInfoResponse):
                self.userInfo = userInfoResponse
            case .failure(let error):
                print("유저 정보 조회 실패: \(error)")
            }
        }
    }
    private func getReviews() {
        NetworkManager.getReviews(clubId: clubID, page: 0, size: 1000, sort: ["createdDate,desc"], accessToken: _UserAccessToken.shared.accessTokenStored) { result in
            switch result {
            case .success(let reviewResponse):
                checkIfUserHasReview(reviews: reviewResponse.reviews)
                print("리뷰조회 성공")
            case .failure(let error):
                print("동아리 리뷰 조회 오류: \(error)")
            }
        }
    }
    private func checkIfUserHasReview(reviews: [Review]) {
//        if let userId = userInfo?.id {
//            if let userReview = reviews.first(where: { $0.user.userId == userId }) {
//                self.userReviewId = userReview.reviewId
//                print("리뷰 존재!!! 리뷰 ID: \(userReview.reviewId)")
//            }
//        }
    }
    
    
    
    // * 화면을 구성하는 View 코드 부분
    var body: some View {
        NavigationView {
            if let clubDetail = clubDetail {
                ZStack {
                    VStack {
                        // * 뒤로가기 버튼
                        Button(action:{
                            self.presentationMode.wrappedValue.dismiss()}) {
                                HStack(spacing:2) {
                                    Image(systemName: "chevron.backward")
                                    Spacer()
                                }
                                .foregroundColor(.black)
                                .padding(EdgeInsets(top: 20, leading: 25, bottom: 10, trailing: 0))
                            }
                        
                        ScrollView {
                            ZStack (alignment: .bottom) {
                                if isEditing {
                                    Button(action: {
                                        self.openPhoto = true
                                    }) {
                                        GeometryReader { geometry in
                                            if isImageChanged { // 이미지를 새로 선택한 경우
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: geometry.size.width - 40, height: 220)
                                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                                            } else { // 기존 이미지 띄우기
                                                AsyncImage(url: URL(string: clubProfile)) { phase in
                                                    switch phase {
                                                    case .empty:
                                                        ProgressView() // 로딩 중 표시
                                                    case .success(let image):
                                                        image
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: geometry.size.width - 40, height: 220)
                                                            .clipShape(RoundedRectangle(cornerRadius: 20))
                                                            .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                                                    case .failure(let error):
                                                        Text("Failed to load image: \(error.localizedDescription)")
                                                    @unknown default:
                                                        Text("Unknown state")
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    .sheet(isPresented: $openPhoto) {
                                        ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image, isImageChanged: self.$isImageChanged)
                                    }
                                    
                                }
                                else {
                                    GeometryReader { geometry in
                                        AsyncImage(url: URL(string: clubProfile)) { phase in
                                            switch phase {
                                            case .empty:
                                                ProgressView() // 로딩 중 표시
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                                    //.frame(height: 220)
                                                    .frame(width: geometry.size.width - 40, height: 220)
                                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                                            case .failure(let error):
                                                Text("이미지 업로드 실패: \(error.localizedDescription)")
                                                    .foregroundColor(.red)
                                            @unknown default:
                                                Text("Unknown state")
                                                    .foregroundColor(.red)
                                            }
                                        }
                                    }
                                }
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(height: 70)
                                        .padding(EdgeInsets(top: 0, leading: 35, bottom: 20, trailing: 35))
                                        .foregroundColor(Color.white)
                                    
                                    // * 동아리 이름 및 한 줄 소개
                                    VStack (spacing:5) {
                                        if isEditing {
                                            HStack {
                                                TextField("\(clubName)", text: $clubName)
                                                    .frame(width: 250)
                                                    .font(.system(size: 14))
                                                    .bold()
                                                    .overlay(
                                                        Rectangle()
                                                            .stroke(Color.gray, lineWidth: 1)
                                                    )
                                                Spacer()
                                                Text("수정완료")
                                                    .underline()
                                                    .font(.system(size: 12))
                                                    .foregroundColor(Color("secondary_"))
                                                    .padding(.trailing)
                                                    .onTapGesture {
                                                        isEditing = false
                                                    }
                                            }
                                            .padding(EdgeInsets(top: 0, leading: 18, bottom: 0, trailing: 0))
                                            
                                            HStack {
                                                TextField("\(clubDescription)", text: $clubDescription)
                                                    .frame(width: 250)
                                                    .font(.system(size: 12))
                                                    .foregroundColor(Color("secondary_"))
                                                    .overlay(
                                                        Rectangle()
                                                            .stroke(Color.gray, lineWidth: 1)
                                                    )
                                                Spacer()
                                            }
                                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                                        }
                                        else {
                                            HStack {
                                                Text(clubName)
                                                    .font(.system(size: 14))
                                                    .bold()
                                                Spacer()
                                                if userRole == "MANAGER" {
                                                    
                                                    NavigationLink(destination: ClubEditPageView(clubID: clubID, onEdit: {fetchClubDetail()})) {
                                                        Text("정보수정")
                                                            .underline()
                                                            .font(.system(size: 12))
                                                            .foregroundColor(Color("secondary_"))
                                                            .padding(.trailing)
                                                    }
                                                }
                                            }
                                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                                            
                                            HStack {
                                                Text(clubDescription)
                                                    .font(.system(size: 12))
                                                    .foregroundColor(Color("secondary_"))
                                                Spacer()
                                            }
                                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                                        }
                                    }
                                    .padding(EdgeInsets(top: 0, leading: 35, bottom: 20, trailing: 35))
                                    
                                }
                                .frame(height: 100)
                            }
                            .frame(height: 220)
                            
                            ZStack(alignment: .top) {
                                // * 탭 배경
                                RoundedRectangle(cornerRadius: 30)
                                    .foregroundColor(.white)
                                    .frame(width: UIScreen.main.bounds.width)
                                    .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: -5)
                                
                                // * 탭
                                VStack {
                                    animate()
                                    InfoAndCommentsEditView(tabState: selectedPicker, userReviewId: $userReviewId,isShowingReviewPopup: $isShowingReviewPopup,isShowNoAccessPopupView: $isShowNoAccessPopup, isShowNoActivityRecordPopup: $isShowNoActivityRecordPopup, isShowingEditReviewPopup: $isShowingEditReviewPopup, isShowingReviewDisplayPopup: $isShowingReviewDisplayPopup, isShowingPointsShortagePopup: $isShowingPointsShortagePopup, isEditing: $isEditing, clubIntroduction: $clubIntroduction,isNewReview: $isNewReview, isOpenReview:$isOpenReview ,clubImages: $clubImages, clubId: clubID, selectedImage: $selectedImage)
                                }
                            }
                        }
                    }
                    .sheet(item: $selectedImage) { image in
                        ZStack {
                            Color.black.edgesIgnoringSafeArea(.all)
                            AsyncImage(url: URL(string: image.url)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                case .failure:
                                    Text("이미지 로드 실패")
                                        .foregroundColor(.white)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }
                    }
                    .overlay(
                        Group {
                            if isShowingPopup {
                                Color.black.opacity(0.4)
                                    .edgesIgnoringSafeArea(.all)
                                EditApplicationPopupView(clubApplication: $clubApplication, isShowingPopup: $isShowingPopup)
                                    .frame(width: 350, height: 350)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .overlay(
                                        Button(action: {
                                            withAnimation {
                                                isShowingPopup = false
                                            }
                                        }) {
                                            Image(systemName: "xmark")
                                                .resizable()
                                                .frame(width: 15, height: 15)
                                                .foregroundColor(.black)
                                                .padding(20)
                                        }
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                    )
                            }
                            if isShowingEditReviewPopup {
                                Color.black.opacity(0.4)
                                    .edgesIgnoringSafeArea(.all)
                                EditReviewPopupView(reviewId: userReviewId, isShowingEditReviewPopup: $isShowingEditReviewPopup)
                                    .frame(width: 350, height: 420)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .overlay(
                                        Button(action: {
                                            withAnimation {
                                                isShowingEditReviewPopup = false
                                            }
                                        }) {
                                            Image(systemName: "xmark")
                                                .resizable()
                                                .frame(width: 15, height: 15)
                                                .foregroundColor(.black)
                                                .padding(20)
                                        }
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                    )
                            }
                            if isShowingReviewPopup {
                                Color.black.opacity(0.4)
                                    .edgesIgnoringSafeArea(.all)
                                ShowReviewPopupView(clubId: clubID, isNewReview: $isNewReview ,isShowingReviewPopup: $isShowingReviewPopup)
                                    .frame(width: 350, height: 420)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .overlay(
                                        Button(action: {
                                            withAnimation {
                                                isShowingReviewPopup = false
                                            }
                                        }) {
                                            Image(systemName: "xmark")
                                                .resizable()
                                                .frame(width: 15, height: 15)
                                                .foregroundColor(.black)
                                                .padding(20)
                                        }
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                    )
                            }
                            if isShowNoActivityRecordPopup {
                                Color.black.opacity(0.4)
                                    .edgesIgnoringSafeArea(.all)
                                ShowNoActivityRecordPopupView()
                                    .frame(width: 350, height: 420)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .overlay(
                                        Button(action: {
                                            withAnimation {
                                                isShowNoActivityRecordPopup = false
                                            }
                                        }) {
                                            Image(systemName: "xmark")
                                                .resizable()
                                                .frame(width: 15, height: 15)
                                                .foregroundColor(.black)
                                                .padding(20)
                                        }
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                    )
                            }
                            if isShowNoAccessPopup {
                                Color.black.opacity(0.4)
                                    .edgesIgnoringSafeArea(.all)
                                ShowNoAccessPopupView()
                                    .frame(width: 350, height: 420)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .overlay(
                                        Button(action: {
                                            withAnimation {
                                                isShowNoAccessPopup = false
                                            }
                                        }) {
                                            Image(systemName: "xmark")
                                                .resizable()
                                                .frame(width: 15, height: 15)
                                                .foregroundColor(.black)
                                                .padding(20)
                                        }
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                    )
                            }
                            if isShowingApplicationSubmitPopup {
                                Color.black.opacity(0.4)
                                    .edgesIgnoringSafeArea(.all)
                                ApplicationSubmitPopupView(clubId: clubID, isShowingApplicationSubmitPopup: $isShowingApplicationSubmitPopup, isShowSuccessApplicationPopup: $isShowSuccessApplicationPopup)
                                    .frame(width: 350, height: 220)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .overlay(
                                        Button(action: {
                                            withAnimation {
                                                isShowingApplicationSubmitPopup = false
                                            }
                                        }) {
                                            Image(systemName: "xmark")
                                                .resizable()
                                                .frame(width: 15, height: 15)
                                                .foregroundColor(.black)
                                                .padding(20)
                                        }
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                    )
                            }
                            if isShowSuccessApplicationPopup {
                                Color.black.opacity(0.4)
                                    .edgesIgnoringSafeArea(.all)
                                ApplicationSuccessPopupView(isShowSuccessApplicationPopup: $isShowSuccessApplicationPopup)
                                    .frame(width: 350, height: 420)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .overlay(
                                        Button(action: {
                                            withAnimation {
                                                isShowSuccessApplicationPopup = false
                                            }
                                        }) {
                                            Image(systemName: "xmark")
                                                .resizable()
                                                .frame(width: 15, height: 15)
                                                .foregroundColor(.black)
                                                .padding(20)
                                        }
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                    )
                            }
                            if isShowingReviewDisplayPopup {
                                Color.black.opacity(0.4)
                                    .edgesIgnoringSafeArea(.all)
                                ReviewDisplayPopupView(clubID: clubID, clubName: clubName, isOpenReview: $isOpenReview, isShowingReviewDisplayPopup: $isShowingReviewDisplayPopup, isShowingPointsShortagePopup: $isShowingPointsShortagePopup)
                                    .frame(width: 340, height: 200)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .overlay(
                                        Button(action: {
                                            withAnimation {
                                                self.isShowingReviewDisplayPopup = false
                                            }
                                        }) {
                                            Image(systemName: "xmark")
                                                .resizable()
                                                .frame(width: 15, height: 15)
                                                .foregroundColor(.black)
                                                .padding(20)
                                        }
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                    )
                            }
                            if isShowingPointsShortagePopup {
                                Color.black.opacity(0.4)
                                    .edgesIgnoringSafeArea(.all)
                                PointsShortagePopupView()
                                    .frame(width: 350, height: 420)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .overlay(
                                        Button(action: {
                                            withAnimation {
                                                self.isShowingPointsShortagePopup = false
                                            }
                                        }) {
                                            Image(systemName: "xmark")
                                                .resizable()
                                                .frame(width: 15, height: 15)
                                                .foregroundColor(.black)
                                                .padding(20)
                                        }
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                    )
                            }
                        }
                    )
                    if selectedPicker == .info && userRole != "MANAGER" {
                        VStack {
                            Spacer()
                            if clubIsRecruit {
                                Button(action: {
                                    if let url = URL(string: "\(clubApplication)") {
                                        UIApplication.shared.open(url)
                                        isShowingApplicationSubmitPopup = true
                                    }
                                }) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 100)
                                            .foregroundColor(Color("accent"))
                                            .frame(width: 200, height: 50)
                                        
                                        Text("지원하러 가기")
                                            .font(.system(size: 15))
                                            .bold()
                                            .foregroundColor(.white)
                                    }
                                    .padding(10)
                                }
                            }
                            else {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 100)
                                        .foregroundColor(Color("gray-40"))
                                        .frame(width: 200, height: 50)
                                    
                                    Text("지금은 모집 기간이 아니에요.")
                                        .font(.system(size: 15))
                                        .bold()
                                        .foregroundColor(.white)
                                }
                                .padding(10)
                            }
                        }
                    }
                    if selectedPicker == .info && userRole == "MANAGER" {
                        VStack {
                            Spacer()
                            
                            // * 회원 관리 버튼
                            NavigationLink(destination: ManageMembersView(clubId: clubID)) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 100)
                                        .foregroundColor(Color("accent"))
                                        .frame(width: 230, height: 50)
                                    
                                    
                                    Text("회원 관리")
                                        .font(.system(size: 15))
                                        .bold()
                                        .foregroundColor(.white)
                                }
                                .padding(5)
                            }
                            
                            NavigationLink(destination: ApplicantManagementView(clubID: clubID)) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 100)
                                        .foregroundColor(Color("accent"))
                                        .frame(width: 230, height: 50)
                                    
                                    Text("지원자 관리")
                                        .font(.system(size: 15))
                                        .bold()
                                        .foregroundColor(.white)
                                }
                                .padding(.bottom, 5)
                            }
                            
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear() {
            fetchUserInfo()
            getReviews()
            fetchClubDetail()
            getClubMembers()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}




// Picker를 클릭했을때 그 Picker에 맞는 뷰 띄우기
struct InfoAndCommentsEditView : View {
    
    var tabState : tapInfo
    var clubId: Int
    
    @State private var average: Double = 0.0
    @State private var starCount: Int = 0
    @State private var remainingStarCount: Int = 0
    @State private var myClubsList: [MyClub] = []
    @State private var reviewResponse: ReviewResponse?
    @State private var userInfo: UserInfoResponse?
    @State private var clubDetail: ClubDetailResponse?
    @State private var ratings: [String: Double] = [:]
    @State private var error: Error?
    @State private var isMember: Bool = false
    @Binding var userReviewId: Int
    @State private var noAccessReview = false
    @State private var openReviewPopup = true
    @State private var isReviewAccess: Bool = false
    
    @Binding var isShowingReviewPopup: Bool
    @Binding var isShowNoActivityRecordPopup: Bool
    @Binding var isShowNoAccessPopupView: Bool
    @Binding var isShowingEditReviewPopup: Bool
    @Binding var isShowingReviewDisplayPopup: Bool
    @Binding var isShowingPointsShortagePopup: Bool
    @Binding var isEditing: Bool
    @Binding var clubIntroduction: String
    @Binding var isNewReview: Bool
    @Binding var isOpenReview: Bool
    @Binding var clubImages: [ClubImage]
    @Binding var selectedImage: IdentifiableImage?
    
    
    @EnvironmentObject var accesstokenStored: _UserAccessToken
    
    init(tabState: tapInfo, userReviewId: Binding<Int>,isShowingReviewPopup: Binding<Bool>, isShowNoAccessPopupView: Binding<Bool>, isShowNoActivityRecordPopup: Binding<Bool>, isShowingEditReviewPopup:Binding<Bool>, isShowingReviewDisplayPopup: Binding<Bool>, isShowingPointsShortagePopup: Binding<Bool>, isEditing: Binding<Bool>, clubIntroduction: Binding<String>, isNewReview: Binding<Bool>, isOpenReview: Binding<Bool>, clubImages: Binding<[ClubImage]>, clubId: Int, selectedImage: Binding<IdentifiableImage?>) {
        self.tabState = tabState
        self.clubId = clubId
        
        self._userReviewId = userReviewId
        self._isShowingReviewPopup = isShowingReviewPopup
        self._isShowNoActivityRecordPopup = isShowNoActivityRecordPopup
        self._isShowingEditReviewPopup = isShowingEditReviewPopup
        self._isShowingReviewDisplayPopup = isShowingReviewDisplayPopup
        self._isShowingPointsShortagePopup = isShowingPointsShortagePopup
        self._isEditing = isEditing
        self._clubIntroduction = clubIntroduction
        self._isNewReview = isNewReview
        self._isOpenReview = isOpenReview
        self._isShowNoAccessPopupView = isShowNoAccessPopupView
        self._clubImages = clubImages
        self._selectedImage = selectedImage
        
        self.average = 0.0
    }
    
    
    // 동아리 리뷰 조회 API 호출
    func getReviews() {
        NetworkManager.getReviews(clubId: clubId, page: 0, size: 100, sort: ["createdDate,desc"], accessToken: _UserAccessToken.shared.accessTokenStored) { result in
            switch result {
            case .success(let reviewResponse):
                self.reviewResponse = reviewResponse
                self.average = reviewResponse.reviewAvg
                self.ratings = [
                    "1점": Double(reviewResponse.one) ?? 0,
                    "2점": Double(reviewResponse.two) ?? 0,
                    "3점": Double(reviewResponse.three) ?? 0,
                    "4점": Double(reviewResponse.four) ?? 0,
                    "5점": Double(reviewResponse.five) ?? 0
                ]
                updateRatings()
                print("등록된 리뷰: \(reviewResponse)")
                checkIfUserHasReview(reviews: reviewResponse.reviews)
            case .failure(let error):
                print("동아리 리뷰 조회 오류: \(error)")
            }
        }
    }
    private func updateRatings() {
        guard let reviewResponse = reviewResponse else { return }
        
        let totalStars = 5
        let fullStars = Int(reviewResponse.reviewAvg)
        let remainder = reviewResponse.reviewAvg - Double(fullStars)
        
        starCount = fullStars
        remainingStarCount = remainder > 0.5 ? totalStars - fullStars - 1 : totalStars - fullStars
    }
    
    // 내가 작성한 리뷰가 있는지 확인하는 함수
    private func checkIfUserHasReview(reviews: [Review]) {
//        if let userId = userInfo?.id {
//            if let userReview = reviews.first(where: { $0.user.userId == userId }) {
//                self.userReviewId = userReview.reviewId
//                print("유저가 작성한 리뷰가 존재합니다. 리뷰 ID: \(userReview.reviewId)")
//                self.noAccessReview = true
//            }
//            else {
//                self.noAccessReview = false
//            }
//        }
    }
    
    // getMyClub API 호출
    private func getMyClubs() {
        NetworkManager.getMyClubs(page: 0, size: 10, sort: ["기타"], accessToken: "\(_UserAccessToken.shared.accessTokenStored)") { result in
            switch result {
            case .success(let myClubsResponse):
                self.myClubsList = myClubsResponse.clubs
                checkIfUserIsMember() // 유저가 동아리 멤버인지 확인하는 함수 호출
            case .failure(let error):
                print("활동 중인 동아리 조회 오류: \(error)")
            }
        }
    }
    private func checkIfUserIsMember() {
        self.isMember = myClubsList.contains { $0.clubId == self.clubId }
    }
    
    
    // (userID를 가져오기 위해) getUserInfo API 호출
    private func fetchUserInfo() {
        NetworkManager.getUserInfo(accessToken: "\(_UserAccessToken.shared.accessTokenStored)") { result in
            switch result {
            case .success(let userInfoResponse):
                self.userInfo = userInfoResponse
            case .failure(let error):
                print("유저 정보 조회 실패: \(error)")
            }
        }
    }
    
    //(isReviewAcceess를 가져오기 위해) 동아리 상세 조회 API 호출
    private func fetchClubDetail() {
        NetworkManager.getClubDetails(clubId: clubId, accessToken: _UserAccessToken.shared.accessTokenStored) { result in
            switch result {
            case .success(let clubDetailResponse):
                self.clubDetail = clubDetailResponse
                if let clubDetail = clubDetail {
                    self.isReviewAccess = clubDetail.isReviewAccess
                }
                print("\n동아리 상세 정보 조회\n")
            case .failure(let error):
                self.error = error
                print("동아리 상세 정보 가져오기 에러: \(error)")
            }
        }
    }
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            switch tabState {
                // * 소개 탭
            case .info:
                VStack {
                    ZStack (alignment: .top) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color("content-secondary"), lineWidth: 2)
                            if isEditing {
                                TextField("\($clubIntroduction)", text: $clubIntroduction)
                                    .font(.system(size: 16))
                                    .padding()
                            } else {
                                Text(clubIntroduction)
                                    .font(.system(size: 16))
                                    .padding()
                            }
                        }
                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20))
                    }
                    
                    // 이미지 리스트
                    ScrollView (.horizontal) {
                        HStack {
                            ForEach(clubImages, id: \.fileId) { clubImage in
                                AsyncImage(url: URL(string: clubImage.imageUrl)) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 150, height: 150)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .padding(2)
                                            .onTapGesture {
                                                selectedImage = IdentifiableImage(url: clubImage.imageUrl) // 선택된 이미지 설정
                                            }
                                    case .failure:
                                        Image(systemName: "xmark.circle")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 150, height: 150)
                                            .padding(2)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            }
                        }
                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20))
                    }
                }
                .onAppear() {
                    fetchClubDetail()
                    fetchUserInfo()
                    getReviews()
                    getMyClubs()
                }
                
                
                // * 후기 탭
            case .comments:
                ZStack {
                    VStack {
                        HStack {
                            Spacer()
                            Text("후기 작성하기")
                                .underline()
                                .font(.system(size: 11))
                                .foregroundColor(Color("accent"))
                                .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 25))
                                .onTapGesture {
                                    getReviews()
                                    if isMember {
                                        print("해당 동아리의 멤버로 확인되었습니다.")
                                        if noAccessReview {
                                            print("유저가 작성한 리뷰 존재")
                                            self.isShowNoAccessPopupView = true
                                        }
                                        else {
                                            print("리뷰 작성 가능")
                                            isShowingReviewPopup = true
                                        }
                                    }
                                    else {
                                        print("동아리의 회원이 아닙니다.")
                                        isShowNoActivityRecordPopup = true
                                    }
                                }
                        }
                        .onAppear() {
                            getReviews()
                        }
                        .onChange(of: isNewReview) { newValue in
                            if newValue {
                                getReviews()
                                isNewReview = false
                            }
                        }
                        
                        // * 후기 평점 차트
                        if let reviewResponse = reviewResponse {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(
                                        AngularGradient(gradient: Gradient(colors: [Color.white, Color("gradationBlue")]), center: .topLeading, angle: .degrees(180 + 45))
                                    )
                                    .frame(height: 150)
                                    .padding(.horizontal, 25)
                                
                                HStack {
                                    VStack {
                                        Text(String(format: "%.1f", reviewResponse.reviewAvg))
                                            .font(.system(size: 35))
                                            .bold()
                                        HStack(spacing: 1) {
                                            ForEach(0..<starCount, id: \.self) { _ in
                                                Image(systemName: "star.fill")
                                                    .foregroundColor(Color("starColor"))
                                            }
                                            ForEach(0..<remainingStarCount, id: \.self) { _ in
                                                Image(systemName: "star.fill")
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                    }
                                    .frame(width: 170)
                                    
                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(width: 1, height: 90)
                                        .foregroundColor(.white)
                                    
                                    RatingBarChartView(ratings: ratings)
                                }
                            }
                            .padding(.bottom)
                            
                            ForEach(reviewResponse.reviews, id: \.reviewId) { review in
                                CommentCardView(reviewId: review.reviewId, review: review.review, totalCnt: reviewResponse.totalCnt, rate: review.rate, createDate: String(review.createdDate.prefix(10)), isUserReview: review.reviewId == userReviewId, onRevieweDeleted: {getReviews()}, isShowingEditReviewPopup: $isShowingEditReviewPopup, isShowingReviewDisplayPopup: $isShowingReviewDisplayPopup, isReviewAccess: $isReviewAccess)
                            }
                            .onChange(of: isShowingEditReviewPopup) { newValue in
                                if !newValue {
                                    getReviews()
                                }
                                else {
                                    getReviews()
                                }
                            }
                            .onChange(of: isOpenReview) { newValue in
                                if !newValue {
                                    fetchClubDetail()
                                    getReviews()
                                }
                                else {
                                    fetchClubDetail()
                                    getReviews()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}


// 나중에 사용
struct CompleteReviewSheetView: View {
    
    @State private var goToNextView = false
    
    var body: some View {
        VStack {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(Color("accent"))
            
            
            Text("5포인트가 적립되었어요.")
                .font(.system(size: 23))
                .bold()
                .padding(.top, 30)
            
            Spacer()
        }
        .padding(.top, 100)
        .background(Color.white)
        .cornerRadius(50)
    }
}
