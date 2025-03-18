//
//  RestService.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 17.03.2025.
//
import UIKit

protocol RestServiceProtocol {
    func requestData(completion: @escaping (Result<String, Error>) -> ())
}

final class RestService: RestServiceProtocol {
    func requestData(completion: @escaping (Result<String, Error>) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            completion(.success("Hello world"))
        }
    }
}

extension RestService {
    struct Rate {
        let from: String
        let to: String
        let rate: Double
    }

    func getSum(model: [TransactionsModel]) -> Double {
        let sum = model.map { $0.convertedGBP }.reduce(0, +)
        return sum
    }
    
    func getConvert(with model: ProductsModel, completion: @escaping ([TransactionsModel]?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let rates = self.loadRatesFromPlist() else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            let ratesDict = self.createRatesDictionary(from: rates)
            let transactions = self.convertCurrency(with: model, ratesDict: ratesDict)
            DispatchQueue.main.async {
                completion(transactions)
            }
        }
    }
    
    func loadProductsFromPlist(completion: @escaping ([ProductsModel]?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let path = Bundle.main.path(forResource: "transactions", ofType: "plist"),
                  let plistData = FileManager.default.contents(atPath: path),
                  let plistArray = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [[String: String]] else {
                DispatchQueue.main.async {
                    completion(nil)
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
            
            DispatchQueue.global(qos: .userInitiated).async {
                completion(sortedProducts)
            }
        }
    }
    
    private func loadRatesFromPlist() -> [Rate]? {
        guard let path = Bundle.main.path(forResource: "rates", ofType: "plist"),
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
