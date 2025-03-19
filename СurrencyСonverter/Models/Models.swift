//
//  Models.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 16.03.2025.
//

struct ProductsDataLayer: Decodable {
    let sku: String
    let currency: String
    let amount: String
}

struct TransactionsProduct: Decodable {
    let currency: String
    let amount: Double
}

struct ProductsDomainLayer: Decodable {
    let sku: String
    let arrayTransactions: [TransactionsProduct]
}

struct RatesDataLayer: Decodable {
    let from: String
    let to: String
    let rate: String
}

struct TransactionsDomainLayer: Equatable {
    let currency: String
    let amount: Double
    let finalTargetCurrency: Double
    
}
