//
//  Business.swift
//  RestaurantManagement
//
//  Created by Amrit Banga on 6/25/24.
//  Edited by Zijian Zhang on 6/28/24, 7/6/24
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth


struct Business: Identifiable, Codable {
    let id: UUID
    let name: String
    var ownerId: String
    var participants: [String]
    
    init(name: String, ownerId: String, participants: [String] = [], id: UUID? = nil) {
        self.id = id ?? UUID()
        self.name = name
        self.ownerId = ownerId
        self.participants = participants
    }
}
class BusinessViewModel: ObservableObject {
    @Published var businesses: [Business] = []
    private var db = Firestore.firestore()
    private var userId: String {
        Auth.auth().currentUser?.uid ?? ""
    }

    func addBusiness(name: String) {
        let business = Business(name: name, ownerId: userId, participants: [userId])
        do {
            try db.collection("businesses").document(business.id.uuidString).setData(from: business)
        } catch let error {
            print("Error writing business to Firestore: \(error)")
        }
    }

    func fetchBusinesses() {
        db.collection("businesses").whereField("participants", arrayContains: userId).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.businesses = documents.compactMap { queryDocumentSnapshot -> Business? in
                return try? queryDocumentSnapshot.data(as: Business.self)
            }
        }
    }

    func joinBusiness(businessId: UUID) {
        let businessRef = db.collection("businesses").document(businessId.uuidString)
        businessRef.updateData([
            "participants": FieldValue.arrayUnion([userId])
        ]) { error in
            if let error = error {
                print("Error joining business: \(error)")
            }
        }
    }

    func joinBusinessWithResult(businessId: UUID, completion: @escaping (String) -> Void) {
        let businessRef = db.collection("businesses").document(businessId.uuidString)
        businessRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let data = document.data(), let participants = data["participants"] as? [String], participants.contains(self.userId) {
                    completion("You have been added in this business!")
                } else {
                    businessRef.updateData([
                        "participants": FieldValue.arrayUnion([self.userId])
                    ]) { error in
                        if let error = error {
                            print("Error joining business: \(error)")
                            completion("Add failed! Business does not exist!")
                        } else {
                            completion("Add succeed!")
                        }
                    }
                }
            } else {
                completion("Add failed! Business does not exist!")
            }
        }
    }

    func updateBusiness(_ business: Business) {
        do {
            try db.collection("businesses").document(business.id.uuidString).setData(from: business)
        } catch let error {
            print("Error updating business in Firestore: \(error)")
        }
    }

    func removeBusiness(_ business: Business) {
        db.collection("businesses").document(business.id.uuidString).delete { error in
            if let error = error {
                print("Error removing business from Firestore: \(error)")
            }
        }
    }

    func quitBusiness(_ business: Business) {
        let businessRef = db.collection("businesses").document(business.id.uuidString)
        businessRef.updateData([
            "participants": FieldValue.arrayRemove([userId])
        ]) { error in
            if let error = error {
                print("Error quitting business: \(error)")
            }
        }
    }
}

