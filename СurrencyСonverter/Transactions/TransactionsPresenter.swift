//
//  TransactionsPresenter.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 17.03.2025.
//
import UIKit
protocol TransactionsPresenterProtocol: AnyObject {
    var title: String { get }
    init(service: CurrencyConverterProtocol, router: TransactionsRouterProtocol, model: ProductsDomainLayer, formatter: CurrencyFormatterProtocol, rates: [RatesDataLayer])
    func viewDidLoad()
    func getSum(model: [TransactionsDomainLayer]) -> Double
    func useFormatter(with model: TransactionsDomainLayer, onlyTargetCurrency: Bool) -> String
}

final class TransactionsPresenter: TransactionsPresenterProtocol {
    
    var title: String { "Transactions for \(model.sku)" }
    weak var view: TransactionsViewProtocol?
    
    private let service: CurrencyConverterProtocol
    private let router: TransactionsRouterProtocol
    private let model: ProductsDomainLayer
    private let formatter: CurrencyFormatterProtocol
    private let rates: [RatesDataLayer]
    
    init(service: CurrencyConverterProtocol, router: any TransactionsRouterProtocol, model: ProductsDomainLayer, formatter: CurrencyFormatterProtocol, rates: [RatesDataLayer]) {
        self.service = service
        self.router = router
        self.model = model
        self.formatter = formatter
        self.rates = rates
    }
    
    func viewDidLoad() {
        view?.startLoader()
        service.getDomainLayerTransactions(transactions: model.arrayTransactions, rates: rates) { [weak self] result in
                guard let self else { return }
                self.view?.stopLoader()
                
                switch result {
                case .success(let model):
                    self.view?.update(with: model)
                case .failure(let error):
                    router.showError(message: error.localizedDescription)
                }
        }
    }
    
    func useFormatter(with model: TransactionsDomainLayer, onlyTargetCurrency: Bool) -> String {
        formatter.make(with: model, onlyTargetCurrency: onlyTargetCurrency)
    }
    
    func getSum(model: [TransactionsDomainLayer]) -> Double {
        return service.getSum(model: model)
    }
}
