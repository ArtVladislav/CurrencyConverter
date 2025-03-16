//
//  ProductsRouter.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 16.03.2025.
//

import UIKit

protocol ProductsRouterProtocol {
    
}

final class ProductsRouter: ProductsRouterProtocol {
    
    private weak var root: UIViewController?
    
    func setRootViewController(root: UIViewController){
        self.root = root
    }
}
