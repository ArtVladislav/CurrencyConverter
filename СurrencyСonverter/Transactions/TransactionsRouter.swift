//
//  TransactionsRouter.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 17.03.2025.
//
import UIKit

protocol TransactionsRouterProtocol: AnyObject{

}

final class TransactionsRouter: TransactionsRouterProtocol {
    
    private weak var root: UIViewController?
    
    func setRootViewController(root: UIViewController) {
        self.root = root
    }

}
