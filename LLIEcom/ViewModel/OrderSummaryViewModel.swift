//
//  OrderSummaryViewModel.swift
//  LLIEcom
//
//  Created by Apple on 10/02/22.
//

import Foundation

class OrderSummaryViewModel {
    var cartItem = [CartItem]()
    
    init(_ cartItem: [CartItem]) {
        self.cartItem = cartItem
    }
    
    func getTotalAmount() -> String {
        var totalPrice = 0
        _ = cartItem.map { item in
            totalPrice += (item.quantity) * (Int(item.product.price ?? "0") ?? 0)
        }
        return "\(totalPrice)"
    }
}

