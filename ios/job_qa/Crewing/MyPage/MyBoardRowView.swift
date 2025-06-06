//
//  MyBoardView.swift
//  Crewing
//
//  Created by 김수민 on 6/4/25.
//

import SwiftUI

struct MyBoardRowView: View {
    let board: Board
    @State var selectedTab: Int = 0
    @State private var showEditModal = false
    @State private var editedTitle = ""
    @State private var editContent = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    var onEditSuccess: () -> Void // ✅ 콜백 추가
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .frame(width: 50, height:50)
                    .foregroundColor(.white)
                Image(systemName: "person")
                    .resizable()
                    .frame(width: 35, height: 35)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(board.title)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 15, weight : .bold))
                    .foregroundColor(.black)
                    .lineLimit(2)
                
                Text(board.category_name)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("\(board.like)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    HStack(spacing: 4) {
                        Image(systemName: "bubble.right.fill")
                            .foregroundColor(.gray)
                        Text("\(board.comment_count)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 4)
            }
            
            Spacer()
            // ⭐️ 여기 편집 & 삭제 버튼
            HStack(spacing: 8) {
                Button(action: {
                    showEditModal = true
                }) {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.blue)
                }
                
                Button(action: {
                    deleteBoard(boardId: board.board_id)
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Color.gray10)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .sheet(isPresented: $showEditModal) {
            VStack(spacing: 20) {
                ScrollView {
                    Text("게시글 수정")
                        .font(.headline)
                        .padding(.top, 5)
                    VStack(alignment: .leading, spacing: 5) {
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
                    VStack(spacing: 0) {
                        
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $editedTitle)
                                .font(.system(size: 15))
                                .frame(height: 40)
                                .padding(.horizontal, 10)
                                .keyboardType(.default)
                                .autocapitalization(.none)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray60, lineWidth: 1))
                                .padding(.vertical, 10)
                            
                            if editedTitle.isEmpty {
                                Text("제목을 입력해주세요.")
                                    .font(.system(size: 15))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(.gray60)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 20)
                            }
                            
                            
                        }
                    }
                    VStack(spacing: 0) {
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $editContent)
                                .font(.system(size: 15))
                                .frame(height: 500)
                                .padding(.horizontal, 10)
                                .keyboardType(.default)
                                .autocapitalization(.none)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray60, lineWidth: 1))
                                .padding(.vertical, 10)
                            
                            if editContent.isEmpty {
                                Text("사람들과 자유롭게 얘기해보세요. \n#취업 #면접")
                                    .font(.system(size: 15))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(.gray60)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 20)
                            }
                        }
                    }
                    
                }
                Button(action: {
                    editBoard(boardId: board.board_id, editedTitle: editedTitle, editedContent: editContent, categoryId: selectedTab)
                    showEditModal = false
                }) {
                    Text("수정 완료")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                }
            }
            .onAppear(perform: {
                editedTitle = board.title // 수정할 글 세팅
                editContent = board.content
            })
            .padding()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("수정 완료"),
                message: Text(alertMessage),
                dismissButton: .default(Text("확인"))
            )
        }

    }
    
    // ✅ 수정 API
    func editBoard(boardId: Int, editedTitle: String, editedContent: String, categoryId: Int) {
        print("\(boardId),\(editedTitle), \(editedContent), \(categoryId)")
        // 여기에 실제 수정 API 요청
        NetworkManager.editBoard(board_id: boardId, requestBody: EditRequest(title: editedTitle, content: editedContent,  category_id: categoryId )) { result in
            switch result {
            case .success(let response):
                print("수정 성공: \(response)")
                self.alertMessage = "게시글이 성공적으로 수정되었습니다."
                self.showAlert = true
                onEditSuccess()
            case .failure(let error):
                print("수정 실패: \(error)")
            }
        }
    }
    
    // ✅ 삭제 API
    func deleteBoard(boardId: Int) {
        NetworkManager.deleteBoard(board_id: boardId, category_id: selectedTab+1) { result in
            switch result {
            case .success(let response):
                print("삭제 성공: \(response)")
                // 삭제 후 리스트 갱신 필요하면 상위 뷰에 콜백 주는 것도 방법
                onEditSuccess()
            case .failure(let error):
                print("삭제 실패: \(error)")
            }
        }
    }
}
