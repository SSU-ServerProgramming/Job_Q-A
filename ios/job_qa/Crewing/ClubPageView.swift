<<<<<<< HEAD
//import SwiftUI
//import Charts
//
//
//enum tapInfo : String, CaseIterable {
//    case info = "소개"
//    case comments = "후기"
//}
//
//let ratings: [String: Double] = ["1점": 4, "2점": 0, "3점": 8, "4점": 75, "5점":56] // 예시 데이터
//
//
//struct ClubPageView: View {
//    
//    //@State private var infoTextEdit: String = "" 동아리 소개탭 편집시 사용
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//    @State private var selectedPicker: tapInfo = .info
//    @Namespace private var animation
//    
//    // 팝업창 표시 여부를 제어하는 상태 변수 추가
//    @State private var isShowingPopup = false
//    
//    @ViewBuilder // 뷰 생성시 전달받은 함수를 통해 하나 이상의 자식 뷰를 만드는데 사용
//    private func animate() -> some View {
//        HStack {
//            ForEach(tapInfo.allCases, id: \.self) { item in
//                VStack {
//                    Text(item.rawValue)
//                        .font(.system(size: 13))
//                        .bold()
//                        .padding(.top)
//                        .frame(maxWidth: .infinity/2, minHeight: 30)
//                        .foregroundColor(selectedPicker == item ? Color("accent") : .gray)
//
//                    if selectedPicker == item {
//                        Capsule()
//                            .foregroundColor(Color("accent"))
//                            .frame(width: 175 , height: 3, alignment: .center)
//                            .matchedGeometryEffect(id: "info", in: animation)
//                    }
//                    if selectedPicker != item {
//                        Capsule()
//                            .foregroundColor(Color("gray-60"))
//                            .frame(width: 175 , height: 3, alignment: .center)
//                    }
//                }
//                .onTapGesture {
//                    withAnimation(.easeInOut) {
//                        self.selectedPicker = item
//                    }
//                }
//            }
//        }
//        .padding(EdgeInsets(top: 10, leading: 15, bottom: 0, trailing: 15))
//    }
//    
//    
//
//    // * 화면을 구성하는 View 코드 부분
//    var body: some View {
//        ZStack {
//            VStack {
//                // * 뒤로가기 버튼
//                Button(action:{
//                    self.presentationMode.wrappedValue.dismiss()}) {
//                        HStack(spacing:2) {
//                            Image(systemName: "chevron.backward")
//                            Spacer()
//                        }
//                        .foregroundColor(.black)
//                        .padding(EdgeInsets(top: 20, leading: 25, bottom: 10, trailing: 0))
//                    }
//                
//                ScrollView {
//                    ZStack (alignment: .bottom) {
//                        // * 동아리 이미지
//                        Image("galleryImg")
//                            .resizable()
//                            .scaledToFill()
//                            .frame(height: 220)
//                            .clipShape(RoundedRectangle(cornerRadius: 20))
//                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
//                        
//                        ZStack {
//                            RoundedRectangle(cornerRadius: 10)
//                                .frame(height: 70)
//                                .padding(EdgeInsets(top: 0, leading: 35, bottom: 20, trailing: 35))
//                                .foregroundColor(Color.white)
//                            
//                            // * 동아리 이름 및 한 줄 소개
//                            VStack {
//                                HStack {
//                                    Text("동학대학운동")
//                                        .font(.system(size: 14))
//                                        .bold()
//                                    Spacer()
//                                }
//                                .padding(EdgeInsets(top: 0, leading: 20, bottom: 1, trailing: 0))
//                                HStack {
//                                    Text("사이드 프로젝트 진행하는 IT동아리")
//                                        .font(.system(size: 12))
//                                        .foregroundColor(Color("secondary_"))
//                                    Spacer()
//                                }
//                                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
//                            }
//                            .padding(EdgeInsets(top: 0, leading: 35, bottom: 20, trailing: 35))
//                            
//                        } // ZStack
//                        .frame(height: 100)
//                    } // ZStack
//                    .frame(height: 220)
//                    
//                    
//                    ZStack(alignment: .top) {
//                        // * 탭 배경
//                        RoundedRectangle(cornerRadius: 30)
//                            .foregroundColor(.white)
//                            .frame(width: UIScreen.main.bounds.width) // 화면 너비와 일치하도록 설정
//                            .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: -5)
//                        
//                        // * 탭
//                        VStack {
//                            animate()
//                            InfoAndCommentsView(tabState: selectedPicker, isShowingPopup: $isShowingPopup)
//                            
//                        }
//                    }
//                } // ScrollView
//            } // VStack
//            .navigationBarBackButtonHidden() // 뒤로가기 버튼 숨기기
//            .overlay(
//                Group {
//                    if isShowingPopup {
//                        Color.black.opacity(0.4) // 반투명한 검은색 배경
//                            .edgesIgnoringSafeArea(.all) //화면의 안전 영역을 무시하고 전체 화면을 덮도록
//                        //ShowNoActivityRecordPopupView()
//                        ShowReviewPopupView()
//                            .frame(width: 350, height: 420)
//                            .background(Color.white)
//                            .cornerRadius(20)
//                            .overlay(
//                                // 닫기 버튼
//                                Button(action: {
//                                    withAnimation {
//                                        isShowingPopup = false
//                                    }
//                                }) {
//                                    Image(systemName: "xmark")
//                                        .resizable()
//                                        .frame(width: 15, height: 15)
//                                        .foregroundColor(.black)
//                                        .padding(20)
//                                }
//                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
//                            )
//                    }
//                }
//            ) // overlay
//            
//            // 소개탭이 선택된 경우에만 지원 버튼 표시
//            if selectedPicker == .info {
//                VStack {
//                    Spacer()
//                    Button(action: {
//                        if let url = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSeXFCBJgdHoZvjTMmR043AEKEv4OBQ9ulUatmS4XKHmVtW8dQ/viewform?usp=sf_link") {
//                            UIApplication.shared.open(url)
//                        }
//                    }) {
//                        ZStack {
//                            RoundedRectangle(cornerRadius: 100)
//                                .foregroundColor(Color("accent"))
//                                .frame(width: 200, height: 50)
//                                        
//                            Text("지원하러 가기")
//                                .font(.system(size: 15))
//                                .bold()
//                                .foregroundColor(.white)
//                        }
//                    }
//                }
//            } // 지원 버튼
//        } //ZStack
//    } // body
//}
//
//
//
//// Picker를 클릭했을때 그 Picker에 맞는 뷰 띄우기
//struct InfoAndCommentsView : View {
//    
//    var tabState : tapInfo
//    
//    // 별점 평균과 관련된 변수들을 선언
//    var totalSum: Double
//    var totalCount: Double
//    var average: Double
//    var integerPart: Int
//    var decimalPart: Int
//    var starCount: Int
//    var remainingStarCount: Int
//    
//    // 팝업창 표시 여부를 제어하는 바인딩 변수 추가
//    @Binding var isShowingPopup: Bool
//    
//    // 초기화 시 평균과 관련된 변수들을 계산
//    init(tabState: tapInfo, isShowingPopup: Binding<Bool>) {
//        self.tabState = tabState
//        self.totalSum=0
//        self.totalCount=0
//        self.average=0
//        self.integerPart=0
//        self.decimalPart=0
//        self.starCount=0
//        self.remainingStarCount=0
//        
//        self._isShowingPopup = isShowingPopup // 바인딩 변수 초기화
//
//        for (key, value) in ratings {
//            let removedDot = key.filter { !$0.isLetter } // "5점" 문자열에서 "5"만 추출하기
//            if let intValue = Int(removedDot) { // 문자열 "5"를 정수로 변환
//                totalSum += Double(intValue) * value
//                totalCount += value
//            } else {
//                print("Error: Cannot convert \(removedDot) to integer")
//            }
//        }
//        
//        average = totalSum / totalCount
//        integerPart = Int(average)
//        decimalPart = Int((average - Double(integerPart)) * 10)
//        starCount = min(integerPart, 5)
//        remainingStarCount = max(0, 5 - starCount)
//    }
//
//
//    var body: some View {
//        ScrollView(.vertical, showsIndicators: false) {
//            switch tabState {
//            // * 소개 탭
//            case .info:
//            //case .comments:
//                ZStack (alignment: .top) {
//                    ScrollView {
//                        ZStack {
//                            RoundedRectangle(cornerRadius: 6)
//                                .stroke(Color("content-secondary"), lineWidth: 2)
//                            Text("시작\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n\n.\n.\n.\n.\n.\n.\n끝")
//                                .font(.system(size: 16))
//                                .padding()
//                        }
//                        .padding(EdgeInsets(top: 10, leading: 25, bottom: 0, trailing: 25))
//                    }
//                } // ZStack
//
//                
//            // * 후기 탭
//            case .comments:
//            //case .info:
//                ScrollView {
//                    // * 후기 작성하기 버튼
//                    HStack {
//                        Spacer()
//                        Text("후기 작성하기")
//                            .underline()
//                            .font(.system(size: 11))
//                            .foregroundColor(Color("accent"))
//                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 25))
//                            .onTapGesture {
//                                isShowingPopup = true // 팝업창 표시
//                            }
//                    }
//                    
//                    // * 후기 평점 차트
//                    ZStack {
//                        RoundedRectangle(cornerRadius: 10)
//                            .fill(
//                                AngularGradient(gradient: Gradient(colors: [Color.white, Color("gradationBlue")]), center: .topLeading, angle: .degrees(180 + 45))
//                            )
//                            .frame(width: .infinity, height: 150)
//                            .padding(.horizontal, 25)
//                        
//                        HStack {
//                            // 별점 평균 수치 및 별 아이콘
//                            VStack {
//                                Text("\(integerPart).\(decimalPart)") // 평균 점수 표시
//                                    .font(.system(size: 35))
//                                    .bold()
//
//                                HStack(spacing: 1) {
//                                    ForEach(0..<starCount, id: \.self) { _ in
//                                        Image(systemName: "star.fill")
//                                            .foregroundColor(Color("starColor"))
//                                    }
//                                    ForEach(0..<remainingStarCount, id: \.self) { _ in
//                                        Image(systemName: "star.fill")
//                                            .foregroundColor(.gray)
//                                    }
//                                }
//                            }
//                            .frame(width: 170)
//
//                            // 중앙 구분선
//                            RoundedRectangle(cornerRadius: 5)
//                                .frame(width: 1, height: 90)
//                                .foregroundColor(.white)
//
//                            // 별점 항목별 수치
//                            RatingBarChartView(ratings: ratings)
//                        }
//                    }
//                    .padding(.bottom)
//                    
//                    ForEach(0..<5) { _ in
//                        CommentCardView()
//                    }
//                    
//                } // ScrollView
//            }
//        }
//    }
//}
//
//
//
//
//
//#Preview {
//    ClubPageView()
//}
=======
import SwiftUI
import Charts


