import SwiftUI

struct ManageMembersView: View {
    
    var clubId: Int
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var members: [Member] = []
    @State private var isShowingAddMemberPopup = false
    @State private var isShowingRemoveMemberPopup = false
    @State private var isShowingDelegateClubOfficerPopup = false
    @State private var isShowingDemoteManagerPopup = false
    @State private var selectedMemberName: String? = nil
    @State private var selectedMemberId: Int? = nil
    @State private var error: Error?
    @State var isShowingNoExistentMemberPopup = false
    @State private var isShowDemoteManagerErrorPopup = false
    
    @State private var isManager: Bool = false
    
    @EnvironmentObject var accesstokenStored: _UserAccessToken
    
    // 회원 목록 조회 API 호출
    private func getClubMembers() {
        NetworkManager.getMembers(clubId: clubId, page: 0, size: 1000, sort: ["createdDate,desc"], accessToken: _UserAccessToken.shared.accessTokenStored) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.members = response.members
                    print("회원 목록 조회: \(members)")
                case .failure(let error):
                    self.error = error
                    print("회원 목록 조회 오류: \(error)")
                }
            }
        }
    }
    
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Button(action:{
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack{
                            Image(systemName: "chevron.backward")
                            Spacer()
                        }
                        .foregroundColor(.black)
                    }
                    
                    Text("회원 관리")
                        .font(.system(size: 18))
                        .bold()
                    
                    HStack{
                        Spacer()
                        Image(systemName: "plus")
                            .onTapGesture {
                                isShowingAddMemberPopup = true
                            }
                    }
                    .foregroundColor(.black)
                }
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
                .navigationBarBackButtonHidden()
                
                List {
                    ForEach(members) { member in
                        MembersCardView(
                            memberName: member.user.name,
                            userId: member.user.userId,
                            memberId: member.memberId,
                            isClubOfficer: member.role == "MANAGER",
                            isShowingDemoteManagerPopup: $isShowingDemoteManagerPopup,
                            isShowingDelegateClubOfficerPopup: $isShowingDelegateClubOfficerPopup,
                            selectedMemberName: $selectedMemberName,
                            selectedMemberId: $selectedMemberId
                        )
                        .listRowSeparator(.hidden)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button {
                                selectedMemberName = member.user.name
                                selectedMemberId = member.memberId
                                isShowingRemoveMemberPopup = true
                            }
                        label: { Text("삭제") }
                                .tint(Color("gray-60"))
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                
            }
            .onAppear() {
                getClubMembers()
            }
            .overlay(
                Group {
                    if isShowingAddMemberPopup {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                        AddMemberPopupView(clubId: clubId,
                                           onMemberAdded: {getClubMembers()}, isShowingAddMemberPopup: $isShowingAddMemberPopup, isShowingNoExistentMemberPopup: $isShowingNoExistentMemberPopup)
                        .frame(width: 350, height: 280)
                        .background(Color.white)
                        .cornerRadius(20)
                        .overlay(
                            Button(action: {
                                withAnimation {
                                    isShowingAddMemberPopup = false
                                }
                            }) {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(.black)
                                    .padding(20)
                            }
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        )
                    }
                    if isShowingRemoveMemberPopup, let memberName = selectedMemberName, let memberId = selectedMemberId {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                        RemoveMemberPopupView(memberName: memberName, memberId: memberId, onMemberRemoved: {getClubMembers()}, isShowingRemoveMemberPopup: $isShowingRemoveMemberPopup)
                            .frame(width: 350, height: 190)
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(
                                Button(action: {
                                    withAnimation {
                                        isShowingRemoveMemberPopup = false
                                    }
                                }) {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                        .foregroundColor(.black)
                                        .padding(20)
                                }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                            )
                    }
                    if isShowingDelegateClubOfficerPopup, let memberName = selectedMemberName, let memberId = selectedMemberId {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                        DelegateClubOfficerPopupView(memberName: memberName, memberId: memberId, onMemberOfficer: {getClubMembers()}, isShowingDelegateClubOfficerPopup: $isShowingDelegateClubOfficerPopup)
                            .frame(width: 350, height: 190)
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(
                                Button(action: {
                                    withAnimation {
                                        isShowingDelegateClubOfficerPopup = false
                                    }
                                }) {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                        .foregroundColor(.black)
                                        .padding(20)
                                }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                            )
                    }
                    if isShowingDemoteManagerPopup, let memberName = selectedMemberName, let memberId = selectedMemberId {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                        DemoteManagerPopupView(memberName: memberName, memberId: memberId, onManagerDemoted: {getClubMembers()}, isShowingDemoteManagerPopup: $isShowingDemoteManagerPopup, isShowDemoteManagerErrorPopup: $isShowDemoteManagerErrorPopup)
                            .frame(width: 350, height: 190)
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(
                                Button(action: {
                                    withAnimation {
                                        isShowingDemoteManagerPopup = false
                                    }
                                }) {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                        .foregroundColor(.black)
                                        .padding(20)
                                }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                            )
                    }
                    if isShowingNoExistentMemberPopup {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                        NoExistentMemberPopupView(isShowingNoExistentMemberPopup: $isShowingNoExistentMemberPopup)
                            .frame(width: 300, height: 190)
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(
                                Button(action: {
                                    withAnimation {
                                        isShowingNoExistentMemberPopup = false
                                    }
                                }) {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                        .foregroundColor(.black)
                                        .padding(20)
                                }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                            )
                    }
                    if isShowDemoteManagerErrorPopup {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                        DemoteManagerErrorPopupView()
                            .frame(width: 350, height: 420)
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(
                                Button(action: {
                                    withAnimation {
                                        isShowDemoteManagerErrorPopup = false
                                    }
                                }) {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                        .foregroundColor(.black)
                                        .padding(20)
                                }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                            )
                    }
                    
                }
            )
        }
        .navigationBarBackButtonHidden()
        .navigationViewStyle(StackNavigationViewStyle())
    }
}



