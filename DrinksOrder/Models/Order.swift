//
//  Order.swift
//  DrinksOrder
//
//  Created by Machir on 2021/9/13.
//

import Foundation

struct Order: Codable {
    var orders: [OrderDetail.Record]
    
    init(orders: [OrderDetail.Record] = []) {
        self.orders = orders
    }
}
