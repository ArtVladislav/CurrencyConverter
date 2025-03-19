//
//  Models.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 16.03.2025.
//

struct ProductsPlistModel: Decodable {
    let sku: String
    let currency: String
    let amount: String
}

struct TransactionsProduct: Decodable {
    let currency: String
    let amount: Double
}

struct ProductsModel: Decodable {
    let sku: String
    let arrayTransactions: [TransactionsProduct]
}

struct RatesModel: Decodable {
    let from: String
    let to: String
    let rate: String
}

struct TransactionsModel: Decodable {
    let currency: String
    let amount: Double
    let finalTargetCurrency: Double
}
