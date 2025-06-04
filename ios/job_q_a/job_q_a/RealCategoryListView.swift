import SwiftUI

struct RealCategoryListView: View {
    @State private var boardList: [Board] = []
    @State var categoryIndex : Int
    @State private var allClubsList: [Club] = []
    @State private var searchText: String = ""
    @State private var clubsSearched: [Club] = []
    @State private var acceptORreturnClubs: [Club] = []
    @State private var isToggled = false
    @State private var isLoading = false
    
    @EnvironmentObject var accesstokenStored: _UserAccessToken
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let categories = ["전체", "IT/데이터", "사진/촬영", "인문학/독서", "여행", "스포츠", "문화/예술", "댄스", "음악/악기", "봉사활동", "기타"]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack() {
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
                    
                    Text("\(categories[categoryIndex])")
                        .font(.system(size: 18))
                        .bold()
                }
                .padding(20)
                .navigationBarBackButtonHidden()
                
                ScrollView {
                    VStack {
                        if isLoading {
                            ProgressView()
                        } else {
                            LazyVStack(spacing: 10) {
                                ForEach(boardList) { board in
                                    NavigationLink(destination: BoardDetailView(boardId: board.board_id)) {
                                        BoardRowView(board: board)
                                    }
                                }
                            }
                            .padding(.top, 10)
                            .padding(.horizontal, 15)
                        }
                    }
                }
            }

            NavigationLink(destination: PostView()) {
                HStack {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .frame(width: 25, height: 25)
                    Text("글 쓰기")
                        .font(.system(size: 18, weight: .bold))
                }
                .foregroundColor(.white)
                .padding()
                .frame(width: 300)
                .background(Color.blue)
                .cornerRadius(28)
                .shadow(radius: 5)
            }.padding(.bottom, 50)
            
        }
        .onAppear {
            getBoardInfo()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    private func getBoardInfo() {
        NetworkManager.getCategoryBoards(id: categoryIndex) { result in
            switch result {
            case .success(let clubResponse):
                self.boardList = clubResponse
            case .failure(let error):
                print("추천 동아리 API 호출 실패: \(error.localizedDescription)")
            }
        }
    }
}
