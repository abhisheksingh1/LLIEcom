//
//  OrderSummaryViewModel.swift
//  LLIEcom
//
//  Created by Apple on 10/02/22.
//

import Foundation

class OrderSummaryViewModel {
    var cartItem = [CartItem]()
    var apiResponse:((OrderDone?, ServiceError?) ->Void)?
    
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
    
    func postCartItems(_ address: String) {
        OrderSummaryAPI().postCartItems(address: address, cart: cartItem) { response, error in
            self.apiResponse?(response, error)
        }
    }
}

