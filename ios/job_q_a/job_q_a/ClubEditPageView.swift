import SwiftUI

struct ClubEditPageView: View {
    
    var clubID: Int
    var onEdit: () -> Void
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var accesstokenStored: _UserAccessToken
    @State private var clubDetail: ClubDetailResponse?
    @State private var clubs: [Club] = []
    @State private var error: Error?
    @State var presentSheet: Bool = false
    
    // 동아리 상세 정보 저장 변수
    @State private var clubName = ""
    @State private var clubDescription = ""
    @State private var clubIntroduction = ""
    @State private var clubProfile = ""
    @State private var clubApplication = ""
    @State private var clubCategory: Int = 0
    @State private var clubStatus = ""
    @State private var clubIsRecruit: Bool = false
    @State private var clubImages: [UIImage] = []
    @State private var clubImageUrls: [String] = []
    @State private var addedImages: [UIImage] = []
    @State private var clubdocDeadLine = ""
    @State private var clubdocResultDate = ""
    @State private var clubinterviewStartDate = ""
    @State private var clubinterviewEndDate = ""
    @State private var clubfinalResultDate = ""
    
    @State var isRecruit: String = "모집 중"
    @State var int_isRecruit: Int = 0
    @State var bool_isRecruit: Bool = true
    
    // 날짜 선택 저장 변수
    @State private var selectedDateForDocumentSubmission: Date = Date()
    @State private var showDatePickerForDocumentSubmission: Bool = false
    @State private var selectedDateForDocumentResult: Date = Date()
    @State private var showDatePickerForDocumentResult: Bool = false
    @State private var selectedDateForInterviewStart: Date = Date()
    @State private var showDatePickerForInterviewStart: Bool = false
    @State private var selectedDateForInterviewEnd: Date = Date()
    @State private var showDatePickerForInterviewEnd: Bool = false
    @State private var selectedDateForFinalResult: Date = Date()
    @State private var showDatePickerForFinalResult: Bool = false
    
    @State private var beforeSelectDateForDocumentSubmission: Bool = false
    @State private var beforeSelectDateForDocumentResult: Bool = false
    @State private var beforeSelectDateForInterviewStart: Bool = false
    @State private var beforeSelectDateForInterviewEnd: Bool = false
    @State private var beforeSelectDateForFinalResult: Bool = false
    
    @State private var showDateErrorForDocumentSubmission = false
    @State private var showDateErrorForDocumentResult = false
    @State private var showDateErrorForInterviewStart = false
    @State private var showDateErrorForInterviewEnd = false
    @State private var showDateErrorForFinalResult = false
    
    @State private var noneLink: Bool = false
    @State private var noneInterview: Bool = false
    
    let interests = ["IT/데이터", "사진/촬영", "인문학/독서", "여행", "스포츠", "문화/예술", "언어/외국어", "음악/악기", "댄스", "봉사활동", "기타"]
    
    // 갤러리를 불러오기 위한 변수
    @State private var openPhoto = false
    @State private var image = UIImage()
    @State private var isChanged = false
    @State private var imageForIntroduction = UIImage()
    @State private var isChangedForIntroduction = false
    @State private var deletedImages: [String] = []
    
    // 갤러리에서 이미지 선택 및 추가하는 함수
    private func addDescriptionImage() {
        if clubImages.count < 10 {
            clubImages.append(imageForIntroduction)
            addedImages.append(imageForIntroduction)
            clubImageUrls.append("\(imageForIntroduction)")
        }
    }
    
