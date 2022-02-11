//
//  OrderSummaryViewControllerTests.swift
//  LLIEcomTests
//
//  Created by Apple on 11/02/22.
//

import XCTest
@testable import LLIEcom

class OrderSummaryViewControllerTests: XCTestCase {
    var orderSummaryVC: OrderSummaryViewController?
    var navigationController: UINavigationController?
    override func setUpWithError() throws {
        orderSummaryVC = OrderSummaryViewController.instantiateFromStoryboard()
        guard let viewController = orderSummaryVC else {
            XCTFail("orderSummaryVC is nil")
            return
        }
        navigationController = UINavigationController.init(rootViewController: viewController)
        initializeDependencies()
    }
    
    func initializeDependencies() {
        guard let product = mockDataProduct() else { return }
        let item = CartItem(product: product, quantity: 1)
        orderSummaryVC?.cartItem = [item]
    }
    
    override func tearDownWithError() throws {
        orderSummaryVC = nil
        navigationController = nil
    }
    
    func testViewDidLoad() {
        _ = orderSummaryVC?.view
        XCTAssertEqual(self.orderSummaryVC?.confirmOrderBtn.isEnabled, false)
        XCTAssertEqual(self.orderSummaryVC?.confirmOrderBtn.titleLabel?.text, "Confirm Order")
        //ViewModel
        XCTAssert(self.orderSummaryVC?.summaryViewModel != nil)
        //TableView
        XCTAssert(self.orderSummaryVC?.OrderSummaryTableView.delegate != nil)
        XCTAssert(self.orderSummaryVC?.OrderSummaryTableView.dataSource != nil)
        guard let orderSummaryTV = self.orderSummaryVC?.OrderSummaryTableView else { return }
        guard let cell = self.orderSummaryVC?.tableView(orderSummaryTV, cellForRowAt: IndexPath(row: 0, section: 0)) as? OrderSummaryTableViewCell else { return }
        XCTAssertEqual(self.orderSummaryVC?.summaryViewModel.cartItem.count, 1)
        XCTAssertEqual(cell.quantityLbl.text, "Qty: 1")
        XCTAssertEqual(cell.priceLbl.text, "₹ 800")
        
        XCTAssertEqual(self.orderSummaryVC?.totalPriceLbl.text, "₹ 800")
    }
    
    func testConfirmOrderBtnActive() {
        _ = orderSummaryVC?.view
        XCTAssert(self.orderSummaryVC?.addressTextView.delegate != nil)
        XCTAssertEqual(self.orderSummaryVC?.confirmOrderBtn.isEnabled, false)
        self.orderSummaryVC?.addressTextView.text = "test"
        guard let textView = self.orderSummaryVC?.addressTextView else { return }
        self.orderSummaryVC?.textViewDidChange(textView)
        XCTAssertEqual(self.orderSummaryVC?.confirmOrderBtn.isEnabled, true)
    }
    
    func testConfirmOrderBtnAction() {
        _ = orderSummaryVC?.view
        self.orderSummaryVC?.addressTextView.text = "test"
        guard let textView = self.orderSummaryVC?.addressTextView else { return }
        self.orderSummaryVC?.textViewDidChange(textView)
        XCTAssertEqual(self.orderSummaryVC?.confirmOrderBtn.isEnabled, true)
        self.orderSummaryVC?.confirmOrderBtnAction(UIButton())
        let expectation = self.expectation(description: "Confirm Order")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if let _ = self.navigationController?.visibleViewController as? OrderSuccessViewController {
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 3)
    }
    
    func mockDataProduct() -> Product? {
        let dictionary = [
            "id":"llime001",
            "name":"Polo T-Shirt",
            "description":"Striped Men Polo Neck White T-Shirt",
            "price":"800",
            "url":"https://i.ibb.co/sJ3RJDM/14.jpg",
            "storeId":"1"
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            let product = try JSONDecoder().decode(Product.self, from: jsonData)
            return product
        } catch {
            print("product json Data\(error.localizedDescription)")
        }
        return nil
    }
}
