//
//  OrderSummaryViewController.swift
//  LLIEcom
//
//  Created by Apple on 10/02/22.
//

import UIKit
import ProgressHUD

class OrderSummaryViewController: UIViewController {
    @IBOutlet weak var OrderSummaryTableView: UITableView!
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var confirmOrderBtn: UIButton!
    @IBOutlet weak var confirmBtnBottomConstraint: NSLayoutConstraint!
    var cartItem = [CartItem]()
    var summaryViewModel: OrderSummaryViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        configureUI()
        setupTextView()
        setKeyboardObserver()
    }
    
    func configureUI() {
        enableConfirmButton(false)
        setupTableView()
        self.totalPriceLbl.text = "₹ \(self.summaryViewModel.getTotalAmount())"
    }
    func setupViewModel() {
        summaryViewModel = OrderSummaryViewModel(cartItem)
        summaryViewModel.apiResponse = {  [weak self] (orderCompletionResponse, error) in
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
            }
            guard let self = self else { return }
            guard error == nil else {
                self.showAlertMessage(Constants.alerttitle, error?.message ?? "")
                return
            }
            self.pushToSuccessScreen()
        }
    }
    func setupTableView() {
        OrderSummaryTableView.rowHeight = UITableView.automaticDimension
        OrderSummaryTableView.estimatedRowHeight = 60
        OrderSummaryTableView.tableFooterView = UIView(frame: .zero)
    }
    func setupTextView() {
        addressTextView.layer.borderWidth = 1
        addressTextView.layer.borderColor = UIColor.lightGray.cgColor
        addressTextView.delegate = self
    }
    
    func setKeyboardObserver() {
        let notifier = NotificationCenter.default
        notifier.addObserver(self,
                             selector: #selector(self.keyboardWillShow(_:)),
                             name: UIWindow.keyboardWillShowNotification,
                             object: nil)
        notifier.addObserver(self,
                             selector: #selector(self.keyboardWillHide(_:)),
                             name: UIWindow.keyboardWillHideNotification,
                             object: nil)
    }
    
    @IBAction func confirmOrderBtnAction(_ sender: UIButton) {
        ProgressHUD.show()
        summaryViewModel.postCartItems(addressTextView.text)
    }
    
    func pushToSuccessScreen() {
        let controller = OrderSuccessViewController.instantiateFromStoryboard()
        self.navigationController?.pushViewController(controller, animated: false)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            confirmBtnBottomConstraint.constant = keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            confirmBtnBottomConstraint.constant = 12.0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /// Enable and Disable Confirm Button
    /// - Parameter enable: Bool
    func enableConfirmButton(_ enable: Bool) {
        self.confirmOrderBtn.isEnabled = enable
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

//MARK: UITableViewDelegate, UITableViewDataSource
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

//MARK: UITextViewDelegate
extension OrderSummaryViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        enableConfirmButton((textView.text.trimmingCharacters(in: .whitespacesAndNewlines)).count > 0)
    }
}
