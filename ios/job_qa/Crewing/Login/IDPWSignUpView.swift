import SwiftUI

struct IDPWSignUpView: View {
    
    @State private var idEmailText: String = ""
    let idEmailWriteText = "이메일 주소를 입력해주세요."
    @State private var pwText: String = ""
    @State private var nickname: String = ""
    let pwWriteText = "8~20자, 영문/숫자 조합"
    
    @State private var navigateToNext = false
    @State private var isButtonEnabled = false
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // 이메일 유효성 검사 함수
    func emailValidationMessage() -> String {
        if idEmailText.isEmpty {
            return "이메일 주소를 입력해주세요."
        } else if !idEmailText.contains("@") || !idEmailText.contains(".") {
            return "이메일 형식을 다시 확인해주세요."
        } else {
            return "사용 가능한 이메일입니다."
        }
    }
    
    // 비밀번호 유효성 검사 함수
    func passwordValidationMessage() -> String {
        if pwText.count < 8 || pwText.count > 20 {
            return "비밀번호는 8~20자이어야 합니다."
        } else if pwText.rangeOfCharacter(from: CharacterSet.letters) == nil || pwText.rangeOfCharacter(from: CharacterSet.decimalDigits) == nil {
            return "영문/숫자를 모두 포함한 비밀번호를 입력해주세요."
        } else {
            return "사용 가능한 비밀번호입니다."
        }
    }
    
    // 이메일과 비밀번호 유효성을 확인하여 버튼 활성화 여부 업데이트
    func updateButtonState() {
        let emailIsValid = emailValidationMessage() == "사용 가능한 이메일입니다."
        let passwordIsValid = passwordValidationMessage() == "사용 가능한 비밀번호입니다."
        let nickname = self.nickname != ""
        let companyname = self.nickname != ""
        isButtonEnabled = emailIsValid && passwordIsValid && nickname && companyname
    }
    private func idPwSignUp() {
        let idPwSignUpRequest = IdPwSignUpRequest(
            nickname: nickname,
            email: idEmailText, // <-- 여기 오타도 수정 (idEmailWriteText -> idEmailText)
            password: pwText
        )
        
        NetworkManager.idPwSignUp(request: idPwSignUpRequest) { result in
            DispatchQueue.main.async { // UI 업데이트는 메인스레드에서
                switch result {
                case .success(let response):
                    print("idPwSignUp - 회원가입 성공")
                    self.alertMessage = "회원가입에 성공했습니다."
                    self.showAlert = true
//                    self.presentationMode.wrappedValue.dismiss()
                case .failure(let error):
                    print("ID/PW 회원가입에 실패: \(error)")
                    self.alertMessage = "회원가입에 실패했습니다. 다시 시도해주세요."
                    self.showAlert = true
                }
            }
        }
    }
    
