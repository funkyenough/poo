//
//  PooViewModel.swift
//  poo
//
//  Created by YaoNing on 2024/09/22.
//

import SwiftUI
import Combine

class PooViewModel: ObservableObject {
    // Dictionary to store PooData, using Date as the key.
    @Published  var pooDataDict: [Date: PooDataModel] = [:]

        // Public method to add or update PooData
    func addOrUpdatePooData(for date: Date, pooData: PooDataModel) {
         // Normalize date to remove time components
         let normalizedDate = Calendar.current.startOfDay(for: date)
         pooDataDict[normalizedDate] = pooData
     }

}
