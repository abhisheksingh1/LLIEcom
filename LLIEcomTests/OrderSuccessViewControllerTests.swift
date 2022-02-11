//
//  OrderSuccessViewControllerTests.swift
//  LLIEcomTests
//
//  Created by Apple on 11/02/22.
//

import XCTest
@testable import LLIEcom

class OrderSuccessViewControllerTests: XCTestCase {
    var orderSuccessVC: OrderSuccessViewController?
    var navigationController: UINavigationController?
    override func setUpWithError() throws {
        orderSuccessVC = OrderSuccessViewController.instantiateFromStoryboard()
        guard let viewController = orderSuccessVC else {
            XCTFail("orderSummaryVC is nil")
            return
        }
        navigationController = UINavigationController.init(rootViewController: viewController)
    }
    
    func testViewDidLoad() {
        _ = orderSuccessVC?.view
        XCTAssertEqual(self.orderSuccessVC?.btnBack.titleLabel?.text, "Back")
    }
    
    func testBackBtnAction() {
        _ = orderSuccessVC?.view
        let dashboardVC = DashboardViewController.instantiateFromStoryboard()
        _ = dashboardVC.view
        guard let successVC = orderSuccessVC else {
            XCTFail("orderSummaryVC is nil")
            return
        }
        navigationController?.viewControllers = [dashboardVC, successVC]
        let expectation = self.expectation(description: "Back to Dashboard")
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.orderSuccessVC?.btnBackAction(UIButton())
            if let _ = self.navigationController?.visibleViewController as? DashboardViewController {
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5)
    }
    
    override func tearDownWithError() throws {
        orderSuccessVC = nil
        navigationController = nil
    }
}
