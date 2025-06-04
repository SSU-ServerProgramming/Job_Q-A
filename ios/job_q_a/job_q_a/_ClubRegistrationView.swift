import SwiftUI

struct ClubRegistrationView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var accesstokenStored: _UserAccessToken
    
    @State private var clubNameText: String = ""
    let clubNameWriteText = "동아리명을 입력해주세요."
    @State private var clubOneLinearText: String = ""
    let clubOneLinearWriteText = "동아리에 대해 한 줄로 소개해주세요."
    @State private var clubApplicationLinkText: String = ""
    let clubApplicationLinkWriteText = "지원서 링크를 입력해주세요.(예. 구글폼)"
    @State private var clubDescriptionText: String = ""
    let clubDescriptionWriteText = "동아리에 대한 설명을 입력해주세요."
    
    @State var category: String = "카테고리"
    @State var int_category: Int = 10
    
    @State var isRecruit: String = "모집 여부"
    @State var int_isRecruit: Int = 0
    @State var bool_isRecruit: Bool = true
    
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
    
    // 갤러리에서 이미지 선택 및 추가하는 함수
    private func addDescriptionImage() {
        if imagesForIntroduction.count < 10 {
            imagesForIntroduction.append(imageForIntroduction)
        }
    }
    
    // 갤러리, 이미지 관련 변수
    @State private var openPhoto = false
    @State private var image = UIImage()
    @State private var imageForIntroduction = UIImage()
    @State private var isChangedNo = false
    @State private var openDescriptionPhoto = false
    @State var presentSheet: Bool = false
    @State private var imagesForIntroduction: [UIImage] = []
    
    // 필수 입력 항목 확인 변수
    @State private var showValidationError = false
    
    // 날짜 포맷터
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
    
    // 동아리 생성 API
    private func createClub() {

        
        // 필수 입력 항목 체크
        if clubNameText.isEmpty || !isChangedNo || clubOneLinearText.isEmpty || clubDescriptionText.isEmpty || (!noneLink && clubApplicationLinkText.isEmpty) || clubDescriptionText.isEmpty || (!beforeSelectDateForDocumentSubmission && int_isRecruit == 0) || (!beforeSelectDateForDocumentResult && int_isRecruit == 0) ||
            (!beforeSelectDateForInterviewStart && int_isRecruit == 0 && !noneInterview) ||
            (!beforeSelectDateForInterviewEnd && int_isRecruit == 0 && !noneInterview) ||
            (!beforeSelectDateForFinalResult && int_isRecruit == 0) {
            print(clubNameText, isChangedNo, clubOneLinearText, clubDescriptionText)
            showValidationError = true
            return
        }
        

        if showDateErrorForDocumentSubmission || showDateErrorForDocumentResult || showDateErrorForInterviewStart || showDateErrorForInterviewEnd || showDateErrorForFinalResult {
            return
        }
        
        let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 1024, height: 1024))
        
        guard let profileImageData = resizedImage.jpegData(compressionQuality: 0.8) else {
            print("프로필 이미지 변환 실패")
            return
        }

        var imagesData: [Data] = []
        for img in imagesForIntroduction {
            let resizedImg = resizeImage(image: img, targetSize: CGSize(width: 1024, height: 1024))
            if let imgData = resizedImg.jpegData(compressionQuality: 0.8) {
                imagesData.append(imgData)
            }
        }

        // 날짜 포맷터 설정
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd-HH:mm"
        
        if int_isRecruit == 0 {
            bool_isRecruit = true
        } else {
            bool_isRecruit = false
        }
        

        let request = CreateClubRequest(
            name: clubNameText,
            oneLiner: clubOneLinearText,
            introduction: clubDescriptionText,
            application: clubApplicationLinkText,
            category: int_category,
            isRecruit: bool_isRecruit,
            isOnlyStudent: true,
            docDeadLine: dateFormatter.string(from: selectedDateForDocumentSubmission),
            docResultDate: dateFormatter.string(from: selectedDateForDocumentResult),
            interviewStartDate: dateFormatter.string(from: selectedDateForInterviewStart),
            interviewEndDate: dateFormatter.string(from: selectedDateForInterviewEnd),
            finalResultDate: dateFormatter.string(from: selectedDateForFinalResult)
        )
        
        NetworkManager.createClub(request: request, profileImage: profileImageData, images: imagesData, accessToken: _UserAccessToken.shared.accessTokenStored) { result in
            switch result {
            case .success(let response):
                print("클럽 생성 성공: \(response)")
                self.presentSheet.toggle()
            case .failure(let error):
                print("리퀘스트: \(request)")
                print("클럽 생성 실패: \(error.localizedDescription)")
                // 에러의 전체 내용을 출력
                print("전체 에러 정보: \(error)")
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
                    
                    Text("동아리 등록")
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
                            TextEditor(text: $clubNameText)
                                .padding(10)
                                .foregroundColor(Color("secondary_"))
                                .font(.system(size: 15))
                            
                            if clubNameText.isEmpty {
                                Text(clubNameWriteText)
                                    .foregroundColor(Color("secondary_"))
                                    .padding(10)
                                    .font(.system(size: 15))
                            }
                        }
                        .padding(.horizontal, 20)
                        .frame(width: UIScreen.main.bounds.width, height: 50)
                        
                        HStack {
                            Spacer()
                            if showValidationError && clubNameText.isEmpty {
                                Text("필수 입력 항목입니다.")
                                    .foregroundColor(.red)
                                    .font(.system(size: 12))
                                    .padding(.horizontal, 20)
                            }
                        }
                        
                        // * 동아리 대표 사진
                        HStack {
                            Text("동아리 대표 사진")
                                .font(.system(size: 13))
                                .foregroundColor(Color("tertiary"))
                                .bold()
                            Spacer()
                        }
                        .padding(EdgeInsets(top: 30, leading: 20, bottom: 10, trailing: 0))
                        
                        HStack (spacing:10) {
                            
                            Button(action:{
                                self.openPhoto = true
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
                                        
                                        if isChangedNo {
                                            Text("1/1")
                                                .font(.system(size: 12))
                                                .foregroundColor(Color("content-secondary"))
                                        }
                                        else {
                                            Text("0/1")
                                                .font(.system(size: 12))
                                                .foregroundColor(Color("content-secondary"))
                                        }
                                    }
                                }
                                .frame(width: 68, height: 68)
                                .sheet(isPresented: $openPhoto) {
                                    ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image, isImageChanged: $isChangedNo)
                                }
                            }
                            
                            if isChangedNo {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 68, height: 68)
                                    .clipped()
                                    .cornerRadius(6)
                            } else {
                                ZStack (alignment: .topTrailing) {
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color("content-secondary"), lineWidth: 1)
                                        .frame(width: 68, height: 68)
                                }
                                .frame(width: 68, height: 68)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        
                        HStack {
                            Spacer()
                            if showValidationError && !isChangedNo {
                                Text("필수 입력 항목입니다.")
                                    .foregroundColor(.red)
                                    .font(.system(size: 12))
                                    .padding(.horizontal, 20)
                            }
                        }
                        
                        
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
                            TextEditor(text: $clubOneLinearText)
                                .padding(10)
                                .foregroundColor(Color("secondary_"))
                                .font(.system(size: 15))
                            
                            if clubOneLinearText.isEmpty {
                                Text(clubOneLinearWriteText)
                                    .foregroundColor(Color("secondary_"))
                                    .padding(10)
                                    .font(.system(size: 15))
                            }
                        }
                        .padding(.horizontal, 20)
                        .frame(width: UIScreen.main.bounds.width, height: 50)
                        
                        HStack {
                            Spacer()
                            if showValidationError && clubOneLinearText.isEmpty {
                                Text("필수 입력 항목입니다.")
                                    .foregroundColor(.red)
                                    .font(.system(size: 12))
                                    .padding(.horizontal, 20)
                            }
                        }
                        
                        
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
                                .padding(.horizontal, 20)
                                .frame(width: UIScreen.main.bounds.width, height: 185, alignment: .topLeading)
                            
                            TextEditor(text: $clubDescriptionText)
                                .padding(10)
                                .foregroundColor(Color("secondary_"))
                                .font(.system(size: 15))
                                .padding(.horizontal, 20)
                                .frame(width: UIScreen.main.bounds.width, height: 185, alignment: .topLeading)
                            
                            if clubDescriptionText.isEmpty {
                                Text("\(clubDescriptionWriteText)")
                                    .foregroundColor(Color("secondary_"))
                                    .padding(13)
                                    .font(.system(size: 15))
                                    .padding(.horizontal, 20)
                                    .frame(width: UIScreen.main.bounds.width, height: 185, alignment: .topLeading)
                            }
                            
                        }
                        
                        HStack {
                            Spacer()
                            if showValidationError && clubDescriptionText.isEmpty {
                                Text("필수 입력 항목입니다.")
                                    .foregroundColor(.red)
                                    .font(.system(size: 12))
                                    .padding(.horizontal, 20)
                            }
                        }
                        
                        // 자세한 설명 이미지 등록
                        ScrollView (.horizontal) {
                            HStack (spacing:10) {
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
                                            Text("\(imagesForIntroduction.count)/10")
                                                .font(.system(size: 12))
                                                .foregroundColor(Color("content-secondary"))
                                        }
                                    }
                                    .frame(width: 68, height: 68)
                                    .sheet(isPresented: $openDescriptionPhoto, onDismiss: {
                                        if isChangedNo {
                                            addDescriptionImage()
                                        }
                                    }) {
                                        ImagePicker(sourceType: .photoLibrary, selectedImage: self.$imageForIntroduction, isImageChanged: $isChangedNo)
                                    }
                                }
                                
                                ForEach(imagesForIntroduction.indices, id: \.self) { index in
                                    ZStack(alignment: .topTrailing) {
                                        Image(uiImage: imagesForIntroduction[index])
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 68, height: 68)
                                            .clipped()
                                            .cornerRadius(6)
                                        
                                        Button(action: {
                                            imagesForIntroduction.remove(at: index)
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
                                    .frame(width: 70, height: 80)
                                }
                                
                                Spacer()
                            }
                        }
                        .padding(EdgeInsets(top: 20, leading: 20, bottom: 10, trailing: 20))
                        
                        // * 동아리 카테고리
                        HStack {
                            Text("카테고리")
                                .font(.system(size: 13))
                                .foregroundColor(Color("tertiary"))
                                .bold()
                                .padding(EdgeInsets(top: 30, leading: 20, bottom: 10, trailing: 0))
                            Spacer()
                            if showValidationError && int_category==11 {
                                Text("필수 입력 항목입니다.")
                                    .foregroundColor(.red)
                                    .font(.system(size: 12))
                                    .padding(.horizontal, 20)
                                    .padding(EdgeInsets(top: 30, leading: 20, bottom: 0, trailing: 0))
                            }
                        }
                        
                        CustomDropDownPickerForClub(
                            selection: $category,
                            selectedIndex: $int_category,
                            options: ["IT/데이터", "사진/촬영", "인문학/독서", "여행", "스포츠", "문화/예술", "언어/외국어", "음악/악기", "댄스", "봉사활동", "기타"]
                        )
                        .padding(.horizontal, 20)
                        .frame(width: UIScreen.main.bounds.width, height: 120)
                        
                        
                        
                        // * 동아리 모집여부
                        HStack {
                            Text("모집 여부")
                                .font(.system(size: 13))
                                .foregroundColor(Color("tertiary"))
                                .bold()
                                .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 0))
                            Spacer()
                        }
                        
                        CustomDropDownPickerForClub(
                            selection: $isRecruit,
                            selectedIndex: $int_isRecruit,
                            options: ["모집 중", "모집 예정"]
                        )
                        .padding(.horizontal, 20)
                        .frame(width: UIScreen.main.bounds.width, height: 100)
                        
                        
                        if isRecruit != "모집 예정" {
                            // * 동아리 지원서 링크
                            HStack(spacing:5) {
                                Text("동아리 지원서 링크")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color("tertiary"))
                                    .bold()
                                Spacer()
                                
                                Button(action: {
                                    noneLink.toggle()
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
                                    .font(.system(size: 13))
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
                                    TextEditor(text: $clubApplicationLinkText)
                                        .padding(10)
                                        .foregroundColor(Color("secondary_"))
                                        .font(.system(size: 15))
                                    
                                    if clubApplicationLinkText.isEmpty {
                                        Text(clubApplicationLinkWriteText)
                                            .foregroundColor(Color("secondary_"))
                                            .padding(10)
                                            .font(.system(size: 15))
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .frame(width: UIScreen.main.bounds.width, height: 50)
                            
                            HStack {
                                Spacer()
                                if showValidationError && !noneLink && clubApplicationLinkText.isEmpty {
                                    Text("필수 입력 항목입니다.")
                                        .foregroundColor(.red)
                                        .font(.system(size: 12))
                                        .padding(.horizontal, 20)
                                }
                            }
                            
                        }
                        
                        
                        if isRecruit != "모집 예정" {
                            // * 서류 접수
                            HStack {
                                Text("서류 접수 마감일")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color("tertiary"))
                                    .bold()
                                Spacer()
                            }
                            .padding(EdgeInsets(top: 20, leading: 20, bottom: 10, trailing: 0))
                            
                            
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color("content-secondary"), lineWidth: 1)
                                
                                HStack {
                                    if beforeSelectDateForDocumentSubmission {
                                        Text(selectedDateForDocumentSubmission, formatter: dateFormatter)
                                            .foregroundColor(Color("secondary_"))
                                            .padding(10)
                                            .font(.system(size: 15))
                                            .onTapGesture {
                                                self.showDatePickerForDocumentSubmission.toggle()
                                            }
                                        Spacer()
                                    }
                                    else {
                                        Text("날짜와 시간을 선택해주세요.")
                                            .foregroundColor(Color("secondary_"))
                                            .padding(10)
                                            .font(.system(size: 15))
                                            .onTapGesture {
                                                beforeSelectDateForDocumentSubmission = true
                                                self.showDatePickerForDocumentSubmission.toggle()
                                            }
                                        Spacer()
                                    }
                                }
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
                                if showValidationError && !beforeSelectDateForDocumentSubmission {
                                    Text("필수 입력 항목입니다.")
                                        .foregroundColor(.red)
                                        .font(.system(size: 12))
                                        .padding(.horizontal, 20)
                                }
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
                                            .onTapGesture {
                                                self.showDatePickerForDocumentResult.toggle()
                                            }
                                        Spacer()
                                    }
                                    else {
                                        Text("날짜와 시간을 선택해주세요.")
                                            .foregroundColor(Color("secondary_"))
                                            .padding(10)
                                            .font(.system(size: 15))
                                            .onTapGesture {
                                                beforeSelectDateForDocumentResult = true
                                                self.showDatePickerForDocumentResult.toggle()
                                            }
                                        Spacer()
                                    }
                                }
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
                                if showValidationError && !beforeSelectDateForDocumentResult {
                                    Text("필수 입력 항목입니다.")
                                        .foregroundColor(.red)
                                        .font(.system(size: 12))
                                        .padding(.horizontal, 20)
                                }
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
                                                .onTapGesture {
                                                    self.showDatePickerForInterviewStart.toggle()
                                                }
                                            Spacer()
                                        }
                                        else {
                                            Text("날짜와 시간을 선택해주세요.")
                                                .foregroundColor(Color("secondary_"))
                                                .padding(10)
                                                .font(.system(size: 15))
                                                .onTapGesture {
                                                    beforeSelectDateForInterviewStart = true
                                                    self.showDatePickerForInterviewStart.toggle()
                                                }
                                            Spacer()
                                        }
                                    }
                                }
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
                                if showValidationError && !beforeSelectDateForInterviewStart && !noneInterview {
                                    Text("필수 입력 항목입니다.")
                                        .foregroundColor(.red)
                                        .font(.system(size: 12))
                                        .padding(.horizontal, 20)
                                }
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
                                                .onTapGesture {
                                                    self.showDatePickerForInterviewEnd.toggle()
                                                }
                                            Spacer()
                                        }
                                        else {
                                            Text("날짜와 시간을 선택해주세요.")
                                                .foregroundColor(Color("secondary_"))
                                                .padding(10)
                                                .font(.system(size: 15))
                                                .onTapGesture {
                                                    beforeSelectDateForInterviewEnd = true
                                                    self.showDatePickerForInterviewEnd.toggle()
                                                }
                                            Spacer()
                                        }
                                    }
                                }
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
                                if showValidationError && !beforeSelectDateForInterviewEnd && !noneInterview {
                                    Text("필수 입력 항목입니다.")
                                        .foregroundColor(.red)
                                        .font(.system(size: 12))
                                        .padding(.horizontal, 20)
                                }
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
                                            .onTapGesture {
                                                self.showDatePickerForFinalResult.toggle()
                                            }
                                        Spacer()
                                    }
                                    else {
                                        Text("날짜와 시간을 선택해주세요.")
                                            .foregroundColor(Color("secondary_"))
                                            .padding(10)
                                            .font(.system(size: 15))
                                            .onTapGesture {
                                                beforeSelectDateForFinalResult = true
                                                self.showDatePickerForFinalResult.toggle()
                                            }
                                        Spacer()
                                    }
                                }
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
                                if showValidationError && !beforeSelectDateForFinalResult {
                                    Text("필수 입력 항목입니다.")
                                        .foregroundColor(.red)
                                        .font(.system(size: 12))
                                        .padding(.horizontal, 20)
                                }
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
                            createClub()
                        }) {
                            
                            ZStack {
                                RoundedRectangle (cornerRadius: 10)
                                    .foregroundColor(Color("primary_"))
                                
                                Text("동아리 등록")
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
            .sheet(isPresented: self.$presentSheet) {
                _CompleteRegistrationBottomSheetView()
            }
        }
        .navigationBarBackButtonHidden()
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct _CompleteRegistrationBottomSheetView: View {
    
    @State private var goToNextView = false
    
    var body: some View {
        VStack {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(Color("accent"))
            
            
            Text("동아리 등록이 완료되었어요.")
                .font(.system(size: 28))
                .bold()
                .padding(.top, 30)
            
            Text("승인까지 3~5일이 소요될 수 있어요.")
                .font(.system(size: 16))
                .foregroundColor(Color("secondary_"))
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 50, trailing: 0))
            
            Button(action: {
                self.goToNextView = true
            }) {
                ZStack {
                    RoundedRectangle (cornerRadius: 10)
                        .stroke(Color("accent"), lineWidth: 1)
                        .frame(width: 200, height: 50)
                    Text("홈으로 돌아가기")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .bold()
                }
            }
            .fullScreenCover(isPresented: $goToNextView) {
                MainTabView()
            }
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .padding(.top, 450)
        .background(Color.white)
        .cornerRadius(30)
    }
}


