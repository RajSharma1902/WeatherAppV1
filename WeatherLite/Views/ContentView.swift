//
//  ContentView.swift
//  WeatherLite
//
//  Created by Raj Narayan Sharma on 15/12/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    var pollutionManager = PollutionManager()
    @State var weather: ResponseBody?
    @State var pollution: PollutionResponseBody?
    @State private var selectedTab = 0 // Track the selected tab
    
    var body: some View {
        VStack {
            if let location = locationManager.location {
                TabView(selection: $selectedTab) { // Bind the TabView to the selectedTab state
                    if let weather = weather {
                        WeatherView(weather: weather)
                            .tag(0)
                    } else {
                        LoadingView()
                            .task {
                                do {
                                    weather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                                } catch {
                                    print("Error getting weather: \(error)")
                                }
                            }
                            .tag(0)
                    }
                    
                    if let pollution = pollution {
                        PollutionView(pollution: pollution)
                            .tag(1)
                    } else {
                        LoadingView()
                            .task {
                                do {
                                    pollution = try await pollutionManager.getCurrentPollution(latitude: location.latitude, longitude: location.longitude)
                                } catch {
                                    print("Error getting pollution data: \(error)")
                                }
                            }
                            .tag(1)
                    }
                }
                .tabViewStyle(.page)
            } else {
                if locationManager.isLoading {
                    LoadingView()
                } else {
                    WelcomeView()
                        .environmentObject(locationManager)
                }
            }
        }
        .background(Image(""))
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