enum tapInfo : String, CaseIterable {
    case info = "소개"
    case comments = "후기"
}

let ratings: [String: Double] = ["1점": 4, "2점": 0, "3점": 8, "4점": 75, "5점":56] // 예시 데이터


struct ClubPageView: View {
    
    //@State private var infoTextEdit: String = "" 동아리 소개탭 편집시 사용
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var selectedPicker: tapInfo = .info
    @Namespace private var animation
    
    // 팝업창 표시 여부를 제어하는 상태 변수 추가
    @State private var isShowingPopup = false
    
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
    }
    
    

    // * 화면을 구성하는 View 코드 부분
    var body: some View {
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
                        .padding(EdgeInsets(top: 20, leading: 15, bottom: 10, trailing: 0))
                    }
                
                ScrollView {
                    ZStack (alignment: .bottom) {
                        // * 동아리 이미지
                        RoundedRectangle(cornerRadius: 10)
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
                            .frame(height: 220)
                            .foregroundColor(Color("tertiary"))
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 70)
                                .padding(EdgeInsets(top: 0, leading: 35, bottom: 30, trailing: 35))
                                .foregroundColor(Color.white)
                            
                            // * 동아리 이름 및 한 줄 소개
                            VStack {
                                HStack {
                                    Text("동학대학운동")
                                        .font(.system(size: 14))
                                        .bold()
                                    Spacer()
                                }
                                .padding(EdgeInsets(top: 0, leading: 20, bottom: 1, trailing: 0))
                                HStack {
                                    Text("사이드 프로젝트 진행하는 IT동아리")
                                        .font(.system(size: 12))
                                        .foregroundColor(Color("secondary_"))
                                    Spacer()
                                }
                                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                            }
                            .padding(EdgeInsets(top: 0, leading: 35, bottom: 30, trailing: 35))
                            
                        } // ZStack
                        .frame(height: 100)
                    } // ZStack
                    .frame(height: 220)
                    
                    
                    ZStack(alignment: .top) {
                        // * 탭 배경
                        RoundedRectangle(cornerRadius: 30)
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width) // 화면 너비와 일치하도록 설정
                            .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: -5)
                        
                        // * 탭
                        VStack {
                            animate()
                            InfoAndCommentsView(tabState: selectedPicker, isShowingPopup: $isShowingPopup)
                            
                        }
                    }
                } // ScrollView
            } // VStack
            .navigationBarBackButtonHidden() // 뒤로가기 버튼 숨기기
            .overlay(
                Group {
                    if isShowingPopup {
                        Color.black.opacity(0.4) // 반투명한 검은색 배경
                            .edgesIgnoringSafeArea(.all) //화면의 안전 영역을 무시하고 전체 화면을 덮도록
                        //showNoActivityRecordPopupView()
                        showReviewPopupView()
                            .frame(width: 350, height: 420)
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(
                                // 닫기 버튼
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
                }
            ) // overlay
            
            // 소개탭이 선택된 경우에만 지원 버튼 표시
            if selectedPicker == .info {
                VStack {
                    Spacer()
                    Button(action: {
                        if let url = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSeXFCBJgdHoZvjTMmR043AEKEv4OBQ9ulUatmS4XKHmVtW8dQ/viewform?usp=sf_link") {
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
            } // 지원 버튼
        } //ZStack
    } // body
}



// Picker를 클릭했을때 그 Picker에 맞는 뷰 띄우기
struct InfoAndCommentsView : View {
    
    var tabState : tapInfo
    
    // 별점 평균과 관련된 변수들을 선언
    var totalSum: Double
    var totalCount: Double
    var average: Double
    var integerPart: Int
    var decimalPart: Int
    var starCount: Int
    var remainingStarCount: Int
    
    // 팝업창 표시 여부를 제어하는 바인딩 변수 추가
    @Binding var isShowingPopup: Bool
    
    // 초기화 시 평균과 관련된 변수들을 계산
    init(tabState: tapInfo, isShowingPopup: Binding<Bool>) {
        self.tabState = tabState
        self.totalSum=0
        self.totalCount=0
        self.average=0
        self.integerPart=0
        self.decimalPart=0
        self.starCount=0
        self.remainingStarCount=0
        
        self._isShowingPopup = isShowingPopup // 바인딩 변수 초기화

        for (key, value) in ratings {
            let removedDot = key.filter { !$0.isLetter } // "5점" 문자열에서 "5"만 추출하기
            if let intValue = Int(removedDot) { // 문자열 "5"를 정수로 변환
                totalSum += Double(intValue) * value
                totalCount += value
            } else {
                print("Error: Cannot convert \(removedDot) to integer")
            }
        }
        
        average = totalSum / totalCount
        integerPart = Int(average)
        decimalPart = Int((average - Double(integerPart)) * 10)
        starCount = min(integerPart, 5)
        remainingStarCount = max(0, 5 - starCount)
    }


    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            switch tabState {
            // * 소개 탭
            case .info:
            //case .comments:
                ZStack (alignment: .top) {
                    ScrollView {
                        ZStack {
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color("content-secondary"), lineWidth: 2)
                            Text("시작\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n\n.\n.\n.\n.\n.\n.\n끝")
                                .font(.system(size: 16))
                                .padding()
                        }
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                    }
                } // ZStack

                
            // * 후기 탭
            case .comments:
            //case .info:
                ScrollView {
                    // * 후기 작성하기 버튼
                    HStack {
                        Spacer()
                        Text("후기 작성하기")
                            .underline()
                            .font(.system(size: 11))
                            .foregroundColor(Color("accent"))
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 15))
                            .onTapGesture {
                                isShowingPopup = true // 팝업창 표시
                            }
                    }
                    
                    // * 후기 평점 차트
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                AngularGradient(gradient: Gradient(colors: [Color.white, Color("gradationBlue")]), center: .topLeading, angle: .degrees(180 + 45))
                            )
                            .frame(width: .infinity, height: 150)
                            .padding(.horizontal)
                        
                        HStack {
                            // 별점 평균 수치 및 별 아이콘
                            VStack {
                                Text("\(integerPart).\(decimalPart)") // 평균 점수 표시
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

                            // 중앙 구분선
                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: 1, height: 90)
                                .foregroundColor(.white)

                            // 별점 항목별 수치
                            RatingBarChartView(ratings: ratings)
                        }
                    }
                    .padding(.bottom)
                    
                    ForEach(0..<5) { _ in
                        CommentCardView()
                    }
                    
                } // ScrollView
            }
        }
    }
}





#Preview {
    ClubPageView()
}
>>>>>>> 2387ab6ccd878b97a09a976648f05e182cc049a9
