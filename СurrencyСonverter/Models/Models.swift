//
//  Models.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 16.03.2025.
//

struct ProductsModel {
    let sku: String
    let transactions: [(currency: String, amount: Double)]
}

struct TransactionsModel {
    let currency: String
    let amount: Double
    let convertedGBP: Double
}

struct Rate {
    let from: String
    let to: String
    let rate: Double
}
