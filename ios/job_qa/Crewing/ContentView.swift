import SwiftUI

struct ContentView: View {

    @State private var showMainView = false
    
    var body: some View {
        ZStack {
            if showMainView {
                OnBoardingScreenView()
            } else {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation {
                                showMainView = true
                            }
                        }
                    }
            }
        }
    }
}
