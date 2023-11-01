//
//  ShopItem.swift
//  Levi
//
//  Created by Ginger Chang on 12/12/22.
//

import Foundation

class ShopItem {
    var levi: Int
    var money: Double
    var name: String
    var count: Int
    var unit: String
    
    init(levi: Int, money: Double, name: String, count: Int, unit: String) {
        self.levi = levi
        self.money = money
        self.name = name
        self.count = count
        self.unit = unit
    }
    
    func getFullName() -> String {
        return String(self.count) + " " + unit + " " + name
    }
}
