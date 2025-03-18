//
//  TransactionsViewController.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 17.03.2025.
//

import UIKit

protocol TransactionsViewProtocol: AnyObject {
    func update(with model: [TransactionsModel])
}

class TransactionsViewController: UIViewController {
    
    private let presenter: TransactionsPresenterProtocol
    private lazy var transactionsView = TransactionsView(presenter: presenter)
    
    init(presenter: TransactionsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = transactionsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = presenter.title
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.barTintColor = .white
        presenter.viewDidLoad()
    }
    
}

extension TransactionsViewController: TransactionsViewProtocol {
    func update(with model: [TransactionsModel]) {
        transactionsView.update(with: model)
    }
}
