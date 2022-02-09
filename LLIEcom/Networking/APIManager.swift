//
//  APIManager.swift
//  LLIEcom
//
//  Created by Apple on 09/02/22.
//

import Foundation

enum EndPoints: String {
    case storesInfo
    case products
}

struct ServiceError: Error,Codable {
    let status: Int
    let message: String
}

struct APIManager {
    static let shared = APIManager()
    func loadAPIRequest<C:Codable>(request: EndPoints, completionHandler: @escaping (C?, ServiceError?) -> ()) {
        do {
            guard let jsonData = MockJsonHelper.readLocalFile(forName: request.rawValue) else  {
                completionHandler(nil, ServiceError(status: 400, message: "Error in reading json data"))
                return
            }
            let parsedResponse = try JSONDecoder().decode(C.self, from: jsonData)
            completionHandler(parsedResponse, nil)
        } catch  {
            completionHandler(nil, ServiceError(status: 400, message: error.localizedDescription))
        }
    }
}
