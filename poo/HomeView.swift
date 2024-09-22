//
//  CalendarView.swift
//  poo
//
//  Created by YaoNing on 2024/09/21.
//

import SwiftUI
//struct HomeView: View {
//    @State private var selectedDate = Date()
//    @State private var recommendedRecipe: Recipe?
//
//    let calendar = Calendar.current
//
//    var body: some View {
//        ScrollView {
//            VStack {
//                DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date])
//                    .datePickerStyle(GraphicalDatePickerStyle())
//                    .padding()
//
//                Divider()
//
//                VStack(alignment: .leading, spacing: 10) {
//                    Text("Today's Recommended Recipe")
//                        .font(.headline)
//
//                    if let recipe = recommendedRecipe {
//                        RecipeCard(recipe: recipe)
//                    } else {
//                        Text("Loading recipe...")
//                            .italic()
//                    }
//                }
//                .padding()
//
//                Spacer()
//            }
//            .navigationTitle("Calendar & Recipe")
//            .onAppear(perform: loadRecommendedRecipe)
//        }
//    }
//    func loadRecommendedRecipe() {
//        // Simulating an API call to get a recommended recipe
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.recommendedRecipe = Recipe(
//                name: "Grilled Chicken Salad",
//                description: "A healthy and delicious salad with grilled chicken, mixed greens, and a light vinaigrette.",
//                ingredients: [
//                    "2 chicken breasts",
//                    "4 cups mixed greens",
//                    "1 cucumber, sliced",
//                    "1 tomato, diced",
//                    "1/4 cup olive oil",
//                    "2 tbsp balsamic vinegar",
//                    "Salt and pepper to taste"
//                ],
//                preparationTime: 20,
//                cookingTime: 15
//            )
//        }
//    }
//}
//
struct Recipe: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let ingredients: [String]
    let preparationTime: Int
    let cookingTime: Int
}

struct RecipeCard: View {
    let recipe: Recipe

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(recipe.name)
                .font(.title2)
                .fontWeight(.bold)

            Text(recipe.description)
                .font(.subheadline)
                .foregroundColor(.secondary)

            HStack {
                Label("\(recipe.preparationTime) min", systemImage: "clock")
                Label("\(recipe.cookingTime) min", systemImage: "flame")
            }
            .font(.caption)

            Text("Ingredients:")
                .font(.headline)

            ForEach(recipe.ingredients, id: \.self) { ingredient in
                Text("• \(ingredient)")
                    .font(.caption)
            }
        }
        .padding()
        //        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}
//
//#Preview {
//    CalendarView()
//}

/////- --------


struct CalendarView: View {

    @State private var selectedDate: Date?
    //    @State private var pooDataDict: [Date: PooDataModel] = [:]
    @State private var showAIView = false
    @EnvironmentObject private var popManager: PooViewModel
    @State private var recommendedRecipe: Recipe?
    private var daysOfWeek: [String] {
        return Calendar.current.weekdaySymbols
    }

