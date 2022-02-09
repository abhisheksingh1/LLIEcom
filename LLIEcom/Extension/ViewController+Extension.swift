//
//  ViewController+Extension.swift
//  LLIEcom
//
//  Created by Apple on 09/02/22.
//

import Foundation
import UIKit

extension UIViewController {
    /// showAlertMessage
    /// - Parameters:
    ///   - title: String
    ///   - message: String
    func showAlertMessage(_ title:String, _ message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    class func instantiateFromStoryboard(_ name: String = "Main") -> Self {
        return instantiateFromStoryboardHelper(name)
    }
    
    fileprivate class func instantiateFromStoryboardHelper<T>(_ name: String) -> T {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! T
        return controller
    }
}
