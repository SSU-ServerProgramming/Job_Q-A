//
//  BoardService.swift
//  Crewing
//
//  Created by 김수민 on 6/4/25.
//

import Foundation
import Moya

enum BoardService {
    case postBoard(PostBoardRequest)
}

extension BoardService: TargetType {
    var baseURL: URL {
        return URL(string: "http://localhost:8000")!
    }
    
    var path: String {
        switch self {
        case .postBoard:
            return "/board/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postBoard:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .postBoard(let request):
            
            return .requestJSONEncodable(request)
        }
    }
    
    var headers: [String: String]? {
        return [
            "Authorization": "Bearer \(loadAccessToken()!)",
            "Content-Type": "application/json"
        ]
    }
}

