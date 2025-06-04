import SwiftUI

struct EditUserInfoView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var userInfo: UserInfoResponse?
    @EnvironmentObject var accesstokenStored: _UserAccessToken
    
    @State var birth: String = "출생년도"
    @State var gender: String = "성별"
    @State var int_birth: Int = 107
    @State var int_gender: Int = 3
    @State var presentSheet: Bool = false
    
    @State private var birthUpdated = false
    @State private var genderUpdated = false
    @State private var interestsUpdated = false
    
    @State private var userInterests: [UserInterest] = []
    
    let interests = ["IT/데이터", "사진/촬영", "인문학/독서", "여행", "스포츠", "문화/예술", "언어/외국어", "음악/악기", "댄스", "봉사활동", "기타"]
    
    
    // 선택된 관심 분야를 토글하는 함수
    private func toggleInterest(_ interest: String) {
        if let index = userInterests.firstIndex(where: { $0.interest == interest }) {
            userInterests.remove(at: index)
        } else {
            userInterests.append(UserInterest(interest: interest))
        }
    }

    
    // getUserInfo API 호출
    
    
    // 세 개의 API 호출 성공 여부를 체크하는 함수
    private func checkAllUpdatesCompleted() {
        if birthUpdated && genderUpdated && interestsUpdated {
            presentSheet = true
        }
    }
    
    // 성별과 출생년도를 수정하는 함수
    private func updateUserInfo() {
        let accessToken = _UserAccessToken.shared.accessTokenStored
        
        print("요청으로 보내는 나이 데이터: \(birth)")
        // 나이 수정
        NetworkManager.updateUserBirth(birth: birth, accessToken: accessToken) { result in
            switch result {
            case .success:
                self.birthUpdated = true
                print("나이 수정 성공")
                checkAllUpdatesCompleted()
            case .failure(let error):
                print("나이 수정 실패: \(error)")
            }
        }
        
        print("요청으로 보내는 성별 데이터: \(gender)")
        // 성별 수정
        NetworkManager.updateUserGender(gender: gender, accessToken: accessToken) { result in
            switch result {
            case .success:
                self.genderUpdated = true
                print("성별 수정 성공")
                checkAllUpdatesCompleted()
            case .failure(let error):
                print("성별 수정 실패: \(error)")
            }
        }
        
        // 관심항목 수정
        NetworkManager.updateUserInterests(accessToken: _UserAccessToken.shared.accessTokenStored, interests: userInterests) { result in
            switch result {
            case .success:
                self.interestsUpdated = true
                print("사용자 관심 항목: \(userInterests)")
                checkAllUpdatesCompleted()
            case .failure(let error):
                print("관심항목 수정 실패: \(error)")
            }
        }
    }
    
    
    
    
    var body: some View {
        ZStack {
            Button(action:{
                self.presentationMode.wrappedValue.dismiss()}) {
                    HStack(spacing:2) {
                        Image(systemName: "chevron.backward")
                        Spacer()
                    }
                    .foregroundColor(.black)
                }
            Text("프로필 정보 입력")
                .font(.system(size: 18))
                .bold()
        }
        .padding(20)
        .navigationBarBackButtonHidden()
        
        ScrollView {
            VStack {
                HStack {
                    Text("출생년도")
                        .font(.system(size: 17))
                        .foregroundColor(Color("tertiary"))
                        .bold()
                        .padding(EdgeInsets(top: 20, leading: 20, bottom: 10, trailing: 20))
                    Spacer()
                    
                }
                
                CustomDropDownPicker(
                    selection: $birth,
                    selectedIndex: $int_birth,
                    options: (1900...2006).reversed().map { String($0) } + [""]
                )
                .padding(.horizontal, 20)
                .frame(width: UIScreen.main.bounds.width, height: 130)
                
                
                HStack {
                    Text("성별")
                        .font(.system(size: 17))
                        .foregroundColor(Color("tertiary"))
                        .bold()
                        .padding(EdgeInsets(top: 5, leading: 20, bottom: 10, trailing: 20))
                    Spacer()
                }
                
                CustomDropDownPicker (
                    selection: $gender,
                    selectedIndex: $int_gender,
                    options: ["여자", "남자", "기타", ""]
                )
                .padding(.horizontal, 20)
                .frame(width: UIScreen.main.bounds.width, height: 130)
                
                
                HStack {
                    Text("관심 분야")
                        .font(.system(size: 17))
                        .foregroundColor(Color("tertiary"))
                        .bold()
                        .padding(EdgeInsets(top: 5, leading: 20, bottom: 10, trailing: 20))
                    Spacer()
                }
                
                Rectangle()
                    .frame(height: 0.25) // 높이 설정
                    .foregroundColor(Color("secondary_")) // 색상 설정
                    .padding(.horizontal, 25)
                
                ForEach(interests, id: \.self) { interest in
                    Button(action: {
                        toggleInterest(interest)
                    }) {
                        HStack {
                            // userInterests 배열에 해당 interest가 있는지 확인
                            if userInterests.contains(where: { $0.interest == interest }) {
                                Text(interest)
                                    .font(.system(size: 15))
                                    .foregroundColor(Color("tertiary"))
                            } else {
                                Text(interest)
                                    .font(.system(size: 15))
                                    .foregroundColor(Color("secondary_"))
                            }
                            Spacer()
                            if userInterests.contains(where: { $0.interest == interest }) {
                                Image(systemName: "checkmark")
                                    .resizable()
                                    .frame(width: 12, height: 12)
                                    .foregroundColor(.blue)
                            } else {
                                Image(systemName: "checkmark")
                                    .resizable()
                                    .frame(width: 12, height: 12)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }

                .padding(EdgeInsets(top: 5, leading: 30, bottom: 10, trailing: 30))
                
                Rectangle()
                    .frame(height: 0.25) // 높이 설정
                    .foregroundColor(Color("secondary_")) // 색상 설정
                    .padding(.horizontal, 25)
                
                // * 다음 버튼
                Button(action: {
                    updateUserInfo()
                }) {
                    ZStack {
                        RoundedRectangle (cornerRadius: 10)
                            .foregroundColor(Color("primary_"))
                            .frame(width: 330, height: 60)
                            .padding(.horizontal, 25)
                        
                        Text("완료")
                            .font(.system(size: 16))
                            .foregroundColor(Color("secondary_"))
                            .bold()
                    }
                    .frame(width: UIScreen.main.bounds.width, height: 60)
                    .padding(EdgeInsets(top: 50, leading: 0, bottom: 0, trailing: 0))
                }
                
                Spacer()
            }
            
        }
        .navigationBarBackButtonHidden()
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
//            fetchUserInfo() // 화면이 나타날 때 API 호출
        }
        .sheet(isPresented: self.$presentSheet) {
            CompleteEditUserInfoBottomSheetView()
                .presentationDetents([.height(500), .large])
        }
    }
}

struct CompleteEditUserInfoBottomSheetView: View {
    
    var body: some View {
        VStack {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(Color("accent"))
            
            
            Text("프로필 정보 수정이 완료되었어요.")
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

#Preview {
    EditUserInfoView()
}
