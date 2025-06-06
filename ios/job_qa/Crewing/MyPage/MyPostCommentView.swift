//
//  MyPostCommentView.swift
//  Crewing
//
//  Created by 김수민 on 6/3/25.
//

import SwiftUI

struct MyPostCommentView: View {
    @State private var commentList: [MyComment] = []
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(commentList) { comment in
                    NavigationLink(destination: BoardDetailView(boardId: comment.board_id)) {
                        MyCommentRowView(comment: comment, commentList: $commentList                            ,onEditSuccess: {
                            getMyPostBoard() // ✅ 수정 성공 시 리스트 다시 불러오기
                        })
                    }
                }
            }
            .padding(.top, 10)
        }
        .onAppear(perform: {
            getMyPostBoard()
        })
    }
    private func getMyPostBoard() {
        print("!!!!")
        NetworkManager.getMyPostComment() { result in
            switch result {
            case .success(let clubResponse):
                self.commentList = clubResponse
            case .failure(_):
                print("error")
                
            }
        }
    }
}



struct MyCommentRowView: View {
    let comment: MyComment
    @State private var showEditModal = false
    @State private var editedContent = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @Binding var commentList: [MyComment]
    var onEditSuccess: () -> Void // ✅ 콜백 추가
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                Image(systemName: "person")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(comment.content)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.black)
                
                Text(comment.content)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                Button(action: {
                    editedContent = comment.content
                    showEditModal = true
                }) {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.blue)
                }
                
                Button(action: {
                    deleteComment(commentId: comment.comment_id)
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
        .background(Color.gray10)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
        .sheet(isPresented: $showEditModal) {
            VStack(spacing: 20) {
                Text("댓글 수정")
                    .font(.headline)
                
                TextEditor(text: $editedContent)
                    .font(.system(size: 14))
                    .frame(height: 200)
                    .padding(.horizontal, 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray60, lineWidth: 1)
                    )
                    .padding(.vertical, 10)
                
                Spacer()
                Button(action: {
                    editComment(commentId: comment.comment_id, editedContent: editedContent)
                    showEditModal = false
                    self.alertMessage = "게시글이 성공적으로 수정되었습니다."
                    self.showAlert = true
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
    func editComment(commentId: Int, editedContent: String) {
        NetworkManager.editComment(comment_id: commentId, content: editedContent) { result in
            switch result {
            case .success(let response):
                print("수정 성공: \(response)")
                // 수정 후 화면 새로고침 필요하면 상위 뷰에 콜백 주는 것도 방법
                onEditSuccess()
            case .failure(let error):
                print("수정 실패: \(error)")
            }
        }
    }
    
    // ✅ 삭제 API
    func deleteComment(commentId: Int) {
        NetworkManager.deleteComment(comment_id: commentId) { result in
            switch result {
            case .success(let response):
                print("삭제 성공: \(response)")
                onEditSuccess()
            case .failure(let error):
                print("삭제 실패: \(error)")
            }
        }
    }
}


#Preview {
    MyPostCommentView()
}
