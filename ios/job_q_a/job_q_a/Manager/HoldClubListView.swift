import SwiftUI

struct HoldClubListView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var accesstokenStored: _UserAccessToken
    
    @State private var clubs: [ClubsByStatus] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    
    private func getHoldClubs() {
        self.isLoading = true
        self.errorMessage = nil
        NetworkManager.getClubsByStatus(page: 0, size: 1000, sort: ["name"], status: "HOLD", accessToken: _UserAccessToken.shared.accessTokenStored) { result in
            self.isLoading = false
            switch result {
            case .success(let clubs):
                self.clubs = clubs.clubs
                print("승인 요청된 동아리: \(clubs)")
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                print("승인 요청된 동아리 목록 조회 실패: \(error)")
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
            
            Text("동아리 승인 요청")
                .font(.system(size: 18))
                .bold()
        }
        .padding(20)
        .navigationBarBackButtonHidden()
        .onAppear() {
            self.getHoldClubs()
        }
        
        
        ScrollView {
            VStack {
                ForEach(clubs, id: \.clubId) { club in
                    NavigationLink(destination: ClubPageForManagerView(clubID: club.clubId)) {
                        RecruitmentCardView(clubId: club.clubId, name: club.name, profile: club.profile ?? "", clubOneLiner: club.oneLiner, reviewAvg: Double(club.reviewAvg), reviewNum: club.reviewNum, category: club.category, isRecruit: club.isRecruit, recruitmentPeriod: "\(club.recruitStartDate) ~ \(club.recruitEndDate)")
                    }
                }
                
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


