//
//  DashboardAPI.swift
//  LLIEcom
//
//  Created by Apple on 09/02/22.
//

import Foundation

struct DashboardAPI {
    
    ///  Get All stores
    /// - Parameter completion: storesInfo, error
    func getStores(completion: @escaping (StoresInfo?, ServiceError?) -> ()) {
        APIManager.shared.loadAPIRequest(request: .storesInfo) { (storesInfo: StoresInfo?, error) in
            if let _ = error {
                completion(nil, error)
            } else {
                completion(storesInfo, nil)
            }
        }
    }
    
    /// Get Products for store
    /// - Parameter completion: products, error
    func getProducts(storeId: String, completion: @escaping ([Product]?, ServiceError?) -> ()) {
        APIManager.shared.loadAPIRequest(request: .products) { (products: Products?, error) in
            if let _ = error {
                completion(nil, error)
            } else {
                //Based on store id fetch product
                let productForStore = products?.items?.filter({$0.storeId == storeId})
                completion(productForStore, nil)
            }
        }
    }
}
