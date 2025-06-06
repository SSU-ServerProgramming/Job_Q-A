import SwiftUI

struct MainTabView: View {
    
    @State private var navigateToClubView = false
    
    private enum Tabs {
        case home, club, profile
    }
    
    @State private var selectedTab: Tabs = .home
    
    init() {
        UITabBar.appearance().backgroundColor = .white
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                HomeView()
                    .navigationViewStyle(StackNavigationViewStyle())
            }
            .tabItem {
                Image(systemName: "house")
                Text("홈")
            }
            .tag(Tabs.home)
            
            NavigationView {
                CategoryListView(categoryIndex: 0)
            }
            .tabItem {
                Image(systemName: "square.stack.3d.up.fill")
                Text("커뮤니티")
            }
            .tag(Tabs.club)
            
            NavigationView {
                ProfileView()
            }
            .tabItem {
                Image(systemName: "person")
                Text("프로필")
            }
            .tag(Tabs.profile)
        }
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
