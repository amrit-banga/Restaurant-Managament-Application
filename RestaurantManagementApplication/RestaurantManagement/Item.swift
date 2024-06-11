//
//  Item.swift
//  RestaurantManagement
//
//  Created by Amrit Banga on 6/10/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
