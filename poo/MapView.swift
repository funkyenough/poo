//
//  MapView.swift
//  poo
//
//  Created by Ying Hong on 2024/09/22.
//

import SwiftUI
import MapKit
import CoreLocation

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
                        Image("poo-chan")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)
                            .onTapGesture {
                                selectedToilet = toilet
                                showingDetail = true
                            }
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
                    let id = UUID()
                    let name = item.name ?? "トイレ"
                    let coordinate = item.placemark.coordinate
                    let address = parseAddress(from: item.placemark)
                    let facilities = ["Accessible"] // Placeholder
                    let rating = 4.0 // Placeholder
                    
                    return PublicToilet(id: id, name: name, coordinate: coordinate, address: address, facilities: facilities, rating: rating)
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

// MARK: - FacilityStatusView
struct FacilityStatusView: View {
    var iconName: String
    var status: Bool
    var label: String
    
    var body: some View {
        VStack {
            Image(systemName: iconName)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(status ? .green : .red)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - AvailabilityIconView
struct AvailabilityIconView: View {
    var iconName: String
    var label: String
    var available: Bool?
    
    var body: some View {
        VStack {
            Image(systemName: iconName)
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(available == true ? .green : .red)
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - ReviewView
struct ReviewView: View {
    var review: Review
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                // User Identifier Placeholder
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading) {
                    Text("User \(review.user_id.uuidString.prefix(5))") // Placeholder for user name
                        .font(.headline)
                    Text(review.timestamp, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            // Ratings
            HStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Cleanliness")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    HStack(spacing: 2) {
                        ForEach(0..<5) { index in
                            Image(systemName: index < Int(review.cleanliness.rounded()) ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                        }
                        Text(String(format: "%.1f", review.cleanliness))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Crowdedness")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    HStack(spacing: 2) {
                        ForEach(0..<5) { index in
                            Image(systemName: index < Int(review.crowdedness.rounded()) ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                        }
                        Text(String(format: "%.1f", review.crowdedness))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            // Facilities Availability
            HStack(spacing: 15) {
                AvailabilityIconView(iconName: "paperclip", label: "Toilet Paper", available: review.toilet_paper_available)
                AvailabilityIconView(iconName: "soap", label: "Soap", available: review.soap_available)
                AvailabilityIconView(iconName: "hand.dryer", label: "Hand Dryer", available: review.hand_dryer_functional)
                AvailabilityIconView(iconName: "drop.fill", label: "Sanitizer", available: review.sanitizer_available)
            }
            
            // Comments
            if let comments = review.comments, !comments.isEmpty {
                Text(comments)
                    .font(.body)
                    .foregroundColor(.primary)
                    .padding(.top, 5)
            }
            
            Divider()
        }
        .padding(.vertical, 5)
    }
}

// MARK: - ToiletDetailView
struct ToiletDetailView: View {
    var toilet: PublicToilet
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header with Toilet Name
                Text(toilet.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.top)
                
                // Address Section
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "location.fill")
                        .foregroundColor(.blue)
                        .frame(width: 24, height: 24)
                    Text(toilet.address)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Facilities Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Facilities")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    HStack {
                        ForEach(toilet.facilities, id: \.self) { facility in
                            HStack(spacing: 5) {
                                Image("poo-chan")
                                    .foregroundColor(.green)
                                    .frame(width: 250, height: 250)
                                Text(facility)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                }
                
                // Average Ratings Section
                VStack(alignment: .leading, spacing: 5) {
                    Text("Ratings")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 20) {
                        VStack(alignment: .leading) {
                            Text("Cleanliness")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            HStack(spacing: 2) {
                                ForEach(0..<5) { index in
                                    Image(systemName: index < Int(toilet.averageCleanliness.rounded()) ? "star.fill" : "star")
                                        .foregroundColor(.yellow)
                                }
                                Text(String(format: "%.1f", toilet.averageCleanliness))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Crowdedness")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            HStack(spacing: 2) {
                                ForEach(0..<5) { index in
                                    Image(systemName: index < Int(toilet.averageCrowdedness.rounded()) ? "star.fill" : "star")
                                        .foregroundColor(.yellow)
                                }
                                Text(String(format: "%.1f", toilet.averageCrowdedness))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                
                // Facilities Availability Based on Reviews
                VStack(alignment: .leading, spacing: 10) {
                    Text("Facilities Availability")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    HStack {
                        FacilityStatusView(
                            iconName: "toilet.paper",
                            status: toilet.reviews.contains { $0.toilet_paper_available == true },
                            label: "Toilet Paper"
                        )
                        
                        FacilityStatusView(
                            iconName: "soap",
                            status: toilet.reviews.contains { $0.soap_available == true },
                            label: "Soap"
                        )
                        
                        FacilityStatusView(
                            iconName: "hand.dryer",
                            status: toilet.reviews.contains { $0.hand_dryer_functional == true },
                            label: "Hand Dryer"
                        )
                        
                        FacilityStatusView(
                            iconName: "drop.fill",
                            status: toilet.reviews.contains { $0.sanitizer_available == true },
                            label: "Sanitizer"
                        )
                    }
                }
                
//                // Open in Maps Button
//                Button(action: openInMaps) {
//                    HStack {
//                        Image(systemName: "map")
//                        Text("Open in Maps")
//                            .fontWeight(.semibold)
//                    }
//                    .foregroundColor(.white)
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .background(Color.blue)
//                    .cornerRadius(10)
//                }
//                .padding(.top)
//                
                // Reviews Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Reviews")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    if toilet.reviews.isEmpty {
                        Text("No reviews yet.")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(toilet.reviews.sorted(by: { $0.timestamp > $1.timestamp })) { review in
                            ReviewView(review: review)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
        }
    }
    
    // MARK: - Preview
    struct ToiletDetailView_Previews: PreviewProvider {
        static var previews: some View {
            let sampleReview = Review(
                id: UUID(),
                toilet_id: UUID(),
                user_id: UUID(),
                cleanliness: 4.5,
                crowdedness: 2.0,
                toilet_paper_available: true,
                soap_available: true,
                hand_dryer_functional: false,
                sanitizer_available: true,
                comments: "Clean and well-maintained. The soap dispenser works fine.",
                timestamp: Date()
            )
            
            let sampleToilet = PublicToilet(
                id: UUID(),
                name: "Central Park Public Toilet",
                coordinate: CLLocationCoordinate2D(latitude: 35.6895, longitude: 139.6917),
                address: "1 Central Park, Tokyo, Japan",
                facilities: ["Accessible", "Baby Changing", "Unisex"],
                rating: 4.5,
                distance: 250.0,
                reviews: [sampleReview]
            )
            
            ToiletDetailView(toilet: sampleToilet)
        }
    }
}

