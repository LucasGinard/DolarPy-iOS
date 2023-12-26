//
//  HomeViewModelTest.swift
//  DolarPyTests
//
//  Created by Lucas Ginard on 2023-10-27.
//

import XCTest
@testable import DolarPy

final class HomeViewModelTest: XCTestCase {
    
    var viewModel: HomeViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = HomeViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testOrderQuotations() {
        viewModel.quotations = [QuotationModel(name: "test", compra: 1, venta: 2,ref: nil), QuotationModel(name:"test2", compra: 2, venta: 3,ref: nil)]
        viewModel.arrowOrientation = .zero
        viewModel.isOrderBy = .buy
        
        viewModel.orderQuotations()
        
        XCTAssertEqual(viewModel.quotations.first?.compra, 1)
    }
    
    func testCalculateQuotation() {
        let amount = 10.0
        let amountInput = "5"
        
        let result = viewModel.calculateQuotation(amount: amount, amountInput: amountInput)
        
        XCTAssertEqual(result, 50.0)
    }
    
}
