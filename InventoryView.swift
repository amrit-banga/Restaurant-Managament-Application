//
//  InventoryView.swift
//  RestaurantManagement
//
//  Created by Amrit Banga on 6/10/24.
//  Edited by Tucker Brisbois 6/17/24.
//

import Foundation
import SwiftUI

// Example view for inventory items
struct InventoryView: View {
    var body: some View {
        Text("Inventory Items")
            .font(.title)
    }
}

// Define a simple struct for a food item
struct FoodItem: Identifiable {
    var id = UUID()
    var name: String
    var quantity: Int
}

// Create a ViewModel to manage the inventory
class InventoryViewModel: ObservableObject {
    @Published var foodItems = [
        FoodItem(name: "Apples", quantity: 10),
        FoodItem(name: "Bananas", quantity: 5),
        FoodItem(name: "Oranges", quantity: 8)
    ]
    
    // Function to add a new food item
    func addFoodItem(name: String, quantity: Int) {
        let newItem = FoodItem(name: name, quantity: quantity)
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
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.foodItems) { item in
                        Text("\(item.name) - \(item.quantity)")
                    }
                    .onDelete(perform: viewModel.removeFoodItem)
                }
                .listStyle(PlainListStyle()) // Use PlainListStyle to remove default list appearance
                
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
                
                Spacer()
            }
            .padding()
            .navigationTitle("Food Inventory")
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
                    
                    HStack {
                        Button("Add") {
                            guard !newName.isEmpty, let quantity = Int(newQuantity) else { return }
                            viewModel.addFoodItem(name: newName, quantity: quantity)
                            isShowingAddItemSheet = false // Dismiss sheet after adding
                            newName = ""
                            newQuantity = ""
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
        }
    }
}

struct FoodInventoryView_Previews: PreviewProvider {
    static var previews: some View {
        FoodInventoryView()
    }
}
