//
//  WeatherRow.swift
//  WeatherLite
//
//  Created by Raj Narayan Sharma on 15/12/24.
//


import SwiftUI

struct WeatherRow: View {
    var logo: String
    var name: String
    var value: String
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: logo)
                .font(.headline)
                .frame(width: 20, height: 20)
                .padding()
                .symbolRenderingMode(.multicolor)
                .background(Color.black)
                .cornerRadius(50)
                
            
            VStack(alignment: .leading, spacing: 8) {
                Text(name)
                    .font(.caption)
                
                Text(value)
                    .bold()
                    .font(.system(size: 20))
            }
        }
    }
}

struct WeatherRow_Previews: PreviewProvider {
    static var previews: some View {
        WeatherRow(logo: "sunset.fill", name: "Feels like", value: "8°")
        
    }
}

