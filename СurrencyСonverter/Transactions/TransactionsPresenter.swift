//
//  TransactionsPresenter.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 17.03.2025.
//
import UIKit
protocol TransactionsPresenterProtocol: AnyObject {
    var title: String { get }
    init(service: RestService, router: TransactionsRouterProtocol, model: ProductsModel, formatter: CurrencyFormatterProtocol)
    func viewDidLoad()
    func getSum(model: [TransactionsModel]) -> Double
    func useFormatter(with model: TransactionsModel, onlyTargetCurrency: Bool) -> String
}

final class TransactionsPresenter: TransactionsPresenterProtocol {
    
    var title: String { "Transactions for \(model.sku)" }
    weak var view: TransactionsViewProtocol?
    
    private let service: RestService
    private let router: TransactionsRouterProtocol
    private let model: ProductsModel
    private let formatter: CurrencyFormatterProtocol
    
    init(service: RestService, router: any TransactionsRouterProtocol, model: ProductsModel, formatter: CurrencyFormatterProtocol) {
        self.service = service
        self.router = router
        self.model = model
        self.formatter = formatter
    }
    
    func viewDidLoad() {
        view?.startLoader()
        service.getAllTransactions(with: model) { [weak self] result in
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
