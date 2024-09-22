//
//  HomeView.swift
//  poo
//
//  Created by YaoNing on 2024/09/21.
//
import SwiftUI
 
struct PooView: View {

    // Data : Model
    var selectedDate: Date


    var isSheet: Bool = false // New parameter to indicate context

    @State private var selectedColor: PooColor = .brown
    @State private var selectedFeeling: PooFeeling = .happy
    @State private var selectedSize: PooSize = .normal
    @State private var isLoading = false // Loading state
    @EnvironmentObject private var popManager: PooViewModel
    @State private var alertMessage = ""
    @State private var showAlert = false
    @Environment(\.dismiss) var dismiss
//    @State private var selectedDate: Date = Date()

    var onSubmit: (PooDataModel) -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("排便の記録")
                .font(.largeTitle)
                .fontWeight(.bold)


            Image(selectedFeeling.rawValue)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120)
                .foregroundColor(selectedColor.color)
//                .background(selectedColor.color)

            Text(DateFormatter.localizedString(from: selectedDate, dateStyle: .medium, timeStyle: .none))
                     .font(.subheadline)
                     .foregroundColor(.gray)
            

            Text("便の色を選択")
                .font(.headline)

            HStack {
                ForEach(PooColor.allCases, id: \.self) { color in
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

            Text("便の質を選択")
                .font(.headline)

            // ExcrementQuantity Selector
            HStack {
                ForEach(PooSize.allCases, id: \.self) { size in
                    Button(action: {
                        selectedSize = size
                    }) {
                        Text(size.rawValue)
                            .padding()
                            .background(selectedSize == size ? Color.mainColor : Color.gray.opacity(0.2))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }

            Text("便の気持ちを選択")
                .font(.headline)

            HStack {
                
                ForEach(PooFeeling.allCases, id: \.self) { feeling in
                    Button(action: {
                        selectedFeeling = feeling
                    }) {
                        Image(feeling.rawValue)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .border(selectedFeeling == feeling ? Color.blue : Color.clear, width: 2)
                    }
                }
            }

            Button(action: {
                popManager.addOrUpdatePooData(for: selectedDate, pooData: PooDataModel(pooColor: selectedColor, pooFeeling: selectedFeeling, pooSize: selectedSize))
//                pooDataDict[date] = poo
//                submitRecord()
                onSubmit(PooDataModel(pooColor: selectedColor, pooFeeling: selectedFeeling, pooSize: selectedSize))
                

                isLoading = true
                          // Simulate a network request or processing delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    popManager.addOrUpdatePooData(for: selectedDate, pooData: PooDataModel(pooColor: selectedColor, pooFeeling: selectedFeeling, pooSize: selectedSize))
                    onSubmit(PooDataModel(pooColor: selectedColor, pooFeeling: selectedFeeling, pooSize: selectedSize))


                    if isSheet {
                        dismiss()
                    }
                    alertMessage = "Updated Data:\nColor: \(selectedColor)\nFeeling: \(selectedFeeling)\nSize: \(selectedSize)"
                    showAlert = true // Show the alert

                    isLoading = false // End loading state
                }
            }) {
//                Text("Submit")
//                    .fontWeight(.bold)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)

                ZStack {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5, anchor: .center)
                    } else {
                        Text(isSheet ? "Submit" : "記録する")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.secondaryColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .frame(height: 50) // Fixed height to prevent layout shifts
            }
        }

        .padding()
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Data Updated"),
                          message: Text(alertMessage),
                          dismissButton: .default(Text("OK")))
                }
    }

    private func submitRecord() {
        // Handle the submission logic here
        print("Color: \(selectedColor), Feeling: \(selectedFeeling)")
    }
}


#Preview {
    PooView(selectedDate: Date(), isSheet: false){_ in }
}



