//
//  DashboardViewControllerTests.swift
//  LLIEcomTests
//
//  Created by Apple on 11/02/22.
//

import XCTest
@testable import LLIEcom

class DashboardViewControllerTests: XCTestCase {
    var dashboardVC: DashboardViewController?
    var navigationController: UINavigationController?
    override func setUpWithError() throws {
        dashboardVC = DashboardViewController.instantiateFromStoryboard()
        guard let viewController = dashboardVC else {
            XCTFail("dashboardVC is nil")
            return
        }
        navigationController = UINavigationController.init(rootViewController: viewController)
    }

    override func tearDownWithError() throws {
        dashboardVC = nil
        navigationController = nil
    }
    
    func testViewDidLoad() {
        _ = dashboardVC?.view
        let expectation = self.expectation(description: "check stores")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            //Delegate and data source
            XCTAssert(self.dashboardVC?.storeInfoCollectionView.delegate != nil)
            XCTAssert(self.dashboardVC?.storeInfoCollectionView.dataSource != nil)
            XCTAssert(self.dashboardVC?.productsCollectionView.delegate != nil)
            XCTAssert(self.dashboardVC?.productsCollectionView.dataSource != nil)
            
            XCTAssertEqual(self.dashboardVC?.btnOrderSummary.isEnabled, false)
            XCTAssertEqual(self.dashboardVC?.btnOrderSummary.titleLabel?.text, "Order Summary")
            XCTAssertEqual(self.dashboardVC?.itemsStackView.isHidden, true)
            //ViewModel
            XCTAssert(self.dashboardVC?.dashboardViewModel != nil)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
    }
    
    func testCheckStores() {
        _ = dashboardVC?.view
        let expectation = self.expectation(description: "check stores")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.dashboardVC?.dashboardViewModel.stores.count, 2)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
    }
    func testCheckProducts() {
        _ = dashboardVC?.view
        let expectation = self.expectation(description: "check Products")
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            XCTAssertEqual(self.dashboardVC?.dashboardViewModel.products.count, 8)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testAddAndRemoveProducts() {
        _ = dashboardVC?.view
        let expectation = self.expectation(description: "check Products")
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            guard let productCV = self.dashboardVC?.productsCollectionView else { return }
            guard let cell = self.dashboardVC?.collectionView(productCV, cellForItemAt: IndexPath(row: 0, section: 0)) as? ProductsCollectionViewCell else { return }
            XCTAssertEqual(self.dashboardVC?.dashboardViewModel.cart.count, 0)
            cell.addBtnAction(UIButton())
            XCTAssertEqual(self.dashboardVC?.dashboardViewModel.cart.count, 1)
            guard self.dashboardVC?.dashboardViewModel.cart.count == 1 else {
                XCTFail("cart is empty")
                return
            }
            XCTAssertEqual(self.dashboardVC?.dashboardViewModel.cart[0].quantity, 1)
            
            //Add one more quantity
            cell.addBtnAction(UIButton())
            guard self.dashboardVC?.dashboardViewModel.cart.count == 1 else {
                XCTFail("cart is empty")
                return
            }
            XCTAssertEqual(self.dashboardVC?.dashboardViewModel.cart[0].quantity, 2)
            
            //Remove one quantity
            cell.removeBtnAction(UIButton())
            guard self.dashboardVC?.dashboardViewModel.cart.count == 1 else {
                XCTFail("cart is empty")
                return
            }
            XCTAssertEqual(self.dashboardVC?.dashboardViewModel.cart[0].quantity, 1)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testStoreSelection() {
        _ = dashboardVC?.view
        let expectation = self.expectation(description: "check stores")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            guard let storeCV = self.dashboardVC?.storeInfoCollectionView else { return }
            self.dashboardVC?.collectionView(storeCV, didSelectItemAt: IndexPath(row: 1, section: 0))
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                XCTAssertEqual(self.dashboardVC?.dashboardViewModel.products.count, 2)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 6)
    }
    
    func testOrderSummaryAction() {
        _ = dashboardVC?.view
        let expectation = self.expectation(description: "check Products")
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            guard let productCV = self.dashboardVC?.productsCollectionView else {
                XCTFail("productsCollectionView is nil")
                return
            }
            guard let cell = self.dashboardVC?.collectionView(productCV, cellForItemAt: IndexPath(row: 0, section: 0)) as? ProductsCollectionViewCell else {
                XCTFail("ProductsCollectionViewCell is nil")
                return
            }
            cell.addBtnAction(UIButton())
            XCTAssertEqual(self.dashboardVC?.btnOrderSummary.isEnabled, true)
            XCTAssertEqual(self.dashboardVC?.itemsStackView.isHidden, false)
            self.dashboardVC?.btnOrderSummaryAction(UIButton())
            if let _ = self.navigationController?.visibleViewController as? OrderSummaryViewController {
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 6)
    }
}
