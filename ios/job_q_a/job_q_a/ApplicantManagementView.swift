import SwiftUI


struct ApplicantManagementView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var accesstokenStored: _UserAccessToken
    
    @State private var applicants: [ApplicantByStatus] = []
    @State private var selectedStatus: String? = nil
    @State private var selectedIndex = 0
    @State private var selectedApplicants: [Int] = [] 
    @State private var isSuccessChangeStatus = false
    
    @State private var isShowingDocumentSubmissionPopup = false
    @State private var isShowingDocumentApprovalPopup = false
    @State private var isShowingDocumentRejectionPopup = false
    @State private var isShowingFinalRejectionPopup = false
    @State private var isShowingFinalApprovalPopup = false
    @State private var isShowingContentPopup = false
    
    @State private var isShowingAddApplicantsPopup = false
    @State var isShowingNoExistentMemberPopup = false
    @State private var isShowingRemoveApplicantsPopup = false
    
    @State private var selectedApplicantName: String? = nil
    @State private var selectedApplicantId: Int? = nil
    
    var clubID: Int
    
    // 동아리 지원자 목록 조회
    private func getApplicants() {
        NetworkManager.getApplicants(clubId: clubID, page: 0, size: 1000, accessToken: _UserAccessToken.shared.accessTokenStored) { result in
            switch result {
            case .success(let response):
                self.applicants = response.applicants
                if isSuccessChangeStatus { self.selectedApplicants = [] }
                print("동아리 지원자 목록 조회 성공: \(self.applicants)")
            case .failure(let error):
                print("동아리 지원자 목록 조회 실패: \(error)")
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

                    Text("지원자 관리")
                        .font(.system(size: 18))
                        .bold()

                    HStack{
                        Spacer()
                        Image(systemName: "plus")
                            .onTapGesture {
                                isShowingAddApplicantsPopup = true
                            }
                    }
                    .foregroundColor(.black)
                    
                }
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
                .navigationBarBackButtonHidden()
                
                ZStack(alignment: .top) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 0)
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 10)
                        
                        HStack(spacing:0) {
                            Image(systemName: "square.fill")
                                .resizable()
                                .foregroundColor(Color("content-secondary"))
                                .frame(width: 20, height: 20)
                                .foregroundColor(.blue)
                                .padding()
                            
                            Text("\(selectedApplicants.count)명 선택")
                                .bold()
                                .font(.system(size: 16))
                            
                            Spacer()
                        }
                    }
                    .frame(height: 50, alignment: .leading)

                    List {
                        ForEach(applicants) { applicant in
                            ApplicantCardView(
                                memberName: applicant.user.name,
                                userId: applicant.user.userId,
                                memberId: applicant.applicantId,
                                isSelected: selectedApplicants.contains(applicant.applicantId),
                                status: applicant.status ?? "상태없음"
                            ) {
                                if let index = selectedApplicants.firstIndex(of: applicant.applicantId) {
                                    selectedApplicants.remove(at: index)
                                } else {
                                    selectedApplicants.append(applicant.applicantId)
                                }
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button {
                                    selectedApplicantName = applicant.user.name
                                    selectedApplicantId = applicant.applicantId
                                    self.isShowingRemoveApplicantsPopup = true
                                }
                            label: { Text("삭제") }
                                    .tint(Color("gray-60"))
                            }
                        }
                    }
                    .listStyle(.plain)
                    .padding(.top, 60)
                    
                    
                    HStack {
                        Spacer()
                        _CustomDropDownPicker(selection: $selectedStatus, selectedIndex: $selectedIndex, isShowingDocumentSubmissionPopup: $isShowingDocumentSubmissionPopup, isShowingDocumentApprovalPopup: $isShowingDocumentApprovalPopup, isShowingDocumentRejectionPopup: $isShowingDocumentRejectionPopup, isShowingFinalApprovalPopupPopup: $isShowingFinalApprovalPopup, isShowingFinalRejectionPopup: $isShowingFinalRejectionPopup, options: ["서류접수", "서류합격", "서류불합격", "최종합격", "최종불합격"])
                            .cornerRadius(10)
                            .transition(.move(edge: .top))
                            .padding()
                    }
                    .frame(height: 50, alignment: .leading)
                }
                .onAppear {
                    getApplicants()
                }
            }
            .overlay(
                Group {
                    if isShowingAddApplicantsPopup {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                        AddApplicantsPopupView(clubId: clubID, onApplicantsAdded: {getApplicants()}, isShowingAddApplicantsPopup: $isShowingAddApplicantsPopup, isShowingNoExistentApplicantsPopup: $isShowingNoExistentMemberPopup)
                            .frame(width: 350, height: 280)
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(
                                Button(action: {
                                    withAnimation {
                                        isShowingAddApplicantsPopup = false
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
                    if isShowingRemoveApplicantsPopup, let selectedApplicantName = selectedApplicantName, let selectedApplicantId = selectedApplicantId {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                        RemoveApplicantsPopupView(clubID: clubID, applicantsName: selectedApplicantName, applicantsId: selectedApplicantId, onApplicantsRemoved: {getApplicants()}, isShowingRemoveApplicantsPopup: $isShowingRemoveApplicantsPopup)
                            .frame(width: 350, height: 200)
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(
                                Button(action: {
                                    withAnimation {
                                        isShowingRemoveApplicantsPopup = false
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
                    if isShowingNoExistentMemberPopup {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                        NoExistentMemberPopupView(isShowingNoExistentMemberPopup: $isShowingNoExistentMemberPopup)
                            .frame(width: 300, height: 190)
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(
                                Button(action: {
                                    withAnimation {
                                        isShowingNoExistentMemberPopup = false
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
                    if isShowingDocumentSubmissionPopup, let firstApplicant = applicants.first(where: { selectedApplicants.contains($0.applicantId) }) {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                        DocumentSubmissionPopupView(clubID: clubID, selectedApplicants: selectedApplicants, firstApplicantName: firstApplicant.user.name, callApplucantsAPI: {getApplicants()},isShowingDocumentSubmissionPopup: $isShowingDocumentSubmissionPopup, isShowingContentPopup: $isShowingContentPopup)
                            .frame(width: 350, height: 220)
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(
                                Button(action: {
                                    withAnimation {
                                        self.isShowingDocumentSubmissionPopup = false
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
                    if isShowingDocumentApprovalPopup, let firstApplicant = applicants.first(where: { selectedApplicants.contains($0.applicantId) }) {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                        DocumentApprovalPopupView(clubID: clubID, selectedApplicants: selectedApplicants, firstApplicantName: firstApplicant.user.name, callApplucantsAPI: {getApplicants()}, isShowingDocumentApprovalPopup: $isShowingDocumentApprovalPopup, isShowingContentPopup: $isShowingContentPopup)
                            .frame(width: 350, height: 220)
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(
                                Button(action: {
                                    withAnimation {
                                        self.isShowingDocumentApprovalPopup = false
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
                    if isShowingDocumentRejectionPopup, let firstApplicant = applicants.first(where: { selectedApplicants.contains($0.applicantId) }) {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                        DocumentRejectionPopupView(clubID: clubID, selectedApplicants: selectedApplicants, firstApplicantName: firstApplicant.user.name, callApplucantsAPI: {getApplicants()}, isShowingDocumentRejectionPopup: $isShowingDocumentRejectionPopup, isShowingContentPopup: $isShowingContentPopup)
                            .frame(width: 350, height: 220)
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(
                                Button(action: {
                                    withAnimation {
                                        self.isShowingDocumentRejectionPopup = false
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
                    if isShowingFinalApprovalPopup, let firstApplicant = applicants.first(where: { selectedApplicants.contains($0.applicantId) }) {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                        FinalApprovalPopupView(clubID: clubID, selectedApplicants: selectedApplicants, firstApplicantName: firstApplicant.user.name, callApplucantsAPI: {getApplicants()}, isShowingFinalApprovalPopup: $isShowingFinalApprovalPopup, isShowingContentPopup: $isShowingContentPopup)
                            .frame(width: 350, height: 220)
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(
                                Button(action: {
                                    withAnimation {
                                        self.isShowingFinalApprovalPopup = false
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
                    if isShowingFinalRejectionPopup, let firstApplicant = applicants.first(where: { selectedApplicants.contains($0.applicantId) }) {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                        FinalRejectionPopupView(clubID: clubID, selectedApplicants: selectedApplicants, firstApplicantName: firstApplicant.user.name, callApplucantsAPI: {getApplicants()}, isShowingFinalRejectionPopup: $isShowingFinalRejectionPopup, isShowingContentPopup: $isShowingContentPopup)
                            .frame(width: 350, height: 220)
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(
                                Button(action: {
                                    withAnimation {
                                        self.isShowingFinalRejectionPopup = false
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
                    if isShowingContentPopup {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                        ContentPopupView(clubID: clubID, selectedApplicants: selectedApplicants, callApplucantsAPI: {getApplicants()}, status: selectedStatus ?? "" ,isShowingContentPopup: $isShowingContentPopup, isSuccessChangeStatus: $isSuccessChangeStatus)
                            .frame(width: 350, height: 400)
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(
                                Button(action: {
                                    withAnimation {
                                        self.isShowingContentPopup = false
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
        }
        .navigationBarBackButtonHidden()
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


// 드롭다운 메뉴 상태를 정의하는 열거형
enum _CustomDropDownPickerState {
    case top, bottom
}

struct _CustomDropDownPicker: View {
    
    @Binding var selection: String?
    @Binding var selectedIndex: Int
    
    @Binding var isShowingDocumentSubmissionPopup: Bool
    @Binding var isShowingDocumentApprovalPopup: Bool
    @Binding var isShowingDocumentRejectionPopup: Bool
    @Binding var isShowingFinalApprovalPopupPopup: Bool
    @Binding var isShowingFinalRejectionPopup: Bool
    
    // 드롭다운 메뉴가 나타날 위치를 정의
    var state: _CustomDropDownPickerState = .bottom
    
    // 드롭다운에 표시할 옵션 배열
    var options: [String]
    
    // 드롭다운 메뉴를 보여줄지 여부를 상태 변수로 관리
    @State var showDropdown = false
    
    // SceneStorage를 사용하여 드롭다운 메뉴의 z-index를 관리 (드롭다운 메뉴가 항상 다른 UI 요소 위에 나타나고, 사용자가 앱을 재시작해도 z-index 상태가 유지되도록 함)
    @SceneStorage("drop_down_zindex") private var index = 1000.0
    @State var zindex = 1000.0
    
    var body: some View {
        VStack(spacing: 0) {
            // 드롭다운 메뉴가 상단에 위치할 때 옵션을 표시
            if state == .top && showDropdown {
                OptionsView()
            }
            
            HStack {
                Text("상태변경")
                    .foregroundColor(Color(.white))
                    .font(.system(size: 10))
                    .bold()
                
            }
            .padding(.horizontal, 15)
            .frame(width: 65, height: 20)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .onTapGesture {
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
        .zIndex(zindex)
    }
    
    // 드롭다운 메뉴 옵션을 정의하는 뷰
    func OptionsView() -> some View {
        VStack {
            ForEach(options.indices, id: \.self) { index in
                Button(action: {
                    withAnimation(.easeInOut) {
                        selectedIndex = index
                        selection = options[index]
                        showDropdown.toggle()
                        showPopup(for: index)
                    }
                }) {
                    Text(options[index])
                        .frame(width: 65, height: 20)
                        .background(backgroundColor(for: index))
                    
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(3)
                        .font(.system(size: 10))
                }
            }
        }
        .background(Color.white)
        .cornerRadius(4)
        .shadow(radius: 1)
        .padding(5)
        .transition(.move(edge: state == .top ? .bottom : .top))
        .zIndex(1)
    }
    
    // 인덱스에 따라 다른 배경색을 반환하는 함수
    func backgroundColor(for index: Int) -> Color {
        switch index {
        case 0:
            return Color("tertiary_dark")
        case 1:
            return Color("accent")
        case 2:
            return Color("accent")
        case 3:
            return Color("tertiary")
        case 4:
            return Color("tertiary")
        default:
            return Color.gray.opacity(0.2)
        }
    }
    
    // 인덱스에 따라 다른 팝업을 표시하는 함수
    func showPopup(for index: Int) {
        switch index {
        case 0:
            self.isShowingDocumentSubmissionPopup = true
            print("서류접수 팝업")
            selection = "WAIT"
        case 1:
            self.isShowingDocumentApprovalPopup = true
            print("서류합격 팝업")
            selection = "DOC"
        case 2:
            self.isShowingDocumentRejectionPopup = true
            print("서류 불합격 팝업")
            selection = "DOC_FAIL"
        case 3:
            self.isShowingFinalApprovalPopupPopup = true
            print("최종합격 팝업")
            selection = "INTERVIEW"
        case 4:
            self.isShowingFinalRejectionPopup = true
            print("최종불합격 팝업")
            selection = "FINAL_FAIL"
        default:
            break
        }
    }
    
}