    private var daysInMonth: [Int] {
        let calendar = Calendar.current
        let currentDate = Date()
        let range = calendar.range(of: .day, in: .month, for: currentDate)!
        return Array(range)
    }
    private func formattedDate(for day: Int) -> Date? {
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month], from: Date())
        dateComponents.day = day
        return calendar.date(from: dateComponents)
    }

    private func isToday(day: Int) -> Bool {
        guard let date = formattedDate(for: day) else { return false }
        return Calendar.current.isDateInToday(date)
    }
    // Function to summarize poo data
    private func summarizePooData() -> [String: Int] {
        var summary: [String: Int] = [:]

        for (_, pooData) in popManager.pooDataDict {
            // Increment counts based on color or feeling
            let colorKey = pooData.pooColor.rawValue
            summary[colorKey, default: 0] += 1
        }
        return summary
    }

    func loadRecommendedRecipe() {
        // Simulating an API call to get a recommended recipe
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.recommendedRecipe = Recipe(
                name: "Grilled Chicken Salad",
                description: "A healthy and delicious salad with grilled chicken, mixed greens, and a light vinaigrette.",
                ingredients: [
                    "2 chicken breasts",
                    "4 cups mixed greens",
                    "1 cucumber, sliced",
                    "1 tomato, diced",
                    "1/4 cup olive oil",
                    "2 tbsp balsamic vinegar",
                    "Salt and pepper to taste"
                ],
                preparationTime: 20,
                cookingTime: 15
            )
        }
    }


    var body: some View {


        GeometryReader { geometry in
            VStack {
                Text("カレンダー")
                    .font(.title)
                    .padding(5)

                Text("2024年9月")
                    .font(.title2)
                    .padding(8)

            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    Text("排便カレンダー")
                        .font(.largeTitle)
                        .padding()

                    HStack {
                        ForEach(daysOfWeek, id: \.self) { day in
                            Text(day.prefix(2))
                                .frame(maxWidth: .infinity)
                        }
                    }

                    let days = daysInMonth
                    let isLandscape = geometry.size.width > geometry.size.height
                    let columns = Array(repeating: GridItem(.flexible()), count: isLandscape ? 10 : 7)
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(days, id: \.self) { day in
                            VStack {
                                Text("\(day)")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)

                                // display poo data in here
                                if let date = formattedDate(for: day), let pooData = popManager.pooDataDict[date] {
                                    Image(pooData.pooFeeling.rawValue)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(pooData.pooColor.color)
                                }
                            }

                            .frame(height: 65)
                            .background(isToday(day: day) ? Color.blue.opacity(0.3) : Color.white) // Highlight today
                            .cornerRadius(8)
                            .shadow(radius: 2)
                            .onTapGesture {
                                // Set selected date and show PooView
                                let calendar = Calendar.current
                                var dateComponents = calendar.dateComponents([.year, .month], from: Date())
                                dateComponents.day = day
                                selectedDate = calendar.date(from: dateComponents)
                            }
                        }
                    }
                    .padding()
                    // Summary View
                    //                let summary = summarizePooData()
                    //                PooSummaryView(summary: summary)

                Button(action: {
                    showAIView.toggle()
                }) {
                    Text(" 相談する ")
                        .fontWeight(.semibold)
//                      .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.secondaryColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Today's Recommended Recipe")
                            .font(.headline)

                        if let recipe = recommendedRecipe {
                            RecipeCard(recipe: recipe)
                        } else {
                            Text("Loading recipe...")
                                .italic()
                        }
                    }
                    .padding()
                    Button(action: {
                        showAIView.toggle()
                    }) {
                        Text("相談")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.secondaryColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
        }
        .onAppear(perform: loadRecommendedRecipe)
        .sheet(item: $selectedDate){ date in
            //            if let selectedDate = selectedDate {
            PooView(selectedDate: date, isSheet: true) { poo in
                // Handle submission logic here
                print("Submitted: Color: \(poo.pooColor), Feeling: \(poo.pooFeeling) for date: \(poo.pooColor)")
                // Store the submitted poo data for the selected date
                //                    pooDataDict[date] = poo
                popManager.addOrUpdatePooData(for: date, pooData: poo)
            }
            //            }
        }
        .sheet(isPresented: $showAIView){
            AIView()
        }
    }
}

#Preview {
    MenuBar()
        .environmentObject(PooViewModel())
}

//struct Date: Identifiable {
////    let id = UUID()  // Unique identifier
////    let date: Date
//    public var id: Dat { self }
//}
extension String: Identifiable { public var id: String { self } }


extension Date: Identifiable {
    public var id: TimeInterval { self.timeIntervalSince1970 }
}


struct PooSummaryView: View {
    var summary: [String: Int] // Dictionary to hold summary data

    var body: some View {
        VStack(alignment: .leading) {
            Text("Summary")
                .font(.headline)
                .padding(.bottom, 5)

            ForEach(summary.keys.sorted(), id: \.self) { key in
                HStack {
                    Text("\(key): \(summary[key] ?? 0)")
                        .padding(5)
                    Spacer()
                }
                .background(Color.gray.opacity(0.1))
                .cornerRadius(5)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
