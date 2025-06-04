

import SwiftUI

struct AppliedClubsView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var accesstokenStored: _UserAccessToken
    
    @State private var AppliedClubsList: [AppliedClub] = []
    
    // 지원한 동아리 목록 조회
    private func fetchAppliedClubs() {
        NetworkManager.getMyAppliedClubs(accessToken: _UserAccessToken.shared.accessTokenStored) { result in
            switch result {
            case .success(let clubs):
                self.AppliedClubsList = clubs
                print("지원한 동아리 목록: \(AppliedClubsList)")
            case .failure(let error):
                print("지원한 동아리 목록 조회 실패: \(error)")
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

            Text("지원한 동아리")
                .font(.system(size: 18))
                .bold()
        }
        .padding(20)
        .navigationBarBackButtonHidden()
        
        ScrollView {
            ForEach(AppliedClubsList, id: \.clubId) { club in
                NavigationLink(destination: ClubPageView(clubID: club.clubId)) {
                    RecruitmentCardView(clubId: club.clubId, name: club.name, profile: club.profile, clubOneLiner: club.oneLiner, reviewAvg: club.reviewAvg, reviewNum: club.reviewNum, category: club.category, isRecruit: club.isRecruit, recruitmentPeriod: club.recruitmentPeriod)
                }
            }
        }
        .onAppear {
            fetchAppliedClubs() }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

