//
//  TransactionsFactory.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 17.03.2025.
//
import UIKit

final class TransactionsFactory {
    func make(with model: ProductsModel) -> UIViewController {
        
        let service = RestService()
        
        let router = TransactionsRouter()
        
        let presenter = TransactionsPresenter(service: service, router: router, model: model)
        
        let vc = TransactionsViewController(presenter: presenter)
            
        presenter.view = vc
        router.setRootViewController(root: vc)
        
        return vc
    }
}
