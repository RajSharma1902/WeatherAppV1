//
//  LiveBackground.swift
//  WeatherLite
//
//  Created by Raj Narayan Sharma on 20/12/24.
//
//
//  LiveBackground.swift
//  WeatherLite
//
//  Created by Raj Narayan Sharma on 20/12/24.
//

import SwiftUI

struct LiveBackground: View {
    @State private var animateGradient = false // Control the animation state
    var weatherCondition: String // Dynamically passed weather condition
    
    var body: some View {
        ZStack {
            // Background Image based on weather
            Image(imageName(for: weatherCondition))
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(gradientOverlay) // Add animated gradient
        }
        .onAppear {
            withAnimation(.linear(duration: 5).repeatForever(autoreverses: true)) {
                animateGradient.toggle()
            }
        }
    }
    
    // Placeholder method for weather-specific image mapping
    private func imageName(for condition: String) -> String {
        // Add specific mappings here
        switch condition.lowercased() {
        case "clear":
            return "sunny"
        case "rain":
            return "rainy"
        case "clouds":
            return "cloudy"
        case "snow":
            return "snowy"
        default:
            return "default" // Default fallback image
        }
    }
    
    // Animated gradient overlay for a dynamic live effect
    private var gradientOverlay: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.blue.opacity(0.3),
                Color.purple.opacity(0.2),
                Color.orange.opacity(0.3)
            ]),
            startPoint: animateGradient ? .topLeading : .bottomTrailing,
            endPoint: animateGradient ? .bottomTrailing : .topLeading
        )
        .blendMode(.overlay)
        .ignoresSafeArea()
    }
}

#Preview {
    LiveBackground(weatherCondition: "Rain")
}
