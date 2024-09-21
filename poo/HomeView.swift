//
//  CalendarView.swift
//  poo
//
//  Created by YaoNing on 2024/09/21.
//

import SwiftUI
struct HomeView: View {
    @State private var selectedDate = Date()
    @State private var recommendedRecipe: Recipe?

    let calendar = Calendar.current

    var body: some View {
        ScrollView {
            VStack {
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date])
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                
                Divider()
                
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
                
                Spacer()
            }
            .navigationTitle("Calendar & Recipe")
            .onAppear(perform: loadRecommendedRecipe)
        }
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
}

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

#Preview {
    CalendarView(friends: [])
}



struct Friend {
    var name: String
    var birthday: Date
}

struct CalendarView: View {
    var friends: [Friend]
  

    @State private var selectedDate: Date?
    @State private var showPooView = false

    private var daysOfWeek: [String] {
        return Calendar.current.weekdaySymbols
    }

    private var daysInMonth: [Int] {
        let calendar = Calendar.current
        let currentDate = Date()
        let range = calendar.range(of: .day, in: .month, for: currentDate)!
        return Array(range)
    }

    private func friendsNames(for day: Int) -> [String] {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())

        return friends
            .filter { friend in
                let birthdayComponents = calendar.dateComponents([.month, .day], from: friend.birthday)
                return birthdayComponents.month == currentMonth && birthdayComponents.day == day
            }
            .map { friend in
                friend.name
            }
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Calendar")
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
                                .onTapGesture {
                                    // Set selected date and show PooView
                                    let calendar = Calendar.current
                                    var dateComponents = calendar.dateComponents([.year, .month], from: Date())
                                    dateComponents.day = day
                                    selectedDate = calendar.date(from: dateComponents)
                                    showPooView.toggle()
                                }

                            ForEach(friendsNames(for: day), id: \.self) { name in
                                Text(name)
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                        }
                        .frame(height: 50)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 2)
                    }
                }
                .padding()
            }
            .padding()
        }
        .sheet(isPresented: $showPooView) {
            if let selectedDate = selectedDate {
                PooView(selectedDate: selectedDate) { color, feeling in
                    // Handle submission logic here
                    print("Submitted: Color: \(color), Feeling: \(feeling) for date: \(selectedDate)")
                    
                }
            }
        }
    }
}

#Preview {
    CalendarView(friends: [
        Friend(name: "Alice", birthday: DateComponents(calendar: Calendar.current, year: 2024, month: 9, day: 15).date!),
        Friend(name: "Bob", birthday: DateComponents(calendar: Calendar.current, year: 2024, month: 9, day: 15).date!)
    ])
}
