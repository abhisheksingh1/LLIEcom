//
//  OrderSummaryTableViewCell.swift
//  LLIEcom
//
//  Created by Apple on 10/02/22.
//

import UIKit

class OrderSummaryTableViewCell: UITableViewCell {
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    
    @IBOutlet weak var priceLbl: UILabel!
    
    @IBOutlet weak var quantityLbl: UILabel!
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(_ item: CartItem) {
        productImage.sd_setImage(with: URL(string: item.product.url ?? ""), placeholderImage: nil, options: [], completed: nil)
        nameLbl.text = item.product.name
        descLbl.text = item.product.description
        priceLbl.text = "₹ \(item.product.price)"
        quantityLbl.text = "Qty: \(item.quantity)"
    }

}
