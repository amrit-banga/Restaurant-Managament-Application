//
//  Business.swift
//  RestaurantManagement
//
//  Created by Amrit Banga on 6/25/24.
//  Edited by Zijian Zhang on 6/28/24.


import Foundation

struct Business: Identifiable, Codable {
    let id: UUID
    let name: String
    
    init(name: String, id: UUID? = nil) {
        self.id = id ?? UUID()
        self.name = name
    }
}
