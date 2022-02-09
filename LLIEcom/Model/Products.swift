//
//  Products.swift
//  LLIEcom
//
//  Created by Apple on 09/02/22.
//

import Foundation

struct Products: Codable{
    var items: [Product]?
}

struct Product: Codable{
    var id: String?
    var name: String?
    var description: String?
    var price: String?
    var url: String?
    var storeId: String?
}



