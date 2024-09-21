import SwiftUI
import MapKit
import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

extension CLLocationCoordinate2D: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
}

// MARK: - PublicToilet Model
struct PublicToilet: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let address: String
    let facilities: [String]
    let rating: Double
}

// MARK: - LocationManager
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.6895, longitude: 139.6917), // Tokyo
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        requestAuthorization()
    }
    
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.authorizationStatus = status
        }
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            // Handle denied access
            break
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}

// MARK: - ContentView
struct MapView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var toilets: [PublicToilet] = []
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var selectedToilet: PublicToilet?
    @State private var showingDetail = false
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $locationManager.region, annotationItems: toilets) { toilet in
                MapAnnotation(coordinate: toilet.coordinate) {
                    VStack {
                        Image(systemName: "toilet")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)
                            .onTapGesture {
                                selectedToilet = toilet
                                showingDetail = true
                            }
                        Text(toilet.name)
                            .font(.caption)
                            .fixedSize()
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                searchForPublicToilets()
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        searchForPublicToilets()
                    }) {
                        Image(systemName: "magnifyingglass")
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .clipShape(Circle())
                    }
                    .padding()
                }
            }
        }
        .sheet(isPresented: $showingDetail) {
            if let toilet = selectedToilet {
                ToiletDetailView(toilet: toilet)
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func searchForPublicToilets() {
        let queries = ["トイレ", "公衆トイレ", "公共トイレ"] // "Toilet", "Public Toilet" in Japanese
        var foundToilets: [PublicToilet] = []
        let group = DispatchGroup()
        
        for query in queries {
            group.enter()
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = query
            request.region = locationManager.region
            
            let search = MKLocalSearch(request: request)
            search.start { response, error in
                defer { group.leave() }
                
                if let error = error {
                    print("Search error for query \(query): \(error.localizedDescription)")
                    return
                }
                
                guard let response = response else {
                    print("No response for query \(query)")
                    return
                }
                
                let mapItems = response.mapItems
                let toiletsFromQuery = mapItems.map { item -> PublicToilet in
                    let name = item.name ?? "トイレ"
                    let coordinate = item.placemark.coordinate
                    let address = parseAddress(from: item.placemark)
                    let facilities = ["Accessible"] // Placeholder
                    let rating = 4.0 // Placeholder
                    
                    return PublicToilet(name: name, coordinate: coordinate, address: address, facilities: facilities, rating: rating)
                }
                
                foundToilets.append(contentsOf: toiletsFromQuery)
            }
        }
        
        group.notify(queue: .main) {
            // Remove duplicates based on coordinate proximity
            toilets = removeDuplicates(from: foundToilets)
        }
    }
    
    func parseAddress(from placemark: CLPlacemark) -> String {
        let addressComponents = [
            placemark.thoroughfare,
            placemark.subThoroughfare,
            placemark.locality,
            placemark.administrativeArea,
            placemark.postalCode,
            placemark.country
        ]
        
        return addressComponents.compactMap { $0 }.joined(separator: ", ")
    }
    
    func removeDuplicates(from toilets: [PublicToilet]) -> [PublicToilet] {
        var uniqueToilets: [PublicToilet] = []
        let threshold: Double = 0.0001 // Adjust as needed for proximity
        
        for toilet in toilets {
            let isDuplicate = uniqueToilets.contains { existing in
                let distance = haversineDistance(
                    lat1: toilet.coordinate.latitude,
                    lon1: toilet.coordinate.longitude,
                    lat2: existing.coordinate.latitude,
                    lon2: existing.coordinate.longitude
                )
                return distance < threshold
            }
            
            if !isDuplicate {
                uniqueToilets.append(toilet)
            }
        }
        
        return uniqueToilets
    }
    
    func haversineDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let R = 6371.0 // Earth radius in kilometers
        let dLat = degreesToRadians(lat2 - lat1)
        let dLon = degreesToRadians(lon2 - lon1)
        let a = sin(dLat / 2) * sin(dLat / 2) +
                cos(degreesToRadians(lat1)) * cos(degreesToRadians(lat2)) *
                sin(dLon / 2) * sin(dLon / 2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))
        return R * c
    }
    
    func degreesToRadians(_ degrees: Double) -> Double {
        return degrees * .pi / 180
    }
}

// MARK: - ToiletDetailView
struct ToiletDetailView: View {
    var toilet: PublicToilet
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(toilet.name)
                .font(.largeTitle)
                .padding(.top)
            
            Text("Address: \(toilet.address)")
                .font(.subheadline)
            
            Text("Facilities: \(toilet.facilities.joined(separator: ", "))")
                .font(.subheadline)
            
            Text(String(format: "Rating: %.1f ⭐️", toilet.rating))
                .font(.subheadline)
            
            Spacer()
        }
        .padding()
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
