//
//  TransactionsPresenter.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 17.03.2025.
//
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
        service.getConvert(with: model, completion: { model in
            guard let model = model else { return }
            self.view?.update(with: model)
        })
        
    }
    
    func getSum(model: [TransactionsModel]) -> Double {
        return service.getSum(model: model)
    }
    
    
}
