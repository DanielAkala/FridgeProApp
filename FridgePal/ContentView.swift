//
//  ContentView.swift
//  FridgePal
//
//  Created by csuftitan on 3/25/25.
//


import SwiftUI
import CoreData
import UserNotifications

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FoodItem.expirationDate, ascending: true)],
        animation: .default)
    private var items: FetchedResults<FoodItem>

    @State private var showingAddItem = false
    @State private var showExpiredAlert = false
    @State private var hasShownExpiredAlert = false

    var body: some View {
        NavigationView {
            Group {
                if items.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "snowflake")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.blue.opacity(0.4))

                        Text("Your fridge is empty 🧊")
                            .font(.title3)
                            .multilineTextAlignment(.center)

                        Text("Tap ➕ to start adding items.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                } else {
                    List {
                        ForEach(items) { item in
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(item.name ?? "Unnamed Item")
                                        .font(.headline)

                                    if isExpired(item.expirationDate) {
                                        Text("Expired")
                                            .font(.caption2)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(Color.red)
                                            .cornerRadius(6)
                                    } else if isExpiringSoon(item.expirationDate) {
                                        Text("Use Soon")
                                            .font(.caption2)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(Color.orange)
                                            .cornerRadius(6)
                                    }
                                }

                                HStack {
                                    Text("Qty: \(item.quantity)")
                                    Spacer()
                                    Text("Expires: \(formattedDate(item.expirationDate))")
                                        .foregroundColor(colorForExpiration(item.expirationDate))
                                }
                                .font(.subheadline)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    markItemAsUsed(item)
                                } label: {
                                    Label("Used", systemImage: "checkmark.circle")
                                }

                                Button {
                                    moveToShoppingList(item)
                                } label: {
                                    Label("To Shop", systemImage: "cart")
                                }
                                .tint(.blue)
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                }
            }
            .navigationTitle("FridgePro")
            .onAppear(perform: checkExpiredThreshold)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddItem = true }) {
                        Label("Add", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ShoppingListView()) {
                        Image(systemName: "cart")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: RecipeSuggestionsView()) {
                        Image(systemName: "lightbulb")
                    }
                }
            }
            .sheet(isPresented: $showingAddItem) {
                AddItemView()
                    .environment(\.managedObjectContext, viewContext)
            }
            .alert("🧼 Clean Out Reminder", isPresented: $showExpiredAlert) {
                Button("Got it!", role: .cancel) { }
            } message: {
                Text("You have at least 3 expired items. It might be time to clean out your fridge.")
            }
        }
    }

    private func checkExpiredThreshold() {
        guard !hasShownExpiredAlert else { return } //avoids repeat alert
        let expiredCount = items.filter { isExpired($0.expirationDate) }.count
        if expiredCount >= 3 {
            showExpiredAlert = true
            hasShownExpiredAlert = true
        }
    }

    private func deleteItems(offsets: IndexSet) {
        for index in offsets {
            viewContext.delete(items[index])
        }

        do {
            try viewContext.save()
        } catch {
            print("Error deleting: \(error.localizedDescription)")
        }
    }

    private func markItemAsUsed(_ item: FoodItem) {
        viewContext.delete(item)
        do {
            try viewContext.save()
        } catch {
            print("Failed to mark item as used: \(error.localizedDescription)")
        }
    }

    private func moveToShoppingList(_ item: FoodItem) {
        let shoppingItem = ShoppingItem(context: viewContext)
        shoppingItem.id = UUID()
        shoppingItem.name = item.name
        shoppingItem.quantity = item.quantity
        shoppingItem.addedDate = Date()

        viewContext.delete(item)

        do {
            try viewContext.save()
        } catch {
            print("❌ Failed to move item to shopping list: \(error.localizedDescription)")
        }
    }

    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    private func isExpired(_ date: Date?) -> Bool {
        guard let date = date else { return false }
        return date < Date()
    }

    private func isExpiringSoon(_ date: Date?) -> Bool {
        guard let date = date else { return false }
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        return date <= tomorrow && !isExpired(date)
    }

    private func colorForExpiration(_ date: Date?) -> Color {
        if isExpired(date) {
            return .red
        } else if isExpiringSoon(date) {
            return .orange
        } else {
            return .secondary
        }
    }
}
