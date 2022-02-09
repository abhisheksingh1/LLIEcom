//
//  MockJsonHelper.swift
//  LLIEcom
//
//  Created by Apple on 09/02/22.
//

import Foundation

class MockJsonHelper {
    class func readLocalFile(forName name: String)-> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print("\(error)")
        }
        return nil
    }
}
