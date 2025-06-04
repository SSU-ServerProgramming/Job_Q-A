import Foundation

struct SignUpRequest: Codable {
    let birth: String?
    let gender: String?
    let name: String
    let nickname: String
    let interests: [String]?
}

struct IdPwSignUpRequest: Codable {
    let nickname: String
    let email: String
    let password: String
}

struct loginRequest: Codable {
    let email: String
    let password : String
}

struct LoginRequest: Codable {
    let oauthAccessToken: String
}

struct BoardDetailData: Decodable {
    let board: BoardDetail
    let comments: [Comment]
}

struct BoardDetail: Decodable {
    let board_id: Int
    let category_name: String
    let comment_count: Int
    let content: String
    let date: String
    let like: Int
    let title: String
    let writer: String
}

class Comment: ObservableObject, Identifiable, Decodable {
    var id: Int { comment_id }
    let comment_id: Int
    let content: String
    @Published var like: Int
    let parent_comment_id: Int?
    let writer: String

    @Published var is_liked: Bool = false

    enum CodingKeys: String, CodingKey {
        case comment_id, content, like, parent_comment_id, writer, is_liked
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.comment_id = try container.decode(Int.self, forKey: .comment_id)
        self.content = try container.decode(String.self, forKey: .content)
        self.like = try container.decode(Int.self, forKey: .like)
        self.parent_comment_id = try container.decodeIfPresent(Int.self, forKey: .parent_comment_id)
        self.writer = try container.decode(String.self, forKey: .writer)

        // is_liked는 서버에서 내려줄 수도 있고 안 내려줄 수도 있으면 이렇게:
        self.is_liked = (try? container.decode(Bool.self, forKey: .is_liked)) ?? false
    }
}


struct MyComment: Decodable, Identifiable {
    var id: Int { comment_id }
    let board_id: Int
    let comment_id: Int
    let content: String
    let date: String
}

struct CreateClubRequest: Codable {
    let name: String
    let oneLiner: String
    let introduction: String
    let application: String
    let category: Int
    let isRecruit: Bool
    let isOnlyStudent: Bool
    let docDeadLine: String
    let docResultDate: String
    let interviewStartDate: String
    let interviewEndDate: String
    let finalResultDate: String
}


struct ReviewCreateRequest: Codable {
    let clubId: Int
    let review: String
    let rate: Int
}


struct EmailSignUpRequest: Codable {
    let birth: String?
    let gender: String?
    let name: String
    let nickname: String
    let interests: [String]?
    let email: String
    let verified: Bool
}

struct DeviceRequest: Codable {
    let fcmToken: String
    let model: String
    let os: String
    let osVersion: String
    let appVersion: String
    let codePushVersion: String
}

