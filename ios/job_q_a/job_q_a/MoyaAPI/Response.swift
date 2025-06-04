import Foundation

// API 응답 모델 구조체 추가
struct LoginResponse: Decodable {
    let needSignUp: Bool
    let tokenResponse: TokenResponse
}

struct TokenResponse: Decodable {
    let accessToken: String
    let refreshToken: String
}

struct LoginForEmailResponse: Codable {
    let verifyResult: Bool
    let needSignUp: Bool
    let tokenResponse: TokenForEmailResponse
}

struct TokenForEmailResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let role: String?
}

struct IdPwLoginResponse: Codable {
    let access_token: String
    let company_id: Int
    let email: String
    let id: Int
    let nickname: String
    let refresh_token: String
}


// 전체 동아리 조회 - ClubView
struct ClubResponse: Codable {
    let pageNum: Int
    let pageSize: Int
    let totalCnt: Int
    let clubs: [Club]
}

struct Board: Decodable, Identifiable {
    var id: Int { board_id } // board_id를 id로 사용
    
    let board_id: Int            // board_id
    let category_name: String
    let comment_count: Int
    let content: String
    let date: String
    let like: Int
    let title: String
    let writer: String
}

struct Club: Codable, Identifiable {
    let clubId: Int
    let name: String
    let oneLiner: String
    let reviewAvg: Double
    let reviewNum: Int
    let latestReview: String?
    let profile: String?
    let category: Int
    let status: String
    let isRecruit: Bool
    let isOnlyStudent: Bool?
    let docDeadLine: String?
    let docResultDate: String?
    let interviewStartDate: String?
    let interviewEndDate: String?
    let finalResultDate: String?
    
    var id: Int {
        return clubId
    }
    
    var recruitmentPeriod: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd-HH:mm"
        
        guard let endDateString = docDeadLine,
              let endDate = formatter.date(from: endDateString) else {
            return "Invalid date"
        }
        
        let currentDate = Date()
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.day], from: currentDate, to: endDate)
        
        if let daysRemaining = components.day {
            if daysRemaining > 0 {
                return "D-\(daysRemaining)"
            } else if daysRemaining == 0 {
                return "D-Day"
            } else {
                return "모집마감"
            }
        } else {
            return "Invalid date calculation"
        }

    }
    
}


// 유저 정보 조회 - ProfileView
struct UserInfoResponse: Codable {
    let company_name: String
    let email: String
    let nickname: String
    let user_id: Int
}

struct UserInterest: Codable {
    let interest: String
}


// 활동 중인 동아리 조회 - MyClubsView
struct MyClubsResponse: Decodable {
    let pageNum: Int
    let pageSize: Int
    let totalCnt: Int
    let clubs: [MyClub]
}

struct MyClub: Decodable {
    let clubId: Int
    let name: String
    let oneLiner: String
    let reviewAvg: Double
    let reviewNum: Int
    let profile: String?
    let category: Int
    let status: String
    let isRecruit: Bool
    let isOnlyStudent: Bool?
    let docDeadLine: String?
    let docResultDate: String?
    let interviewStartDate: String?
    let interviewEndDate: String?
    let finalResultDate: String?
    
    var recruitmentPeriod: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd-HH:mm"
        
        guard let endDateString = docDeadLine,
              let endDate = formatter.date(from: endDateString) else {
            return "Invalid date"
        }
        
        let currentDate = Date()
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.day], from: currentDate, to: endDate)
        
        if let daysRemaining = components.day {
            if daysRemaining > 0 {
                return "D-\(daysRemaining)"
            } else if daysRemaining == 0 {
                return "D-Day"
            } else {
                return "모집마감"
            }
        } else {
            return "Invalid date calculation"
        }

    }
}

struct MyClubImage: Codable {
    let fileId: Int
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case fileId
        case imageUrl
    }
}


// 동아리 생성 API - ClubRegistrationVIew
struct CreateClubResponse: Codable {
    struct ClubImage: Codable {
        let fileId: Int
        let imageUrl: String
    }
    
