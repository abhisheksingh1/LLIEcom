//
//  DashboardViewModel.swift
//  LLIEcom
//
//  Created by Apple on 09/02/22.
//

import Foundation

class DashboardViewModel {
    var apiResponse:((ServiceError?) ->Void)?
    var updateUI:(() ->Void)?
    var stores = [Store]()
    var products = [Product]()
    var cart = [CartItem]()
    var selectedStore: String = "" {
        didSet {
            getProducts(selectedStore)
        }
    }
    init() {
        getStores()
    }
    
    /// Get Stores
    private func getStores() {
        DashboardAPI().getStores {[weak self] (storesInfo: StoresInfo?, error) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.stores = storesInfo?.stores ?? []
                self.apiResponse?(error)
            }
        }
    }
    
    /// Get Products for store
    /// - Parameter storeId: Store id
    func getProducts(_ storeId: String) {
        DashboardAPI().getProducts(storeId: storeId, completion: {[weak self] (products: [Product]?, error) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.products = products ?? []
                self.updateUI?()
            }
        })
    }
    
    /// Update selected item in Cart
    /// - Parameters:
    ///   - product: product/item
    ///   - add: add or remove
    func updateCartItem(_ product: Product, add: Bool) {
        if let index = cart.firstIndex(where: {$0.product.id == product.id}) {
            let quantity =  cart[index].quantity
            let updatedQuantity = add == true ? (quantity + 1): (quantity - 1)
            //If updatedQuantity is more then 0 update quantity else remove product
            if updatedQuantity > 0 {
                cart[index].quantity = updatedQuantity
            } else {
                cart[index].quantity = updatedQuantity
                cart.remove(at: index)
            }
        } else  {
            if add == true {
                cart.append(CartItem(product: product, quantity: 1))
            }
        }
    }
    
    /// Get Cart Item
    /// - Parameter id:product Id
    /// - Returns: selected item
    func getCartItem(_ id: String?) -> CartItem? {
        guard let id = id else { return nil }
        return cart.filter({$0.product.id == id}).first
    }
}
