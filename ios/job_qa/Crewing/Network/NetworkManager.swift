import Foundation
import Moya

struct EditRequest: Codable {
    let title : String
    let content : String
    let category_id : Int
}

struct deleteBoardRequest: Codable {
    let category_id: Int
}
struct editCommentRequest: Codable {
    let content: String
}


enum API {
    case editBoard(board_id: Int, requestBody: EditRequest)
    case deleteBoard(board_id: Int, category_id: Int)
    case editComment(comment_id: Int, content: String)
    case deleteComment(comment_id: Int)
    case registerDevice(fcmToken: String, model: String, os: String, osVersion: String, appVersion: String, codePushVersion: String, accessToken: String) // 디바이스 정보 등록
    case updateDevice(deviceId: Int, fcmToken: String, osVersion: String, appVersion: String, codePushVersion: String, accessToken: String) // 디바이스 정보 갱신
    case refreshToken(refreshToken: String) // 리프레시 토큰 재발급
    case signUp(request: SignUpRequest) // 회원가입
    case idPwSignUp(request: IdPwSignUpRequest) // 아이디패스워드 회원가입
    case emailLogin(email: String, authNumber: String) // 이메일 로그인
    case login(socialType: String, oauthAccessToken: String) // 소셜 로그인
    case idPwLogin(email: String, password: String) // 아이디패스워드 로그인
    case getClubs(page: Int, size: Int, sort: [String], accessToken: String) // 전체 동아리 조회 - ClubView
    case getUserInfo(accessToken: String) // 유저 정보 조회 - ProfileView
    case updateUserInterests(accessToken: String, interests: [UserInterest]) // 유저 관심사 수정 - ProfileView
    case getMyClubs(page: Int, size: Int, sort: [String], accessToken: String) // 나의 동아리 목록 조회 - ProgfileView
    case createClub(request: CreateClubRequest, profileImage: Data?, images: [Data]?, accessToken: String)
    case getClubDetails(clubId: Int, accessToken: String) // 동아리 상세 조회 - ClubPageView
    case getReviews(clubId: Int, page: Int, size: Int, sort: [String], accessToken: String) // 리뷰 전체 조회
    case getMembers(clubId: Int, page: Int, size: Int, sort: [String], accessToken: String) // 회원 목록 조회
    case createReview(ReviewCreateRequest, accessToken: String) // 리뷰 생성
    case createMember(clubId: Int, userId: Int, accessToken: String) // 동아리 회원 생성
    case deleteMember(memberId: Int, accessToken: String) // 동아리 회원 삭제
    case appointManager(memberId: Int, accessToken: String) // 동아리 매니저 임명
    case demoteManager(memberId: Int, accessToken: String) // 동아리 매니저 삭제
    case deleteReview(reviewId: Int, accessToken: String) // 리뷰 삭제
    case searchClubs(accessToken: String, search: String, category: Int, page: Int, size: Int) // 검색어별 동아리 조회
    case getClubsByStatus(page: Int, size: Int, sort: [String], status: String, accessToken: String) // 상태별 동아리 조회
    case editClub(clubId: Int, content: ClubContent, accessToken: String) // 동아리 수정
    case updateStatus(clubId: Int, status: String, content: String, accessToken: String) // 동아리 상태 수정
    case sendVerificationEmail(email: String) // 이메일 인증 메일 발송
    case verifyEmail(email: String, authNum: String) // 인증 메일 검증
    //case emailSignUp(body: EmailSignUpRequest) // (이메일) 기본 회원가입
    case getRecommendedClubs(sort: String) // 추천
    case likeBoard(boardId: Int) // 추천
    case deleteLikeBoard(boardId: Int) // 추천
    case likeComment(commentId: Int) // 추천
    case deleteLikeComment(commentId: Int) // 추천
    case getBoards
    case getMyPostBoard
    case getMyPostComment
    
    case getCategoryBoards(id : Int)
    case submitClubApplication(clubId: Int, accessToken: String) // 동아리 지원
    case getMyAppliedClubs(accessToken: String) // 지원한 동아리 목록 조회
    case getApplicantsByStatus(clubId: Int, status: String, pageable: Pageable, accessToken: String) // 동아리 지원자 상태별 목록 조회
    case changeApplicantStatus(clubId: Int, changeList: [Int], status: String, content: String, accessToken: String) // 동아리 지원자 상태 변경
    case deleteApplicants(clubId: Int, deleteList: [Int], content: String, accessToken: String) // 동아리 지원자 탈락
    case getApplicants(clubId: Int, page: Int, size: Int, accessToken: String) // 동아리 지원자 목록 조회
    case registerApplicant(clubId: Int, accessToken: String) // 동아리 회원 등록 (최종 합격)
    case getNotifications(accessToken: String, page: Int, size: Int, sort: [String]) // 사용자 알림 목록 조회
    case checkNotification(notificationId: Int, accessToken: String) // 알림 확인 체크
    case subscribe(lastEventId: String?, accessToken: String) // 알림 sse연결
    case updateReview(reviewId: Int, review: String, rate: Int, accessToken: String) // 후기 수정하기
    case createApplicantForManager(clubId: Int, userId: Int, accessToken: String) // 운영진이 직접 지원자 등록
    case checkEmailDuplicate(email: String) // 이메일 중복 체크
    case deleteUser(accessToken: String) // 유저 삭제
    case purchaseReviewAccess(clubId: Int, accessToken: String) // 리뷰 열람 포인트 권한 구매
    case updateUserBirth(birth: String, accessToken: String) // 유저 나이 수정
    case updateUserGender(gender: String, accessToken: String) // 유저 성별 수정
    case getBoardDetail(boardId: Int)
    case postBoard(request: PostBoardRequest)
    case postComment(request: PostCommentRequest)
    
}

extension API: TargetType {
    
    var baseURL: URL {
        return URL(string: "http://localhost:8000")!
    }
    
