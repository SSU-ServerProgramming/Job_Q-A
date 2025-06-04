import SwiftUI

struct BoardDetailView: View {
    let boardId: Int
    
    @State private var board: BoardDetail?
    @State private var comments: [Comment] = []
    @State private var parentCommentId: Int?
    @FocusState private var isReplyFieldFocused: Bool
    @State private var commentText: String = ""
    
    var body: some View {
        VStack() {
            ScrollView {
                if let board = board {
                    VStack(alignment: .leading, spacing: 16) {
                        BoardHeaderView(board: board)
                            .padding(.bottom, 20)
                            .padding(.horizontal, 20)
                        
                        Divider().padding(0)
                        
                        BoardActionView(onReplyButtonTap: {
                            isReplyFieldFocused = true // 상위뷰 TextField 포커스
                        }, board: board, parent: $parentCommentId)
                            .padding(.horizontal, 20)
                        
                        Divider().padding(0)
                        
                        CommentListView(onReplyButtonTap: {
                            isReplyFieldFocused = true // 상위뷰 TextField 포커스
                        }, selectedCellId: $parentCommentId, comments: comments)
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
                    NetworkManager.postComment(request: PostCommentRequest(board_id: board?.board_id ?? 0, content: commentText, parent_comment_id: parentCommentId))
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
                case .failure(let error):
                    print("에러22")
                }
            }
        }
        .navigationTitle(board?.category_name ?? "이상함.")
        .navigationBarTitleDisplayMode(.inline)
    }

}
struct BoardHeaderView: View {
    let board: BoardDetail
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
                
                VStack(alignment: .leading) {
                    Text("\(board.writer)") // Int → String
                        .font(.headline)
                    Text(board.category_name)
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
    }
}
struct BoardActionView: View {
    var onReplyButtonTap: () -> Void
    let board: BoardDetail
    @State var isMine: Bool = true
    @State var isMyLike: Bool = false
    @Binding var parent: Int?
    
    var body: some View {
        HStack {
            Button(action: {
                if isMyLike {
                    NetworkManager.deleteLikeBoard(boardId: board.board_id)  // DELETE 호출
                    isMyLike = false

                } else {
                    NetworkManager.likeBoard(boardId: board.board_id)   // POST 호출
                    isMyLike = true
                    
                }
            }) {
                Label {
                    Text("공감 \(board.like)")
                } icon: {
                    Image(systemName: isMyLike ? "hand.thumbsup.fill" : "hand.thumbsup") // ⭐️ 채워진/빈 아이콘
                }
            }
            .padding(.leading, 40)
            
            Spacer()
            
            Button(action: {
                parent = nil
                onReplyButtonTap()
            }) {
                Label("댓글 \(board.comment_count)", systemImage: "bubble.right")
            }
            .buttonStyle(.borderless)
            .padding(.trailing, 40)
        }
        .padding(.vertical, 0)
        .foregroundColor(.blue)
    }
}

struct CommentListView: View {
    var onReplyButtonTap: () -> Void
    @Binding var selectedCellId: Int?
    @State var comments: [Comment] // <-- 배열은 State로 유지

    private var groupedComments: [(comment: Comment, replies: [Comment])] {
        let parentComments = comments.filter { $0.parent_comment_id == nil }
        return parentComments.map { parent in
            let replies = comments.filter { $0.parent_comment_id == parent.comment_id }
            return (comment: parent, replies: replies)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(groupedComments, id: \.comment.comment_id) { group in
                VStack(alignment: .leading, spacing: 8) {
                    CommentRow(comment: group.comment, selectedCellId: $selectedCellId, onReplyButtonTap: onReplyButtonTap)
                        .padding(.leading, 20)

                    ForEach(group.replies) { reply in
                        CommentRow(comment: reply, selectedCellId: $selectedCellId, onReplyButtonTap: onReplyButtonTap)
                            .padding(.leading, 60)
                    }
                }
            }
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
                    
                    Button(action: {
                        // 더보기
                    }) {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.degrees(90))
                            .foregroundColor(.gray)
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


