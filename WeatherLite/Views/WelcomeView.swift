//
//  WelcomeView.swift
//  WeatherLite
//
//  Created by Raj Narayan Sharma on 15/12/24.
//

import SwiftUI
import CoreLocationUI

struct WelcomeView: View {
    @EnvironmentObject var locationManager : LocationManager
    
    var body: some View {
        VStack {
            VStack(spacing: 20){
                Text("Welcome to this Lite Weather App").bold().font(.title)
                Text("Please Share your current Loaction to Get Weather in your area").padding()
            }.multilineTextAlignment(.center).padding()
            LocationButton(.shareCurrentLocation){
                locationManager.requestLocation()
            }.cornerRadius(30).symbolVariant(.fill).foregroundColor(.white)
            
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
    }
}

#Preview {
    WelcomeView()
}
