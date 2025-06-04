////
////  PreSurveyView.swift
////  MaiN
////
////  Created by Jihun Song on 1/24/25.
////
//


import SwiftUI
import Moya
struct PostView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var selectedTab: Int = 0

    @State var showAlert = false
    @State var isSaveable = false
    @State var title = ""
    @State var content = ""
    var body: some View {
        VStack(spacing: 0) {
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
                
                Text("글 쓰기")
                    .font(.system(size: 18))
                    .bold()
            
                HStack() {
                    Spacer()
                    Button(action: {postBoard()}) {
                        Text("완료")
                            .font(.system(size: 18))
                            .bold()
                            .foregroundColor(.blue)
                            .padding(5)
                    }
                }
            
        
            }
            .padding(15)
            .navigationBarBackButtonHidden()

            VStack(alignment: .leading, spacing: 18) {
                Text("카테고리")
                    .padding(.horizontal, 2)
                ScrollView(.horizontal, showsIndicators: false){
                        HStack {
                            TabButton(title: 0, selectedTab: $selectedTab)
                            TabButton(title: 1, selectedTab: $selectedTab)
                            TabButton(title: 2, selectedTab: $selectedTab)
                            TabButton(title: 3, selectedTab: $selectedTab)
                            TabButton(title: 4, selectedTab: $selectedTab)
                            TabButton(title: 5, selectedTab: $selectedTab)
                            TabButton(title: 6, selectedTab: $selectedTab)
                            TabButton(title: 7, selectedTab: $selectedTab)
                            TabButton(title: 8, selectedTab: $selectedTab)
                            TabButton(title: 9, selectedTab: $selectedTab)
                        }
                }
            }
            .padding(.horizontal)
            
            ScrollView {
                VStack(spacing: 0) {
                    
                    VStack(spacing: 0) {
                        
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $title)
                                .font(.system(size: 15))
                                .frame(height: 40)
                                .padding(.horizontal, 10)
                                .keyboardType(.default)
                                .autocapitalization(.none)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray60, lineWidth: 1))
                                .padding(.vertical, 10)
                            
                            if title.isEmpty {
                                Text("제목을 입력해주세요.")
                                    .font(.system(size: 15))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(.gray60)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 20)
                            }
                            
                            
                        }
                    }
                    .padding(.top, 5)
                    
                    VStack(spacing: 0) {
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $content)
                                .font(.system(size: 15))
                                .frame(height: 500)
                                .padding(.horizontal, 10)
                                .keyboardType(.default)
                                .autocapitalization(.none)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray60, lineWidth: 1))
                                .padding(.vertical, 10)
                            
                            if content.isEmpty {
                                Text("사람들과 자유롭게 얘기해보세요. \n#취업 #면접")
                                    .font(.system(size: 15))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(.gray60)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 20)
                            }
                        }
                    }
                    .padding(.top, 0)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 20)
            }
        }
        .frame(maxWidth: .infinity)
        .onTapGesture {
            self.endTextEditing()
        }
        .navigationBarHidden(true)
    }
    
    private func postBoard() {
        let provider = MoyaProvider<BoardService>()

        let request = PostBoardRequest(title: title, category_id: selectedTab, content: content)
        provider.request(.postBoard(request)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(smallAPIResponse.self, from: response.data)
                    print(decoded.message)
                } catch {
                    print("파싱 에러: \(error)")
                }
            case .failure(let error):
                print("요청 실패: \(error)")
            }
        }
    }
    
}

struct TabButton: View {
    let title: Int
    @Binding var selectedTab: Int
    let categories = [
        "IT/데이터",
        "사진/촬영",
        "인문학/독서",
        "여행",
        "스포츠",
        "문화/예술",
        "댄스",
        "음악/악기",
        "봉사활동",
        "기타"
    ]
    var body: some View {
        Button(action: {
            self.selectedTab = title
        }) {
            Text(categories[title])
                .font(.system(size: 13))
                .padding()
                .frame( height: 25)
                .background(self.selectedTab == title ? .blue : Color.white)
                .foregroundColor(self.selectedTab == title ? .white : .black)
                .clipShape(Capsule())
                .overlay (
                    Capsule().stroke(.blue)
                )
        }
    }
}


extension View {
    func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct PostBoardRequest: Codable {
    let title: String
    let category_id: Int
    let content: String
}

struct PostCommentRequest: Codable {
    let board_id: Int
    let content: String
    let parent_comment_id: Int?
}