    var body: some View {
        NavigationView {
                ZStack{
                    // 배경색 지정
                    Color("primary_")
                        .ignoresSafeArea()
                    ScrollView {
                        VStack {
                            Button(action:{
                                self.presentationMode.wrappedValue.dismiss()}) {
                                    HStack(spacing:2) {
                                        Text("취소")
                                            .font(.system(size: 14))
                                            .foregroundColor(.black)
                                            .bold()
                                        Spacer()
                                    }
                                    .foregroundColor(.black)
                                    .padding(.top, 20)
                                    .padding(.leading, 16)
                                }
                            
                            HStack {
                                Text("회원가입")
                                    .font(.system(size: 32))
                                    .foregroundColor(.black)
                                    .bold()
                                Spacer()
                            }
                            .padding(.top, 15)
                            .padding(.leading, 16)
                            
                            HStack {
                                Text("이메일, 비밀번호를 입력해주세요.")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color("secondary_"))
                                    .padding(EdgeInsets(top: 3, leading: 15, bottom: 15, trailing: 0))
                                Spacer()
                            }
                            .padding(.bottom, 25)
                            
                            
                            
                            Spacer()
                            
                            // * 하단 시트
                            ZStack (alignment: .top) {
                                RoundedRectangle(cornerRadius: 30)
                                    .foregroundColor(.white)
                                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: -5)
                                
                                VStack {
                                    HStack {
                                        Text("이메일")
                                            .font(.system(size: 15))
                                            .foregroundColor(Color("tertiary"))
                                            .bold()
                                            .padding(EdgeInsets(top: 30, leading: 20, bottom: 10, trailing: 20))
                                        
                                        Spacer()
                                    }
                                    
                                    ZStack (alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(Color("secondary_"), lineWidth: 1)
                                        
                                        TextField(idEmailWriteText, text: $idEmailText)
                                        .onChange(of: idEmailText) { _ in
                                            self.updateButtonState()
                                        }
                                        .padding(10)
                                        .foregroundColor(Color("secondary_"))
                                        .font(.system(size: 15))
                                    }
                                    .padding(.horizontal, 20)
                                    .frame(width: UIScreen.main.bounds.width, height: 60)
                                    
                                    HStack {
                                        Spacer()
                                        Text(self.emailValidationMessage())
                                            .foregroundColor(Color("secondary_"))
                                            .font(.system(size: 12))
                                            .padding(EdgeInsets(top: 3, leading: 20, bottom: 0, trailing: 20))
                                    }
                                    
                                    HStack {
                                        Text("비밀번호")
                                            .font(.system(size: 15))
                                            .foregroundColor(Color("tertiary"))
                                            .bold()
                                            .padding(EdgeInsets(top: 30, leading: 20, bottom: 10, trailing: 20))
                                        
                                        Spacer()
                                    }
                                    
                                    ZStack (alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(Color("secondary_"), lineWidth: 1)
                                        
                                        TextField(pwWriteText, text: $pwText)
                                        .onChange(of: pwText) { _ in
                                            self.updateButtonState()
                                        }
                                        .padding(10)
                                        .foregroundColor(Color("secondary_"))
                                        .font(.system(size: 15))
                                    }
                                    .padding(.horizontal, 20)
                                    .frame(width: UIScreen.main.bounds.width, height: 60)
                                    
                                    HStack {
                                        Spacer()
                                        Text(self.passwordValidationMessage())
                                            .foregroundColor(Color("secondary_"))
                                            .font(.system(size: 12))
                                            .padding(EdgeInsets(top: 3, leading: 20, bottom: 0, trailing: 20))
                                    }
                                    
    //                                Spacer()
                                    
                                    HStack {
                                        Text("닉네임")
                                            .font(.system(size: 15))
                                            .foregroundColor(Color("tertiary"))
                                            .bold()
                                            .padding(EdgeInsets(top: 30, leading: 20, bottom: 10, trailing: 20))
                                        
                                        Spacer()
                                    }
                                    
                                    ZStack (alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(Color("secondary_"), lineWidth: 1)
                                        
                                        TextField("닉네임을 입력해주세요", text: $nickname)
                                        .onChange(of: nickname) { _ in
                                            self.updateButtonState()
                                        }
                                        .padding(10)
                                        .foregroundColor(Color("secondary_"))
                                        .font(.system(size: 15))
                                    }
                                    .padding(.horizontal, 20)
                                    .frame(width: UIScreen.main.bounds.width, height: 60)
                                    
                                    
                                    Spacer()
                                    // * 다음 버튼
                                    Button(action: {
                                        if self.isButtonEnabled {
                                            idPwSignUp()
                                        }
                                    }) {
                                        ZStack {
                                            RoundedRectangle (cornerRadius: 10)
                                                .foregroundColor(self.isButtonEnabled ? Color("accent") : Color("primary_"))
                                                .frame(width: 330, height: 60)
                                                .padding(.horizontal, 25)
                                            
                                            Text("회원가입")
                                                .font(.system(size: 18))
                                                .foregroundColor(self.isButtonEnabled ? Color.white : Color("secondary_"))
                                                .bold()
                                        }
                                        .frame(width: 60)
                                        .padding(.top, 15)
                                        .padding(.bottom, 30)
                                    }
                                    
                                    
                                }
                            }
                        }
                    }
                    
                }
//            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(""),
                message: Text(alertMessage),
                dismissButton: .default(Text("확인"))
            )
        }
        .navigationBarBackButtonHidden()
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    IDPWSignUpView()
}
