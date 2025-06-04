//
//  MyPostView.swift
//  Crewing
//
//  Created by 김수민 on 6/3/25.
//

import SwiftUI

struct MyPostView: View {
    @State private var boardList: [Board] = []
    
    private func getMyPostBoard() {
        NetworkManager.getMyPostBoard() { result in
            switch result {
            case .success(let clubResponse):
                self.boardList = clubResponse
            case .failure(_):
                print("error")
                
            }
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(boardList) { board in
                    NavigationLink(destination: BoardDetailView(boardId: board.board_id)) {
                        BoardRowView(board: board)
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
    MyPostView()
}
