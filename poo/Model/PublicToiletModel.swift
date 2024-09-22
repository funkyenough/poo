////
////  MapViewModel.swift
////  poo
////
////  Created by Ying Hong on 2024/09/22.
////
//
import Foundation
import CoreLocation
//import MapKit
//import Supabase
//

// MARK: - PublicToilet Struct
struct PublicToilet: Identifiable {
    let id: UUID
    let name: String
    let coordinate: CLLocationCoordinate2D
    let address: String
    let facilities: [String]
    let rating: Double
    var distance: Double? // Distance in meters from user's location
    var reviews: [Review] = [] // Array of reviews
    
    // Computed properties for average ratings
    var averageCleanliness: Double {
        guard !reviews.isEmpty else { return 0.0 }
        let total = reviews.reduce(0) { $0 + $1.cleanliness }
        return total / Double(reviews.count)
    }
    
    var averageCrowdedness: Double {
        guard !reviews.isEmpty else { return 0.0 }
        let total = reviews.reduce(0) { $0 + $1.crowdedness }
        return total / Double(reviews.count)
    }
}

//// Extensions for CLLocationCoordinate2D
//extension CLLocationCoordinate2D: Equatable {
//    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
//        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
//    }
//}
//
//extension CLLocationCoordinate2D: Hashable {
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(latitude)
//        hasher.combine(longitude)
//    }
//}
//
//final class SupabaseManager {
//    static let shared = SupabaseManager()
//    
//    let client: SupabaseClient
//
//    private init() {
//        // Replace with your Supabase URL and Anon Key
//        let supabaseURL = URL(string: "https://YOUR-SUPABASE-URL.supabase.co")!
//        let supabaseKey = "YOUR-ANON-KEY"
//        
//        client = SupabaseClient(supabaseURL: supabaseURL, supabaseKey: supabaseKey)
//    }
//}
//
//let supabaseClient = SupabaseManager.shared.client
