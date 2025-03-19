//
//  _urrency_onverterTests.swift
//  СurrencyСonverterTests
//
//  Created by Владислав Артюхов on 19.03.2025.
//

import XCTest
@testable import СurrencyСonverter

final class ConverterTest: XCTestCase {

    var converter: CurrencyConverter!
    var model: [TransactionsProduct]!
    var rates: [RatesDataLayer]!
    
    override func setUpWithError() throws {
        converter = CurrencyConverter()
        model = [TransactionsProduct(currency: "USD", amount: 55.5), TransactionsProduct(currency: "AUD", amount: 100)]
        rates = [RatesDataLayer(from: "USD", to: "GBP", rate: "0.7"),RatesDataLayer(from: "AUD", to: "USD", rate: "12")]
    }

    override func tearDownWithError() throws {
        converter = nil
        model = nil
        rates = nil
    }

    func testConverterNotNil() {
        XCTAssertNotNil(converter, "Converter is not nil")
    }
    
    func testConverter() {
        let expectation = XCTestExpectation(description: "Асинхронный вызов завершен")
        converter.getDomainLayerTransactions(transactions: model, rates: rates) { (result: Result<[TransactionsDomainLayer], CustomError>) in
            switch result {
            case .success(let value):
                
                XCTAssertFalse(value.isEmpty, "Массив транзакций пуст")
            
                XCTAssertEqual(value, [TransactionsDomainLayer(currency: "USD", amount: 55.5, finalTargetCurrency: 38.849999999999994),
                                       TransactionsDomainLayer(currency: "AUD", amount: 100.0, finalTargetCurrency: 840.0)])
                
            case .failure(let error):
                XCTFail("\(error)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}
