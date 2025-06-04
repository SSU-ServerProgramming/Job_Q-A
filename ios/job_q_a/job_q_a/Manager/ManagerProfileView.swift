import SwiftUI

struct ManagerProfileView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var accesstokenStored: _UserAccessToken
    
    @State private var holdClubs: [ClubsByStatus] = []
    @State private var acceptORreturnClubs: [ClubsByStatus] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    
    private func getAcceptClubs() {
        self.isLoading = true
        self.errorMessage = nil
        NetworkManager.getClubsByStatus(page: 0, size: 1000, sort: ["name"], status: "ACCEPT", accessToken: _UserAccessToken.shared.accessTokenStored) { result in
            self.isLoading = false
            switch result {
            case .success(let clubs):
                self.acceptORreturnClubs = clubs.clubs
                print("승인된 동아리 리스트 불러오기 성공")
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                print("승인된 동아리 목록 조회 실패: \(error)")
            }
        }
    }
    
    private func getReturnClubs() {
        self.isLoading = true
        self.errorMessage = nil
        NetworkManager.getClubsByStatus(page: 0, size: 1000, sort: ["name"], status: "RETURN", accessToken: _UserAccessToken.shared.accessTokenStored) { result in
            self.isLoading = false
            switch result {
            case .success(let clubs):
                self.acceptORreturnClubs = clubs.clubs
                print("반려된 동아리 리스트 불러오기 성공")
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                print("반려된 동아리 목록 조회 실패: \(error)")
            }
        }
    }
    
    private func getHoldClubs() {
        self.isLoading = true
        self.errorMessage = nil
        NetworkManager.getClubsByStatus(page: 0, size: 1000, sort: ["name"], status: "HOLD", accessToken: _UserAccessToken.shared.accessTokenStored) { result in
            self.isLoading = false
            switch result {
            case .success(let clubs):
                self.holdClubs = clubs.clubs
                print("승인 요청된 동아리 리스트 불러오기 성공")
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                print("승인 요청된 동아리 목록 조회 실패: \(error)")
            }
        }
    }
    
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack{
                    HStack {
                        // * 뒤로가기 버튼
                        Button(action:{
                            self.presentationMode.wrappedValue.dismiss()}) {
                                HStack(spacing:2) {
                                    Image(systemName: "chevron.backward")
                                    Spacer()
                                }
                                .foregroundColor(.black)
                                .padding(EdgeInsets(top: 20, leading: 25, bottom: 10, trailing: 0))
                            }
                        Spacer()
                    }
                    
                    Text("관리자탭")
                        .font(.system(size: 18))
                        .bold()
                }
                .navigationBarBackButtonHidden()
                
                // * 동아리 승인 요청
                HStack(spacing: 0) {
                    Text("동아리 승인 요청")
                        .bold()
                        .font(.system(size: 16))
                    Text(" (\(holdClubs.count))")
                        .font(.system(size: 16))
                    Spacer()
                    NavigationLink(destination: HoldClubListView().navigationBarBackButtonHidden(true)) {
                        Image(systemName: "chevron.forward")
                            .foregroundColor(Color.black)
                    }
                }
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20))
                
                HStack {
                    ForEach(holdClubs.prefix(4), id: \.clubId) { club in
                        ClubButton(imageName: club.profile ?? "", clubName: club.name ?? "", destination: ClubPageForManagerView(clubID: club.clubId))
                    }
                    Spacer()
                }
                .padding(.horizontal, 15)
                
                // * 동아리 승인/반려 완료 리스트
                HStack(spacing: 0) {
                    Text("동아리 승인/반려 완료")
                        .bold()
                        .font(.system(size: 16))
                    Text(" (\(acceptORreturnClubs.count))")
                        .font(.system(size: 16))
                    Spacer()
                    NavigationLink(destination: ClubApprovalAndRejectionCompletedView().navigationBarBackButtonHidden(true)) {
                        Image(systemName: "chevron.forward")
                            .foregroundColor(Color.black)
                    }
                }
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20))
                
                HStack {
                    ForEach(acceptORreturnClubs.prefix(4), id: \.clubId) { club in
                        ClubButton(imageName: club.profile ?? "", clubName: club.name ?? "", destination: ClubPageView(clubID: club.clubId))
                    }
                    Spacer()
                }
                .padding(.horizontal, 15)
                
                Spacer()
            }
            .onAppear() {
                getHoldClubs()
                getAcceptClubs()
                getReturnClubs()
            }
        }
        .navigationBarBackButtonHidden()
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

