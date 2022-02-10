//
//  OrderSummaryAPI.swift
//  LLIEcom
//
//  Created by Apple on 10/02/22.
//

import Foundation

struct OrderSummaryAPI {
    /// Post Cart Items
    /// - Parameter completion: products, error
    func postCartItems(address: String, cart: [CartItem], completion: @escaping (OrderDone?, ServiceError?) -> ()) {
        APIManager.shared.loadAPIRequest(request: .orderDone) { (response: OrderDone?, error) in
            if let _ = error {
                completion(nil, error)
            } else {
                completion(response, nil)
            }
        }
    }
}
