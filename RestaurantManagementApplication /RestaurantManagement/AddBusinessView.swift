//
//  AddBusinessView.swift
//  RestaurantManagement
//
//  Created by Amrit Banga on 6/25/24.
//  Edited by Zijian Zhang on 6/28/24.

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

class BusinessViewModel: ObservableObject {
    @Published var businesses: [Business] = []
    private var db = Firestore.firestore()
    
    func addBusiness(name: String, id: UUID? = nil) {
        let business = Business(name: name, id: id)
        businesses.append(business)

        do {
            try db.collection("businesses").document(business.id.uuidString).setData(from: business)
        } catch let error {
            print("Error writing business to Firestore: \(error)")
        }
    }
    
    func fetchBusinesses() {
        db.collection("businesses").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.businesses = documents.compactMap { queryDocumentSnapshot -> Business? in
                return try? queryDocumentSnapshot.data(as: Business.self)
            }
        }
    }
    
    func updateBusiness(_ business: Business) {
        if let index = businesses.firstIndex(where: { $0.id == business.id }) {
            businesses[index] = business
            do {
                try db.collection("businesses").document(business.id.uuidString).setData(from: business)
            } catch let error {
                print("Error updating business in Firestore: \(error)")
            }
        }
    }
    
    func removeBusiness(_ business: Business) {
        businesses.removeAll { $0.id == business.id }
        db.collection("businesses").document(business.id.uuidString).delete { error in
            if let error = error {
                print("Error removing business from Firestore: \(error)")
            }
        }
    }
}

struct AddBusinessView: View {
    @State private var name: String = ""
    @State private var uniqueID: String = ""
    @ObservedObject var viewModel: BusinessViewModel
    @Binding var isShowingBusinessSheet: Bool

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Add Business")) {
                    TextField("Business Name", text: $name)
                    TextField("Unique ID (optional)", text: $uniqueID)
                    Button("Add Business") {
                        if uniqueID.isEmpty {
                            viewModel.addBusiness(name: name)
                        } else if let uuid = UUID(uuidString: uniqueID) {
                            viewModel.addBusiness(name: name, id: uuid)
                        }
                        isShowingBusinessSheet = false
                    }
                }
            }
            .navigationTitle("New Business")
            .navigationBarItems(leading: Button("Cancel") {
                isShowingBusinessSheet = false
            })
        }
    }
}
