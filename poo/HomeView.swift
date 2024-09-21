//
//  HomeView.swift
//  poo
//
//  Created by YaoNing on 2024/09/21.
//

import SwiftUI
struct HomeView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Featured")) {
                    ForEach(0..<3) { item in
                        Text("Featured Item \(item + 1)")
                    }
                }

                Section(header: Text("Categories")) {
                    ForEach(["Category 1", "Category 2", "Category 3"], id: \.self) { category in
                        NavigationLink(destination: Text(category)) {
                            Text(category)
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Home")
        }
    }
}



#Preview {
    HomeView()
}
