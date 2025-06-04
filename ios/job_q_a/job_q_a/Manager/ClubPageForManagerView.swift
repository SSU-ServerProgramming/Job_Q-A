import SwiftUI
import Charts

enum tapInfoForManager : String, CaseIterable {
    case info = "소개"
    case category = "카테고리"
}

enum PopupType {
    case approval, rejection, none
}


struct ClubPageForManagerView: View {
    
    var clubID: Int
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var accesstokenStored: _UserAccessToken
    @State private var clubDetail: ClubDetailResponse?
    @State private var selectedPicker: tapInfoForManager = .info
    @State private var error: Error?
    @Namespace private var animation
    
    // 동아리 상세 정보 저장 변수
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
    
    // 팝업창 표시 여부를 제어하는 상태 변수 추가
    @State private var popupType: PopupType = .none
    @State private var popupContent: String = ""
    
    @ViewBuilder // 뷰 생성시 전달받은 함수를 통해 하나 이상의 자식 뷰를 만드는데 사용
    private func animate() -> some View {
        HStack {
            ForEach(tapInfoForManager.allCases, id: \.self) { item in
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
                            .frame(width: 175 , height: 3, alignment: .center)
                            .matchedGeometryEffect(id: "info", in: animation)
                    }
                    if selectedPicker != item {
                        Capsule()
                            .foregroundColor(Color("gray-60"))
                            .frame(width: 175 , height: 3, alignment: .center)
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
        .navigationBarBackButtonHidden()
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
                }
                print("\n동아리 상세 정보: \(clubDetailResponse)\n")
            case .failure(let error):
                self.error = error
                print("동아리 상세 정보 가져오기 에러: \(error)")
            }
        }
    }
    
    // 승인, 반려, 보류 상태 업데이트 함수
    private func updateClubStatus(status: String, content: String) {
        NetworkManager.updateClubStatus(clubId: clubID, status: status, content: content, accessToken: _UserAccessToken.shared.accessTokenStored) { result in
            switch result {
            case .success(let response):
                print("동아리 상태 업데이트 성공: \(response)")
                fetchClubDetail()
            case .failure(let error):
                print("동아리 상태 업데이트 실패: \(error)")
            }
        }
    }
    
    
    var body: some View {
        ZStack {
            VStack {
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
                        AsyncImage(url: URL(string: clubProfile)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 220)
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
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 70)
                                .padding(EdgeInsets(top: 0, leading: 35, bottom: 20, trailing: 35))
                                .foregroundColor(Color.white)
                            
                            HStack {
                                VStack {
                                    HStack {
                                        Text(clubName)
                                            .font(.system(size: 14))
                                            .bold()
                                        Spacer()
                                    }
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 1, trailing: 0))
                                    HStack {
                                        Text(clubDescription)
                                            .font(.system(size: 12))
                                            .foregroundColor(Color("secondary_"))
                                        Spacer()
                                    }
                                }
                                
                                RadioButtonGroup(callback: { (previousId, currentId) in
                                    withAnimation {
                                        if currentId == 0 {
                                            popupType = .approval
                                        } else if currentId == 1 {
                                            popupType = .rejection
                                        } else {
                                            popupType = .none
                                        }
                                    }
                                })
                            }
                            .frame(height: 70)
                            .padding(EdgeInsets(top: 0, leading:50, bottom:20, trailing: 50))
                            
                        }
                        .frame(height: 100)
                    }
                    .frame(height: 220)
                    
                    
                    ZStack(alignment: .top) {
                        RoundedRectangle(cornerRadius: 30)
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width)
                            .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: -5)
                        
                        VStack {
                            animate()
                            InfoAndCategoryView(tabState: selectedPicker, clubIntroduction: $clubIntroduction, clubCategory: $clubCategory, isShowingPopup: Binding.constant(false))
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden()
            .overlay(
                Group {
                    if popupType != .none {
                        Color.black.opacity(0.4) // 반투명한 검은색 배경
                            .edgesIgnoringSafeArea(.all) //화면의 안전 영역을 무시하고 전체 화면을 덮도록
                        if popupType == .approval {
                            ClubApprovalPopupView(popupContent: $popupContent) { content in
                                updateClubStatus(status: "ACCEPT", content: content)
                                popupType = .none
                            }
                            .frame(width: 350, height: 250)
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(
                                Button(action: {
                                    withAnimation {
                                        popupType = .none
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
                        } else if popupType == .rejection {
                            ClubRejectionPopupView(popupContent: $popupContent) { content in
                                updateClubStatus(status: "RETURN", content: content)
                                popupType = .none
                            }
                            .frame(width: 350, height: 250)
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(
                                Button(action: {
                                    withAnimation {
                                        popupType = .none
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
                }
            )
            
            // 소개탭이 선택된 경우에만 지원 버튼 표시
            if selectedPicker == .info {
                VStack {
                    Spacer()
                    Button(action: {
                        if let url = URL(string: clubApplication) {
                            UIApplication.shared.open(url)
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
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear() {
            fetchClubDetail()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}



// 탭 뷰
struct InfoAndCategoryView : View {
    
    var tabState : tapInfoForManager
    
    @Binding var clubIntroduction: String
    @Binding var clubCategory: Int
    @Binding var isShowingPopup: Bool
    
    init(tabState: tapInfoForManager, clubIntroduction: Binding<String>, clubCategory: Binding<Int>, isShowingPopup: Binding<Bool>) {
        self.tabState = tabState
        self._isShowingPopup = isShowingPopup
        self._clubCategory = clubCategory
        self._clubIntroduction = clubIntroduction
    }
    
    let categories = ["IT/데이터", "사진/촬영", "인문학/독서", "여행", "스포츠", "문화/예술", "언어/외국어", "음악/악기", "댄스", "봉사활동", "기타"]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            switch tabState {
                // * 소개 탭
            case .info:
                ZStack (alignment: .top) {
                    ScrollView {
                        ZStack {
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color("content-secondary"), lineWidth: 2)
                            Text(clubIntroduction)
                                .font(.system(size: 16))
                                .padding()
                        }
                        .padding(EdgeInsets(top: 10, leading: 25, bottom: 0, trailing: 25))
                    }
                }
                
                // * 카테고리 탭
            case .category:
                VStack {
                    HStack {
                        Text("카테고리")
                            .font(.system(size: 15))
                            .foregroundColor(Color("tertiary"))
                            .bold()
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 15, leading: 25, bottom: 10, trailing: 0))
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("secondary_"))
                            .padding(.horizontal, 20)
                            .frame(width: UIScreen.main.bounds.width, height: 50)
                        
                        HStack {
                            Text(categories[clubCategory])
                                .padding(.leading, 40)
                                .foregroundColor(Color("secondary_"))
                            
                            Spacer()
                        }
                    }
                    Spacer()
                }
                
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}




// 커스텀 라디오 버튼
struct RadioButtonGroup: View {
    let window = UIScreen.main.bounds.size
    let items :[String] = ["승인", "반려", "보류"]
    
    @State var selectedId:Int = 2
    
    let callback: ((Int,Int)) -> ()
    
    func radioGroupCallback(id: Int) {
        callback((selectedId,id)) //콜백 (이전 선택,현재 선택)을 튜플 형태로 설정
        selectedId = id //선택된 아이디 변경
    } 
    
    var body: some View {
        
        VStack(alignment: .leading) {
            VStack(spacing: 1) {
                ForEach(Array(items.enumerated()), id: \.offset) { idx, item in
                    RadioButton(title: item, id:idx, callback: self.radioGroupCallback, selectedID: self.selectedId)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


struct RadioButton: View {
    let window = UIScreen.main.bounds.size
    let id:Int
    let title:String
    let callback: (Int)->()
    let selectedId:Int
    init(
        title:String,
        id: Int,
        callback: @escaping (Int)->(),
        selectedID: Int
    ) {
        self.title = title
        self.id = id
        self.selectedId = selectedID
        self.callback = callback
    }
    
    var body: some View {
        Button(action: {
            self.callback(id)
        }) {
            HStack {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 10, height: 10)
                        .overlay(
                            Circle()
                                .stroke(self.selectedId == self.id ? Color.black : Color("gray-60"), lineWidth: 1)
                        )
                    Circle()
                        .fill(self.selectedId == self.id ? Color.black : Color.white)
                        .frame(width: 5, height: 5)
                        .overlay(
                            Circle()
                                .stroke(self.selectedId == self.id ? Color.black : Color.white, lineWidth: 1)
                        )
                }
                
                Text(title)
                    .fontWeight(.bold)
                    .font(.system(size: 12))
                    .foregroundColor(self.selectedId == self.id ? .black : .gray)
            }
        }
        .padding(2)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

