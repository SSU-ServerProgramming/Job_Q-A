import SwiftUI
import Moya

class NotificationManager: NSObject, ObservableObject {
    @Published var notifications: [String] = [] // 실시간 알림을 저장할 배열
    
    private var eventSource: URLSessionDataTask?
    private let provider = MoyaProvider<API>()
    
    
    func startSSE(accessToken: String, lastEventId: String? = nil) {
        guard let url = URL(string: "http://35.216.102.254:8081/api/v1/notification/subscribe") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("text/event-stream", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        if let lastEventId = lastEventId {
            request.setValue(lastEventId, forHTTPHeaderField: "Last-Event-ID")
        }
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        eventSource = session.dataTask(with: request)
        eventSource?.resume()
        
        print("Access Token used: \(accessToken)")
        print("SSE 연결 started with URL: \(url.absoluteString)")
    }
    
    func stopSSE() {
        eventSource?.cancel()
        eventSource = nil
        
        print("SSE 연결 stopped.")
    }
}

extension NotificationManager: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if let eventString = String(data: data, encoding: .utf8) {
            DispatchQueue.main.async {
                self.notifications.append(eventString)
                print("Received SSE 데이터: \(eventString)") // *****
            }
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print("SSE 연결 failed with error: \(error.localizedDescription)") // *****
        } else {
            print("SSE 연결 completed successfully.") // *****
        }
    }
}
