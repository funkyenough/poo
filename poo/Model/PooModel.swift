//
//  PooModel.swift
//  poo
//
//  Created by YaoNing on 2024/09/22.
//

import SwiftUI


struct PooDataModel {
    var pooColor: PooColor = .brown
    var pooFeeling: PooFeeling = .happy
    var pooSize: PooSize = .normal

}

// Enum for Excrement Quantity
enum PooSize: String, CaseIterable {
    case small = "Small"
    case normal = "Normal"
    case large = "Large"
}

// Enum for Excrement Color with actual colors
enum PooColor: String, CaseIterable {
    case yellow = "黄"
    case orange = "オレンジ"
    case brown = "茶"
    case darkGreen = "深緑"
    case black = "黒"

    var color: Color {
        switch self {
        case .yellow:
            return Color.yellow
        case .orange:
            return Color.orange
        case .brown:
            return Color.brown
        case .darkGreen:
            return Color.green
        case .black:
            return Color.black
        }
    }
}

// Enum for Excrement Feeling
enum PooFeeling: String, CaseIterable {
    case happy = "poo-chan-happy"
    case stern = "poo-chan-stern"
    case sukkiri = "poo-chan-sukkiri"
    case light = "poo-chan-light"
}
