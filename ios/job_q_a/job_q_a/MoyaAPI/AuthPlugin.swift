//import Moya
//
//class AuthPlugin: PluginType {
//    private let lock = NSRecursiveLock()
//    private var isRefreshing = false
//    private var requestsToRetry: [(Result<Moya.Response, MoyaError>) -> Void] = []
//
//    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
//        var request = request
//        if let token = _UserAccessToken.shared.accessTokenStored {
//            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        }
//        print("요청 준비: \(request)")
//        return request
//    }
//
//    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
//        guard case let .failure(error) = result,
//              let response = error.response,
//              response.statusCode == 401 else {
//            print("응답 수신: \(result)")
//            return
//        }
//
//        lock.lock()
//        defer { lock.unlock() }
//
//        requestsToRetry.append { [weak self] result in
//            guard let self = self else { return }
//            NetworkManager.provider.request(target as! API, completion: result) // NetworkManager의 provider를 이용하여 재시도
//        }
//
//        if !isRefreshing {
//            isRefreshing = true
//            print("토큰 갱신 중...")
//
//            if let refreshToken = _UserAccessToken.shared.refreshTokenStored {
//                NetworkManager.refreshToken(refreshToken: refreshToken) { [weak self] result in
//                    guard let self = self else { return }
//
//                    self.lock.lock()
//                    defer { self.lock.unlock() }
//
//                    switch result {
//                    case .success(let (accessToken, refreshToken)):
//                        _UserAccessToken.shared.accessTokenStored = accessToken
//                        _UserAccessToken.shared.refreshTokenStored = refreshToken
//                        print("새로운 토큰 발급: \(accessToken), \(refreshToken)")
//
//                        self.requestsToRetry.forEach { $0(.success(response)) }
//                        self.requestsToRetry.removeAll()
//
//                    case .failure:
//                        self.requestsToRetry.forEach { $0(.failure(error)) }
//                        self.requestsToRetry.removeAll()
//                        print("토큰 갱신 실패")
//                    }
//
//                    self.isRefreshing = false
//                }
//            } else {
//                print("리프레시 토큰 없음")
//                self.requestsToRetry.forEach { $0(.failure(error)) }
//                self.requestsToRetry.removeAll()
//                self.isRefreshing = false
//            }
//        }
//    }
//}
