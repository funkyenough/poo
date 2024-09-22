//
//  MapViewModel.swift
//  poo
//
//  Created by Ying Hong on 2024/09/22.
//

import Foundation
import CoreLocation
import MapKit
import Supabase

// MARK: - PublicToilet Model
struct PublicToilet: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let address: String
    let facilities: [String]
    let rating: Double
}

// Extensions for CLLocationCoordinate2D
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

final class SupabaseManager {
    static let shared = SupabaseManager()
    
    let client: SupabaseClient

    private init() {
        // Replace with your Supabase URL and Anon Key
        let supabaseURL = URL(string: "https://YOUR-SUPABASE-URL.supabase.co")!
        let supabaseKey = "YOUR-ANON-KEY"
        
        client = SupabaseClient(supabaseURL: supabaseURL, supabaseKey: supabaseKey)
    }
}

let supabaseClient = SupabaseManager.shared.client

//func fetchPublicToilets(completion: @escaping (Result<[PublicToilet], Error>) -> Void) {
//    let client = SupabaseManager.shared.client
//    client
//        .database
//        .from("public_toilets")
//        .select("*, reviews(*)") // Embedding reviews
//        .execute { result in
//            switch result {
//            case .success(let response):
//                do {
//                    // Decode the response data
//                    let toilets = try JSONDecoder().decode([PublicToilet].self, from: response.data)
//                    completion(.success(toilets))
//                } catch {
//                    completion(.failure(error))
//                }
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//}
//
//func updateToiletRating(toiletID: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
//    let client = SupabaseManager.shared.client
//    
//    let parameters: [String: Any] = [
//        "toilet_uuid": toiletID
//    ]
//    
//    client
//        .database
//        .rpc(fn: "update_public_toilet_rating", params: parameters)
//        .execute { result in
//            switch result {
//            case .success(_):
//                completion(.success(()))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//}

// func generateRegionsForTokyo() -> [MKCoordinateRegion] {
//     // Define Tokyo's approximate bounding box
//     let minLat = 35.528 // Southern latitude
//     let maxLat = 35.898 // Northern latitude
//     let minLon = 139.562 // Western longitude
//     let maxLon = 139.912 // Eastern longitude

//     let latDelta = 0.05
//     let lonDelta = 0.05

//     var regions: [MKCoordinateRegion] = []

//     var lat = minLat
//     while lat < maxLat {
//         var lon = minLon
//         while lon < maxLon {
//             let center = CLLocationCoordinate2D(latitude: lat + latDelta / 2, longitude: lon + lonDelta / 2)
//             let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
//             let region = MKCoordinateRegion(center: center, span: span)
//             regions.append(region)
//             lon += lonDelta
//         }
//         lat += latDelta
//     }

//     return regions
// }

// func searchForToiletsInRegion(region: MKCoordinateRegion, completion: @escaping ([PublicToilet]) -> Void) {
//     let queries = ["トイレ", "公衆トイレ", "公共トイレ"] // Japanese terms for toilets
//     var foundToilets: [PublicToilet] = []
//     let group = DispatchGroup()

//     for query in queries {
//         group.enter()
//         let request = MKLocalSearch.Request()
//         request.naturalLanguageQuery = query
//         request.region = region

//         let search = MKLocalSearch(request: request)
//         search.start { response, error in
//             defer { group.leave() }

//             if let error = error {
//                 print("Search error for query \(query): \(error.localizedDescription)")
//                 return
//             }

//             guard let response = response else {
//                 print("No response for query \(query)")
//                 return
//             }

//             let mapItems = response.mapItems
//             let toiletsFromQuery = mapItems.map { item -> PublicToilet in
//                 let id = UUID()
//                 let name = item.name ?? "トイレ"
//                 let coordinate = item.placemark.coordinate
//                 let address = parseAddress(from: item.placemark)
//                 let facilities = ["Unknown"] // Placeholder or extract if available
//                 let rating = 0.0 // Initial rating
//                 return PublicToilet(
//                     id: id,
//                     name: name,
//                     latitude: coordinate.latitude,
//                     longitude: coordinate.longitude,
//                     address: address,
//                     facilities: facilities,
//                     rating: rating,
//                     reviews: nil
//                 )
//             }

//             foundToilets.append(contentsOf: toiletsFromQuery)
//         }
//     }

//     group.notify(queue: .main) {
//         completion(foundToilets)
//     }
// }

// func parseAddress(from placemark: CLPlacemark) -> String {
//     let addressComponents = [
//         placemark.administrativeArea,
//         placemark.locality,
//         placemark.thoroughfare,
//         placemark.subThoroughfare
//     ]
//     return addressComponents.compactMap { $0 }.joined(separator: ", ")
// }

// func removeDuplicates(from toilets: [PublicToilet]) -> [PublicToilet] {
//     var uniqueToilets: [PublicToilet] = []
//     let threshold = 0.0001 // Approximately 11 meters

//     for toilet in toilets {
//         let isDuplicate = uniqueToilets.contains { existing in
//             let distance = haversineDistance(
//                 lat1: toilet.latitude,
//                 lon1: toilet.longitude,
//                 lat2: existing.latitude,
//                 lon2: existing.longitude
//             )
//             return distance < threshold
//         }

//         if !isDuplicate {
//             uniqueToilets.append(toilet)
//         }
//     }

//     return uniqueToilets
// }

// func haversineDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
//     let R = 6371.0 // Earth's radius in kilometers
//     let dLat = degreesToRadians(lat2 - lat1)
//     let dLon = degreesToRadians(lon2 - lon1)
//     let a = sin(dLat / 2) * sin(dLat / 2) +
//         cos(degreesToRadians(lat1)) * cos(degreesToRadians(lat2)) *
//         sin(dLon / 2) * sin(dLon / 2)
//     let c = 2 * atan2(sqrt(a), sqrt(1 - a))
//     return R * c
// }

// func degreesToRadians(_ degrees: Double) -> Double {
//     return degrees * .pi / 180
// }

// func insertToiletsIntoSupabase(toilets: [PublicToilet], completion: @escaping (Result<Void, Error>) -> Void) {
//     let client = SupabaseManager.shared.client

//     // Prepare data for insertion
//     let toiletsData = toilets.map { toilet -> [String: Any] in
//         return [
//             "id": toilet.id.uuidString,
//             "name": toilet.name,
//             "latitude": toilet.latitude,
//             "longitude": toilet.longitude,
//             "address": toilet.address,
//             "facilities": toilet.facilities,
//             "rating": toilet.rating
//         ]
//     }

//     client
//         .database
//         .from("public_toilets")
//         .insert(values: toiletsData)
//         .execute { result in
//             switch result {
//             case .success(_):
//                 completion(.success(()))
//             case .failure(let error):
//                 completion(.failure(error))
//             }
//         }
// }
