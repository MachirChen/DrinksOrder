//
//  OrderDetail.swift
//  DrinksOrder
//
//  Created by Machir on 2021/9/5.
//

import Foundation

struct OrderDetail: Codable {
    var records: [Record]
    
    struct Record: Codable {
        var fields: Field
    }

    struct Field: Codable {
        var drink: String
        var size: String
        var sweetness: String
        var quantity: Int
        var price: Int
        var toppings: String
        var name: String
        var temperature: String
        var image: URL
    }
}
