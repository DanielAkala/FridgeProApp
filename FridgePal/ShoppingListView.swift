//
//  ShoppingListView.swift
//  FridgePal
//
//  Created by csuftitan on 3/30/25.
//

// ShoppingListView.swift
// FridgePal

import SwiftUI
import CoreData

struct ShoppingListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ShoppingItem.addedDate, ascending: true)],
        animation: .default)
    private var shoppingItems: FetchedResults<ShoppingItem>

    var body: some View {
        NavigationView {
            List {
                ForEach(shoppingItems) { item in
                    HStack {
                        Text(item.name ?? "Unnamed Item")
                            .font(.headline)
                        Spacer()
                        Text("Qty: \(item.quantity)")
                            .font(.subheadline)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Shopping List")
        }
    }

    private func deleteItems(offsets: IndexSet) {
        for index in offsets {
            viewContext.delete(shoppingItems[index])
        }
        do {
            try viewContext.save()
        } catch {
            print("Error deleting shopping item: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ShoppingListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

