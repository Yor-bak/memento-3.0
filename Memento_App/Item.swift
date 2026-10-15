//
//  Item.swift
//  Memento_App
//
//  Created by Sara Fernanda Crespo Galindo  on 15/10/2026.
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
