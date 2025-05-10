//
//  AddItemView.swift
//  FridgePal
//
//  Created by csuftitan on 3/25/25.
//
import UserNotifications
import Foundation
import SwiftUI

struct AddItemView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var quantity = 1
    @State private var expirationDate = Date()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Food Info")) {
                    TextField("Item name", text: $name)
                    Stepper(value: $quantity, in: 1...100) {
                        Text("Quantity: \(quantity)")
                    }
                    DatePicker("Expires on", selection: $expirationDate, displayedComponents: .date)
                }

                Section {
                    Button("Save") {
                        addItem()
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
            .navigationTitle("Add Food")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func addItem() {
        let newItem = FoodItem(context: viewContext)
        newItem.id = UUID()
        newItem.name = name
        newItem.quantity = Int16(quantity)
        newItem.expirationDate = expirationDate

        do {
            try viewContext.save()
            scheduleExpirationNotification(for: newItem)
        } catch {
            print("Failed to save: \(error.localizedDescription)")
        }
    }
}

private func scheduleExpirationNotification(for item: FoodItem) {
    guard let id = item.id?.uuidString,
          let name = item.name else { return }

    let content = UNMutableNotificationContent()
    content.title = "Expiring Today!"
    content.body = "\(name) is expiring today. Don’t forget to use it!"
    content.sound = .default

    let calendar = Calendar.current
    let triggerDate = calendar.dateComponents([.year, .month, .day], from: item.expirationDate ?? Date())

    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

    let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("Error scheduling notification: \(error.localizedDescription)")
        }
    }
}
