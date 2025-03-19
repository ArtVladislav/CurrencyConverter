//
//  CurrencyFormatter.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 18.03.2025.
//

import Foundation

protocol CurrencyFormatterProtocol {
    func make(with model: TransactionsDomainLayer, onlyTargetCurrency: Bool) -> String
}

final class CurrencyFormatter: CurrencyFormatterProtocol {
    func make(with model: TransactionsDomainLayer, onlyTargetCurrency: Bool) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = onlyTargetCurrency ? Constants.targetCurrency : model.currency
        formatter.locale = Locale(identifier: Constants.identifier)
        formatter.groupingSeparator = ","
        formatter.decimalSeparator = "."
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: onlyTargetCurrency ? model.finalTargetCurrency : model.amount)) ?? ""
    }
}

private extension CurrencyFormatter {
    enum Constants {
        static let identifier: String = "en_US"
        static let targetCurrency: String = "GBP"
    }
}