    let clubId: Int
    let name: String
    let oneLiner: String
    let introduction: String
    let profile: String
    let images: [ClubImage]
    let application: String
    let category: Int
    let status: String
    let isRecruit: Bool
    let isOnlyStudent: Bool?
    let docDeadLine: String?
    let docResultDate: String?
    let interviewStartDate: String?
    let interviewEndDate: String?
    let finalResultDate: String?
}


// 동아리 상세 조회 API - ClubPageView
struct ClubDetailResponse: Decodable {
    let clubId: Int
    let name: String
    let oneLiner: String
    let introduction: String
    let reviewAvg: Double
    let reviewNum: Int
    let profile: String
    let images: [ClubImage]
    let application: String
    let category: Int
    let status: String
    let isRecruit: Bool
    let isOnlyStudent: Bool?
    let docDeadLine: String?
    let docResultDate: String?
    let interviewStartDate: String?
    let interviewEndDate: String?
    let finalResultDate: String?
    let isReviewAccess: Bool
}

struct ClubImage: Decodable {
    let fileId: Int
    let imageUrl: String
}



// 리뷰 전체 조회 - ClubPageView
struct ReviewResponse: Codable {
    let clubId: Int
    let reviewAvg: Double
    let five: Int
    let four: Int
    let three: Int
    let two: Int
    let one: Int
    let pageNum: Int
    let pageSize: Int
    let totalCnt: Int
    let reviews: [Review]
}

struct Review: Codable {
    let reviewId: Int
    let clubId: Int
    let review: String
    let user: UserofReview
    let rate: Int
    let createdDate: String
    let lastModifiedDate: String
}

struct UserofReview: Codable {
    let userId: Int
    let nickname: String
}


// 동아리 회원 목록 조회 - ClubPageView
struct MemberResponse: Codable {
    let pageNum: Int
    let pageSize: Int
    let totalCnt: Int
    let members: [Member]
}

struct Member: Codable, Identifiable {
    let id = UUID()
    let memberId: Int
    let user: UserofMember
    let clubId: Int
    let role: String
    
    enum CodingKeys: String, CodingKey {
        case memberId, user, clubId, role
    }
    
}

struct UserofMember: Codable {
    let userId: Int
    let name: String
    let imageUrl: String?
}



// 리뷰 생성
struct ReviewCreateResponse: Codable {
    let reviewId: Int
    let clubId: Int
    let review: String
    let user: User
    let rate: Int
    let createdDate: String
    let lastModifiedDate: String
    
    struct User: Codable {
        let userId: Int
        let nickname: String
    }
}

struct CreateMemberResponse: Codable {
    let memberId: Int
    let user: User
    let clubId: Int
    let role: String
    
    struct User: Codable {
        let userId: Int
        let name: String
        let imageUrl: String?
    }
}

// 매니저 지정
struct AppointManagerResponse: Codable {
    let memberId: Int
    let user: User
    let clubId: Int
    let role: String
    
    struct User: Codable {
        let userId: Int
        let name: String
        let imageUrl: String?
    }
}

// 매니저 삭제
struct MemberForManager: Codable {
    let memberId: Int
    let user: User
    let clubId: Int
    let role: String
    
    struct User: Codable {
        let userId: Int
        let name: String
        let imageUrl: String?
    }
}

// 승인 요청된 동아리
struct ClubsByStatusResponse: Codable {
    let pageNum: Int?
    let pageSize: Int?
    let totalCnt: Int?
    let clubs: [ClubsByStatus]
}

// 나중에 더미데이터 물음표 수정 필요
struct ClubsByStatus: Codable {
    let clubId: Int
    let name: String
    let oneLiner: String
    let introduction: String?
    let reviewAvg: Double
    let reviewNum: Int
    let profile: String?
    let images: [ClubsByStatusImage]?
    let application: String?
    let category: Int
    let status: String
    let isRecruit: Bool
    let recruitStartDate: String?
    let recruitEndDate: String?
}

struct ClubsByStatusImage: Codable {
    let fileId: Int
    let imageUrl: String?
}


