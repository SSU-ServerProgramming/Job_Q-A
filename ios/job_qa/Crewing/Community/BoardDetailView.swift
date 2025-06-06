import SwiftUI

struct BoardDetailView: View {
    let boardId: Int
    
    @State private var board: BoardDetail?
    @State private var comments: [Comment] = []
    @State private var parentCommentId: Int?
    @FocusState private var isReplyFieldFocused: Bool
    @State private var commentText: String = ""
    @State var is_liked = false
    @State var fake_like = 0
    var body: some View {
        VStack() {
            ScrollView {
                if var board = board {
                    VStack(alignment: .leading, spacing: 16) {
                        // 게시글
                        VStack(alignment: .leading, spacing: 16) {
                            HStack(spacing: 12) {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.gray)
                                
                                VStack(alignment: .leading) {
                                    Text("\(board.writer)") // Int → String
                                        .font(.headline)
                                    Text(board.date)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            Text(board.title)
                                .font(.title3)
                                .bold()
                            
                            Text(board.content)
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                            .padding(.bottom, 20)
                            .padding(.horizontal, 20)
                        
                        Divider().padding(0)
                        
                        //boardActionView
                        HStack {
                            Button(action: {
                                if is_liked {
                                    NetworkManager.deleteLikeBoard(boardId: board.board_id)  // DELETE 호출
                                    is_liked = false
                                    fake_like -= 1

                                } else {
                                    NetworkManager.likeBoard(boardId: board.board_id) {_ in
                                        is_liked = true
                                        fake_like += 1
                                    } // POST 호출
                 
                                }
                            }) {
                                Label {
                                    Text("공감 \(fake_like)")
                                } icon: {
                                    Image(systemName: is_liked ? "hand.thumbsup.fill" : "hand.thumbsup") // ⭐️ 채워진/빈 아이콘
                                }
                            }
                            .padding(.leading, 40)
                            
                            Spacer()
                            
                            Button(action: {
                                parentCommentId = nil
                                isReplyFieldFocused = true
                            }) {
                                Label("댓글 \(board.comment_count)", systemImage: "bubble.right")
                            }
                            .buttonStyle(.borderless)
                            .padding(.trailing, 40)
                        }
                        .padding(.vertical, 0)
                        .foregroundColor(.blue)
                            .padding(.horizontal, 20)
                        
                        Divider().padding(0)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(groupedComments, id: \.comment.comment_id) { group in
                                VStack(alignment: .leading, spacing: 8) {
                                    CommentRow(comment: group.comment, selectedCellId: $parentCommentId, onReplyButtonTap: {
                                        isReplyFieldFocused = true // 상위뷰 TextField 포커스
                                    })
                                        .padding(.leading, 10)

                                    ForEach(group.replies, id: \.comment_id) { reply in
                                        HStack(spacing: 0) {
                                            
                                            
                                            Image(systemName: "arrow.turn.right.up")
                                                .rotationEffect(.degrees(90))
                                                .foregroundColor(.gray)
                                                .padding(.leading, 20)
                                            CommentRow(comment: reply, selectedCellId: $parentCommentId, onReplyButtonTap: {
                                                isReplyFieldFocused = true // 상위뷰 TextField 포커스
                                            })
                                                .padding(.leading, 10)
                                        }
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding()
                }
            }
            HStack {
                TextField("댓글을 입력하세요.", text: $commentText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($isReplyFieldFocused)
                
                Button(action: {
                    NetworkManager.postComment(request: PostCommentRequest(board_id: board?.board_id ?? 0, content: commentText, parent_comment_id: parentCommentId)) {_ in 
                        NetworkManager.fetchBoardDetail(boardId: boardId) { result in
                            switch result {
                            case .success(let response):
                                self.board = response.board
                                self.comments = response.comments
                            case .failure(let error):
                                print("에러22")
                            }
                        }
                    }
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.blue)
                }
            }
            .padding(.vertical, 20)
                .padding(.horizontal, 20)
        }
        .onAppear {
            NetworkManager.fetchBoardDetail(boardId: boardId) { result in
                switch result {
                case .success(let response):
                    self.board = response.board
                    self.comments = response.comments
                    fake_like = response.board.like
                case .failure(let error):
                    print("에러22")
                }
            }
        }
        .navigationTitle(board?.category_name ?? "이상함.")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var groupedComments: [(comment: Comment, replies: [Comment])] {
        let parentComments = comments.filter { $0.parent_comment_id == nil }
        return parentComments.map { parent in
            let replies = comments.filter { $0.parent_comment_id == parent.comment_id }
            return (comment: parent, replies: replies)
        }
    }
}







struct CommentRow: View {
    @ObservedObject var comment: Comment
    @Binding var selectedCellId: Int?
    var onReplyButtonTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(comment.writer)")
                        .font(.headline)
                    Text(comment.content)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            HStack(spacing: 16) {
                
                Spacer()
                HStack(spacing: 20) {
                    Button(action: {
                        selectedCellId = comment.comment_id
                        onReplyButtonTap()
                    }) {
                        Image(systemName: "bubble.right")
                            .foregroundColor(.gray)
                    }
                    
                    Button(action: {
                        likeComment(comment: comment)
                    }) {
                        HStack {
                            Image(systemName: "hand.thumbsup")
                            Text("\(comment.like)")
                                .font(.caption)
                        }
                        .foregroundColor(comment.is_liked ? .red : .gray)
                    }
                }
            }
        }
        .padding(.vertical, 5)
        .background(
            selectedCellId == comment.comment_id ? Color.blue.opacity(0.1) : Color.clear
        )
    }
    
    func likeComment(comment: Comment) {
        if (comment.is_liked) {
            NetworkManager.deleteLikeComment(commentId: comment.comment_id) { result in
                switch result {
                case .success(let response):
                    print(response.message)
                    comment.is_liked.toggle()
                    comment.like -= 1
                case .failure(_):
                    print("에러22")
                }
            }
        } else {
            NetworkManager.likeComment(commentId: comment.comment_id) { result in
                switch result {
                case .success(let response):
                    print(response.message)
                    comment.like += 1
                    comment.is_liked.toggle()
                case .failure(_):
                    print("에러22")
                }
            }
        }
    }
}



