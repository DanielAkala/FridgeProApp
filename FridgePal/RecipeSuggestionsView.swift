//
//  RecipeSuggestionsView.swift
//  FridgePal
//
//  Created by csuftitan on 3/31/25.
//

import Foundation
import SwiftUI
import CoreData

struct RecipeSuggestionsView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FoodItem.name, ascending: true)],
        animation: .default)
    private var items: FetchedResults<FoodItem>

    private func findMatchingRecipes(from fridgeItems: [FoodItem]) -> [Recipe] {
        let fridgeNames = fridgeItems.compactMap { $0.name?.lowercased() }

        return sampleRecipes.filter { recipe in
            recipe.ingredients.allSatisfy { fridgeNames.contains($0.lowercased()) }
        }
    }

    var body: some View {
        let matchingRecipes = findMatchingRecipes(from: Array(items))

        return List {
            if matchingRecipes.isEmpty {
                Text("No matching recipes found")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                ForEach(matchingRecipes) { recipe in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(recipe.name)
                            .font(.headline)
                        Text("Ingredients: \(recipe.ingredients.joined(separator: ", "))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(recipe.instructions)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Meal Ideas")
    }
}