    var path: String {
        switch self {
            
        case .registerDevice:
                return "/api/v1/devices"
            
        case .updateDevice(let deviceId, _, _, _, _, _):
                    return "/api/v1/devices/\(deviceId)"
            
        case .refreshToken:
            return "/api/v1/auth/refresh"
            
        case .signUp:
            return "/auth/register"
            
        case .idPwSignUp:
            return "/auth/register"
            
        case .emailLogin:
            return "/api/v1/auth/login/email"
            
        case .idPwLogin:
            return "/auth/login"
            
        case .login(let socialType, _):
            return "/api/v1/auth/login/oauth/\(socialType)"
            
        case .getClubs:
            return "/api/v1/club/clubs"
            
        case .getUserInfo:
            return "/mypage/user"
            
        case .updateUserInterests:
            return "/api/v1/users/me/interest"
            
        case .getMyClubs:
            return "/api/v1/club/my"
            
        case .createClub:
            return "/api/v1/club/create"
            
        case .getClubDetails(let clubId, _):
            return "/api/v1/club/\(clubId)"
            
        case .getReviews(let clubId, _, _, _, _):
            return "/api/v1/review/reviews/\(clubId)"
            
        case .getMembers(let clubId, _, _, _, _):
            return "/api/v1/member/members/\(clubId)"
            
        case .createReview:
            return "/api/v1/review/create"
            
        case .createMember:
            return "/api/v1/member/create"
            
        case .deleteMember(let memberId, _):
            return "/api/v1/member/\(memberId)"
            
        case .appointManager(let memberId, _):
            return "/api/v1/member/manager/\(memberId)"
            
        case .demoteManager(let memberId, _):
            return "/api/v1/member/manager/\(memberId)"
            
        case .deleteReview(let reviewId, _):
            return "/api/v1/review/delete/\(reviewId)"
            
        case .searchClubs:
            return "/api/v1/club/clubs/search"
            
        case .getClubsByStatus:
            return "/api/v1/admin/clubs"
            
        case .editClub(let clubId, _, _):
            return "/api/v1/club/edit/\(clubId)"
            
        case .updateStatus:
            return "/api/v1/club/status"
            
        case .sendVerificationEmail(let email):
            return "/api/v1/signUp/verification/\(email)"
            
        case .verifyEmail:
            return "/api/v1/signUp/verification/email/verify"
            
        case .getRecommendedClubs:
            return "/board"
        case .likeBoard(let boardId):
            return "/board/\(boardId)/like"
        case .deleteLikeBoard(let boardId):
            return "/board/\(boardId)/like"
        case .likeComment(let commentId):
            return "/comment/\(commentId)/like"
        case .deleteLikeComment(let commentId):
            return "/comment/\(commentId)/like"
        case .submitClubApplication:
            return "/api/v1/applicant/create"
            
        case .getMyAppliedClubs:
            return "/api/v1/applicant/applicants/my"
            
        case .getApplicantsByStatus(let clubId, _, _, _):
            return "/api/v1/applicant/applicants/status/\(clubId)"
            
        case .changeApplicantStatus:
            return "/api/v1/applicant/status"
            
        case .deleteApplicants:
            return "/api/v1/applicant/delete"
            
        case .getApplicants(let clubId, _, _, _):
            return "/api/v1/applicant/applicants/\(clubId)"
            
        case .registerApplicant:
            return "/api/v1/applicant/register"
            
        case .getNotifications:
            return "/api/v1/notification/notifications"
            
        case .checkNotification(let notificationId, _):
            return "/api/v1/notification/check/\(notificationId)"
            
        case .subscribe:
            return "/api/v1/notification/subscribe"
            
        case .updateReview(let reviewId, _, _, _):
            return "/api/v1/review/\(reviewId)"
            
        case .createApplicantForManager:
            return "/api/v1/applicant/create/manager"
            
        case .checkEmailDuplicate(let email):
            return "/api/v1/signUp/verification/duplicate/\(email)"
            
        case .deleteUser:
            return "/api/v1/users/me"
            
        case .purchaseReviewAccess(let clubId, _):
            return "/api/v1/review/reviews/\(clubId)/purchase"
            
        case .updateUserBirth(let birth, _):
                    return "/api/v1/users/me/birth/\(birth)"
            
        case .updateUserGender(let gender, _):
                    return "/api/v1/users/me/gender/\(gender)"
        case .getBoardDetail(boardId: let boardId):
                return "/board/detail/\(boardId)"
        case .getBoards:
            return "/board"
        case .getMyPostBoard:
            return "/mypage/user/boards"
        case .getMyPostComment:
            return "/mypage/user/comments"
        case .getCategoryBoards(let id):
            return "/board/category/\(id)"
        case .postBoard(request:_):
            return "/board/"
        case .postComment:
            return "/comment/"
        case .editBoard(board_id: let board_id, requestBody: let requestBody):
            return "/board/\(board_id)"
        case .deleteBoard(board_id: let board_id, category_id: let category_id):
            return "/board/\(board_id)"
        case .editComment(comment_id: let comment_id, content: let content):
            return "/comment/\(comment_id)"
        case .deleteComment(comment_id: let comment_id):
            return "/comment/\(comment_id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .registerDevice, .signUp, .login, .idPwLogin, .createClub, .createReview, .createMember, .sendVerificationEmail, .verifyEmail, .submitClubApplication, .deleteApplicants, .registerApplicant, .createApplicantForManager, .refreshToken, .emailLogin, .purchaseReviewAccess, .idPwSignUp:
            return .post
        case .getClubs, .getUserInfo, .getMyClubs, .getClubDetails, .getReviews, .getMembers, .demoteManager, .searchClubs, .getClubsByStatus, .getRecommendedClubs, .getMyAppliedClubs, .getApplicantsByStatus, .getApplicants, .getNotifications, .subscribe, .checkEmailDuplicate,.getBoardDetail:
            return .get
        case .updateDevice, .updateUserInterests, .appointManager, .editClub, .updateStatus, .changeApplicantStatus, .checkNotification, .updateReview, .updateUserBirth, .updateUserGender:
            return .patch
        case .deleteMember, .deleteReview, .deleteUser:
            return .delete
        case .getBoards, .getCategoryBoards, .getMyPostBoard, .getMyPostComment:
            return .get
        case .postBoard:
            return .post
        case .postComment:
            return .post
        case .likeBoard(boardId: let boardId):
            return .post
        case .deleteLikeBoard(boardId: let boardId):
            return .delete
        case .likeComment(commentId: let commentId):
            return .post
        case .deleteLikeComment(commentId: let commentId):
            return .delete
        case .editBoard(board_id: let board_id, requestBody: let requestBody):
            return .put
        case .deleteBoard(board_id: let board_id, category_id: let category_id):
            return .delete
        case .editComment(comment_id: let comment_id, content: let content):
            return .put
        case .deleteComment(comment_id: let comment_id):
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .registerDevice(let fcmToken, let model, let os, let osVersion, let appVersion, let codePushVersion, _):
                let parameters: [String: Any] = [
                    "fcmToken": fcmToken,
                    "model": model,
                    "os": os,
                    "osVersion": osVersion,
                    "appVersion": appVersion,
                    "codePushVersion": codePushVersion
                ]
                return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .updateDevice(_, let fcmToken, let osVersion, let appVersion, let codePushVersion, _):
                    let parameters: [String: Any] = [
                        "fcmToken": fcmToken,
                        "osVersion": osVersion,
                        "appVersion": appVersion,
                        "codePushVersion": codePushVersion
                    ]
                    return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .refreshToken(let refreshToken):
            let params: [String: Any] = ["refreshToken": refreshToken]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .signUp(let request):
            return .requestJSONEncodable(request)
            
        case .idPwSignUp(let request):
            return .requestJSONEncodable(request)
            
        case .login(_, let oauthAccessToken):
            return .requestParameters(parameters: ["oauthAccessToken": oauthAccessToken], encoding: JSONEncoding.default)
            
        case .idPwLogin(let email, let password):
            return .requestJSONEncodable(loginRequest(email: email, password: password))
            
        case let .getClubs(page, size, sort, accessToken):
            let parameters: [String: Any] = [
                "pageable": [
                    "page": page,
                    "size": size,
                    "sort": sort
                ]
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            
        case .getUserInfo:
            return .requestPlain
            
        case .updateUserInterests(_, let interests):
            let parameters: [String: Any] = [
                "interests": interests.map { ["interest": $0.interest] }
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case let .getMyClubs(page, size, sort, accessToken):
            let parameters: [String: Any] = [
                "pageable": [
                    "page": page,
                    "size": size,
                    "sort": sort
                ]
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            
            
        case let .createClub(request, profileImage, images, _):
            var multipartData = [MultipartFormData]()
            
            // 요청 데이터 JSON으로 변환
            do {
                let jsonData = try JSONEncoder().encode(request)
                let jsonPart = MultipartFormData(provider: .data(jsonData), name: "content", mimeType: "application/json")
                multipartData.append(jsonPart)
            } catch {
                print("Error encoding request: \(error.localizedDescription)")
            }
            
            // 프로필 이미지 추가
            if let profileImage = profileImage {
                let profileImageData = MultipartFormData(provider: .data(profileImage), name: "profile", fileName: "profile.jpg", mimeType: "image/jpeg")
                multipartData.append(profileImageData)
            }
            
            // 추가 이미지 추가
            if let images = images {
                for (index, imageData) in images.enumerated() {
                    multipartData.append(MultipartFormData(provider: .data(imageData), name: "images", fileName: "image\(index).jpg", mimeType: "image/jpeg"))
                }
            }
            
            return .uploadMultipart(multipartData)
            
            
        case .getClubDetails(_, _):
            return .requestPlain
            
        case .getReviews(_, let page, let size, let sort, _):
            return .requestParameters(parameters: ["page": page, "size": size, "sort": sort], encoding: URLEncoding.queryString)
            
        case let .getMembers(_, page, size, sort, _):
            let parameters: [String: Any] = [
                "page": page,
                "size": size,
                "sort": sort
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
            
        case let .createReview(request, _):
            return .requestJSONEncodable(request)
            
        case .createMember(let clubId, let userId, _):
            return .requestParameters(parameters: ["clubId": clubId, "userId": userId], encoding: JSONEncoding.default)
            
        case .deleteMember:
            return .requestPlain
            
        case .appointManager:
            return .requestPlain
            
        case .demoteManager:
            return .requestPlain
            
        case .deleteReview:
            return .requestPlain
            
        case let .searchClubs(_, search, category, page, size):
            return .requestParameters(parameters: [
                "search": search,
                "category": category,
                "pageable": [
                    "page": page,
                    "size": size,
                    "sort": ["string"]
                ]
            ], encoding: URLEncoding.default)
            
            
        case let .getClubsByStatus(page, size, sort, status, _):
            let parameters: [String: Any] = [
                "page": page,
                "size": size,
                "sort": sort,
                "status": status
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
            
            
        case .editClub(_, let content, _):
            var multipartData = [MultipartFormData]()
            
            // JSON 데이터 추가
            do {
                let jsonContent = [
                    "clubId": content.clubId,
                    "name": content.name,
                    "oneLiner": content.oneLiner,
                    "introduction": content.introduction,
                    "application": content.application,
                    "category": content.category,
                    "status": content.status,
                    "isRecruit": content.isRecruit,
                    "isOnlyStudent": content.isOnlyStudent,
                    "docDeadLine": content.docDeadLine ?? nil,
                    "docResultDate": content.docResultDate ?? nil,
                    "interviewStartDate": content.interviewStartDate ?? nil,
                    "interviewEndDate": content.interviewEndDate ?? nil,
                    "finalResultDate": content.finalResultDate ?? nil,
                ] as [String : Any]
                
                let jsonData = try JSONSerialization.data(withJSONObject: jsonContent, options: [])
                let jsonPart = MultipartFormData(provider: .data(jsonData), name: "content", mimeType: "application/json")
                multipartData.append(jsonPart)
            } catch {
                print("Error encoding request: \(error.localizedDescription)")
            }
            
            // 프로필 이미지 추가
            if let profileImageData = content.profile {
                let profileImagePart = MultipartFormData(provider: .data(profileImageData), name: "profile", fileName: "profile.jpg", mimeType: "image/jpeg")
                multipartData.append(profileImagePart)
            }
            
            // 추가 이미지 추가
            for (index, imageData) in content.images.enumerated() { // **** 수정된 부분
                let imagePart = MultipartFormData(provider: .data(imageData), name: "images", fileName: "image\(index).jpg", mimeType: "image/jpeg")
                multipartData.append(imagePart)
            }
            
            // 삭제할 이미지 추가
            //if !content.deletedImages.isEmpty {
            if let deletedImages = content.deletedImages, !deletedImages.isEmpty {
                do {
                    let deletedImagesData = try JSONSerialization.data(withJSONObject: ["deletedImages": content.deletedImages], options: [])
                    let deletedImagesPart = MultipartFormData(provider: .data(deletedImagesData), name: "deletedImages", mimeType: "application/json")
                    multipartData.append(deletedImagesPart)
                } catch {
                    print("Error encoding deleted images: \(error.localizedDescription)")
                }
            }
            
            // 디버그용으로 멀티파트 데이터 출력
            for part in multipartData {
                print("Name: \(part.name), FileName: \(String(describing: part.fileName)), MIMEType: \(String(describing: part.mimeType))")
            }
            
            return .uploadMultipart(multipartData)
            
        case let .updateStatus(clubId, status, content, _):
            let parameters: [String: Any] = [
                "clubId": clubId,
                "status": status,
                "content": content
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .sendVerificationEmail:
            return .requestPlain
            
        case .verifyEmail(let email, let authNum):
            let parameters: [String: Any] = [
                "email": email,
                "authNum": authNum
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .getRecommendedClubs(let sort):
            return .requestParameters(parameters: ["sort": sort], encoding: URLEncoding.queryString)
            
        case let .submitClubApplication(clubId, _):
            let params: [String: Any] = ["clubId": clubId]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .getMyAppliedClubs:
            return .requestPlain
            
            
        case let .getApplicantsByStatus(_, status, pageable, _):
            var params: [String: Any] = [
                "status": status,
                "page": pageable.page,
                "size": pageable.size
            ]
            if let sort = pageable.sort {
                params["sort"] = sort
            }
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case let .changeApplicantStatus(clubId, changeList, status, content, _):
            let parameters: [String: Any] = [
                "clubId": clubId,
                "changeList": changeList,
                "status": status,
                "content": content
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case let .deleteApplicants(clubId, deleteList, content, _):
            let parameters: [String: Any] = [
                "clubId": clubId,
                "deleteList": deleteList,
                "content": content
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .getApplicants(_, let page, let size, _):
            let parameters: [String: Any] = [
                "page": page,
                "size": size
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
            
        case .registerApplicant(let clubId, _):
            let parameters: [String: Any] = [
                "clubId": clubId
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .getNotifications(_, let page, let size, let sort):
            let parameters: [String: Any] = [
                "page": page,
                "size": size,
                "sort": sort
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
            
        case .checkNotification:
            return .requestPlain
            
        case .subscribe:
            return .requestPlain
            
        case .updateReview(_, let review, let rate, _):
            let parameters: [String: Any] = [
                "review": review,
                "rate": rate
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case let .createApplicantForManager(clubId, userId, _):
            let params: [String: Any] = ["clubId": clubId, "userId": userId]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .checkEmailDuplicate:
            return .requestPlain
            
        case .deleteUser:
            return .requestPlain
            
        case .emailLogin(let email, let authNumber):
            return .requestParameters(parameters: ["email": email, "authNumber": authNumber], encoding: JSONEncoding.default)
            
        case .purchaseReviewAccess:
            return .requestPlain
            
        case .updateUserBirth:
                    return .requestPlain
            
        case .updateUserGender:
                    return .requestPlain
        
        case .getBoardDetail:
            return .requestPlain
        case .getBoards, .getCategoryBoards, .getMyPostBoard, .getMyPostComment:
            return .requestPlain
        case .postBoard(let request):
            return .requestJSONEncodable(request)
        case .postComment(request: let request):
            return .requestJSONEncodable(request)
        case .likeBoard(boardId: let boardId):
            return .requestPlain
        case .deleteLikeBoard(boardId: let boardId):
            return .requestPlain
        case .likeComment(commentId: let commentId):
            return .requestPlain
        case .deleteLikeComment(commentId: let commentId):
            return .requestPlain
        case .editBoard(board_id: let board_id, requestBody: let requestBody):
            return .requestJSONEncodable(requestBody)
        case .deleteBoard(board_id: let board_id, category_id: let category_id):
            return .requestJSONEncodable(deleteBoardRequest(category_id: category_id))
        case .editComment(comment_id: let comment_id, content: let content):
            return .requestJSONEncodable(editCommentRequest(content: content))
        case .deleteComment(comment_id: let comment_id):
            return .requestPlain
        }

    }
    
    var headers: [String : String]? {
            switch self {
            
            case .registerDevice(_, _, _, _, _, _, _), .postComment(_):
                return [
                    "Authorization": "Bearer \(loadAccessToken()!)",
                    "Content-Type": "application/json"
                ]
                
            case .updateDevice(_, _, _, _, _, let accessToken):
                return [
                    "Authorization": "Bearer \(accessToken)",
                    "Content-Type": "application/json"
                ]
            case .postBoard:
                return ["Authorization": "Bearer d"]
                
            case .refreshToken, .getBoardDetail:
                return ["Content-type": "application/json"]
                
                
            case .idPwSignUp:
                return ["Content-Type": "application/json"]
                
            case .login:
                return ["Content-type": "application/json"]
                
            case .idPwLogin:
                return ["Content-type": "application/json"]
                
            case .getClubs(_, _, _, let accessToken):
                return ["Authorization": "Bearer \(accessToken)", "Content-type": "application/json"]
                
            case .getUserInfo(let accessToken):
                return ["Authorization": "Bearer \(accessToken)", "Content-type": "application/json"]
                
            case .updateUserInterests(let accessToken, _):
                return ["Authorization": "Bearer \(accessToken)", "Content-type": "application/json"]
                
            case .getMyClubs(_, _, _, let accessToken):
                return ["Authorization": "Bearer \(accessToken)", "Content-type": "application/json"]
                
            case .createClub(_, _, _, let accessToken):
                return ["Authorization": "Bearer \(accessToken)", "Content-type": "multipart/form-data"]
                
            case .getClubDetails(_, let accessToken):
                return ["Authorization": "Bearer \(accessToken)", "Content-type": "application/json"]
                
            case .getReviews(_, _, _, _, let accessToken):
                return ["Authorization": "Bearer \(accessToken)"]
                
            case .getMembers(_, _, _, _, let accessToken):
                return ["Authorization": "Bearer \(accessToken)", "Content-type": "application/json"]
                
            case .createReview(_, let accessToken):
                return ["Authorization": "Bearer \(accessToken)", "Content-type": "application/json"]
                
            case .createMember(_, _, let accessToken):
                return ["Authorization": "Bearer \(accessToken)", "Content-type": "application/json"]
                
            case .deleteMember(_, let accessToken):
                return ["Authorization": "Bearer \(accessToken)", "Content-type": "application/json"]
                
            case .appointManager(_, let accessToken):
                return ["Authorization": "Bearer \(accessToken)", "Content-type": "application/json"]
                
            case .demoteManager(_, let accessToken):
                return ["Authorization": "Bearer \(accessToken)"]
                
            case .deleteReview(_, let accessToken):
                return ["Authorization": "Bearer \(accessToken)", "Content-type": "application/json"]
                
            case let .searchClubs(accessToken, _, _, _, _):
                return ["Authorization": "Bearer \(accessToken)"]
                
            case .getClubsByStatus(_, _, _, _, let accessToken):
                return ["Authorization": "Bearer \(accessToken)", "Content-type": "application/json"]
                
            case .editClub(_, _, let accessToken):
                return ["Content-Type": "multipart/form-data", "Authorization": "Bearer \(accessToken)"]
                
            case .updateStatus(_, _, _, let accessToken):
                return [
                    "Authorization": "Bearer \(accessToken)", "Content-Type": "application/json"]
                
            case .sendVerificationEmail:
                return ["Content-Type": "application/json"]
                
            case .verifyEmail:
                return ["Content-Type": "application/json"]
                
            case .getRecommendedClubs:
                return ["Content-Type": "application/json"]
                
            case let .submitClubApplication(_, accessToken):
                return ["Content-Type": "application/json", "Authorization": "Bearer \(accessToken)"]
                
            case .getMyAppliedClubs(let accessToken):
                return ["Content-Type": "application/json", "Authorization": "Bearer \(accessToken)"]
                
            case .getApplicantsByStatus(_, _, _, let accessToken):
                return ["Content-Type": "application/json", "Authorization": "Bearer \(accessToken)"]
                
            case .changeApplicantStatus(_, _, _, _, let accessToken):
                return ["Authorization": "Bearer \(accessToken)", "Content-Type": "application/json"]
                
            case .deleteApplicants(_, _, _, let accessToken):
                return ["Authorization": "Bearer \(accessToken)", "Content-type": "application/json"]
                
            case .getApplicants(_, _, _, let accessToken):
                return ["Authorization": "Bearer \(accessToken)", "Accept": "application/json"]
                
            case .registerApplicant(_, let accessToken):
                return ["Authorization": "Bearer \(accessToken)", "Content-Type": "application/json", "Accept": "application/json"]
                
            case .getNotifications(let accessToken, _, _, _):
                return ["Authorization": "Bearer \(accessToken)"]
                
            case .checkNotification(_, let accessToken):
                return ["Content-Type": "application/json", "Authorization": "Bearer \(accessToken)"]
                
            case .subscribe(let lastEventId, let accessToken):
                var headers = ["Accept": "text/event-stream", "Authorization": "Bearer \(accessToken)"]
                if let lastEventId = lastEventId {
                    headers["Last-Event-ID"] = lastEventId
                }
                return headers
                
            case .updateReview(_, _, _, let accessToken):
                return ["Authorization": "Bearer \(accessToken)", "Content-Type": "application/json"]
                
            case .createApplicantForManager(_, _, let accessToken):
                return ["Authorization": "Bearer \(accessToken)", "Content-Type": "application/json"]
                
            case .checkEmailDuplicate:
                return ["Content-Type": "application/json"]
                
            case .deleteUser(let accessToken):
                return ["Authorization": "Bearer \(accessToken)", "Content-Type": "application/json", "Accept": "*/*"]
                
            case .emailLogin:
                return ["Content-Type": "application/json"]
                
            case .purchaseReviewAccess(_, let accessToken):
                return ["Content-Type": "application/json", "Authorization": "Bearer \(accessToken)"]
                
            case .updateUserGender(_, let accessToken):
                return ["Authorization": "Bearer \(accessToken)", "Content-Type": "application/json"]
                
            case .updateUserBirth(_, let accessToken):
                return ["Authorization": "Bearer \(accessToken)", "Content-Type": "application/json"]
            case .getMyPostBoard:
                return ["Authorization":"Bearer \(loadAccessToken()!)", "Content-Type": "application/json"]
            case .getMyPostComment:
                return ["Authorization": "Bearer \(loadAccessToken()!)", "Content-Type": "application/json"]
            case .signUp(request: _), .getBoards, .getCategoryBoards:
                return ["Content-Type": "application/json"]
            case .likeBoard:
                return ["Authorization": "Bearer \(loadAccessToken()!)"]
                        
//                        "Content-Type": "application/json"]
            case .deleteLikeBoard:
                return ["Authorization": "Bearer \(loadAccessToken()!)", "Content-Type": "application/json"]
            case .likeComment:
                return ["Authorization": "Bearer \(loadAccessToken()!)", "Content-Type": "application/json"]
            case .deleteLikeComment:
                return ["Authorization": "Bearer \(loadAccessToken()!)", "Content-Type": "application/json"]
            case .editBoard(board_id: let board_id, requestBody: let requestBody):
                return ["Authorization": "Bearer \(loadAccessToken()!)", "Content-Type": "application/json"]
            case .deleteBoard(board_id: let board_id, category_id: let category_id):
                return ["Authorization": "Bearer \(loadAccessToken()!)", "Content-Type": "application/json"]
            case .editComment(comment_id: let comment_id, content: let content):
                return ["Authorization": "Bearer \(loadAccessToken()!)", "Content-Type": "application/json"]
            case .deleteComment(comment_id: let comment_id):
                return ["Authorization": "Bearer \(loadAccessToken()!)", "Content-Type": "application/json"]
            }
//        } else {
//            return [
//                "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjo1LCJleHAiOjE3NDg0ODY5MjcsImlhdCI6MTc0ODQ4MzMyNywidHlwZSI6ImFjY2VzcyJ9.T9iaJhTKau9Ivsd7rHJcXtFNAq6PXdSSIaEBte14KFM",
//                "Content-Type": "application/json"
//            ]
//        }
        
    }
}


let provider = MoyaProvider<API>()
struct PostBoardResponseData: Decodable {
    let board_id: Int
    let category_name: String
    let comment_count: Int
    let content: String
    let date: String
    let like: Int
    let title: String
    let writer: String
}


class NetworkManager {

    static func postBoard(request: PostBoardRequest, completion: @escaping (Result<smallAPIResponse, Error>) -> Void) {
//        print("🚨\(request.title), \(request.category_id) \(request.content)")
        provider.request(.postBoard(request: request)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(smallAPIResponse.self, from: response.data)
                    print(decoded.message)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    static func postComment(request: PostCommentRequest, completion: @escaping (Result<Bool, Error>) -> Void) {
        provider.request(.postComment(request: request)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(smallAPIResponse.self, from: response.data)
                    print(decoded.message)
                    completion(.success(true))
                } catch {
                    print("너도?!")
                }
            case .failure(let error):
                print("에러")
            }
        }
    }
    static func editBoard(board_id: Int, requestBody: EditRequest, completion: @escaping (Result<smallAPIResponse, Error>) -> Void) {
        provider.request(.editBoard(board_id: board_id, requestBody: requestBody)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(smallAPIResponse.self, from: response.data)
                    print(decoded.message)
                    completion(.success(decoded))
                } catch {
                }
            case .failure(let error):
                print("에러")
            }
        }
    }
    static func deleteBoard(board_id: Int, category_id: Int, completion: @escaping (Result<smallAPIResponse, Error>) -> Void) {
        provider.request(.deleteBoard(board_id: board_id, category_id: category_id)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(smallAPIResponse.self, from: response.data)
                    print(decoded.message)
                    completion(.success(decoded))
                } catch {
                    
                }
            case .failure(let error):
                print("에러")
            }
        }
    }
    static func editComment(comment_id: Int, content: String, completion: @escaping (Result<smallAPIResponse, Error>) -> Void) {
        provider.request(.editComment(comment_id: comment_id, content: content)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(smallAPIResponse.self, from: response.data)
                    print(decoded.message)
                    completion(.success(decoded))
                } catch {
                }
            case .failure(let error):
                print("에러")
            }
        }
    }
    static func deleteComment(comment_id: Int,completion: @escaping (Result<smallAPIResponse, Error>) -> Void) {
        provider.request(.deleteComment(comment_id: comment_id)){ result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(smallAPIResponse.self, from: response.data)
                    print(decoded.message)
                    completion(.success(decoded))
                } catch {
                }
            case .failure(let error):
                print("에러")
            }
        }
    }
    
    
    static func getBoards(completion: @escaping (Result<[Board], Error>) -> Void) {
        provider.request(.getBoards) { result in
            switch result {
            case .success(let response):
                do {
                    let clubsResponse = try JSONDecoder().decode(APIResponse<[Board]>.self, from: response.data)
                    completion(.success(clubsResponse.data))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }

    }
    static func getMyPostBoard(completion: @escaping (Result<[Board], Error>) -> Void) {
        provider.request(.getMyPostBoard) { result in
            switch result {
            case .success(let response):
                do {
                    let clubsResponse = try JSONDecoder().decode(APIResponse<[Board]>.self, from: response.data)
                    completion(.success(clubsResponse.data))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }

    }
    static func getMyPostComment(completion: @escaping (Result<[MyComment], Error>) -> Void) {
        provider.request(.getMyPostComment) { result in
            switch result {
            case .success(let response):
                do {
                    let clubsResponse = try JSONDecoder().decode(APIResponse<[MyComment]>.self, from: response.data)
                    completion(.success(clubsResponse.data))
                    print("comment 성공")
                } catch {
                    completion(.failure(error))
                    print("comment 매핑 실패")
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }

    }
    static func likeBoard(boardId: Int, completion: @escaping (Result<smallAPIResponse, Error>) -> Void) {
        provider.request(.likeBoard(boardId: boardId)){ result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(smallAPIResponse.self, from: response.data)
                    print(decoded.message)
                    completion(.success(decoded))
                } catch {
                    print("에러22")
                }
            case .failure(let error):
                print("에러")
            }
        }
    }
    static func deleteLikeBoard(boardId: Int) {
        provider.request(.deleteLikeBoard(boardId: boardId)) { result in
            switch result {
            case .success(let response):
                print("성공")
            case .failure(let error):
                print("실패")
            }
        }

    }
    static func likeComment(commentId: Int, completion: @escaping (Result<smallAPIResponse, Error>) -> Void) {
        provider.request(.likeComment(commentId: commentId)) { result in
            switch result {
            case .success(let response):
                do {
                    let signUpResponse = try JSONDecoder().decode(smallAPIResponse.self, from: response.data)
                    completion(.success(signUpResponse))
                } catch {
                    completion(.failure(error))
                }
                print("서버 응답!!!: \(response)")
            case .failure(let error):
                completion(.failure(error))
                print("에러!!!: \(error)")
            }
        }

    }
    static func deleteLikeComment(commentId: Int, completion: @escaping (Result<smallAPIResponse, Error>) -> Void) {
        provider.request(.deleteLikeComment(commentId: commentId)) { result in
            switch result {
            case .success(let response):
                do {
                    let signUpResponse = try JSONDecoder().decode(smallAPIResponse.self, from: response.data)
                    completion(.success(signUpResponse))
                } catch {
                    completion(.failure(error))
                }
                print("서버 응답!!!: \(response)")
            case .failure(let error):
                completion(.failure(error))
                print("에러!!!: \(error)")
            }
        }

    }
    static func getCategoryBoards(id: Int, completion: @escaping (Result<[Board], Error>) -> Void) {
        provider.request(.getCategoryBoards(id: id)) { result in
            switch result {
            case .success(let response):
                do {
                    let clubsResponse = try JSONDecoder().decode(APIResponse<[Board]>.self, from: response.data)
                    completion(.success(clubsResponse.data))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }

    }

    static func registerDevice(fcmToken: String, model: String, os: String, osVersion: String, appVersion: String, codePushVersion: String, accessToken: String, completion: @escaping (Result<DeviceResponse, Error>) -> Void) {
            provider.request(.registerDevice(fcmToken: fcmToken, model: model, os: os, osVersion: osVersion, appVersion: appVersion, codePushVersion: codePushVersion, accessToken: accessToken)) { result in
                switch result {
                case let .success(response):
                    do {
                        let deviceResponse = try JSONDecoder().decode(DeviceResponse.self, from: response.data)
                        completion(.success(deviceResponse))
                        print("디바이스 정보 등록 성공: \(deviceResponse)")
                    } catch {
                        print("디바이스 정보 등록 에러: \(error)")
                    }
                case let .failure(error):
                    print("디바이스 정보 등록 실패: \(error)")
                }
            }
        }
    
    static func updateDevice(deviceId: Int, fcmToken: String, osVersion: String, appVersion: String, codePushVersion: String, accessToken: String, completion: @escaping (Result<DeviceResponse, Error>) -> Void) {
            provider.request(.updateDevice(deviceId: deviceId, fcmToken: fcmToken, osVersion: osVersion, appVersion: appVersion, codePushVersion: codePushVersion, accessToken: accessToken)) { result in
                switch result {
                case let .success(response):
                    do {
                        let deviceResponse = try JSONDecoder().decode(DeviceResponse.self, from: response.data)
                        completion(.success(deviceResponse))
                        print("디바이스 정보 갱신 성공: \(deviceResponse)")
                    } catch {
                        print("디바이스 정보 갱신 - JSON 파싱 에러: \(error)")
                        completion(.failure(error))
                    }
                case let .failure(error):
                    print("디바이스 정보 갱신 API 호출 실패: \(error)")
                    completion(.failure(error))
                }
            }
        }

    
    static func refreshToken(refreshToken: String, completion: @escaping (Result<(String, String), Error>) -> Void) {
        provider.request(.refreshToken(refreshToken: refreshToken)) { result in
            switch result {
            case .success(let response):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any]
                    if let accessToken = json?["accessToken"] as? String, let newRefreshToken = json?["refreshToken"] as? String {
                        completion(.success((accessToken, newRefreshToken)))
                    } else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid token response"])))
                    }
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func idPwSignUp(request: IdPwSignUpRequest, completion: @escaping (Result<smallAPIResponse, Error>) -> Void) {
        provider.request(.idPwSignUp(request: request)) { result in
            switch result {
            case .success(let response):
                do {
                    let signUpResponse = try JSONDecoder().decode(smallAPIResponse.self, from: response.data)
                    completion(.success(signUpResponse))
                } catch {
                    completion(.failure(error))
                }
                print("서버 응답!!!: \(response)")
            case .failure(let error):
                completion(.failure(error))
                print("에러!!!: \(error)")
            }
        }
    }
    
    
    
    static func login(socialType: String, oauthAccessToken: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        provider.request(.login(socialType: socialType, oauthAccessToken: oauthAccessToken)) { result in
            switch result {
            case .success(let response):
                do {
                    let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: response.data)
                    print("NetworkManager.login 성공: \(loginResponse)")
                    completion(.success(loginResponse))
                } catch {
                    print("NetworkManager.login 디코딩 실패: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("NetworkManager.login 실패: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    
    static func idPwLogin(email: String, password: String, completion: @escaping (Result<IdPwLoginResponse, Error>) -> Void) {
        provider.request(.idPwLogin(email: email, password: password)) { result in
            switch result {
            case .success(let response):
                do {
                    let filteredResponse = try response.filterSuccessfulStatusCodes()
                    let responseData = try filteredResponse.map(APIResponse<IdPwLoginResponse>.self)
                    saveAccessToken(token: responseData.data.access_token)
                    print("idPwLogin 성공: \(responseData)")
                    print("token: \(loadAccessToken())")
                    completion(.success(responseData.data))
                } catch {
                    print("idPwLogin 디코딩 실패: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("idPwLogin 실패: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    

    static func fetchBoardDetail(boardId: Int, completion: @escaping (Result<BoardDetailData, Error>) -> Void) {
        print("boardId : \(boardId)")
        provider.request(.getBoardDetail(boardId: boardId)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(APIResponse<BoardDetailData>.self, from: response.data)
                    completion(.success(decoded.data))
                    print("게시글 디테일 조회 성공")
                } catch {
                    completion(.failure(error))
                    print("게시글 디테일 조회 실패:")
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    static func getClubs(page: Int, size: Int, sort: [String], accessToken: String, completion: @escaping (Result<ClubResponse, Error>) -> Void) {
        // 요청값 출력
        print("Request: page = \(page), size = \(size), sort = \(sort), accessToken = \(accessToken)")
        
        provider.request(.getClubs(page: page, size: size, sort: sort, accessToken: accessToken)) { result in
            switch result {
            case let .success(response):
                do {
                    // 응답 데이터 출력
                    if let responseString = String(data: response.data, encoding: .utf8) {
                        print("Response: \(responseString)")
                    }
                    
                    let clubsResponse = try JSONDecoder().decode(ClubResponse.self, from: response.data)
                    completion(.success(clubsResponse))
                } catch {
                    print("Decoding Error: \(error)")
                    completion(.failure(error))
                }
            case let .failure(error):
                print("Request Error: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    
    
    static func getUserInfo(accessToken: String, completion: @escaping (Result<UserInfoResponse, Error>) -> Void) {
        provider.request(.getUserInfo(accessToken: accessToken)) { result in
            switch result {
            case let .success(response):
                do {
                    let userInfoResponse = try JSONDecoder().decode(APIResponse<UserInfoResponse>.self, from: response.data)
                    completion(.success(userInfoResponse.data))
                } catch {
                    completion(.failure(error))
                    print("api매핑실패")
                }
            case let .failure(error):
                completion(.failure(error))
                print("api걍실패")
            }
        }
    }
    
    
    static func updateUserInterests(accessToken: String, interests: [UserInterest], completion: @escaping (Result<Data, Error>) -> Void) {
        provider.request(.updateUserInterests(accessToken: accessToken, interests: interests)) { result in
            switch result {
            case let .success(response):
                if let bodyString = String(data: response.data, encoding: .utf8) {
                    print("응답 : Response body: \(bodyString)")
                } else {
                    print("에러 : Failed to convert response body to string")
                }
                completion(.success(response.data))
            case let .failure(error):
                print("에러 : Request failed with error: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    
    static func getMyClubs(page: Int, size: Int, sort: [String], accessToken: String, completion: @escaping (Result<MyClubsResponse, Error>) -> Void) {
        provider.request(.getMyClubs(page: page, size: size, sort: sort, accessToken: accessToken)) { result in
            switch result {
            case .success(let response):
                do {
                    let clubsResponse = try JSONDecoder().decode(MyClubsResponse.self, from: response.data)
                    print("응답 : Response body: \(clubsResponse)")
                    completion(.success(clubsResponse))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    static func createClub(request: CreateClubRequest, profileImage: Data, images: [Data]?, accessToken: String, completion: @escaping (Result<CreateClubResponse, Error>) -> Void) {
        provider.request(.createClub(request: request, profileImage: profileImage, images: images, accessToken: accessToken)) { result in
            switch result {
            case .success(let response):
                do {
                    let responseData = try JSONDecoder().decode(CreateClubResponse.self, from: response.data)
                    completion(.success(responseData))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    
    static func getClubDetails(clubId: Int, accessToken: String, completion: @escaping (Result<ClubDetailResponse, Error>) -> Void) {
        provider.request(.getClubDetails(clubId: clubId, accessToken: accessToken)) { result in
            switch result {
            case .success(let response):
                do {
                    let clubDetailResponse = try JSONDecoder().decode(ClubDetailResponse.self, from: response.data)
                    completion(.success(clubDetailResponse))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    
    static func getReviews(clubId: Int, page: Int, size: Int, sort: [String], accessToken: String, completion: @escaping (Result<ReviewResponse, Error>) -> Void) {
        provider.request(.getReviews(clubId: clubId, page: page, size: size, sort: sort, accessToken: accessToken)) { result in
            switch result {
            case let .success(response):
                do {
                    let reviewResponse = try JSONDecoder().decode(ReviewResponse.self, from: response.data)
                    completion(.success(reviewResponse))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    static func getMembers(clubId: Int, page: Int, size: Int, sort: [String], accessToken: String, completion: @escaping (Result<MemberResponse, Error>) -> Void) {
        provider.request(.getMembers(clubId: clubId, page: page, size: size, sort: sort, accessToken: accessToken)) { result in
            switch result {
            case let .success(response):
                do {
                    let memberResponse = try JSONDecoder().decode(MemberResponse.self, from: response.data)
                    completion(.success(memberResponse))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    static func createReview(clubId: Int, review: String, rate: Int, accessToken: String, completion: @escaping (Result<ReviewCreateResponse, Error>) -> Void) {
        let request = ReviewCreateRequest(clubId: clubId, review: review, rate: rate)
        provider.request(.createReview(request, accessToken: accessToken)) { result in
            switch result {
            case let .success(response):
                do {
                    let reviewCreateResponse = try JSONDecoder().decode(ReviewCreateResponse.self, from: response.data)
                    completion(.success(reviewCreateResponse))
                } catch {
                    if let bodyString = String(data: response.data, encoding: .utf8) {
                        print("응답 바디: \(bodyString)")
                    }
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    static func createMember(clubId: Int, userId: Int, accessToken: String, completion: @escaping (Result<CreateMemberResponse, Error>) -> Void) {
        provider.request(.createMember(clubId: clubId, userId: userId, accessToken: accessToken)) { result in
            switch result {
            case .success(let response):
                do {
                    let memberResponse = try JSONDecoder().decode(CreateMemberResponse.self, from: response.data)
                    completion(.success(memberResponse))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func deleteMember(memberId: Int, accessToken: String, completion: @escaping (Result<Data, Error>) -> Void) {
        provider.request(.deleteMember(memberId: memberId, accessToken: accessToken)) { result in
            switch result {
            case let .success(response):
                if response.statusCode == 200 {
                    completion(.success(response.data))
                } else {
                    let error = NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: "회원 삭제 실패"])
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    static func appointManager(memberId: Int, accessToken: String, completion: @escaping (Result<Data, Error>) -> Void) {
        provider.request(.appointManager(memberId: memberId, accessToken: accessToken)) { result in
            switch result {
            case let .success(response):
                if response.statusCode == 200 {
                    completion(.success(response.data))
                } else {
                    let error = NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: "매니저 임명 실패"])
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    static func demoteManager(memberId: Int, accessToken: String, completion: @escaping (Result<Member, Error>) -> Void) {
        provider.request(.demoteManager(memberId: memberId, accessToken: accessToken)) { result in
            switch result {
            case .success(let response):
                do {
                    let member = try JSONDecoder().decode(Member.self, from: response.data)
                    completion(.success(member))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func deleteReview(reviewId: Int, accessToken: String, completion: @escaping (Result<String, Error>) -> Void) {
        provider.request(.deleteReview(reviewId: reviewId, accessToken: accessToken)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    completion(.success("리뷰가 성공적으로 삭제되었습니다."))
                } else {
                    let errorMessage = String(data: response.data, encoding: .utf8) ?? "알 수 없는 오류가 발생했습니다."
                    completion(.failure(NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    static func searchClubs(accessToken: String, search: String, category: Int, page: Int, size: Int, completion: @escaping (Result<ClubResponse, Error>) -> Void) {
        provider.request(.searchClubs(accessToken: accessToken, search: search, category: category, page: page, size: size)) { result in
            switch result {
            case .success(let response):
                do {
                    let clubsResponse = try JSONDecoder().decode(ClubResponse.self, from: response.data)
                    print("응답 : \(clubsResponse)")
                    completion(.success(clubsResponse))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func getClubsByStatus(page: Int, size: Int, sort: [String], status: String, accessToken: String, completion: @escaping (Result<ClubsByStatusResponse, Error>) -> Void) {
        provider.request(.getClubsByStatus(page: page, size: size, sort: sort, status: status, accessToken: accessToken)) { result in
            switch result {
            case .success(let response):
                do {
                    let clubResponse = try JSONDecoder().decode(ClubsByStatusResponse.self, from: response.data)
                    completion(.success(clubResponse))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func editClub(clubId: Int, content: ClubContent, accessToken: String, completion: @escaping (Result<Data, Error>) -> Void) {
        provider.request(.editClub(clubId: clubId, content: content, accessToken: accessToken)) { result in
            switch result {
            case let .success(response):
                if response.statusCode == 200 {
                    completion(.success(response.data))
                } else {
                    let errorMessage = String(data: response.data, encoding: .utf8) ?? "알 수 없는 오류가 발생했습니다."
                    completion(.failure(NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    
    static func updateClubStatus(clubId: Int, status: String, content: String, accessToken: String , completion: @escaping (Result<Data, Error>) -> Void) {
        provider.request(.updateStatus(clubId: clubId, status: status, content: content, accessToken: accessToken)) { result in
            switch result {
            case .success(let response):
                do {
                    let responseData = try response.mapJSON()
                    print("Success: \(responseData)")
                } catch {
                    print("Error mapping response: \(error)")
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    
    static func sendVerificationEmail(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.sendVerificationEmail(email: email)) { result in
            switch result {
            case let .success(response):
                if response.statusCode == 200 {
                    completion(.success(()))
                } else {
                    let error = NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey : "Failed to send verification email."])
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    
    static func verifyEmail(email: String, authNum: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        provider.request(.verifyEmail(email: email, authNum: authNum)) { result in
            switch result {
            case .success(let response):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any]
                    if let verifyResult = json?["verifyResult"] as? Bool {
                        completion(.success(verifyResult))
                    } else {
                        completion(.failure(NSError(domain: "Invalid response", code: -1, userInfo: nil)))
                    }
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func getRecommendedClubs(completion: @escaping (Result<[Board], Error>) -> Void) {
        provider.request(.getRecommendedClubs(sort: "num_likes")) { result in
            switch result {
            case .success(let response):
                do {
                    let clubsResponse = try JSONDecoder().decode(APIResponse<[Board]>.self, from: response.data)
                    completion(.success(clubsResponse.data))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }

    }
    
    static func submitClubApplication(clubId: Int, accessToken: String, completion: @escaping (Result<ApplicantResponse, Error>) -> Void) {
        provider.request(.submitClubApplication(clubId: clubId, accessToken: accessToken)) { result in
            switch result {
            case .success(let response):
                do {
                    let applicantResponse = try JSONDecoder().decode(ApplicantResponse.self, from: response.data)
                    completion(.success(applicantResponse))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func getMyAppliedClubs(accessToken: String, completion: @escaping (Result<[AppliedClub], Error>) -> Void) {
        provider.request(.getMyAppliedClubs(accessToken: accessToken)) { result in
            switch result {
            case .success(let response):
                do {
                    let appliedClubs = try JSONDecoder().decode([AppliedClub].self, from: response.data)
                    completion(.success(appliedClubs))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    static func getApplicantsByStatus(clubId: Int, status: String, pageable: Pageable, accessToken: String, completion: @escaping (Result<ApplicantByStatusResponse, Error>) -> Void) {
        provider.request(.getApplicantsByStatus(clubId: clubId, status: status, pageable: pageable, accessToken: accessToken)) { result in
            switch result {
            case .success(let response):
                do {
                    let applicantResponse = try JSONDecoder().decode(ApplicantByStatusResponse.self, from: response.data)
                    completion(.success(applicantResponse))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func changeApplicantStatus(clubId: Int, changeList: [Int], status: String, content: String, accessToken: String, completion: @escaping (Result<Data, Error>) -> Void) {
        provider.request(.changeApplicantStatus(clubId: clubId, changeList: changeList, status: status, content: content, accessToken: accessToken)) { result in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func deleteApplicants(clubId: Int, deleteList: [Int], content: String, accessToken: String, completion: @escaping (Result<String, Error>) -> Void) {
        provider.request(.deleteApplicants(clubId: clubId, deleteList: deleteList, content: content, accessToken: accessToken)) { result in
            switch result {
            case .success(let response):
                if let responseString = String(data: response.data, encoding: .utf8) {
                    completion(.success(responseString))
                } else {
                    completion(.failure(MoyaError.jsonMapping(response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func getApplicants(clubId: Int, page: Int, size: Int, accessToken: String, completion: @escaping (Result<ApplicantByStatusResponse, Error>) -> Void) {
        provider.request(.getApplicants(clubId: clubId, page: page, size: size, accessToken: accessToken)) { result in
            switch result {
            case .success(let response):
                do {
                    let applicantResponse = try JSONDecoder().decode(ApplicantByStatusResponse.self, from: response.data)
                    completion(.success(applicantResponse))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func registerApplicant(clubId: Int, accessToken: String, completion: @escaping (Result<RegisterMemberResponse, Error>) -> Void) {
        provider.request(.registerApplicant(clubId: clubId, accessToken: accessToken)) { result in
            switch result {
            case .success(let response):
                do {
                    let responseString = try response.mapString()
                    print("최종 회원 등록 응답: \(responseString)")
                    
                    let decoder = JSONDecoder()
                    let memberResponse = try decoder.decode(RegisterMemberResponse.self, from: response.data)
                    completion(.success(memberResponse))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func getNotifications(accessToken: String, page: Int, size: Int, sort: [String], completion: @escaping (Result<NotificationResponse, Error>) -> Void) {
        provider.request(.getNotifications(accessToken: accessToken, page: page, size: size, sort: sort)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let notificationResponse = try decoder.decode(NotificationResponse.self, from: response.data)
                    print("응답값 - NotificationResponse: \(notificationResponse)")
                    completion(.success(notificationResponse))
                } catch let error {
                    print("디코딩 에러: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("네트워크 에러: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    static func checkNotification(notificationId: Int, accessToken: String, completion: @escaping (Result<String, MoyaError>) -> Void) {
        provider.request(.checkNotification(notificationId: notificationId, accessToken: accessToken)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    completion(.success("알림 확인 체크 성공"))
                } else {
                    completion(.failure(MoyaError.statusCode(response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func updateReview(reviewId: Int, review: String, rate: Int, accessToken: String, completion: @escaping (Result<UpdateReviewResponse, Error>) -> Void) {
        provider.request(.updateReview(reviewId: reviewId, review: review, rate: rate, accessToken: accessToken)) { result in
            switch result {
            case .success(let response):
                do {
                    let updateReviewResponse = try JSONDecoder().decode(UpdateReviewResponse.self, from: response.data)
                    completion(.success(updateReviewResponse))
                } catch {
                    if let bodyString = String(data: response.data, encoding: .utf8) {
                        print("응답 바디: \(bodyString)")
                    }
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func createApplicantForManager(clubId: Int, userId: Int, accessToken: String, completion: @escaping (Result<ApplicantResponse, Error>) -> Void) {
        provider.request(.createApplicantForManager(clubId: clubId, userId: userId, accessToken: accessToken)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let applicantResponse = try decoder.decode(ApplicantResponse.self, from: response.data)
                    completion(.success(applicantResponse))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    static func checkEmailDuplicate(email: String, completion: @escaping (Result<EmailDuplicateResponse, Error>) -> Void) {
        provider.request(.checkEmailDuplicate(email: email)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let emailDuplicateResponse = try decoder.decode(EmailDuplicateResponse.self, from: response.data)
                    completion(.success(emailDuplicateResponse))
                } catch let error {
                    print("디코딩 에러: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("네트워크 에러: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    
    static func deleteUser(accessToken: String, completion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.deleteUser(accessToken: accessToken)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    completion(.success(()))
                } else {
                    let error = NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: "유저 삭제 실패"])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    static func emailLogin(email: String, authNumber: String, completion: @escaping (Result<LoginForEmailResponse, Error>) -> Void) {
        provider.request(.emailLogin(email: email, authNumber: authNumber)) { result in
            switch result {
            case .success(let response):
                do {
                    let loginResponse = try JSONDecoder().decode(LoginForEmailResponse.self, from: response.data)
                    completion(.success(loginResponse))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func purchaseReviewAccess(clubId: Int, accessToken: String, completion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.purchaseReviewAccess(clubId: clubId, accessToken: accessToken)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    completion(.success(()))
                } else {
                    let errorMessage = String(data: response.data, encoding: .utf8) ?? "Unknown error"
                    let error = NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func updateUserGender(gender: String, accessToken: String, completion: @escaping (Result<Data, Error>) -> Void) {
        provider.request(.updateUserGender(gender: gender, accessToken: accessToken)) { result in
            switch result {
            case let .success(response):
                if response.statusCode == 200 {
                    completion(.success(response.data))
                } else {
                    let error = NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: "성별 수정 실패"])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }


    static func updateUserBirth(birth: String, accessToken: String, completion: @escaping (Result<Data, Error>) -> Void) {
        provider.request(.updateUserBirth(birth: birth, accessToken: accessToken)) { result in
            switch result {
            case let .success(response):
                if response.statusCode == 200 {
                    completion(.success(response.data))
                } else {
                    let error = NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: "나이 수정 실패"])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    
}
func saveAccessToken(token: String) {
    UserDefaults.standard.set(token, forKey: "accessToken")
}

func loadAccessToken() -> String? {
    UserDefaults.standard.string(forKey: "accessToken")
}
