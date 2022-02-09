//
//  Stores.swift
//  LLIEcom
//
//  Created by Apple on 09/02/22.
//

import Foundation

struct StoresInfo: Codable {
    var stores: [Store]?
}
struct Store: Codable {
    var id: String?
    var name: String?
}
