//
//  OrderSuccessViewController.swift
//  LLIEcom
//
//  Created by Apple on 10/02/22.
//

import UIKit

class OrderSuccessViewController: UIViewController {
    @IBOutlet weak var btnBack: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        for vc in self.navigationController!.viewControllers {
            if let dashboardVC = vc as? DashboardViewController {
                dashboardVC.dashboardViewModel.cart.removeAll()
                dashboardVC.updateItemDetailUI()
                dashboardVC.collectionView(dashboardVC.storeInfoCollectionView, didSelectItemAt: IndexPath(row: 0, section: 0))
                    self.navigationController?.popToViewController(dashboardVC, animated: true)
                break
            }
        }
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