    @State private var openDescriptionPhoto = false
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd-HH:mm"
        return formatter
    }
    
    // 이미지 크기 조정 함수
    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    // 동아리 상세 조회
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
                    self.clubImages = clubDetail.images.map { UIImage(data: try! Data(contentsOf: URL(string: $0.imageUrl)!))! }
                    self.clubImageUrls = clubDetail.images.map { $0.imageUrl }
                    self.clubdocDeadLine = clubDetail.docDeadLine ?? ""
                    self.clubdocResultDate = clubDetail.docResultDate ?? ""
                    self.clubinterviewStartDate = clubDetail.interviewStartDate ?? ""
                    self.clubinterviewEndDate = clubDetail.interviewEndDate ?? ""
                    self.clubfinalResultDate = clubDetail.finalResultDate ?? ""
                    
                }
                
                if clubIsRecruit {
                    int_isRecruit = 0
                    isRecruit = "모집 중"
                } else {
                    int_isRecruit = 1
                    isRecruit = "모집 예정"
                }
                
                print("\n동아리 상세 정보: \(clubDetailResponse)\n")
            case .failure(let error):
                self.error = error
                print("동아리 상세 정보 가져오기 에러: \(error)")
            }
        }
    }
    
    // 동아리 수정
    private func updateClubInfo() {
        
        // 올바른 날짜 기입 필요
        if showDateErrorForDocumentSubmission || showDateErrorForDocumentResult || showDateErrorForInterviewStart || showDateErrorForInterviewEnd || showDateErrorForFinalResult {
            return
        }
        
        var profileImageData: Data?
        
        if isChanged {
            // 선택된 이미지를 보내기 위해 데이터를 설정
            let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 1024, height: 1024))
            profileImageData = resizedImage.jpegData(compressionQuality: 0.8)
        } else {
            // 기존 이미지를 보내기 위해 URL을 문자열로 설정
            if let url = URL(string: clubProfile), let imageData = try? Data(contentsOf: url) {
                profileImageData = imageData
            }
        }
        
        var imagesData: [Data] = []
        for img in addedImages {
            let resizedImg = resizeImage(image: img, targetSize: CGSize(width: 1024, height: 1024))
            if let imgData = resizedImg.jpegData(compressionQuality: 0.8) {
                imagesData.append(imgData)
            }
        }
        
        // 동아리 지원서 링크 설정
        let applicationLink = noneLink ? "" : clubApplication
        
        // 날짜 포맷터 설정
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd-HH:mm"
        
        // 모집 여부에 따른 날짜 값 설정
        let docDeadLine = isRecruit == "모집 예정" ? nil : dateFormatter.string(from: selectedDateForDocumentSubmission)
        let docResultDate = isRecruit == "모집 예정" ? nil : dateFormatter.string(from: selectedDateForDocumentResult)
        let interviewStartDate = isRecruit == "모집 예정" ? nil : (noneInterview ? nil : dateFormatter.string(from: selectedDateForInterviewStart))
        let interviewEndDate = isRecruit == "모집 예정" ? nil : (noneInterview ? nil : dateFormatter.string(from: selectedDateForInterviewEnd))
        let finalResultDate = isRecruit == "모집 예정" ? nil : dateFormatter.string(from: selectedDateForFinalResult)
        
        // 클럽 콘텐츠 데이터를 설정
        let clubContent = ClubContent (
            clubId: clubID,
            name: clubName,
            oneLiner: clubDescription,
            introduction: clubIntroduction,
            profile: profileImageData,
            images: imagesData,
            application: applicationLink,
            deletedImages: deletedImages.isEmpty ? nil : deletedImages,
            category: clubCategory,
            status: clubStatus,
            isRecruit: clubIsRecruit,
            isOnlyStudent: true,
            docDeadLine: docDeadLine ?? nil,
            docResultDate: docResultDate ?? nil,
            interviewStartDate: interviewStartDate ?? nil,
            interviewEndDate: interviewEndDate ?? nil,
            finalResultDate: finalResultDate ?? nil
        )
        
        print("삭제할 이미지 ID 목록: \(deletedImages)")
        
        
        print("clubId: \(clubID)")
            print("name: \(clubName)")
            print("oneLiner: \(clubDescription)")
            print("introduction: \(clubIntroduction)")
            print("profile: \(clubProfile)")
            print("images: \(imagesData.count) files")
            print("application: \(applicationLink)")
            print("deletedImages: \(deletedImages)")
            print("category: \(clubCategory)")
            print("status: \(clubStatus)")
            print("isRecruit: \(clubIsRecruit)")
            print("docDeadLine: \(String(describing: docDeadLine))")
            print("docResultDate: \(String(describing: docResultDate))")
            print("interviewStartDate: \(String(describing: interviewStartDate))")
            print("interviewEndDate: \(String(describing: interviewEndDate))")
            print("finalResultDate: \(String(describing: finalResultDate))")
        
        // 동아리 정보를 PATCH 요청으로 서버에 전송
        NetworkManager.editClub(clubId: clubID, content: clubContent, accessToken: _UserAccessToken.shared.accessTokenStored) { result in
            switch result {
            case .success(let data):
                print("동아리 수정 성공: \(data)")
                self.presentSheet = true
                fetchClubDetail()
                onEdit()
            case .failure(let error):
                print("동아리 수정 실패: \(error)")
                print(clubContent)
                self.presentSheet = false
            }
        }
    }
    
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Button(action:{
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack{
                            Image(systemName: "chevron.backward")
                            Spacer()
                        }
                        .foregroundColor(.black)
                    }
                    
                    Text("동아리 정보 수정")
                        .font(.system(size: 18))
                        .bold()
                    
                }
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
                .navigationBarBackButtonHidden()
                
                ScrollView {
                    VStack {
                        // * 동아리명 입력
                        HStack {
                            Text("동아리명")
                                .font(.system(size: 13))
                                .foregroundColor(Color("tertiary"))
                                .bold()
                            Spacer()
                        }
                        .padding(EdgeInsets(top: 30, leading: 20, bottom: 10, trailing: 0))
                        
                        
                        ZStack (alignment: .leading) {
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color("content-secondary"), lineWidth: 1)
                            TextField("\(clubName)", text: $clubName)
                                .padding(10)
                                .foregroundColor(Color("secondary_"))
                                .font(.system(size: 15))
                        }
                        .padding(.horizontal, 20)
                        .frame(width: UIScreen.main.bounds.width, height: 50)
                        
                        
                        // * 동아리 대표 사진
                        HStack {
                            Text("동아리 대표 사진")
                                .font(.system(size: 13))
                                .foregroundColor(Color("tertiary"))
                                .bold()
                            Spacer()
                        }
                        .padding(EdgeInsets(top: 30, leading: 20, bottom: 10, trailing: 0))
                        
                        HStack(spacing: 10) {
                            Button(action: {
                                openPhoto = true
                            }) {
                                ZStack(alignment: .center) {
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color("content-secondary"), lineWidth: 1)
                                        .frame(width: 68, height: 68)
                                    
                                    VStack {
                                        Image(systemName: "camera")
                                            .resizable()
                                            .frame(width: 23, height: 19)
                                            .foregroundColor(Color("content-secondary"))
                                        
                                        if isChanged {
                                            Text("1/1")
                                                .font(.system(size: 12))
                                                .foregroundColor(Color("content-secondary"))
                                        } else {
                                            Text("0/1")
                                                .font(.system(size: 12))
                                                .foregroundColor(Color("content-secondary"))
                                        }
                                    }
                                }
                                .frame(width: 68, height: 68)
                                .sheet(isPresented: $openPhoto) {
                                    ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image, isImageChanged: $isChanged)
                                }
                            }
                            
                            if isChanged {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 68, height: 68)
                                    .clipped()
                                    .cornerRadius(6)
                            } else {
                                AsyncImage(url: URL(string: clubProfile)) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 68, height: 68)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    case .failure:
                                        Image(systemName: "xmark.circle")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 68, height: 68)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        
                        
                        // * 동아리명 소개
                        HStack {
                            Text("동아리 소개")
                                .font(.system(size: 13))
                                .foregroundColor(Color("tertiary"))
                                .bold()
                            Spacer()
                        }
                        .padding(EdgeInsets(top: 30, leading: 20, bottom: 10, trailing: 0))
                        
                        
                        ZStack (alignment: .leading) {
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color("content-secondary"), lineWidth: 1)
                            TextField("\(clubDescription)", text: $clubDescription)
                                .padding(10)
                                .foregroundColor(Color("secondary_"))
                                .font(.system(size: 15))
                        }
                        .padding(.horizontal, 20)
                        .frame(width: UIScreen.main.bounds.width, height: 50)
                        
                        
                        // * 동아리 설명
                        HStack {
                            Text("자세한 설명")
                                .font(.system(size: 13))
                                .foregroundColor(Color("tertiary"))
                                .bold()
                            Spacer()
                        }
                        .padding(EdgeInsets(top: 30, leading: 20, bottom: 10, trailing: 0))
                        
                        
                        ZStack (alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color("content-secondary"), lineWidth: 1)
                            
                            TextEditor(text: $clubIntroduction)
                                .padding(5)
                                .foregroundColor(.black)
                                .font(.system(size: 12))
                                .frame(height: 175, alignment: .topLeading)
                        }
                        .padding(.horizontal, 20)
                        .frame(width: UIScreen.main.bounds.width,  height: 175, alignment: .topLeading)
                        
                        
                        // 자세한 설명 이미지 등록
                        ScrollView (.horizontal) {
                            HStack {
                                
                                // 이미지 등록 버튼
                                Button(action:{
                                    self.openDescriptionPhoto = true
                                }) {
                                    ZStack (alignment: .center) {
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(Color("content-secondary"), lineWidth: 1)
                                            .frame(width: 68, height: 68)
                                        
                                        VStack {
                                            Image(systemName: "camera")
                                                .resizable()
                                                .frame(width: 23, height: 19)
                                                .foregroundColor(Color("content-secondary"))
                                            Text("\(clubImages.count)/10")
                                                .font(.system(size: 12))
                                                .foregroundColor(Color("content-secondary"))
                                        }
                                    }
                                    .frame(width: 68, height: 68)
                                    .sheet(isPresented: $openDescriptionPhoto, onDismiss: { if isChangedForIntroduction {
                                        addDescriptionImage()
                                    }
                                    }) {
                                        ImagePicker(sourceType: .photoLibrary, selectedImage: self.$imageForIntroduction, isImageChanged: $isChangedForIntroduction)
                                    }
                                }
                                
                                // 기존 이미지들
                                ForEach(clubImages.indices, id: \.self) { index in
                                    ZStack(alignment: .topTrailing) {
                                        Image(uiImage: clubImages[index])
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 68, height: 68)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .padding(2)
                                        
                                        Button(action: {
                                            print("인덱스: \(index)")
                                            
                                            if addedImages.contains(clubImages[index]) {
                                                if let addedIndex = addedImages.firstIndex(of: clubImages[index]) {
                                                    addedImages.remove(at: addedIndex)
                                                }
                                            } else { // 기존 이미지 리스트에서 삭제
                                                deletedImages.append(clubImageUrls[index])
                                                print("삭제할 이미지 URL 추가됨: \(clubImageUrls[index])")
                                                clubImageUrls.remove(at: index)
                                            }
                                            clubImages.remove(at: index) // 이미지 리스트에서 삭제
                                            
                                        }) {
                                            Image(systemName: "x.circle.fill")
                                                .resizable()
                                                .frame(width: 15, height: 15)
                                                .foregroundColor(.gray)
                                                .background(Color.white)
                                                .clipShape(Circle())
                                        }
                                        .offset(x: 5, y: -5)
                                    }
                                }
                                
                            }
                            .padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20))
                        }
                        
                        
                        // * 동아리 카테고리
                        HStack {
                            Text("카테고리")
                                .font(.system(size: 13))
                                .foregroundColor(Color("tertiary"))
                                .bold()
                            Spacer()
                        }
                        .padding(EdgeInsets(top: 30, leading: 20, bottom: 10, trailing: 0))
                        
                        
                        ZStack (alignment: .leading) {
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color("content-secondary"), lineWidth: 1)
                            Text("\(interests[clubCategory])")
                                .padding(10)
                                .foregroundColor(Color("secondary_"))
                                .font(.system(size: 15))
                        }
                        .padding(.horizontal, 20)
                        .frame(width: UIScreen.main.bounds.width, height: 50)
                        
                        
                        // * 동아리 모집여부
                        HStack {
                            Text("모집 여부")
                                .font(.system(size: 13))
                                .foregroundColor(Color("tertiary"))
                                .bold()
                            Spacer()
                        }
                        .padding(EdgeInsets(top: 30, leading: 20, bottom: 10, trailing: 0))
                        
                        CustomDropDownPickerForClub(
                            selection: $isRecruit,
                            selectedIndex: $int_isRecruit,
                            options: ["모집 중", "모집 예정"]
                        )
                        .padding(.horizontal, 20)
                        .frame(width: UIScreen.main.bounds.width, height: 100)
                        .onChange(of: isRecruit) { newValue in
                            self.clubIsRecruit = (newValue == "모집 중")
                        }
                        
                        
                        if isRecruit != "모집 예정" {
                            
                            // * 동아리 지원서 링크
                            HStack(spacing:5) {
                                Text("동아리 지원서 링크")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color("tertiary"))
                                    .bold()
                                Spacer()
                                
                                Button(action: {
                                    self.noneLink.toggle()
                                }) {
                                    if noneLink {
                                        ZStack {
                                            Image(systemName: "circle")
                                                .resizable()
                                                .frame(width: 10, height: 10)
                                                .foregroundColor(Color("secondary_"))
                                            Image(systemName: "circle.fill")
                                                .resizable()
                                                .frame(width: 6, height: 6)
                                                .foregroundColor(Color("secondary_"))
                                        }
                                    } else {
                                        Image(systemName: "circle")
                                            .resizable()
                                            .frame(width: 8, height: 8)
                                            .foregroundColor(Color("secondary_"))
                                    }
                                }
                                
                                Text("링크 없음")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color("secondary_"))
                            }
                            .padding(EdgeInsets(top: 30, leading: 20, bottom: 10, trailing: 20))
                            
                            ZStack (alignment: .leading) {
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color("content-secondary"), lineWidth: 1)
                                
                                if noneLink {
                                    Text("지원서 링크 없음")
                                        .padding(10)
                                        .foregroundColor(Color("gray-60"))
                                        .font(.system(size: 15))
                                } else {
                                    TextField("\(clubApplication)", text: $clubApplication)
                                        .padding(10)
                                        .foregroundColor(Color("secondary_"))
                                        .font(.system(size: 15))
                                }
                            }
                            .padding(.horizontal, 20)
                            .frame(width: UIScreen.main.bounds.width, height: 50)
                            
                            
                            // * 서류 접수
                            HStack {
                                Text("서류 접수 마감일")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color("tertiary"))
                                    .bold()
                                Spacer()
                            }
                            .padding(EdgeInsets(top: 30, leading: 20, bottom: 10, trailing: 0))
                            
                            
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color("content-secondary"), lineWidth: 1)
                                
                                HStack {
                                    if beforeSelectDateForDocumentSubmission {
                                        Text(selectedDateForDocumentSubmission, formatter: dateFormatter)
                                            .foregroundColor(Color("secondary_"))
                                            .padding(10)
                                            .font(.system(size: 15))
                                        Spacer()
                                    }
                                    else {
                                        Text(clubdocDeadLine)
                                            .foregroundColor(Color("secondary_"))
                                            .padding(10)
                                            .font(.system(size: 15))
                                        Spacer()
                                    }
                                }
                            }
                            .onTapGesture {
                                beforeSelectDateForDocumentSubmission = true
                                self.showDatePickerForDocumentSubmission.toggle()
                            }
                            .padding(.horizontal, 20)
                            .frame(width: UIScreen.main.bounds.width, height: 50)
                            .sheet(isPresented: $showDatePickerForDocumentSubmission) {
                                VStack {
                                    DatePicker("날짜와 시간을 선택해주세요.", selection: $selectedDateForDocumentSubmission, displayedComponents: [.date, .hourAndMinute])
                                        .datePickerStyle(GraphicalDatePickerStyle())
                                        .labelsHidden()
                                    Button("완료") {
                                        if selectedDateForDocumentSubmission <= Date() {
                                            self.showDatePickerForDocumentSubmission.toggle()
                                            self.showDateErrorForDocumentSubmission = true
                                        } else {
                                            self.showDatePickerForDocumentSubmission.toggle()
                                            self.showDateErrorForDocumentSubmission = false
                                        }
                                    }
                                    .padding()
                                }
                                .presentationDetents([.height(500)])
                            }
                            
                            HStack {
                                Spacer()
                                if showDateErrorForDocumentSubmission {
                                    Text("오늘 날짜를 기준으로 입력해주세요.")
                                        .foregroundColor(.red)
                                        .font(.system(size: 12))
                                        .padding(.horizontal, 20)
                                }
                            }
                            
                            // * 서류 결과 발표
                            HStack {
                                Text("서류 결과 발표일")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color("tertiary"))
                                    .bold()
                                Spacer()
                            }
                            .padding(EdgeInsets(top: 30, leading: 20, bottom: 10, trailing: 0))
                            
                            
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color("content-secondary"), lineWidth: 1)
                                
                                HStack {
                                    if beforeSelectDateForDocumentResult {
                                        Text(selectedDateForDocumentResult, formatter: dateFormatter)
                                            .foregroundColor(Color("secondary_"))
                                            .padding(10)
                                            .font(.system(size: 15))
                                        Spacer()
                                    }
                                    else {
                                        Text(clubdocResultDate)
                                            .foregroundColor(Color("secondary_"))
                                            .padding(10)
                                            .font(.system(size: 15))
                                        Spacer()
                                    }
                                }
                            }
                            .onTapGesture {
                                beforeSelectDateForDocumentResult = true
                                self.showDatePickerForDocumentResult.toggle()
                            }
                            .padding(.horizontal, 20)
                            .frame(width: UIScreen.main.bounds.width, height: 50)
                            .sheet(isPresented: $showDatePickerForDocumentResult) {
                                VStack {
                                    DatePicker("날짜와 시간을 선택해주세요.", selection: $selectedDateForDocumentResult, displayedComponents: [.date, .hourAndMinute])
                                        .datePickerStyle(GraphicalDatePickerStyle())
                                        .labelsHidden()
                                    Button("완료") {
                                        if selectedDateForDocumentResult <= selectedDateForDocumentSubmission {
                                            self.showDatePickerForDocumentResult.toggle()
                                            self.showDateErrorForDocumentResult = true
                                        } else {
                                            self.showDatePickerForDocumentResult.toggle()
                                            self.showDateErrorForDocumentResult = false
                                        }
                                    }
                                    .padding()
                                }
                                .presentationDetents([.height(500)])
                            }
                            
                            HStack {
                                Spacer()
                                if showDateErrorForDocumentResult {
                                    Text("잘못된 날짜 형식입니다.")
                                        .foregroundColor(.red)
                                        .font(.system(size: 12))
                                        .padding(.horizontal, 20)
                                }
                            }
                            
                            
                            // * 면접 일정 (시작일)
                            HStack(spacing:5) {
                                Text("면접 시작일")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color("tertiary"))
                                    .bold()
                                Spacer()
                                
                                Button(action: {
                                    noneInterview.toggle()
                                }) {
                                    if noneInterview {
                                        ZStack {
                                            Image(systemName: "circle")
                                                .resizable()
                                                .frame(width: 10, height: 10)
                                                .foregroundColor(Color("secondary_"))
                                            Image(systemName: "circle.fill")
                                                .resizable()
                                                .frame(width: 6, height: 6)
                                                .foregroundColor(Color("secondary_"))
                                        }
                                    } else {
                                        Image(systemName: "circle")
                                            .resizable()
                                            .frame(width: 8, height: 8)
                                            .foregroundColor(Color("secondary_"))
                                    }
                                }
                                
                                Text("면접 X")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color("secondary_"))
                            }
                            .padding(EdgeInsets(top: 30, leading: 20, bottom: 10, trailing: 20))
                            
                            
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color("content-secondary"), lineWidth: 1)
                                
                                if noneInterview {
                                    Text("면접 없음")
                                        .padding(10)
                                        .foregroundColor(Color("gray-60"))
                                        .font(.system(size: 15))
                                } else {
                                    HStack {
                                        if beforeSelectDateForInterviewStart {
                                            Text(selectedDateForInterviewStart, formatter: dateFormatter)
                                                .foregroundColor(Color("secondary_"))
                                                .padding(10)
                                                .font(.system(size: 15))
                                            Spacer()
                                        }
                                        else {
                                            Text(clubinterviewStartDate)
                                                .foregroundColor(Color("secondary_"))
                                                .padding(10)
                                                .font(.system(size: 15))
                                            
                                            Spacer()
                                        }
                                    }
                                }
                            }
                            .onTapGesture {
                                beforeSelectDateForInterviewStart = true
                                self.showDatePickerForInterviewStart.toggle()
                            }
                            .padding(.horizontal, 20)
                            .frame(width: UIScreen.main.bounds.width, height: 50)
                            .sheet(isPresented: $showDatePickerForInterviewStart) {
                                VStack {
                                    DatePicker("날짜와 시간을 선택해주세요.", selection: $selectedDateForInterviewStart, displayedComponents: [.date, .hourAndMinute])
                                        .datePickerStyle(GraphicalDatePickerStyle())
                                        .labelsHidden()
                                    Button("완료") {
                                        if selectedDateForInterviewStart <= selectedDateForDocumentResult {
                                            self.showDatePickerForInterviewStart.toggle()
                                            self.showDateErrorForInterviewStart = true
                                        } else {
                                            self.showDatePickerForInterviewStart.toggle()
                                            self.showDateErrorForInterviewStart = false
                                        }
                                    }
                                    .padding()
                                }
                                .presentationDetents([.height(500)])
                            }
                            
                            HStack {
                                Spacer()
                                if showDateErrorForInterviewStart {
                                    Text("잘못된 날짜 형식입니다.")
                                        .foregroundColor(.red)
                                        .font(.system(size: 12))
                                        .padding(.horizontal, 20)
                                }
                            }
                            
                            // * 면접 일정 (종료일)
                            HStack {
                                Text("면접 종료일")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color("tertiary"))
                                    .bold()
                                Spacer()
                            }
                            .padding(EdgeInsets(top: 30, leading: 20, bottom: 10, trailing: 0))
                            
                            
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color("content-secondary"), lineWidth: 1)
                                
                                if noneInterview {
                                    Text("면접 없음")
                                        .padding(10)
                                        .foregroundColor(Color("gray-60"))
                                        .font(.system(size: 15))
                                } else {
                                    HStack {
                                        if beforeSelectDateForInterviewEnd {
                                            Text(selectedDateForInterviewEnd, formatter: dateFormatter)
                                                .foregroundColor(Color("secondary_"))
                                                .padding(10)
                                                .font(.system(size: 15))
                                            
                                            Spacer()
                                        }
                                        else {
                                            Text(clubinterviewEndDate)
                                                .foregroundColor(Color("secondary_"))
                                                .padding(10)
                                                .font(.system(size: 15))
                                            
                                            Spacer()
                                        }
                                    }
                                }
                            }
                            .onTapGesture {
                                beforeSelectDateForInterviewEnd = true
                                self.showDatePickerForInterviewEnd.toggle()
                            }
                            .padding(.horizontal, 20)
                            .frame(width: UIScreen.main.bounds.width, height: 50)
                            .sheet(isPresented: $showDatePickerForInterviewEnd) {
                                VStack {
                                    DatePicker("날짜와 시간을 선택해주세요.", selection: $selectedDateForInterviewEnd, displayedComponents: [.date, .hourAndMinute])
                                        .datePickerStyle(GraphicalDatePickerStyle())
                                        .labelsHidden()
                                    Button("완료") {
                                        if selectedDateForInterviewEnd <= selectedDateForInterviewStart {
                                            self.showDatePickerForInterviewEnd.toggle()
                                            self.showDateErrorForInterviewEnd = true
                                        } else {
                                            self.showDatePickerForInterviewEnd.toggle()
                                            self.showDateErrorForInterviewEnd = false
                                        }
                                    }
                                    .padding()
                                }
                                .presentationDetents([.height(500)])
                            }
                            
                            HStack {
                                Spacer()
                                if showDateErrorForInterviewEnd {
                                    Text("잘못된 날짜 형식입니다.")
                                        .foregroundColor(.red)
                                        .font(.system(size: 12))
                                        .padding(.horizontal, 20)
                                }
                            }
                            
                            // * 최종 합격자 발표일
                            HStack {
                                Text("최종 합격 발표일")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color("tertiary"))
                                    .bold()
                                Spacer()
                            }
                            .padding(EdgeInsets(top: 30, leading: 20, bottom: 10, trailing: 0))
                            
                            
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color("content-secondary"), lineWidth: 1)
                                
                                HStack {
                                    if beforeSelectDateForFinalResult {
                                        Text(selectedDateForFinalResult, formatter: dateFormatter)
                                            .foregroundColor(Color("secondary_"))
                                            .padding(10)
                                            .font(.system(size: 15))
                                        Spacer()
                                    }
                                    else {
                                        Text(clubfinalResultDate)
                                            .foregroundColor(Color("secondary_"))
                                            .padding(10)
                                            .font(.system(size: 15))
                                        Spacer()
                                    }
                                }
                            }
                            .onTapGesture {
                                beforeSelectDateForFinalResult = true
                                self.showDatePickerForFinalResult.toggle()
                            }
                            .padding(.horizontal, 20)
                            .frame(width: UIScreen.main.bounds.width, height: 50)
                            .sheet(isPresented: $showDatePickerForFinalResult) {
                                VStack {
                                    DatePicker("날짜와 시간을 선택해주세요.", selection: $selectedDateForFinalResult, displayedComponents: [.date, .hourAndMinute])
                                        .datePickerStyle(GraphicalDatePickerStyle())
                                        .labelsHidden()
                                    Button("완료") {
                                        if noneInterview {
                                            if selectedDateForFinalResult <= selectedDateForDocumentResult {
                                                self.showDatePickerForFinalResult.toggle()
                                                self.showDateErrorForFinalResult = true
                                            } else {
                                                self.showDatePickerForFinalResult.toggle()
                                                self.showDateErrorForFinalResult = false
                                            }
                                        } else {
                                            if selectedDateForFinalResult <= selectedDateForInterviewEnd {
                                                self.showDatePickerForFinalResult.toggle()
                                                self.showDateErrorForFinalResult = true
                                            } else {
                                                self.showDatePickerForFinalResult.toggle()
                                                self.showDateErrorForFinalResult = false
                                            }
                                        }
                                    }
                                    .padding()
                                }
                                .presentationDetents([.height(500)])
                            }
                            HStack {
                                Spacer()
                                if showDateErrorForFinalResult {
                                    Text("잘못된 날짜 형식입니다.")
                                        .foregroundColor(.red)
                                        .font(.system(size: 12))
                                        .padding(.horizontal, 20)
                                }
                            }
                        }
                        // * 동아리 등록 버튼
                        Button(action: {
                            updateClubInfo()
                        }) {
                            ZStack {
                                RoundedRectangle (cornerRadius: 10)
                                    .foregroundColor(Color("primary_"))
                                
                                Text("완료")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color("secondary_"))
                                    .bold()
                            }
                            .padding(25)
                            .frame(width: UIScreen.main.bounds.width, height: 100)
                            
                        }
                    }
                }
            }
            .onAppear() {
                fetchClubDetail()
            }
            .sheet(isPresented: self.$presentSheet) {
                CompleteEditBottomSheetView()
                    .presentationDetents([.height(370), .large])
            }

        }
        .navigationBarBackButtonHidden()
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


struct CompleteEditBottomSheetView: View {
    
    @State private var goToNextView = false
    
    var body: some View {
        VStack {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(Color("accent"))
            
            
            Text("동아리 수정이 완료되었어요.")
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
