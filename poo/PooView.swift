//
//  HomeView.swift
//  poo
//
//  Created by YaoNing on 2024/09/21.
//
import SwiftUI


struct PooDataModel {
    var pooColor: PoolColor = .brown
    var pooFeeling: PooFeeling = .happy
    var pooSize: PoolSize = .normal


}

//@Observable
//class PooViewModel {
//    var selectedColor:ExcrementColor = .brown
//    var selectedFeeling: String = "happy"
//    var selectedQuantity: ExcrementQuantity = .normal
//
//}



struct PooView: View {

    // Data : Model
    var selectedDate: Date


    @State private var selectedColor: PoolColor = .brown
    @State private var selectedFeeling: PooFeeling = .happy
    @State private var selectedQuantity: PoolSize = .normal


    @Environment(\.dismiss) var dismiss
//    @State private var selectedDate: Date = Date()

    var onSubmit: (PoolColor, PooFeeling) -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Defecation Record")
                .font(.largeTitle)
                .fontWeight(.bold)


            Image("poo-chan-" + selectedFeeling.rawValue)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120)
                .foregroundColor(selectedColor.color)
                .background(selectedColor.color)

            Text(DateFormatter.localizedString(from: selectedDate, dateStyle: .medium, timeStyle: .none))
                     .font(.subheadline)
                     .foregroundColor(.gray)
            

            Text("Select Defecation Color")
                .font(.headline)

            HStack {
                ForEach(PoolColor.allCases, id: \.self) { color in
                    Button(action: {
                        selectedColor = color
                    }) {
                        Circle()
                            .fill(color.color) // Use the color from the enum
                            .frame(width: 50, height: 50)
                            .overlay(
                                Circle()
                                    .stroke(selectedColor == color ? Color.blue : Color.clear, lineWidth: 2)
                            )
                    }
                }
            }

            Text("Select Quantity")
                .font(.headline)

            // ExcrementQuantity Selector
            HStack {
                ForEach(PoolSize.allCases, id: \.self) { quantity in
                    Button(action: {
                        selectedQuantity = quantity
                    }) {
                        Text(quantity.rawValue)
                            .padding()
                            .background(selectedQuantity == quantity ? Color.blue : Color.gray.opacity(0.2))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }

            Text("Select Feeling")
                .font(.headline)

            HStack {
                // TODO: enum
                ForEach(PooFeeling.allCases, id: \.self) { feeling in
                    Button(action: {
                        selectedFeeling = feeling
                    }) {
                        Image("poo-chan-" + feeling.rawValue)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .border(selectedFeeling == feeling ? Color.blue : Color.clear, width: 2)
                    }
                }
            }

            Button(action: {
//                submitRecord()
                onSubmit(selectedColor, selectedFeeling)
                dismiss()
            }) {
                Text("Submit")
                    .fontWeight(.bold)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }

    private func submitRecord() {
        // Handle the submission logic here
        print("Color: \(selectedColor), Feeling: \(selectedFeeling)")
    }
}


#Preview {
    PooView(selectedDate: Date()){_,_ in }
}




// Enum for Excrement Quantity
enum PoolSize: String,CaseIterable {
    case small = "Small"
    case normal = "Normal"
    case large = "Large"
}

// Enum for Excrement Color with actual colors
enum PoolColor: String, CaseIterable {
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
    case happy = "happy"
    case stern = "stern"
    case sukkiri = "sukkiri"
    case light = "light"
}
