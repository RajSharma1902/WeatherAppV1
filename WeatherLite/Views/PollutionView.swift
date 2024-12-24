import SwiftUI
import CoreLocation

struct PollutionView: View {
    @State private var pollution: PollutionResponseBody?  // Change to optional to handle uninitialized state
    @State private var isLoading: Bool = false
    private let pollutionManager = PollutionManager()
    var locationManager = LocationManager()
    init(pollution: PollutionResponseBody? = nil) {  // Allow optional pollution data for preview or initial state
        _pollution = State(initialValue: pollution)
    }

    var body: some View {
        ScrollView {
            ZStack(alignment: .leading) {
                VStack {
                    // Header Section
                    VStack(alignment: .leading, spacing: 5) {
                        Spacer()
                        Text("Air Quality Report")
                            .bold()
                            .font(.title)

                        Text("Today, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                            .fontWeight(.light)
                    }.foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal,14)

                    Spacer()

                    // Pollution Data Section
                    if let pollutionData = pollution {
                        VStack(spacing: 20) {
                            HStack {
                                VStack(spacing: 20) {
                                    Text("AQI")
                                        .font(.headline)
                                    
                                    if let components = pollutionData.list.first?.components {
                                        let aqi = PollutionCalculations.calculateAQI(from: components)
                                        let description = PollutionCalculations.airQualityDescription(for: aqi)
                                        
                                        Text("\(aqi)")
                                            .font(.largeTitle)
                                            .fontWeight(.bold)
                                        
                                        Text(description)
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                    } else {
                                        Text("N/A")
                                            .font(.largeTitle)
                                            .fontWeight(.bold)
                                    }
                                }
                                .foregroundColor(.white)
                                .frame(width: 150, alignment: .leading)


                                Spacer()

                                AsyncImage(url: URL(string: "https://cdn.pixabay.com/photo/2020/01/24/21/33/city-4791269_960_720.png")) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 150)
                                } placeholder: {
                                    ProgressView()
                                }
                            }.foregroundColor(.white)


                            // Components Details
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Pollution Components")
                                    .bold()
                                    .padding(.bottom)

                                PollutionRow(label: "CO", value: pollutionData.list.first?.components.co ?? 0, specifier: "%.1f")
                                PollutionRow(label: "NO", value: pollutionData.list.first?.components.no ?? 0, specifier: "%.1f")
                                PollutionRow(label: "NO₂", value: pollutionData.list.first?.components.no2 ?? 0, specifier: "%.1f")
                                PollutionRow(label: "O₃", value: pollutionData.list.first?.components.o3 ?? 0, specifier: "%.1f")
                                PollutionRow(label: "SO₂", value: pollutionData.list.first?.components.so2 ?? 0, specifier: "%.1f")
                                PollutionRow(label: "PM2.5", value: pollutionData.list.first?.components.pm2_5 ?? 0, specifier: "%.1f")
                                PollutionRow(label: "PM10", value: pollutionData.list.first?.components.pm10 ?? 0, specifier: "%.1f")
                                PollutionRow(label: "NH₃", value: pollutionData.list.first?.components.nh3 ?? 0, specifier: "%.2f")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .padding(.bottom, 20)
                            .foregroundColor(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
                            .background(.white)
                            .cornerRadius(20, corners: [.topLeft, .topRight,.bottomLeft,.bottomRight])
                        }
                        .padding()
                    } else {
                        ProgressView("Loading...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(2)
                            .padding()
                    }
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .background(Image("Night"))
            .preferredColorScheme(.dark)
        }
        .refreshable {
            await refreshPollution()
        }
    }

    func refreshPollution() async {
        guard let location = locationManager.location else { return }
        isLoading = true
        do {
            let newPollution = try await pollutionManager.getCurrentPollution(latitude: location.latitude, longitude: location.longitude)
            pollution = newPollution
        } catch {
            print("Failed to fetch pollution data: \(error.localizedDescription)")
        }
        isLoading = false
    }
}

// PollutionRow View for individual components
struct PollutionRow: View {
    let label: String
    let value: Double
    let specifier: String
    let unit = "μg/m3"
    var body: some View {
        HStack {
            Text(label)
                .font(.headline)
            Spacer()
            Text(String(format: specifier, value))
                .font(.headline).fontWeight(.heavy)
            Text(" "+unit).font(.footnote).fontWeight(.light)
        }
        .padding(.vertical, 5)
    }
}

struct PollutionView_Previews: PreviewProvider {
    static var previews: some View {
        PollutionView(pollution: previewPollution)
    }
}
