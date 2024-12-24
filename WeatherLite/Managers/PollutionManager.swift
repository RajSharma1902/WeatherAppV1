import Foundation
import CoreLocation

class PollutionManager {
    
    func getCurrentPollution(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> PollutionResponseBody {
        let API_KEY=GlobalSetting.API_KEY
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/air_pollution?lat=\(latitude)&lon=\(longitude)&appid=\(API_KEY)") else {
            fatalError("Missing URL")
        }
        
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error Fetching Weather data")
        }
        
        let decodedData = try JSONDecoder().decode(PollutionResponseBody.self, from: data)
        
        return decodedData
    }
}

struct PollutionResponseBody: Decodable {
    var coord: CoordinatesResponse
    var list: [ListsResponse]  // Change this to an array to match the response
    
    struct CoordinatesResponse: Decodable {
        var lon: Double
        var lat: Double
    }
    
    struct ListsResponse: Decodable {
        var main: MainResponse
        struct MainResponse: Decodable {
            var aqi: Double
        }
        
        var components: ComponentsResponse
        struct ComponentsResponse: Decodable {
            var co: Double
            var no: Double
            var no2: Double
            var o3: Double
            var so2: Double
            var pm2_5: Double
            var pm10: Double
            var nh3: Double
        }
        
        var dt: Double  // Time of the data, can be used for timestamp
        
    }
}
