//
//  Calculations.swift
//  WeatherLite
//
//  Created by Raj Narayan Sharma on 18/12/24.
//

import Foundation

struct PollutionCalculations {
    
    /// Calculates the Air Quality Index (AQI) based on the components.
    static func calculateAQI(from components: PollutionResponseBody.ListsResponse.ComponentsResponse) -> Int {
        // Example AQI calculation based on simplified logic
        let coAQI = components.co / 10 // Adjust factor as per standards
        let no2AQI = components.no2 / 20
        let so2AQI = components.so2 / 30
        let pm25AQI = components.pm2_5 / 15
        
        let overallAQI = max(coAQI, no2AQI, so2AQI, pm25AQI)
        return Int(overallAQI)
    }
    
    /// Determines the air quality description based on the AQI value.
    static func airQualityDescription(for aqi: Int) -> String {
        switch aqi {
        case 0..<50:
            return "Good"
        case 50..<100:
            return "Moderate"
        case 100..<150:
            return "Unhealthy for Sensitive Groups"
        case 150..<200:
            return "Unhealthy"
        case 200...:
            return "Very Unhealthy"
        default:
            return "Unknown"
        }
    }
}