struct CustomDropDownPickerForClub: View {
    
    @Binding var selection: String
    @Binding var selectedIndex: Int
    
    // 드롭다운 메뉴가 나타날 위치를 정의
    var state: CustomDropDownPickerState = .bottom
    
    // 드롭다운에 표시할 옵션 배열
    var options: [String]
    
    // 드롭다운 메뉴를 보여줄지 여부를 상태 변수로 관리
    @State var showDropdown = false
    
    // SceneStorage를 사용하여 드롭다운 메뉴의 z-index를 관리 (드롭다운 메뉴가 항상 다른 UI 요소 위에 나타나고, 사용자가 앱을 재시작해도 z-index 상태가 유지되도록 함)
    @SceneStorage("drop_down_zindex") private var index = 1000.0
    @State var zindex = 1000.0
    
    
    var body: some View {
        // GeometryReader를 사용하여 뷰의 크기를 읽음
        GeometryReader {
            let size = $0.size
            
            VStack(spacing: 0) {
                // 드롭다운 메뉴가 상단에 위치할 때 옵션을 표시
                if state == .top && showDropdown {
                    OptionsView()
                }
                
                HStack {
                    // 선택된 항목을 텍스트로 표시
                    Text(selection)
                        .foregroundColor(selection != nil ? Color("secondary_") : Color("secondary_"))
                        .font(.system(size:15))
                    
                    Spacer(minLength: 0)
                    
                    // 드롭다운 메뉴 아이콘
                    Image(systemName: state == .top ? "chevron.up" : "chevron.down")
                        .font(.title3)
                        .foregroundColor(Color("content-secondary"))
                        .rotationEffect(.degrees((showDropdown ? -180 : 0))) // 드롭다운 메뉴가 열릴 때 아이콘을 회전
                }
                .padding(.horizontal, 20)
                .frame(height: 50)
                .background(.white)
                .contentShape(.rect)
                .onTapGesture {
                    // 드롭다운 메뉴를 토글
                    index += 1
                    zindex = index
                    withAnimation(.snappy) {
                        showDropdown.toggle()
                    }
                }
                .zIndex(10)
                
                // 드롭다운 메뉴가 하단에 위치할 때 옵션을 표시
                if state == .bottom && showDropdown {
                    OptionsView()
                }
            }
            .clipped()
            .background(.white)
            .cornerRadius(10)
            .overlay {
                // 드롭다운 메뉴의 테두리
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("content-secondary"))
            }
            .frame(height: size.height, alignment: state == .top ? .bottom : .top)
        }
        .zIndex(zindex)
    }
    
    // 드롭다운 메뉴 옵션을 정의하는 뷰
    func OptionsView() -> some View {
        ScrollView {
            ForEach(options.indices, id: \.self) { index in
                HStack {
                    Text(options[index])
                        .font(.system(size:15))
                    
                    Spacer()
                    
                    Image(systemName: "checkmark")
                        .opacity(selectedIndex == index ? 1 : 0)
                }
                .foregroundStyle(selectedIndex == index ? Color("secondary_") : Color("secondary_"))
                .animation(.none, value: selectedIndex)
                .frame(height: 30)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        selectedIndex = index
                        selection = options[index]
                        showDropdown.toggle()
                    }
                }
            }
        }
        .transition(.move(edge: state == .top ? .bottom : .top))
        .zIndex(1)
        .padding(.horizontal, 20)
    }
}



