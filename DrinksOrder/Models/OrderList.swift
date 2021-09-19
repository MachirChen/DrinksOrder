//
//  OrderList.swift
//  DrinksOrder
//
//  Created by Machir on 2021/9/6.
//

import Foundation

struct OrderList: Codable {
    var records: [Record]
    
    struct Record: Codable {
        var id: String
        var fields: OrderDetail.Field
    }
}

