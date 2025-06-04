import SwiftUI

struct TermsofServiceView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            ScrollView {
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
                    Text("이용약관")
                        .font(.system(size: 18))
                        .bold()
                    
                }
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20))
                .navigationBarBackButtonHidden()
                
                VStack {
                    Group {
                        HStack {
                            Text("제1조 (목적)")
                                .bold()
                                .font(.system(size: 15))
                            Spacer()
                        }
                        HStack {
                        Text("이 약관은 “동학대학운동”(이하 \"회사\")가 제공하는 “크루잉”(이하 \"앱\")의 이용과 관련하여 회사와 이용자 간의 권리, 의무, 책임 사항, 기타 필요한 사항을 규정함을 목적으로 합니다.")
                            .font(.system(size: 13))
                            Spacer()
                        }
                        
                        HStack {
                            Text("\n제2조 (정의)")
                                .bold()
                                .font(.system(size: 15))
                            Spacer()
                        }
                        HStack {
                        Text("""
                        1. "앱"이란 회사가 제공하는 모바일 애플리케이션 서비스를 말합니다.
                        2. "이용자"란 본 약관에 따라 회사가 제공하는 앱을 이용하는 모든 고객을 말합니다.
                        3. "계정"이란 이용자가 앱을 이용하기 위해 등록한 아이디(ID)와 비밀번호를 말합니다.
                        4. "콘텐츠"란 앱에서 제공하는 모든 정보, 데이터, 텍스트, 소프트웨어, 음악, 사운드, 사진, 그래픽, 비디오, 메시지 등을 말합니다.
                        """)
                        .font(.system(size: 13))
                            Spacer()
                        }
                    }
                    
                    Group {
                        HStack {
                            Text("\n제3조 (이용약관의 효력 및 변경)")
                                .bold()
                                .font(.system(size: 15))
                            Spacer()
                        }
                        HStack {
                        Text("""
                        1. 본 약관은 앱 초기 화면에 게시하여 공지하며, 이용자가 본 약관에 동의함으로써 효력이 발생합니다.
                        2. 회사는 필요하다고 인정되는 경우 관련 법령을 위배하지 않는 범위 내에서 약관을 변경할 수 있습니다.
                        3. 변경된 약관은 공지사항을 통해 공지하며, 이용자가 변경된 약관에 동의하지 않을 경우 앱 이용을 중단하고 탈퇴할 수 있습니다.
                        """)
                        .font(.system(size: 13))
                            Spacer()
                        }
                        
                        HStack {
                            Text("\n제4조 (이용계약의 성립)")
                                .bold()
                                .font(.system(size: 15))
                            Spacer()
                        }
                        HStack {
                        Text("""
                        1. 이용계약은 이용자가 앱을 다운로드하고 설치하여 본 약관에 동의한 후 회원 가입을 완료함으로써 성립합니다.
                        2. 회사는 특정 이용자에 대해 이용 신청을 거절할 수 있습니다.
                        """)
                        .font(.system(size: 13))
                            Spacer()
                        }
                    }
                    
                    Group {
                        HStack {
                            Text("\n제5조 (개인정보의 보호)")
                                .bold()
                                .font(.system(size: 15))
                            Spacer()
                        }
                        HStack {
                        Text("회사는 이용자의 개인정보를 보호하기 위해 노력하며, 관련 법령에 따라 이용자의 개인정보를 보호합니다. 자세한 내용은 개인정보처리방침에 따릅니다.")
                            .font(.system(size: 13))
                            Spacer()
                        }
                        
                        HStack {
                            Text("\n제6조 (이용자의 의무)")
                                .bold()
                                .font(.system(size: 15))
                            Spacer()
                        }
                        HStack {
                        Text("""
                        1. 이용자는 본 약관 및 관련 법령을 준수하여야 합니다.
                        2. 이용자는 다음 행위를 해서는 안 됩니다.
                            - 타인의 개인정보 도용
                            - 회사의 운영을 방해하는 행위
                            - 불법적이거나 부적절한 콘텐츠 게시
                            - 타인의 권리를 침해하는 행위
                        """)
                        .font(.system(size: 13))
                            Spacer()
                        }
                    }
                    
                    Group {
                        HStack {
                            Text("\n제7조 (회사의 의무)")
                                .bold()
                                .font(.system(size: 15))
                            Spacer()
                        }
                        HStack {
                        Text("""
                        1. 회사는 지속적이고 안정적인 서비스를 제공하기 위해 최선을 다합니다.
                        2. 회사는 이용자로부터 제기되는 의견이나 불만이 정당하다고 인정될 경우 이를 처리합니다.
                        """)
                        .font(.system(size: 13))
                            Spacer()
                        }
                        
                        HStack {
                            Text("\n제8조 (서비스의 제공 및 중단)")
                                .bold()
                                .font(.system(size: 15))
                            Spacer()
                        }
                        HStack {
                        Text("""
                        1. 서비스는 연중무휴, 24시간 제공함을 원칙으로 합니다.
                        2. 회사는 다음 각 호에 해당하는 경우 서비스 제공을 중단할 수 있습니다.
                            - 시스템 점검, 유지보수
                            - 정전, 천재지변, 비상사태 등 불가항력적 사유
                        """)
                        .font(.system(size: 13))
                            Spacer()
                        }
                    }
                    
                    Group {
                        HStack {
                            Text("\n제9조 (계약 해지 및 이용 제한)")
                                .bold()
                                .font(.system(size: 15))
                            Spacer()
                        }
                        HStack {
                        Text("""
                        1. 이용자는 언제든지 앱 내에서 계정 탈퇴를 신청할 수 있으며, 회사는 이를 즉시 처리합니다.
                        2. 회사는 이용자가 본 약관을 위반한 경우 사전 통보 없이 서비스 이용을 제한하거나 계약을 해지할 수 있습니다.
                        """)
                        .font(.system(size: 13))
                            Spacer()
                        }
                        
                        HStack {
                            Text("\n제10조 (책임의 한계)")
                                .bold()
                                .font(.system(size: 15))
                            Spacer()
                        }
                        HStack {
                        Text("""
                        1. 회사는 무료로 제공되는 서비스와 관련하여 발생하는 손해에 대해 책임을 지지 않습니다.
                        2. 회사는 이용자의 고의 또는 과실로 인해 발생한 손해에 대해 책임을 지지 않습니다.
                        """)
                        .font(.system(size: 13))
                            Spacer()
                        }
                    }
                    
                    Group {
                        HStack {
                            Text("\n제11조 (준거법 및 재판관할)")
                                .bold()
                                .font(.system(size: 15))
                            Spacer()
                        }
                        HStack {
                        Text("본 약관은 대한민국 법률에 따라 해석되며, 회사와 이용자 간에 발생한 분쟁에 대해서는 민사소송법상 관할법원에 제소합니다.")
                            .font(.system(size: 13))
                            Spacer()
                        }
                        
                        HStack {
                            Text("\n부칙")
                                .bold()
                                .font(.system(size: 15))
                            Spacer()
                        }
                        HStack {
                        Text("이 약관은 2024년 8월 1일부터 시행됩니다.")
                            .font(.system(size: 13))
                            Spacer()
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden()
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    TermsofServiceView()
}
