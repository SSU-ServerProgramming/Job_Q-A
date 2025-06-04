import SwiftUI

struct GeneralSettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    
    @State private var isShowingLogoutPopup: Bool = false
    @State private var isShowingDeleteAccountPopup: Bool = false
    @State private var toPrivacyPolicyView = false
    @State private var toTermsofServiceView = false
    
    var body: some View {
        VStack {
            ZStack {
                Button(action:{
                    self.presentationMode.wrappedValue.dismiss()}) {
                        HStack(spacing:2) {
                            Image(systemName: "chevron.backward")
                            Spacer()
                        }
                        .foregroundColor(.black)
                    }
                
                Text("환경설정")
                    .font(.system(size: 18))
                    .bold()
            }
            .padding(20)
            .navigationBarBackButtonHidden()
            
            List {
                HStack {
                    Text("앱 버전")
                        .font(.system(size: 15))
                    Spacer()
                    Text(version)
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Text("개인정보 처리방침")
                        .font(.system(size: 15))
                    Spacer()
                }
                .onTapGesture {
                    self.toPrivacyPolicyView = true
                }
                
                HStack {
                    Text("이용약관")
                        .font(.system(size: 15))
                    Spacer()
                }
                .onTapGesture {
                    self.toTermsofServiceView = true
                }
                
                HStack {
                    Text("로그아웃")
                        .font(.system(size: 15))
                    Spacer()
                }
                .onTapGesture {
                    isShowingLogoutPopup = true
                }
                
                HStack {
                    Text("회원 탈퇴")
                        .font(.system(size: 15))
                    Spacer()
                }
                .onTapGesture {
                    isShowingDeleteAccountPopup = true
                }
            }
            .listStyle(.plain)
            
            NavigationLink(destination: PrivacyPolicyView(), isActive: $toPrivacyPolicyView) {
                EmptyView()
            }
            NavigationLink(destination: TermsofServiceView(), isActive: $toTermsofServiceView) {
                EmptyView()
            }
        }
        .navigationBarBackButtonHidden()
        .navigationViewStyle(StackNavigationViewStyle())
        .overlay(
            Group {
                if isShowingLogoutPopup {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                    LogoutPopupView(isShowingLogoutPopup: $isShowingLogoutPopup)
                        .frame(width: 350, height: 180)
                        .background(Color.white)
                        .cornerRadius(20)
                        .overlay(
                            Button(action: {
                                withAnimation {
                                    self.isShowingLogoutPopup = false
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
                if isShowingDeleteAccountPopup {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                    DeleteAccountPopupView(isShowingDeleteAccountPopup: $isShowingDeleteAccountPopup)
                        .frame(width: 350, height: 180)
                        .background(Color.white)
                        .cornerRadius(20)
                        .overlay(
                            Button(action: {
                                withAnimation {
                                    self.isShowingDeleteAccountPopup = false
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
}
