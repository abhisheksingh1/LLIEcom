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
    private var products = [Product]()
    var storeProducts = [Product]()
    var cart = [CartItem]()
    
    var selectedStore: String? {
        didSet {
            storeProducts = products.filter({$0.storeId == selectedStore})
            updateUI?()
        }
    }
    var error: ServiceError?
    init() {
        error = nil
        getStoresAndProduct()
    }
    private func getStoresAndProduct() {
        let group = DispatchGroup()
        group.enter()
        DashboardAPI().getStores {[weak self] (storesInfo: StoresInfo?, error) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.stores = storesInfo?.stores ?? []
                self.error = error
                group.leave()
            }
        }
        group.enter()
        DashboardAPI().getProducts(completion: {[weak self] (products: Products?, error) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.products = products?.items ?? []
                self.error = error
                group.leave()
            }
        })
        
        group.notify(queue: .main) {
            self.apiResponse?(self.error)
        }
    }
    
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
    
    func getCartItem(_ id: String?) -> CartItem? {
        guard let id = id else { return nil }
        return cart.filter({$0.product.id == id}).first
    }
}
