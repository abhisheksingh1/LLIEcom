//
//  StoreInfoCollectionViewCell.swift
//  LLIEcom
//
//  Created by Apple on 09/02/22.
//

import UIKit

class StoreInfoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var storeNameLbl: UILabel!
    
    static var identifier: String {
        return String(describing: self)
    }
    
    func configure(_ store: Store) {
        storeNameLbl.layer.borderColor = UIColor.lightGray.cgColor
        storeNameLbl.layer.borderWidth = 1.0
        storeNameLbl.layer.cornerRadius = 20
        storeNameLbl.clipsToBounds = true
        storeNameLbl.text = store.name
    }
    
}
