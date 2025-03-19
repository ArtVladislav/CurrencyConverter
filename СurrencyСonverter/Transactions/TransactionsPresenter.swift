//
//  TransactionsPresenter.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 17.03.2025.
//
import UIKit
protocol TransactionsPresenterProtocol: AnyObject {
    var title: String { get }
    init(service: CurrencyConverterProtocol, router: TransactionsRouterProtocol, model: ProductsModel, formatter: CurrencyFormatterProtocol, rates: [RatesModel])
    func viewDidLoad()
    func getSum(model: [TransactionsModel]) -> Double
    func useFormatter(with model: TransactionsModel, onlyTargetCurrency: Bool) -> String
}

final class TransactionsPresenter: TransactionsPresenterProtocol {
    
    var title: String { "Transactions for \(model.sku)" }
    weak var view: TransactionsViewProtocol?
    
    private let service: CurrencyConverterProtocol
    private let router: TransactionsRouterProtocol
    private let model: ProductsModel
    private let formatter: CurrencyFormatterProtocol
    private let rates: [RatesModel]
    
    init(service: CurrencyConverterProtocol, router: any TransactionsRouterProtocol, model: ProductsModel, formatter: CurrencyFormatterProtocol, rates: [RatesModel]) {
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
    
    func useFormatter(with model: TransactionsModel, onlyTargetCurrency: Bool) -> String {
        formatter.make(with: model, onlyTargetCurrency: onlyTargetCurrency)
    }
    
    func getSum(model: [TransactionsModel]) -> Double {
        return service.getSum(model: model)
    }
}
