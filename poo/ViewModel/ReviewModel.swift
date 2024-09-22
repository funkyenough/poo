//
//  Review.swift
//  poo
//
//  Created by Ying Hong on 2024/09/22.
//

import Foundation

struct Review: Identifiable, Codable, Hashable {
    let id: UUID
    let toilet_id: UUID
    let user_id: UUID
    let cleanliness: Double
    let crowdedness: Double
    let toilet_paper_available: Bool?
    let soap_available: Bool?
    let hand_dryer_functional: Bool?
    let sanitizer_available: Bool?
    let comments: String?
    let timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case toilet_id
        case user_id
        case cleanliness
        case crowdedness
        case toilet_paper_available
        case soap_available
        case hand_dryer_functional
        case sanitizer_available
        case comments
        case timestamp
    }
}

// func addReview(toiletID: UUID, userID: UUID, review: Review, completion: @escaping (Result<Review, Error>) -> Void) {
//     let client = SupabaseManager.shared.client
    
//     // Prepare the data to insert
//     let newReview: [String: Any] = [
//         "toilet_id": toiletID,
//         "user_id": userID,
//         "cleanliness": review.cleanliness,
//         "crowdedness": review.crowdedness,
//         "toilet_paper_available": review.toilet_paper_available as Any,
//         "soap_available": review.soap_available as Any,
//         "hand_dryer_functional": review.hand_dryer_functional as Any,
//         "sanitizer_available": review.sanitizer_available as Any,
//         "comments": review.comments as Any,
//         "timestamp": review.timestamp
//     ]
    
//     client
//         .database
//         .from("reviews")
//         .insert(values: [newReview])
//         .execute { result in
//             switch result {
//             case .success(let response):
//                 do {
//                     // Decode the inserted review
//                     let insertedReviews = try JSONDecoder().decode([Review].self, from: response.data)
//                     if let insertedReview = insertedReviews.first {
//                         completion(.success(insertedReview))
//                     } else {
//                         completion(.failure(NSError(domain: "No Review Inserted", code: 0, userInfo: nil)))
//                     }
//                 } catch {
//                     completion(.failure(error))
//                 }
//             case .failure(let error):
//                 completion(.failure(error))
//             }
//         }
// }

// func deleteReview(reviewID: UUID, toiletID: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
//     let client = SupabaseManager.shared.client
    
//     client
//         .database
//         .from("reviews")
//         .delete()
//         .eq(column: "id", value: reviewID)
//         .execute { result in
//             switch result {
//             case .success(_):
//                 // After deletion, update the toilet's rating
//                 updateToiletRating(toiletID: toiletID, completion: completion)
//             case .failure(let error):
//                 completion(.failure(error))
//             }
//         }
// }