// 동아리 수정
struct ClubContent: Codable {
    var clubId: Int
    var name: String
    var oneLiner: String
    var introduction: String
    var profile: Data?
    var images: [Data]
    var application: String
    var deletedImages: [String]?
    var category: Int
    var status: String
    var isRecruit: Bool
    var isOnlyStudent: Bool
    var docDeadLine: String?
    var docResultDate: String?
    var interviewStartDate: String?
    var interviewEndDate: String?
    var finalResultDate: String?
}

struct APIResponse<T: Decodable>: Decodable {
    let data: T
    let message: String
    let status: String
}

struct smallAPIResponse: Decodable {
    let message: String
    let status: String
}
// 동아리 지원
struct ApplicantResponse: Decodable {
    let applicantId: Int?
    let clubId: Int
    let status: String
    let createdDate: String
    let lastModifiedDate: String
    let user: User
    
    struct User: Decodable {
        let userId: Int
        let name: String
        let imageUrl: String?
    }
}


// 내가 지원한 동아리 목록 조회
struct AppliedClub: Decodable {
    let clubId: Int
    let name: String
    let oneLiner: String
    let reviewAvg: Double
    let reviewNum: Int
    let latestReview: String?
    let profile: String
    let category: Int
    let status: String
    let isRecruit: Bool
    let isOnlyStudent: Bool
    let docDeadLine: String?
    let docResultDate: String?
    let interviewStartDate: String?
    let interviewEndDate: String?
    let finalResultDate: String?
    
    var recruitmentPeriod: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd-HH:mm"
        
        guard let endDateString = docDeadLine,
              let endDate = formatter.date(from: endDateString) else {
            return "Invalid date"
        }
        
        let currentDate = Date()
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.day], from: currentDate, to: endDate)
        
        if let daysRemaining = components.day {
            if daysRemaining > 0 {
                return "D-\(daysRemaining)"
            } else if daysRemaining == 0 {
                return "D-Day"
            } else {
                return "모집마감"
            }
        } else {
            return "Invalid date calculation"
        }

    }

}


// 동아리 지원자 상태별 목록 조회
struct Pageable {
    var page: Int
    var size: Int
    var sort: [String]?
}

struct ApplicantByStatusResponse: Decodable {
    let pageNum: Int
    let pageSize: Int
    let totalCnt: Int
    let applicants: [ApplicantByStatus]
}

struct ApplicantByStatus: Decodable, Identifiable {
    let applicantId: Int
    let clubId: Int
    let status: String
    let createdDate: String
    let lastModifiedDate: String
    let user: User
    
    var id: Int { applicantId }
    
    struct User: Decodable {
        let userId: Int
        let name: String
        let imageUrl: String?
    }
}

struct Applicant: Decodable {
    let applicantId: Int
    let clubId: Int
    let status: String
    let createdDate: String?
    let lastModifiedDate: String?
    let user: _User
}

struct _User: Decodable {
    let userId: Int
    let name: String
    let imageUrl: String?
}


struct RegisterMemberResponse: Codable {
    let memberId: Int
    let user: User
    let clubId: Int
    let role: String
    
    struct User: Codable {
        let userId: Int
        let name: String
        let imageUrl: String?
    }
}

struct NotificationResponse: Codable {
    let pageNum: Int
    let pageSize: Int
    let totalCnt: Int
    let notifications: [Notification]
    
    struct Notification: Codable, Identifiable {
        let id = UUID()
        let notificationId: Int
        let message: String
        let createdDate: String
        let title: String
        let content: String
        let clubInfo: ClubInfo
        let type: String
        let check: Bool
        
        struct ClubInfo: Codable {
            let clubId: Int
            let name: String
            let profile: String?
        }
    }
}

// 후기 수정
struct UpdateReviewResponse: Decodable {
    let reviewId: Int
    let clubId: Int
    let review: String
    let user: User
    let rate: Int
    let createdDate: String?
    let lastModifiedDate: String?
    
    struct User: Codable {
        let userId: Int
        let nickname: String
    }
}


// 이메일 중복 체크
struct EmailDuplicateResponse: Codable {
    let email: String
    let duplicate: Bool
}

// 디바이스 정보 등록
struct DeviceResponse: Codable {
    let id: Int
    let fcmToken: String
    let model: String
    let os: String
    let osVersion: String
    let appVersion: String
    let codePushVersion: String
}

