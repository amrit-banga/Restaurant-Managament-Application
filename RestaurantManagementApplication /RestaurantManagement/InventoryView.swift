//
//  InventoryView.swift
//  RestaurantManagement
//
//  Created by Amrit Banga on 6/10/24.
//  Edited by Tucker Brisbois 6/17/24.
//  Edited by Zijian Zhang 6/25/24, 6/28/24, 7/6/24
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct FoodItem: Identifiable {
    var id = UUID()
    var name: String
    var quantity: Int
    var cost: Double
    var expirationDate: Date
    var businessID: UUID
}

class DatabaseManager {
    static let shared = DatabaseManager()
    private let db = Firestore.firestore()
    
    private init() {}
    
    func getAllItems(for businessID: UUID, completion: @escaping ([FoodItem]) -> Void) {
        db.collection("foodItems").whereField("businessID", isEqualTo: businessID.uuidString).getDocuments { (snapshot, error) in
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
                   let expirationDate = (data["expirationDate"] as? Timestamp)?.dateValue(),
                   let businessID = data["businessID"] as? String {
                    items.append(FoodItem(id: UUID(uuidString: id)!,
                                          name: name,
                                          quantity: quantity,
                                          cost: cost,
                                          expirationDate: expirationDate,
                                          businessID: UUID(uuidString: businessID)!))
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
            "expirationDate": item.expirationDate,
            "businessID": item.businessID.uuidString
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
            "expirationDate": item.expirationDate,
            "businessID": item.businessID.uuidString
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

class InventoryViewModel: ObservableObject {
    @Published var foodItems = [FoodItem]()
    var businessID: UUID
    
    init(businessID: UUID) {
        self.businessID = businessID
        fetchFoodItems()
    }

    func fetchFoodItems() {
        DatabaseManager.shared.getAllItems(for: businessID) { [weak self] items in
            DispatchQueue.main.async {
                self?.foodItems = items
            }
        }
    }

    func addFoodItem(name: String, quantity: Int, cost: Double, expirationDate: Date) {
        let newItem = FoodItem(name: name, quantity: quantity, cost: cost, expirationDate: expirationDate, businessID: businessID)
        DatabaseManager.shared.addItem(newItem)
        fetchFoodItems()
    }
    
    func updateFoodItem(_ item: FoodItem) {
        DatabaseManager.shared.updateItem(item)
        fetchFoodItems()
    }
    
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
    @StateObject private var viewModel: InventoryViewModel
    @State private var isShowingAddItemSheet = false
    @State private var isEditingItem = false
    @State private var selectedItem: FoodItem? = nil
    @State private var newName = ""
    @State private var newQuantity = ""
    @State private var newCost = ""
    @State private var newExpirationDate = Date()
    var business: Business?
    private var isOwner: Bool {
        return Auth.auth().currentUser?.uid == business?.ownerId
    }

    init(business: Business) {
        self._viewModel = StateObject(wrappedValue: InventoryViewModel(businessID: business.id))
        self.business = business
    }

    var body: some View {
        VStack {
            VStack {
                Text("Managing Inventory for: \(business?.name ?? "Unknown Business")")
                    .font(.title2)
                    .padding()

                HStack {
                    Text("Business ID: \(business?.id.uuidString ?? "Unknown ID")")
                        .font(.subheadline)
                        .padding(.trailing, 10)
                    Button(action: {
                        if let businessId = business?.id.uuidString {
                            UIPasteboard.general.string = businessId
                        }
                    }) {
                        Text("Copy ID")
                            .foregroundColor(.blue)
                    }
                }
                .padding()

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
                        if isOwner {
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
                    }
                    .padding()
                    .border(Color.black)
                }
            }
            .padding()
            .border(Color.black)
            
            Spacer()
            
            if isOwner {
                Button(action: {
                    isShowingAddItemSheet = true
                }) {
                    HStack {
                        Image(systemName: "plus")
                            .padding(.leading, 5)
                        Text("Add Item")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding()
            }
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
                        isShowingAddItemSheet = false
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
                        isShowingAddItemSheet = false
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
                        let updatedItem = FoodItem(id: selectedItem.id, name: newName, quantity: quantity, cost: cost, expirationDate: newExpirationDate, businessID: viewModel.businessID)
                        viewModel.updateFoodItem(updatedItem)
                        isEditingItem = false
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
                        isEditingItem = false
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
        let sampleBusiness = Business(name: "Sample Business", ownerId: "sampleOwner")
        FoodInventoryView(business: sampleBusiness)
    }
}
