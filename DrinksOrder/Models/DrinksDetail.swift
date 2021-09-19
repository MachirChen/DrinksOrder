//
//  DrinksDetail.swift
//  DrinksOrder
//
//  Created by Machir on 2021/9/4.
//


//Step1
import Foundation

struct DrinksData: Codable {
    let records: [Record]
}

struct Record: Codable {
    let id: String
    let fields: Field
}

struct Field: Codable {
    let name: String
    let large: Int?
    let description: String
    let medium: Int
    let image: [Image]
}

struct Image: Codable {
    let url: URL
}
