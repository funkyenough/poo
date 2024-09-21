//
//  CalendarView.swift
//  poo
//
//  Created by YaoNing on 2024/09/21.
//

import SwiftUI
struct CalendarRecipeView: View {
    @State private var selectedDate = Date()
    @State private var recommendedRecipe: Recipe?

    let calendar = Calendar.current

    var body: some View {
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
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    CalendarRecipeView()
}
