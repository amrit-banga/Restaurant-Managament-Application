//
//  InventoryView.swift
//  RestaurantManagement
//
//  Created by Amrit Banga on 6/10/24.
//  Edited by Tucker Brisbois 6/17/24.
//  Edited by Zijian Zhang 6/25/24.

import Foundation
import SwiftUI
import FirebaseFirestore

// Define a struct for a food item with additional properties

struct FoodItem: Identifiable {
    var id = UUID()
    var name: String
    var quantity: Int
    var cost: Double
    var expirationDate: Date
}


class DatabaseManager {
    static let shared = DatabaseManager()
    private let db = Firestore.firestore()
    
    private init() {}
    
    func getAllItems(completion: @escaping ([FoodItem]) -> Void) {
        db.collection("foodItems").getDocuments { (snapshot, error) in
            var items = [FoodItem]()
            if let error = error {
                print("Error getting documents: \(error)")
                completion(items)
                return
            }
            for document in snapshot!.documents {
                let data = document.data()
                if let id = data["id"] as? String,
                   let name = data["name"] as? String,
                   let quantity = data["quantity"] as? Int,
                   let cost = data["cost"] as? Double,
                   let expirationDate = (data["expirationDate"] as? Timestamp)?.dateValue() {
                    items.append(FoodItem(id: UUID(uuidString: id)!,
                                          name: name,
                                          quantity: quantity,
                                          cost: cost,
                                          expirationDate: expirationDate))
                }
            }
            completion(items)
        }
    }
    
    func addItem(_ item: FoodItem) {
        db.collection("foodItems").document(item.id.uuidString).setData([
            "id": item.id.uuidString,
            "name": item.name,
            "quantity": item.quantity,
            "cost": item.cost,
            "expirationDate": item.expirationDate
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            }
        }
    }
    
    func updateItem(_ item: FoodItem) {
        db.collection("foodItems").document(item.id.uuidString).updateData([
            "name": item.name,
            "quantity": item.quantity,
            "cost": item.cost,
            "expirationDate": item.expirationDate
        ]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            }
        }
    }
    
    func deleteItem(_ item: FoodItem) {
        db.collection("foodItems").document(item.id.uuidString).delete { error in
            if let error = error {
                print("Error deleting document: \(error)")
            }
        }
    }
}

// Create a ViewModel to manage the inventory

class InventoryViewModel: ObservableObject {
    @Published var foodItems = [FoodItem]()
    
    init() {
        fetchFoodItems()
    }

    func fetchFoodItems() {
        DatabaseManager.shared.getAllItems { [weak self] items in
            DispatchQueue.main.async {
                self?.foodItems = items
            }
        }
    }

    // Function to add a new food item
    func addFoodItem(name: String, quantity: Int, cost: Double, expirationDate: Date) {
        let newItem = FoodItem(name: name, quantity: quantity, cost: cost, expirationDate: expirationDate)
        DatabaseManager.shared.addItem(newItem)
        fetchFoodItems()
    }
    
    // Function to update an existing food item
    func updateFoodItem(_ item: FoodItem) {
        DatabaseManager.shared.updateItem(item)
        fetchFoodItems()
    }
    
    // Function to remove a food item
    func removeFoodItem(at offsets: IndexSet) {
        offsets.map { foodItems[$0] }.forEach { DatabaseManager.shared.deleteItem($0) }
        fetchFoodItems()
    }
    func removeFoodItem(_ item: FoodItem) {
        DatabaseManager.shared.deleteItem(item)
        fetchFoodItems()
    }
}


struct FoodInventoryView: View {
    @StateObject private var viewModel = InventoryViewModel()
    @State private var isShowingAddItemSheet = false
    @State private var isEditingItem = false
    @State private var selectedItem: FoodItem? = nil
    @State private var newName = ""
    @State private var newQuantity = ""
    @State private var newCost = ""
    @State private var newExpirationDate = Date()
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Food")
                        .frame(maxWidth: 45, alignment: .leading)
                    Text("Quantity")
                        .frame(maxWidth: 70, alignment: .center)
                    Text("Cost")
                        .frame(maxWidth: 40, alignment: .center)
                    Text("Expiration Date")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .font(.subheadline)
                .padding()
                .border(Color.black)
                
                ForEach(viewModel.foodItems) { item in
                    HStack {
                        Text(item.name)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(size: 11))
                        Text("\(item.quantity)")
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text("$\(String(format: "%.2f", item.cost))")
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text(expirationDateFormatted(item.expirationDate))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .font(.system(size: 12))
                        Button(action: {
                            selectedItem = item
                            newName = item.name
                            newQuantity = "\(item.quantity)"
                            newCost = String(format: "%.2f", item.cost)
                            newExpirationDate = item.expirationDate
                            isEditingItem = true
                        }) {
                            Image(systemName: "pencil")
                                .foregroundColor(.blue)
                        }
                        .padding(.leading, 5)
                        Button(action: {
                            viewModel.removeFoodItem(item)
                        }) {
                            Text("X")
                                .foregroundColor(.red)
                                .font(.system(size: 20))
                        }
                        .padding(.leading, 1)
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
        .sheet(isPresented: $isEditingItem, content: {
            // Sheet content for editing existing food item
            VStack {
                Text("Edit")
                .font(.system(size: 30))
                
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
                    Button("Save") {
                        guard let selectedItem = selectedItem,
                              !newName.isEmpty,
                              let quantity = Int(newQuantity),
                              let cost = Double(newCost) else { return }
                        let updatedItem = FoodItem(id: selectedItem.id, name: newName, quantity: quantity, cost: cost, expirationDate: newExpirationDate)
                        viewModel.updateFoodItem(updatedItem)
                        isEditingItem = false // Dismiss sheet after editing
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
                        isEditingItem = false // Dismiss sheet on cancel
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
