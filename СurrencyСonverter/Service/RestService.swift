//
//  RestService.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 17.03.2025.
//

import UIKit

protocol RestServiceProtocol {
    func loadProductsFromPlist(completion: @escaping (Result<[ProductsModel], CustomError>) -> ())
    func getConvert(with model: ProductsModel, completion: @escaping (Result<[TransactionsModel], CustomError>) -> ())
    var fileNameTransactions: String { get }
    var fileNameRates: String { get }
}

final class RestService: RestServiceProtocol {
    
    var fileNameTransactions: String { "transactions" }
    var fileNameRates: String { "rates" }
    
    func getConvert(with model: ProductsModel, completion: @escaping (Result<[TransactionsModel], CustomError>) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let rates = self.loadRatesFromPlist() else {
                DispatchQueue.main.async {
                    completion(.failure(.calculationError))
                }
                return
            }
            let ratesDict = self.createRatesDictionary(from: rates)
            let transactions = self.convertCurrency(with: model, ratesDict: ratesDict)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                completion(.success(transactions))
            }
        }
    }
    
    func loadProductsFromPlist(completion: @escaping (Result<[ProductsModel], CustomError>) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let path = Bundle.main.path(forResource: self.fileNameTransactions, ofType: "plist"),
                  let plistData = FileManager.default.contents(atPath: path),
                  let plistArray = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [[String: String]] else {
                DispatchQueue.main.async {
                    completion(.failure(.failedToLoadDataFromFile))
                }
                return
            }
            
            // Группируем по sku
            let groupedProducts = Dictionary(grouping: plistArray) { $0["sku"]! }
            
            // Преобразуем в массив моделей ProductsModel
            let products = groupedProducts.compactMap { sku, dicts -> ProductsModel? in
                guard !sku.isEmpty else { return nil }
                
                // Преобразуем массив словарей в массив транзакций
                let transactions = dicts.compactMap { dict -> (currency: String, amount: Double)? in
                    guard let amountString = dict["amount"],
                          let amount = Double(amountString), // Преобразуем String в Double
                          let currency = dict["currency"] else {
                        return nil
                    }
                    return (currency: currency, amount: amount)
                }
                
                // Создаем модель ProductsModel
                return ProductsModel(sku: sku, transactions: transactions)
            }
            
            // Сортируем массив моделей по sku
            let sortedProducts = products.sorted { $0.sku < $1.sku }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                completion(.success(sortedProducts))
            }
        }
    }
}

extension RestService {

    func getSum(model: [TransactionsModel]) -> Double {
        let sum = model.map { $0.convertedGBP }.reduce(0, +)
        return sum
    }
    
    private func loadRatesFromPlist() -> [Rate]? {
        guard let path = Bundle.main.path(forResource: self.fileNameRates, ofType: "plist"),
              let plistData = FileManager.default.contents(atPath: path),
              let plistArray = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [[String: Any]] else {
            return nil
        }
        
        return plistArray.compactMap { dict in
            guard let from = dict["from"] as? String,
                  let to = dict["to"] as? String,
                  let rateString = dict["rate"] as? String,
                  let rate = Double(rateString) else {
                return nil
            }
            return Rate(from: from, to: to, rate: rate)
        }
    }
    
    private func createRatesDictionary(from rates: [Rate]) -> [String: Double] {
        var ratesDict: [String: Double] = [:]
        for rate in rates {
            let key = "\(rate.from)-\(rate.to)"
            ratesDict[key] = rate.rate
        }
        return ratesDict
    }

    private func convertCurrency(with model: ProductsModel, ratesDict: [String: Double]) -> [TransactionsModel] {
        return model.transactions.map { transaction in
            let amount = transaction.amount
            let currency = transaction.currency
            
            // Если валюта уже GBP, возвращаем исходную сумму
            if currency == "GBP" {
                return TransactionsModel(currency: currency, amount: amount, convertedGBP: amount)
            }
            
            // Прямая конвертация в GBP
            let directKey = "\(currency)-GBP"
            if let directRate = ratesDict[directKey] {
                let convertedGBP = amount * directRate
                return TransactionsModel(currency: currency, amount: amount, convertedGBP: convertedGBP)
            }
            
            // Конвертация через USD
            let toUSDKey = "\(currency)-USD"
            let toGBPKey = "USD-GBP"
            
            if let usdRate = ratesDict[toUSDKey], let gbpRate = ratesDict[toGBPKey] {
                let amountInUSD = amount * usdRate
                let convertedGBP = amountInUSD * gbpRate
                return TransactionsModel(currency: currency, amount: amount, convertedGBP: convertedGBP)
            }
            
            // Если конвертация невозможна, возвращаем исходные данные с convertedGBP = 0
            return TransactionsModel(currency: currency, amount: amount, convertedGBP: 0)
        }
    }
    
}
