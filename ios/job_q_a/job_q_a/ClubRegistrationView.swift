//import SwiftUI
//import Charts
//
//enum tapInfoForRegistration : String, CaseIterable {
//    case info = "소개"
//    case category = "카테고리"
//}
//
//
//struct ClubRegistrationView: View {
//    
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//    @State private var selectedPicker: tapInfoForRegistration = .info
//    @EnvironmentObject var accesstokenStored: UserAccessToken
//    @Namespace private var animation
//    
//    @State private var isShowingPopup = false
//    @State private var isEditing = true
//    @State var presentSheet: Bool = false
//    
//    
//    // 수정 가능한 동아리 이름과 소개 텍스트를 위한 상태 변수 추가
//    @State private var clubName = "동아리 이름 입력하기 . . ."
//    @State private var clubDescription = "동아리를 소개하세요 . . ."
//    @State private var clubApplication: String = ""
//    @State private var clubCategoryIndex: Int = 0 // 카테고리 선택 인덱스
//    
//    // 갤러리를 불러오기 위한 변수
//    @State private var initialImage = UIImage(named: "galleryImg")! // 초기 이미지
//    @State private var openPhoto = false
//    @State private var image = UIImage()
//    @State private var isChangedNo = false
//    
//    
//    @ViewBuilder // 뷰 생성시 전달받은 함수를 통해 하나 이상의 자식 뷰를 만드는데 사용
//    private func animate() -> some View {
//        HStack {
//            ForEach(tapInfoForRegistration.allCases, id: \.self) { item in
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
//    // 이미지 크기 조정 함수
//    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
//        let size = image.size
//
//        let widthRatio  = targetSize.width  / size.width
//        let heightRatio = targetSize.height / size.height
//
//        var newSize: CGSize
//        if(widthRatio > heightRatio) {
//            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
//        } else {
//            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
//        }
//        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
//        image.draw(in: CGRect(origin: .zero, size: newSize))
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        return newImage!
//    }
//
//    // 동아리 생성 API
////    private func createClub() {
////        let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 1024, height: 1024))
////        
////        guard let profileImageData = resizedImage.jpegData(compressionQuality: 0.8) else {
////            print("프로필 이미지 변환 실패")
////            return
////        }
////
////        let request = CreateClubRequest(
////            name: clubName,
////            oneLiner: clubDescription,
////            introduction: clubDescription,
////            application: clubApplication,
////            category: clubCategoryIndex,
////            isRecruit: true,
////            recruitStartDate: "2024-01-01",
////            recruitEndDate: "2024-01-10"
////        )
////
////        NetworkManager.createClub(request: request, profileImage: profileImageData, images: nil, accessToken: accesstokenStored.accessTokenStored) { result in
////            switch result {
////            case .success(let response):
////                print("클럽 생성 성공: \(response)")
////            case .failure(let error):
////                print("리퀘스트: \(request)")
////                print("클럽 생성 실패: \(error.localizedDescription)")
////            }
////        }
////    }
//
//
//    
//    
//
//    // * 화면을 구성하는 View 코드 부분
//    var body: some View {
//        NavigationView {
//            ZStack {
//                VStack {
//                    // * 뒤로가기 버튼
//                    Button(action:{
//                        self.presentationMode.wrappedValue.dismiss()}) {
//                            HStack(spacing:2) {
//                                Image(systemName: "chevron.backward")
//                                Spacer()
//                            }
//                            .foregroundColor(.black)
//                            .padding(EdgeInsets(top: 20, leading: 25, bottom: 10, trailing: 0))
//                        }
//                    
//                    ScrollView {
//                        ZStack (alignment: .bottom) {
//                            // * 동아리 이미지
//                            Button(action:{
//                                self.openPhoto = true}) {
//                                    HStack {
//                                        Image(uiImage: image == UIImage() ? initialImage : image) // 선택된 이미지 또는 초기 이미지 표시
//                                            .resizable()
//                                            .scaledToFill()
//                                            .frame(height: 220)
//                                            .clipShape(RoundedRectangle(cornerRadius: 20))
//                                            .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
//                                    }
//                                    .sheet(isPresented: $openPhoto) {
//                                        ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image, isImageChanged: $isChangedNo)
//                                    }
//                                }
//                            
//                            ZStack {
//                                RoundedRectangle(cornerRadius: 10)
//                                    .frame(height: 70)
//                                    .padding(EdgeInsets(top: 0, leading: 35, bottom: 20, trailing: 35))
//                                    .foregroundColor(Color.white)
//                                
//                                // * 동아리 이름 및 한 줄 소개
//                                VStack (spacing:5) {
//                                    if isEditing {
//                                        HStack {
//                                            TextField("동아리 이름", text: $clubName)
//                                                .frame(width: 250)
//                                                .font(.system(size: 14))
//                                                .bold()
//                                                .overlay(
//                                                    Rectangle()
//                                                        .stroke(Color.gray, lineWidth: 1)
//                                                )
//                                            Spacer()
//                                            Text("등록 완료")
//                                                .underline()
//                                                .font(.system(size: 12))
//                                                .foregroundColor(Color("secondary_"))
//                                                .padding(.trailing)
//                                                .onTapGesture {
//                                                    isEditing = false
//                                                    self.presentSheet.toggle()
//                                                    //createClub()
//                                                }
//                                        }
//                                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
//                                        
//                                        HStack {
//                                            TextField("한 줄 소개", text: $clubDescription)
//                                                .frame(width: 250)
//                                                .font(.system(size: 12))
//                                                .foregroundColor(Color("secondary_"))
//                                                .overlay(
//                                                    Rectangle()
//                                                        .stroke(Color.gray, lineWidth: 1)
//                                                )
//                                            Spacer()
//                                        }
//                                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
//                                    }
//                                    else {
//                                        HStack {
//                                            Text(clubName)
//                                                .font(.system(size: 14))
//                                                .bold()
//                                            Spacer()
//                                            Text("편집")
//                                                .underline()
//                                                .font(.system(size: 12))
//                                                .foregroundColor(Color("secondary_"))
//                                                .padding(.trailing)
//                                                .onTapGesture {
//                                                    isEditing = true
//                                                }
//                                        }
//                                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
//                                        
//                                        HStack {
//                                            Text(clubDescription)
//                                                .font(.system(size: 12))
//                                                .foregroundColor(Color("secondary_"))
//                                            Spacer()
//                                        }
//                                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
//                                    }
//                                } // VStack
//                                .padding(EdgeInsets(top: 0, leading: 35, bottom: 20, trailing: 35))
//                                
//                            } // ZStack
//                            .frame(height: 100)
//                        } // ZStack
//                        .frame(height: 220)
//                        
//                        
//                        ZStack(alignment: .top) {
//                            // * 탭 배경
//                            RoundedRectangle(cornerRadius: 30)
//                                .foregroundColor(.white)
//                                .frame(width: UIScreen.main.bounds.width) // 화면 너비와 일치하도록 설정
//                                .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: -5)
//                            // * 탭
//                            VStack {
//                                animate()
//                                InfoAndCategoryEditForRegistration(tabState: selectedPicker, isEditing: $isEditing, clubCategoryIndex: $clubCategoryIndex)
//                            }
//                        }
//                    } // ScrollView
//                } // VStack
//                .overlay(
//                    Group {
//                        if isShowingPopup {
//                            Color.black.opacity(0.4)
//                                .edgesIgnoringSafeArea(.all)
//                            EditApplicationPopupView(clubApplication: $clubApplication, isShowingPopup: $isShowingPopup)
//                                .frame(width: 350, height: 350)
//                                .background(Color.white)
//                                .cornerRadius(20)
//                                .overlay(
//                                    // 닫기 버튼
//                                    Button(action: {
//                                        withAnimation {
//                                            isShowingPopup = false
//                                        }
//                                    }) {
//                                        Image(systemName: "xmark")
//                                            .resizable()
//                                            .frame(width: 15, height: 15)
//                                            .foregroundColor(.black)
//                                            .padding(20)
//                                    }
//                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
//                                )
//                        }
//                    }
//                ) // overlay
//                
//                // 지원서 링크 등록 버튼
//                if selectedPicker == .info {
//                    VStack {
//                        Spacer()
//                        ZStack {
//                            RoundedRectangle(cornerRadius: 100)
//                                .foregroundColor(Color("accent"))
//                                .frame(width: 230, height: 50)
//                            
//                            Text("지원서 링크 등록하기")
//                                .font(.system(size: 15))
//                                .bold()
//                                .foregroundColor(.white)
//                                .onTapGesture {
//                                    isShowingPopup = true 
//                                }
//                        }
//                        .padding(10)
//                    }
//                }
//            } //ZStack
//            .sheet(isPresented: self.$presentSheet) {
//                CompleteRegistrationBottomSheetView()
//            }
//        } // NavigationView
//        .navigationBarBackButtonHidden() // 뒤로가기 버튼 숨기기
//    } // body
//    
//    
//}
//
//
//
//// Picker를 클릭했을때 그 Picker에 맞는 뷰 띄우기
//struct InfoAndCategoryEditForRegistration : View {
//    
//    var tabState : tapInfoForRegistration
//    
//    @State private var clubInfo = "Text field\n.\n.\n."
//    @State var clubCategoryString: String? = "카테고리"
//    @Binding var clubCategoryIndex: Int
//    
//    // 편집 상태를 제어하는 바인딩 변수 추가
//    @Binding var isEditing: Bool
//  
//    init(tabState: tapInfoForRegistration, isEditing: Binding<Bool>, clubCategoryIndex: Binding<Int>) {
//        self.tabState = tabState
//        self._isEditing = isEditing
//        self._clubCategoryIndex = clubCategoryIndex
//    }
//
//
//    var body: some View {
//        ScrollView(.vertical, showsIndicators: false) {
//            switch tabState {
//            // * 소개 탭
//            case .info:
//                ZStack (alignment: .top) {
//                        ZStack {
//                            RoundedRectangle(cornerRadius: 6)
//                                .stroke(Color("content-secondary"), lineWidth: 2)
//                            if !isEditing {
//                                Text(clubInfo) // 수정 불가능한 동아리 정보
//                                    .font(.system(size: 16))
//                                    .padding()
//                            } else {
//                                TextEditor(text: $clubInfo) // 수정 가능한 동아리 정보
//                                    .font(.system(size: 16))
//                                    .padding()
//                            }
//                        }
//                        .padding(EdgeInsets(top: 10, leading: 25, bottom: 0, trailing: 25))
//                } // ZStack
//
//                
//            // * 카테고리 탭
//            case .category:
//                VStack {
//                    HStack {
//                        Text("카테고리")
//                            .font(.system(size: 15))
//                            .foregroundColor(Color("tertiary"))
//                            .bold()
//                        Spacer()
//                    }
//                    .padding(EdgeInsets(top: 20, leading: 40, bottom: 10, trailing: 0))
//                    
//                    CustomDropDownPicker(
//                        selection: $clubCategoryString,
//                        selectedIndex: $clubCategoryIndex,
//                        options: ["IT/데이터", "사진/촬영", "인문학/독서", "여행", "스포츠", "문화/예술", "언어/외국어", "음악/악기", "댄스", "봉사활동", "기타"]
//                    )
//                    .padding(.horizontal, 20)
//                    .frame(width: UIScreen.main.bounds.width, height: 480)
//                    
//                } // ScrollView
//            }
//        }
//    }
//}
//
//
//struct CompleteRegistrationBottomSheetView: View {
//    
//    @State private var goToNextView = false // 다음 화면으로 이동하는 상태 변수
//    
//    var body: some View {
//        VStack {
//            Image(systemName: "checkmark.circle.fill")
//                .resizable()
//                .frame(width: 100, height: 100)
//                .foregroundColor(Color("accent"))
//                
//                
//            Text("동아리 등록이 완료되었어요.")
//                .font(.system(size: 28))
//                .bold()
//                .padding(.top, 30)
//                
//            Text("승인까지 3~5일이 소요될 수 있어요.")
//                .font(.system(size: 16))
//                .foregroundColor(Color("secondary_"))
//                .padding(EdgeInsets(top: 10, leading: 0, bottom: 50, trailing: 0))
//                
//            Button(action: {
//                self.goToNextView = true // 다음 화면으로 이동하는 상태 변경
//            }) {
//                ZStack {
//                    RoundedRectangle (cornerRadius: 10)
//                        .stroke(Color("accent"), lineWidth: 1)
//                        .frame(width: 200, height: 50)
//                    Text("홈으로 돌아가기")
//                        .font(.system(size: 14))
//                        .foregroundColor(.black)
//                        .bold()
//                }
//            }
//            .fullScreenCover(isPresented: $goToNextView) {
//                MainTabView() // 전체 화면으로 새로운 뷰로 전환
//            }
//            Spacer()
//        }
//        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//        .padding(.top, 450)
//        .background(Color.white)
//        .cornerRadius(30)
//    }
//}
//
