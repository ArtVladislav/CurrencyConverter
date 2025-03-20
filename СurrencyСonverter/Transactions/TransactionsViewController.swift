//
//  TransactionsViewController.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 17.03.2025.
//

import UIKit

protocol TransactionsViewProtocol: AnyObject {
    func update(with model: [TransactionsDomainLayer])
    func startLoader()
    func stopLoader()
}

class TransactionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView: UITableView
    private let presenter: TransactionsPresenterProtocol
    private var model: [TransactionsDomainLayer]?
    private var activityIndicator: UIActivityIndicatorView!
    
    init(presenter: TransactionsPresenterProtocol) {
        self.presenter = presenter
        self.tableView = UITableView()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = presenter.title
        commonInit()
        presenter.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let model = model else { return nil }
        let sum = presenter.getSum(model: model)
        return "Total: " + presenter.useFormatter(with: TransactionsDomainLayer(currency: "", amount: 0, finalTargetCurrency: sum), onlyTargetCurrency: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = .black
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = self.model else { return 0 }
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionsCell.cellId, for: indexPath) as? TransactionsCell else { return UITableViewCell() }
        guard let model = self.model else { return cell }
        cell.configure(with: model[indexPath.row], presenter: presenter)
        return cell
    }
    
    deinit {
        print(">>> TransactionsController is Deinit")
    }
}

extension TransactionsViewController: TransactionsViewProtocol {
    
    func startLoader() {
        activityIndicator.startAnimating()
    }
    
    func stopLoader() {
        activityIndicator.stopAnimating()
    }
    
    func update(with model: [TransactionsDomainLayer]) {
        self.model = model
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func commonInit() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.barTintColor = .white
        view.backgroundColor = .white
        setupTableView()
        setupConstraints()
        setupIndicator()
    }
    
    private func setupIndicator(){
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .gray
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .white
        tableView.rowHeight = 50
        tableView.allowsSelection = false
        tableView.register(TransactionsCell.self, forCellReuseIdentifier: TransactionsCell.cellId)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
