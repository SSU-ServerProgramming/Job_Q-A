import SwiftUI

struct MyClubsView: View {
    
    @State private var myClubsList: [MyClub]?
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var accesstokenStored: _UserAccessToken
    
    // 활동 중인 동아리 조회 API
    private func fetchMyClubs() {
        NetworkManager.getMyClubs(page: 0, size: 10, sort: ["기타"], accessToken: _UserAccessToken.shared.accessTokenStored) { result in
            switch result {
            case .success(let myClubsResponse):
                self.myClubsList = myClubsResponse.clubs
                print("활동 중인 동아리: \(myClubsList)")
            case .failure(let error):
                print("활동 중인 동아리 조회 실패: \(error)")
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
            
            Text("활동 중인 동아리")
                .font(.system(size: 18))
                .bold()
        }
        .padding(20)
        .navigationBarBackButtonHidden()
        
        ScrollView {
            if let myClubsList = myClubsList {
                ForEach(myClubsList, id: \.clubId) { club in
                    NavigationLink(destination: ClubPageView(clubID: club.clubId)) {
                        RecruitmentCardView(clubId: club.clubId, name: club.name, profile: club.profile ?? "", clubOneLiner: club.oneLiner, reviewAvg: club.reviewAvg, reviewNum: club.reviewNum, category: club.category, isRecruit: club.isRecruit, recruitmentPeriod: "\(club.recruitmentPeriod)")
                    }
                }
            }
        }
        .onAppear {
            fetchMyClubs() }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
