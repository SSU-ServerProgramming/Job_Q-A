import SwiftUI

struct SplashView: View {
    
    let bundleID = Bundle.main.bundleIdentifier
    
    var body: some View {
        Image("splashImg")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
    }
    
}

#Preview {
    SplashView()
}
