//
//  ProductsCollectionViewCell.swift
//  LLIEcom
//
//  Created by Apple on 09/02/22.
//

import UIKit
import SDWebImage

class ProductsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var counterLbl: UILabel!
    @IBOutlet weak var removeBtn: UIButton!
    var product: Product!
    var updateCount:((Bool) ->Void)?
    
    var count:Int = 0 {
        didSet {
            counterLbl.text = "\(count)"
        }
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    @IBAction func addBtnAction(_ sender: UIButton) {
        updateCount?(true)
    }
    
    @IBAction func removeBtnAction(_ sender: UIButton) {
        updateCount?(false)
    }
    
    func configure() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        nameLbl.text = product.name
        productImage.sd_setImage(with: URL(string: product.url ?? ""), placeholderImage: nil, options: [], completed: nil)
        if let proPrice = product.price {
            priceLbl.text = "₹ \(proPrice)"
        }
        count = 0
    }
}
