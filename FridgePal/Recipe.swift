//
//  Recipe.swift
//  FridgePal
//
//  Created by csuftitan on 3/31/25.
//

import Foundation
import Foundation

struct Recipe: Identifiable {
    let id = UUID()
    let name: String
    let ingredients: [String]
    let instructions: String
}

let sampleRecipes: [Recipe] = [
    Recipe(
        name: "Grilled Cheese Sandwich",
        ingredients: ["bread", "cheese", "butter"],
        instructions: "Butter the bread, add cheese, and grill until golden brown."
    ),
    Recipe(
        name: "Fruit Salad",
        ingredients: ["apple", "banana", "orange"],
        instructions: "Chop all fruits and mix them in a bowl."
    ),
    Recipe(
        name: "Omelette",
        ingredients: ["egg", "milk", "salt"],
        instructions: "Whisk eggs with milk, season, and cook in a pan."
    )
]
