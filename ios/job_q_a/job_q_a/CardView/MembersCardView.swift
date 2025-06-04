import SwiftUI

struct MembersCardView: View {
    
    var memberName: String
    var userId: Int
    var memberId: Int
    var isClubOfficer: Bool
    
    @Binding var isShowingDemoteManagerPopup: Bool
    @Binding var isShowingDelegateClubOfficerPopup: Bool
    @Binding var selectedMemberName: String?
    @Binding var selectedMemberId: Int?
    
    @EnvironmentObject var accesstokenStored: _UserAccessToken
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 10)
            
            HStack(spacing:0) {
                ZStack {
                    Circle()
                        .frame(width: 63, height: 63)
                        .foregroundColor(.white)
                    Image(systemName: "person")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color("gray-60"))
                }
                .frame(width: 63, height: 63)
                .padding(EdgeInsets(top: 14, leading: 14, bottom: 14, trailing: 0))
                
                Text(memberName)
                    .bold()
                    .font(.system(size: 16))
                    .padding()
                Text("#")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                Text(String(format: "%04d", userId))
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                Spacer()
                
                ZStack {
                    if isClubOfficer {
                        AngularGradient(gradient: Gradient(colors: [Color("gradationBlue"), Color("accent")]), center: .center)
                            .frame(width: 25, height: 20)
                            .mask(
                                Image(systemName: "crown")
                                    .resizable()
                                    .foregroundColor(.white)
                                    .frame(width: 25, height: 20)
                            )
                    } else {
                        Color("gray-40") // 회색 배경
                            .frame(width: 25, height: 20)
                            .mask(
                                Image(systemName: "crown")
                                    .resizable()
                                    .foregroundColor(.white)
                                    .frame(width: 25, height: 20)
                            )
                    }
                }
                .onTapGesture {
                    if isClubOfficer {
                        selectedMemberName = memberName
                        selectedMemberId = memberId
                        isShowingDemoteManagerPopup = true
                    } else {
                        selectedMemberName = memberName
                        selectedMemberId = memberId
                        isShowingDelegateClubOfficerPopup = true
                    }
                }
                .padding()
            }
        }
        .frame(height: 90, alignment: .leading)
    } 
}


