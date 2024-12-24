//
//  LoadingView.swift
//  WeatherLite
//
//  Created by Raj Narayan Sharma on 15/12/24.
//
import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let animationName: String
    let loopMode: LottieLoopMode

    func makeUIView(context: Context) -> LottieAnimationView {
        let animationView = LottieAnimationView()
        animationView.animation = LottieAnimation.named(animationName)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.play()
        return animationView
    }

    func updateUIView(_ uiView: LottieAnimationView, context: Context) {
        // No additional updates required
    }
}

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea() // Background color
            
            LottieView(animationName: "DayNight", loopMode: .loop)
                .aspectRatio(contentMode: .fit) // Maintain aspect ratio
                .scaleEffect(calculateScale()) // Dynamically scale
                .padding()
        }
    }
    
    private func calculateScale() -> CGFloat {
        // Adjust scale based on device size
        #if os(iOS)
        let screenSize = UIScreen.main.bounds.size
        return min(screenSize.width / 900, screenSize.height / 900)
        #else
        return 1.0 // Default for non-iOS devices
        #endif
    }
}


#Preview {
    LoadingView()
}
