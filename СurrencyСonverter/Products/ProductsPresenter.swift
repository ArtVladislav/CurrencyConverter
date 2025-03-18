//
//  ProductsPresenter.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 16.03.2025.
//

protocol ProductsPresenterProtocol: AnyObject {
    var title: String { get }
    init(service: RestService, router: ProductsRouterProtocol)
    func viewDidLoad()
    func tapCell(with model: ProductsModel)
}

final class ProductsPresenter: ProductsPresenterProtocol {
    
    var title: String { "Products" }
    weak var view: ProductsViewProtocol?
    
    private let service: RestService
    private let router: ProductsRouterProtocol
    
    init(service: RestService, router: ProductsRouterProtocol) {
        self.service = service
        self.router = router
    }
    
    func viewDidLoad() {
        view?.startLoader()
        service.getProductsFromPlist { [weak self] result in

            guard let self else { return }
            self.view?.stopLoader()
            
            switch result {
            case .success(let model):
                self.view?.update(model: model)
            case .failure(let error):
                self.router.showError(message: error.localizedDescription)
            }
                
        }
    }
    
    func tapCell(with model: ProductsModel) {
        router.openTransactions(with: model)
    }
}
