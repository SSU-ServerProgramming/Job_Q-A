import SwiftUI

struct NotificationCardView: View {
    
    var notification: NotificationResponse.Notification
    @Binding var selectedNotification: NotificationResponse.Notification?
    @Binding var isShowingNotification: Bool
    @Binding var presentSheet: Bool
    
    @State private var showDetail = false
    
    private func formattedDate(from isoDateString: String) -> String {
        let isoFormatter = DateFormatter()
        isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        
        if let date = isoFormatter.date(from: isoDateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "MM/dd HH:mm"
            return displayFormatter.string(from: date)
        }
        
        return isoDateString
    }
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color("gray-10"))
            
            VStack {
                
                HStack {
                    Text(notification.title)
                        .font(.system(size: 15))
                        .bold()
                    Spacer()
                }
                .padding(.top)
                .padding(.horizontal)
                
                HStack {
                    Text(notification.message)
                        .font(.system(size: 13))
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }
                .padding(.vertical, 3)
                .padding(.horizontal)
                
                HStack {
                    Spacer()
                    Text(formattedDate(from: notification.createdDate))
                        .font(.system(size: 10))
                        .foregroundColor(Color("gray-100"))
                }
                .padding(.horizontal)
                .padding(.bottom, 5)
            }
            Spacer()
        }
        .frame(height: 80, alignment: .leading)
        .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
        .onTapGesture {
            self.selectedNotification = notification
            self.isShowingNotification = true
            self.presentSheet = false
        }
    }
}
