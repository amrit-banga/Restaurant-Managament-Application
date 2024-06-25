//
//  Business.swift
//  RestaurantManagement
//
//  Created by Amrit Banga on 6/25/24.
//

import Foundation

struct Business: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let code: String
    let isAdmin: Bool

    static func == (lhs: Business, rhs: Business) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

