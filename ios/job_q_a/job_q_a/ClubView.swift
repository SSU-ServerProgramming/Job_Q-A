import SwiftUI

struct ClubView: View {
    
    @State private var searchText: String = ""
    @State private var selectedCategoryIndex = 0
    @State private var isToggled = false
    @State private var allClubsList: [Club] = []
    @State private var clubsSearched: [Club] = []
    
    @State private var errorMessage: String?
    @State private var isLoading = false
    
    let categories = ["전체", "IT/데이터", "사진/촬영", "인문학/독서", "여행", "스포츠", "문화/예술", "댄스", "음악/악기", "봉사활동", "기타"]
    
    @EnvironmentObject var accesstokenStored: _UserAccessToken
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var navigateToClubView: Bool
    
    
    // 전체 동아리 조회 API
    private func getAllClubInfo() {
        NetworkManager.getClubs(page: 1, size: 100, sort: ["name"], accessToken: _UserAccessToken.shared.accessTokenStored) { result in
            switch result {
            case .success(let clubResponse):
                self.allClubsList = clubResponse.clubs
                print("동아리 목록: \(allClubsList)")
            case .failure(let error):
                print("전체 동아리 조회 실패: \(error)")
            }
            
        }
    }
    
    // 카테고리 사용시
    var filteredClubs: [Club] {
        var filteredList = allClubsList
        
        if selectedCategoryIndex > 0 { // [전체]가 아닌 카테고리를 선택하는 경우
            filteredList = allClubsList.filter { $0.category == selectedCategoryIndex-1 }
        }
        
        if isToggled { // 모집 중 토글이 true인 경우
            filteredList = filteredList.filter { $0.isRecruit }
        }
        
        print("카테고리 or 모집 중 토글 사용시 : \(filteredList)")
        print("\(filteredList.count)개 있음")
        
        return filteredList
    }
    var filteredSearchedClubs: [Club] {
        var filteredList = clubsSearched
        
        if selectedCategoryIndex > 0 { // [전체]가 아닌 카테고리를 선택하는 경우
            filteredList = clubsSearched.filter { $0.category == selectedCategoryIndex-1 }
        }
        
        if isToggled { // 모집 중 토글이 true인 경우
            filteredList = filteredList.filter { $0.isRecruit }
        }
        
        print("카테고리 or 모집 중 토글 사용시 : \(filteredList)")
        
        return filteredList
    }
    
    
    // 검색어별 동아리 조회
    private func searchClubs() {
        isLoading = true
        errorMessage = ""
        
        NetworkManager.searchClubs(accessToken: _UserAccessToken.shared.accessTokenStored, search: searchText, category: selectedCategoryIndex-1, page: 0, size: 1000) { result in
            isLoading = false
            switch result {
            case .success(let response):
                self.clubsSearched = response.clubs
                print("검색된 동아리 목록: \(clubsSearched)")
            case .failure(let error):
                self.errorMessage = "Error: \(error.localizedDescription)"
            }
        }
    }
    
    
    var body: some View {
        VStack {
            if navigateToClubView {
                ZStack{
                    HStack {
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
                    
                    Text("연합 동아리")
                        .font(.system(size: 18))
                        .bold()
                }
                .navigationBarBackButtonHidden()
            }
            else {
                ZStack {
                    Text("연합 동아리")
                        .font(.system(size: 18))
                        .bold()
                }
                .padding(20)
                .navigationBarBackButtonHidden()
            }
            
            ScrollView {
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color("primary_"))
                            .frame(height: 45)
                        
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color("secondary_"))
                                .onTapGesture {
                                    searchClubs()
                                }
                            TextField("후기가 궁금한 연합 동아리를 검색해보세요 :)", text: $searchText)
                                .foregroundColor(Color("secondary_"))
                                .font(.system(size: 12))
                                .onChange(of: searchText) { newValue in
                                    searchClubs()
                                }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.horizontal)
                    .onSubmit {
                        searchClubs()
                    }
                    
                    
                    HStack {
                        Picker("", selection: $selectedCategoryIndex) {
                            ForEach(0..<categories.count) { index in
                                Text(categories[index])
                                    .tag(index)
                            }
                        }
                        .pickerStyle(.menu)
                        .accentColor(.gray)
                        .padding(5)
                        
                        Spacer()
                        
                        Toggle("모집 중", isOn: $isToggled)
                            .font(.system(size: 13))
                            .frame(width: 95)
                            .padding(10)
                            .tint(Color("accent"))
                        
                    }
                    
                    if isLoading {
                        ProgressView()
                    } else {
                        ForEach(searchText.isEmpty ? filteredClubs : filteredSearchedClubs, id: \.clubId) { club in
                            NavigationLink(destination: ClubPageView(clubID: club.clubId)) {
                                if club.status == "ACCEPT" {
                                    RecruitmentCardView(clubId: club.clubId, name: club.name, profile: club.profile ?? "", clubOneLiner: club.oneLiner,reviewAvg: club.reviewAvg, reviewNum: club.reviewNum, category: club.category, isRecruit: club.isRecruit, recruitmentPeriod: club.recruitmentPeriod)
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            getAllClubInfo() }
        .onTapGesture {
            
        }
        .navigationBarBackButtonHidden()
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
