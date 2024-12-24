//
//  WeatherView.swift
//  WeatherLite
//
//  Created by Raj Narayan Sharma on 16/12/24.
//
import SwiftUI

func formatUnixTimeToLocalTime(unixTime: Double) -> String {
    let date = Date(timeIntervalSince1970: unixTime)
    let formatter = DateFormatter()
    formatter.timeStyle = .short // Shows in AM/PM format
    formatter.dateStyle = .none
    formatter.timeZone = .current // Converts to the current timezone
    return formatter.string(from: date)
}

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct WeatherView: View {
    @State private var weather: ResponseBody
    @State private var isLoading: Bool = false
    var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    
    init(weather: ResponseBody) {
        _weather = State(initialValue: weather)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Static background image
                Image("Sunset")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height) // Adjust image size dynamically
                    .ignoresSafeArea()
                    .clipped() // Prevent image overflow

                // ScrollView that adjusts for the top safe area
                ScrollView {
                    VStack {
                        // Add padding at the top of the ScrollView content
                        VStack(alignment: .leading, spacing: 5) {
                            Text(weather.name)
                                .bold()
                                .font(.title)
                            
                            Text("Today, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                                .fontWeight(.light)
                        }
                        .padding(.horizontal, 14)
                        .padding(.top, geometry.safeAreaInsets.top + 20) // Adjust top padding based on device safe area
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                        
                        VStack {
                            HStack {
                                VStack(spacing: 0) {
                                    AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png")) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 100)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    
                                    Text("\(weather.weather[0].main)").font(.system(size: 30))
                                }
                                .padding(.horizontal, 14)
                                .frame(width: 150, alignment: .leading)
                                
                                Spacer()
                                
                                Text("\(String(format: "%.0f", weather.main.feelsLike-273.15))°C")
                                    .font(.system(size: 60))
                                    .fontWeight(.bold)
                                    .padding()
                            }
                            
                            Spacer()
                                .frame(height: 10)
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        
                        VStack {
                            Spacer(minLength: 80)
                            VStack(alignment: .leading, spacing: 20) {
                                Text("Weather now")
                                    .bold()
                                    .padding(.bottom)
                                
                                HStack {
                                    WeatherRow(logo: "thermometer", name: "Min temp", value: "\(String(format: "%.0f", weather.main.tempMin-273.15))°C")
                                    Spacer()
                                    WeatherRow(logo: "thermometer", name: "Max temp", value: "\(String(format: "%.0f", weather.main.tempMax-273.15))°C")
                                }
                                
                                HStack {
                                    WeatherRow(logo: "wind", name: "WindSpeed", value: "\(weather.wind.speed.roundDouble()) m/s")
                                    Spacer()
                                    HStack(spacing: 25) {
                                        Image(systemName: "humidity")
                                            .foregroundColor(Color.white)
                                            .font(.headline)
                                            .frame(width: 20, height: 20)
                                            .padding()
                                            .symbolRenderingMode(.palette)
                                            .background(Color.black)
                                            .cornerRadius(50)
                                        
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Humidity")
                                                .font(.caption)
                                            
                                            Text("\(weather.main.humidity.roundDouble())%")
                                                .bold()
                                                .font(.system(size: 20))
                                        }
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .padding(.bottom, 20)
                            .foregroundColor(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
                            .background(.white)
                            .cornerRadius(20, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight])
                            Spacer()
                            VStack(alignment: .leading, spacing: 20) {
                                Text("Sunrise/Sunset")
                                    .bold()
                                    .padding(.bottom)
                                
                                HStack {
                                    WeatherRow(logo: "sunrise.fill", name: "Sunrise", value: formatUnixTimeToLocalTime(unixTime: weather.sys.sunrise))
                                    Spacer()
                                    WeatherRow(logo: "sunset.fill", name: "Sunset", value: formatUnixTimeToLocalTime(unixTime: weather.sys.sunset))
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .padding(.bottom, 20)
                            .foregroundColor(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
                            .background(.white)
                            .cornerRadius(20, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight])
                        }
                        .cornerRadius(20, corners: [.topLeft, .topRight])
                        .padding(.horizontal, 20)
                    }
                    .edgesIgnoringSafeArea(.bottom)
                }
                .preferredColorScheme(.dark)
            }
        }
        .task {
            await fetchWeather()
        }
        .refreshable {
            await fetchWeather()
        }
    }

    func fetchWeather() async {
        guard let location = locationManager.location else { return }
        do {
            let newWeather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
            weather = newWeather
        } catch {
            print("Failed to fetch weather data: \(error.localizedDescription)")
        }
    }

}

#Preview {
    WeatherView(weather: previewWeather)
}
