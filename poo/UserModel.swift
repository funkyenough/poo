//
//  UserModel.swift
//  poo
//
//  Created by YaoNing on 2024/09/21.
//

import UIKit


struct UserModel: Codable ,Equatable, Hashable, Identifiable {

    var id: String { uid }
    let uid: String
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var postCode: String = ""
    var address1: String = ""
    var address2: String = ""
    var phoneNumber: String = ""
    var snsAccount: String = ""
    var isBusiness: Bool = false
    var title: String = ""
    var company: String = ""
    var birthday: String?
    //Since UserDefaults only stores simple data types (like strings, numbers, and data), you can store your UserModel by making it conform to Codable and serializing the data before storing it in UserDefaults.
    var profileImageData: Data?

    var profileImage: UIImage {
        get {
            if let data = profileImageData, let image = UIImage(data: data) {
                return image
            }
            return UIImage(named: "user") ?? UIImage()
        }
        set {
            profileImageData = newValue.jpegData(compressionQuality: 0.8)
        }
    }

    // store friend's userId here
    var allFriend: [String]?
    var tierOne: [String]?
    var tierTwo: [String]?
    var tierThree: [String]?

    //business
    var tierOneBusiness: [String]?
    var tierTwoBusiness: [String]?
    var tierThreeBusiness: [String]?
}

 


struct Friendship: Codable, Identifiable {
    var id: String
    var userId: String
    var tier: FriendshipTier
    var addedDate: Date
}

enum FriendshipTier: String, Codable {
    case tier1 = "Tier 1"
    case tier2 = "Tier 2"
    case tier3 = "Tier 3"

//    tier_three
}

