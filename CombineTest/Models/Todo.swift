//
//  Todo.swift
//  CombineTest
//
//  Created by Jeff on 2023/3/10.
//

import Foundation

struct Todo: Codable {
//let userId: Int
//let id: Int
//let title: String
//let completed: Bool
//
//    let age: Int
//    let name: String
//    let gender: String
    
     var USD: Double
     var JPY: Double
     var EUR: Double
     
     enum Currency: String, CaseIterable {
         case usd = "USD"
         case jpy = "JPY"
         case eur = "EUR"
     }


    
}
