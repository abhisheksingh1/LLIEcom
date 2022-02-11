//
//  OrderDone.swift
//  LLIEcom
//
//  Created by Apple on 10/02/22.
//

import Foundation

struct OrderDone: Codable {
    var success: Bool
    var code: Int
    var message: String
}
