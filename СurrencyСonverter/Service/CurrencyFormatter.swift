//
//  CurrencyFormatter.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 18.03.2025.
//

import Foundation

protocol CurrencyFormatterProtocol {
    func make(with model: TransactionsModel, onlyTargetCurrency: Bool) -> String
}

class CurrencyFormatter: CurrencyFormatterProtocol {
    func make(with model: TransactionsModel, onlyTargetCurrency: Bool) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = onlyTargetCurrency ? CurrencyFormatter.targetCurrency : model.currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.groupingSeparator = ","
        formatter.decimalSeparator = "."
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: onlyTargetCurrency ? model.finalTargetCurrency : model.amount)) ?? ""
    }
}

extension CurrencyFormatter {
    static let targetCurrency: String = "GBP"
}
