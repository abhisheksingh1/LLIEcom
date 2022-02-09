//
//  OrderSummaryViewController.swift
//  LLIEcom
//
//  Created by Apple on 10/02/22.
//

import UIKit

class OrderSummaryViewController: UIViewController {
    @IBOutlet weak var OrderSummaryTableView: UITableView!
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var confirmOrderBtn: UIButton!
    var cartItem = [CartItem]()
    var summaryViewModel: OrderSummaryViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
    }
    
    func setupViewModel() {
        summaryViewModel = OrderSummaryViewModel(cartItem)
    }
    
    @IBAction func confirmOrderBtnAction(_ sender: UIButton) {
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension OrderSummaryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderSummaryTableViewCell.identifier, for: indexPath) as? OrderSummaryTableViewCell else{
            return UITableViewCell()
        }
        cell.configure(cartItem[indexPath.row])
        return cell
    }
}
