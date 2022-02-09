//
//  DashboardViewController.swift
//  LLIEcom
//
//  Created by Apple on 08/02/22.
//

import UIKit
import ProgressHUD

class DashboardViewController: UIViewController {

    @IBOutlet weak var storeInfoCollectionView: UICollectionView!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var btnOrderSummary: UIButton!
    var storeLayout: UICollectionViewFlowLayout!
    var productsLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var itemsCountLbl: UILabel!
    @IBOutlet weak var itemsStackView: UIStackView!
    var dashboardViewModel: DashboardViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ProgressHUD.show()
        hideView(true)
        configureUI()
        setupViewModel()
    }
    
    func configureUI() {
        setupStoreItemSize()
        setupProductItemSize()
        itemsStackView.isHidden = true
        btnOrderSummary.isEnabled = false
        bottomView.layer.shadowOpacity = 0.7
        bottomView.layer.shadowOffset = CGSize(width: 3, height: 3)
        bottomView.layer.shadowRadius = 15.0
        bottomView.layer.shadowColor = UIColor.black.cgColor
    }
    
    func setupViewModel() {
        dashboardViewModel = DashboardViewModel()
        dashboardViewModel.apiResponse = { [weak self] (error) in
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
            }
            guard let self = self else { return }
            guard error == nil else {
                self.showAlertMessage(Constants.alerttitle, error?.message ?? "")
                return
            }
            self.updateUI()
        }
        
        dashboardViewModel.updateUI = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.productsCollectionView.reloadData()
            }
        }
    }

    func setupStoreItemSize() {
        if storeLayout == nil {
            let lineSpacing:CGFloat = 5
            let interitemSpacing:CGFloat = 5
            let width:CGFloat = 100.0
            let height:CGFloat = 40.0
            storeLayout = UICollectionViewFlowLayout()
            storeLayout.itemSize = CGSize(width: width, height: height)
            storeLayout.sectionInset = .zero
            storeLayout.scrollDirection = .horizontal
            storeLayout.minimumLineSpacing = lineSpacing
            storeLayout.minimumInteritemSpacing = interitemSpacing
            storeInfoCollectionView.setCollectionViewLayout(storeLayout, animated: true)
        }
    }
    
    func setupProductItemSize() {
        if productsLayout == nil {
            let numberOfItemPerRow:CGFloat = 2
            let lineSpacing:CGFloat = 5
            let interitemSpacing:CGFloat = 5
            let width = (productsCollectionView.frame.size.width-(numberOfItemPerRow-1)*interitemSpacing)/numberOfItemPerRow
            let height = width*1.2
            productsLayout = UICollectionViewFlowLayout()
            productsLayout.itemSize = CGSize(width: width, height: height)
            productsLayout.sectionInset = .zero
            productsLayout.scrollDirection = .vertical
            productsLayout.minimumLineSpacing = lineSpacing
            productsLayout.minimumInteritemSpacing = interitemSpacing
            productsCollectionView.setCollectionViewLayout(productsLayout, animated: true)
        }
    }
    
    func updateUI() {
        hideView()
        self.storeInfoCollectionView.reloadData()
        guard !dashboardViewModel.stores.isEmpty else { return }
        dashboardViewModel.selectedStore = dashboardViewModel.stores[0].id
    }
    
    func hideView(_ hide: Bool = false) {
        self.storeInfoCollectionView.isHidden = hide
        self.productsCollectionView.isHidden = hide
        self.bottomView.isHidden = hide
    }
    
    @IBAction func btnOrderSummaryAction(_ sender: UIButton) {
        let controller = OrderSummaryViewController.instantiateFromStoryboard()
        self.navigationController?.pushViewController(controller, animated: false)
    }
    
}

//MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case storeInfoCollectionView:
            return dashboardViewModel.stores.count
        case productsCollectionView:
            return dashboardViewModel.storeProducts.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case storeInfoCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreInfoCollectionViewCell.identifier, for: indexPath) as? StoreInfoCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(dashboardViewModel.stores[indexPath.row])
            return cell
        case productsCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductsCollectionViewCell.identifier, for: indexPath) as? ProductsCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.product = dashboardViewModel.storeProducts[indexPath.row]
            cell.configure()
            cell.updateCount = {[weak self] (add) in
                guard let self = self else { return }
                self.dashboardViewModel.updateCartItem(cell.product, add: add)
                print(self.dashboardViewModel.cart)
                DispatchQueue.main.async {
                    let boolVal = self.dashboardViewModel.cart.count > 0
                    self.btnOrderSummary.isEnabled = boolVal
                    self.itemsStackView.isHidden = !boolVal
                    self.itemsCountLbl.text = boolVal ?  "\(self.dashboardViewModel.cart.count)" : "0"
                }
                if let cartItem = self.dashboardViewModel.getCartItem(cell.product.id) {
                    cell.count = cartItem.quantity
                } else  {
                    cell.count = 0
                }
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}


