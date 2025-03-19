//
//  ProductsCell.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 17.03.2025.
//

import UIKit

final class TransactionsCell: CustomTableCell {
    
    static let cellId = "TransactionsCell"

    func configure(with model: TransactionsModel, presenter: TransactionsPresenterProtocol) {
        leftLabel.text = presenter.useFormatter(with: model, onlyTargetCurrency: false)
        rightLabel.text = presenter.useFormatter(with: model, onlyTargetCurrency: true)
    }
}
