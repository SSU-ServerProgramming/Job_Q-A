
import SwiftUI

struct RecommendedListView: View {
    
    @State private var searchText: String = ""
    
    // 모집 중 토글의 상태
    @State private var isToggled = false
    @State private var recommendedClubsList: [Board] = []
    @State private var errorMessage: String?
    @State private var isLoading = false
    @State private var clubsSearched: [Board] = []
    
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    // 추천 동아리 목록 조회 API
    private func getRecommendedClubs() {
        NetworkManager.getRecommendedClubs() { result in
            switch result {
            case .success(let clubResponse):
                self.recommendedClubsList = clubResponse
                self.clubsSearched = clubResponse
            case .failure(let error):
                print("추천 동아리 API 호출 실패: \(error.localizedDescription)")
            }
        }
    }
    

    
    var body: some View {
        
        
        ZStack {
            Button(action:{
                self.presentationMode.wrappedValue.dismiss()}) {
                    HStack(spacing:2) {
                        Image(systemName: "chevron.backward")
                        Text("홈")
                            .font(.system(size: 15))
                        Spacer()
                    }
                    .foregroundColor(.black)
                }
            
            Text("실시간 인기글")
                .font(.system(size: 18))
                .bold()
        }
        .padding(20)
        .navigationBarBackButtonHidden()
        
        
        ScrollView {
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("primary_"))
                        .frame(height: 45)
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color("secondary_"))
                        TextField("후기가 궁금한 연합 동아리를 검색해보세요 :)", text: $searchText, onCommit: {
                            getRecommendedClubs() // 검색어가 변경될 때마다 API 호출
                        })
                        .foregroundColor(Color("secondary_"))
                        .font(.system(size: 12))
                    }
                    .padding(.horizontal)
                }
                .padding(.horizontal)
                .onTapGesture {
                    getRecommendedClubs()
                }
                
                
                HStack {
                    Spacer()
                    
                    Toggle("모집 중", isOn: $isToggled)
                        .font(.system(size: 13))
                        .frame(width: 95)
                        .padding(8)
                        .tint(Color("accent"))
                    
                }
                
                if isLoading {
                    ProgressView()
                } else {
//                    ForEach(searchText.isEmpty ? filteredClubs : filteredSearchedClubs, id: \.clubId) { club in
//                        NavigationLink(destination: ClubPageView(clubID: club.clubId)) {
//                            if club.status == "ACCEPT" {
//                                RecruitmentCardView(clubId: club.clubId, name: club.name, profile: club.profile ?? "", clubOneLiner: club.oneLiner, reviewAvg: club.reviewAvg, reviewNum: club.reviewNum, category: club.category, isRecruit: club.isRecruit, recruitmentPeriod: club.recruitmentPeriod)
//                            }
//                        }
//                    }
                }
                
            }
        }
        .onAppear() {
            getRecommendedClubs()
        }
        .navigationViewStyle(StackNavigationViewStyle())
  
    }
}

