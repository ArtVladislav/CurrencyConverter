//
//  TransactionsPresenter.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 17.03.2025.
//
import UIKit
protocol TransactionsPresenterProtocol: AnyObject {
    var title: String { get }
    init(service: RestService, router: TransactionsRouterProtocol, model: ProductsModel)
    func viewDidLoad()
    func getSum(model: [TransactionsModel]) -> Double
}

final class TransactionsPresenter: TransactionsPresenterProtocol {
    
    var title: String { "Transactions for \(model.sku)" }
    weak var view: TransactionsViewProtocol?
    
    private let service: RestService
    private let router: TransactionsRouterProtocol
    private let model: ProductsModel
    
    init(service: RestService, router: any TransactionsRouterProtocol, model: ProductsModel) {
        self.service = service
        self.router = router
        self.model = model
    }
    
    func viewDidLoad() {
        view?.startLoader()
        service.getConvert(with: model) { [weak self] result in
                guard let self else { return }
                self.view?.stopLoader()
                
                switch result {
                case .success(let model):
                    self.view?.update(with: model)
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    func getSum(model: [TransactionsModel]) -> Double {
        return service.getSum(model: model)
    }
    
    
}
