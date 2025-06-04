import SwiftUI

struct ClubApprovalAndRejectionCompletedView: View {
    
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var accesstokenStored: _UserAccessToken
    
    @State private var acceptClubs: [ClubsByStatus] = []
    @State private var returnClubs: [ClubsByStatus] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    
    private func getAcceptClubs() {
        self.isLoading = true
        self.errorMessage = nil
        NetworkManager.getClubsByStatus(page: 0, size: 1000, sort: ["name"], status: "ACCEPT", accessToken: _UserAccessToken.shared.accessTokenStored) { result in
            self.isLoading = false
            switch result {
            case .success(let clubs):
                self.acceptClubs = clubs.clubs
                print("승인된 동아리 목록 조회: \(clubs)")
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
                self.returnClubs = clubs.clubs
                print("반려된 동아리 목록 조회: \(clubs)")
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                print("반려된 동아리 목록 조회 실패: \(error)")
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
            
            Text("동아리 승인/반려 완료")
                .font(.system(size: 18))
                .bold()
        }
        .padding(20)
        .navigationBarBackButtonHidden()
        
        
        ScrollView {
            VStack(alignment: .leading) {
                // * 승인된 동아리 목록
                Text("승인된 동아리")
                    .font(.headline)
                    .padding(.leading)
                
                ForEach(acceptClubs, id: \.clubId) { club in
                    NavigationLink(destination: ClubPageView(clubID: club.clubId)) {
                        ClubCardForManagerView(
                            clubId: club.clubId,
                            name: club.name ?? "",
                            profile: club.profile ?? "없음",
                            reviewAvg: Double(club.reviewAvg),
                            reviewNum: club.reviewNum,
                            category: club.category,
                            isRecruit: club.isRecruit,
                            recruitmentPeriod: "\(club.recruitStartDate) - \(club.recruitEndDate)",
                            status: "승인"
                        )
                    }
                    .padding(.bottom, 5)
                }
                
                // * 반려된 동아리 목록
                Text("반려된 동아리")
                    .font(.headline)
                    .padding(.leading)
                    .padding(.top)
                
                ForEach(returnClubs, id: \.clubId) { club in
                    NavigationLink(destination: ClubPageView(clubID: club.clubId)) {
                        ClubCardForManagerView(
                            clubId: club.clubId,
                            name: club.name ?? "",
                            profile: club.profile ?? "없음",
                            reviewAvg: Double(club.reviewAvg),
                            reviewNum: club.reviewNum,
                            category: club.category,
                            isRecruit: club.isRecruit,
                            recruitmentPeriod: "\(club.recruitStartDate) - \(club.recruitEndDate)",
                            status: "반려"
                        )
                    }
                    .padding(.bottom, 5)
                }
            }
        }.onAppear {
            getAcceptClubs()
            getReturnClubs()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

