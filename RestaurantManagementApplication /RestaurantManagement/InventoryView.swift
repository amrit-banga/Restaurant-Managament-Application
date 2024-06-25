//
//  InventoryView.swift
//  RestaurantManagement
//
//  Created by Amrit Banga on 6/10/24.
//  Edited by Tucker Brisbois 6/17/24.
//

import Foundation
import SwiftUI

// Define a struct for a food item with additional properties
struct FoodItem: Identifiable {
    var id = UUID()
    var name: String
    var quantity: Int
    var cost: Double
    var expirationDate: Date
}

// Create a ViewModel to manage the inventory
class InventoryViewModel: ObservableObject {
    @Published var foodItems = [
        FoodItem(name: "Apples", quantity: 10, cost: 2.99, expirationDate: Date()),
        FoodItem(name: "Bananas", quantity: 5, cost: 1.99, expirationDate: Date().addingTimeInterval(86400 * 5)), // 5 days later
        FoodItem(name: "Oranges", quantity: 8, cost: 3.49, expirationDate: Date().addingTimeInterval(86400 * 7)) // 7 days later
    ]
    
    // Function to add a new food item
    func addFoodItem(name: String, quantity: Int, cost: Double, expirationDate: Date) {
        let newItem = FoodItem(name: name, quantity: quantity, cost: cost, expirationDate: expirationDate)
        foodItems.append(newItem)
    }
    
    // Function to remove a food item
    func removeFoodItem(at offsets: IndexSet) {
        foodItems.remove(atOffsets: offsets)
    }
}

struct FoodInventoryView: View {
    @StateObject private var viewModel = InventoryViewModel()
    @State private var isShowingAddItemSheet = false
    @State private var newName = ""
    @State private var newQuantity = ""
    @State private var newCost = ""
    @State private var newExpirationDate = Date()
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Food")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Quantity")
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text("Cost")
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text("Expiration Date")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .font(.headline)
                .padding()
                .border(Color.black)
                
                ForEach(viewModel.foodItems) { item in
                    HStack {
                        Text(item.name)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(item.quantity)")
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text("$\(String(format: "%.2f", item.cost))")
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text(expirationDateFormatted(item.expirationDate))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding()
                    .border(Color.black)
                }
            }
            .padding()
            .border(Color.black)
            
            Spacer()
            
            Button(action: {
                isShowingAddItemSheet = true // Toggle to show the sheet
            }) {
                HStack {
                    Image(systemName: "plus")
                        .padding(.leading, 5) // Add padding to center image
                    Text("Add Item")
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .buttonStyle(BorderlessButtonStyle()) // Use BorderlessButtonStyle for macOS
            .padding()
        }
        .padding()
        .sheet(isPresented: $isShowingAddItemSheet, content: {
            // Sheet content for adding new food item
            VStack {
                TextField("Enter name", text: $newName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("Enter quantity", text: $newQuantity)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onChange(of: newQuantity) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            self.newQuantity = filtered
                        }
                    }
                
                TextField("Enter cost", text: $newCost)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onChange(of: newCost) { newValue in
                        let filtered = newValue.filter { "0123456789.".contains($0) }
                        if filtered != newValue {
                            self.newCost = filtered
                        }
                    }
                
                DatePicker("Expiration Date", selection: $newExpirationDate, displayedComponents: .date)
                    .padding()
                
                HStack {
                    Button("Add") {
                        guard !newName.isEmpty, let quantity = Int(newQuantity), let cost = Double(newCost) else { return }
                        viewModel.addFoodItem(name: newName, quantity: quantity, cost: cost, expirationDate: newExpirationDate)
                        isShowingAddItemSheet = false // Dismiss sheet after adding
                        newName = ""
                        newQuantity = ""
                        newCost = ""
                        newExpirationDate = Date()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    Button("Cancel") {
                        isShowingAddItemSheet = false // Dismiss sheet on cancel
                        newName = ""
                        newQuantity = ""
                        newCost = ""
                        newExpirationDate = Date()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding(.top)
            }
            .padding()
        })
        .navigationTitle("Food Inventory")
    }
    
    func expirationDateFormatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

struct FoodInventoryView_Previews: PreviewProvider {
    static var previews: some View {
        FoodInventoryView()
    }
}
