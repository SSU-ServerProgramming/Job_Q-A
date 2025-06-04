//
//  MyPostCommentView.swift
//  Crewing
//
//  Created by 김수민 on 6/3/25.
//

import SwiftUI

struct MyPostCommentView: View {
    @State private var commentList: [MyComment] = []
    
    private func getMyPostBoard() {
        NetworkManager.getMyPostComment() { result in
            switch result {
            case .success(let clubResponse):
                self.commentList = clubResponse
            case .failure(_):
                print("error")
                
            }
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(commentList) { comment in
                    NavigationLink(destination: BoardDetailView(boardId: comment.board_id)) {
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.gray)
                            
                            VStack(alignment: .leading) {
                                Text("\(comment.content)")
                                    .font(.headline)
                                Text(comment.date)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .padding(.top, 10)
        }
        .onAppear(perform: {
            getMyPostBoard()
        })
    }
}

#Preview {
    MyPostCommentView()
}
