//
//  TransactionsFactory.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 17.03.2025.
//
import UIKit

final class TransactionsFactory {
    func make(with model: ProductsDomainLayer, rates: [RatesDataLayer]) -> UIViewController {
        
        let service = CurrencyConverter()
        
        let formatter = CurrencyFormatter()
        
        let router = TransactionsRouter()
        
        let presenter = TransactionsPresenter(service: service, router: router, model: model, formatter: formatter, rates: rates)
        
        let vc = TransactionsViewController(presenter: presenter)
            
        presenter.view = vc
        router.setRootViewController(root: vc)
        
        return vc
    }
}
