//
//  RestService.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 17.03.2025.
//

import UIKit

protocol RestServiceProtocol {
    func getProductsFromPlist(completion: @escaping (Result<[ProductsModel], CustomError>) -> ())
    func getAllTransactions(with model: ProductsModel, completion: @escaping (Result<[TransactionsModel], CustomError>) -> ())
}

final class RestService: RestServiceProtocol {
    
    func getProductsFromPlist(completion: @escaping (Result<[ProductsModel], CustomError>) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let model = self.getProducts(with: Constants.fileNameTransactions, extensionFile: Constants.fileExtension) else {
                DispatchQueue.main.async {
                    completion(.failure(.failedToLoadDataFromFile))
                }
                return
            }
            DispatchQueue.main.async {
                completion(.success(model))
            }
        }
    }
    
    func getAllTransactions(with model: ProductsModel, completion: @escaping (Result<[TransactionsModel], CustomError>) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let model = self.getTransactions(with: Constants.fileNameRates, extensionFile: Constants.fileExtension, transactions: model.arrayTransactions, targetCurrency: Constants.targetCurrency) else {
                DispatchQueue.main.async {
                    completion(.failure(.calculationError))
                }
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                completion(.success(model))
            }
        }
    }
}

extension RestService {
    
    private func getData(with fileName: String, extensionFile: String) -> Data? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: extensionFile) else { return nil }
        return FileManager.default.contents(atPath: path)
    }
    
    private func getPlistModel<T: Decodable>(with fileName: String, extensionFile: String) -> [T]? {
        guard let data = getData(with: fileName, extensionFile: extensionFile) else { return nil }
        do {
            return try PropertyListDecoder().decode([T].self, from: data)
        } catch {
            print("Error decodable")
            return nil
        }
    }
  
    private func getProducts(with fileName: String, extensionFile: String) -> [ProductsModel]? {
        guard let model: [ProductsPlistModel] = getPlistModel(with: fileName, extensionFile: extensionFile) else { return nil }
        let groupedDict = Dictionary(grouping: model, by: { $0.sku })
        return groupedDict.map { sku, plistModels in
            let transactions = plistModels.compactMap { plistModel -> TransactionsProduct? in
                return TransactionsProduct(currency: plistModel.currency, amount: Double(plistModel.amount) ?? 0)
            }
            return ProductsModel(sku: sku, arrayTransactions: transactions)
        }.sorted { $0.sku < $1.sku }
    }
    
    private func getTransactions(with fileName: String, extensionFile: String, transactions: [TransactionsProduct], targetCurrency: String) -> [TransactionsModel]? {
        guard let rates: [RatesModel] = getPlistModel(with: fileName, extensionFile: extensionFile) else { return nil }
        let filteredRates = rates.filter { $0.to == targetCurrency }
        let ratesDict = Dictionary(uniqueKeysWithValues: filteredRates.map { ($0.from, Double($0.rate) ?? 1.0) })
        
        // Создаем словарь для конвертации через USD
        let usdRatesDict = Dictionary(uniqueKeysWithValues: rates.filter { $0.to == Constants.currencyUSD }.map { ($0.from, Double($0.rate) ?? 1.0) })
        let targetRateFromUSD = rates.first { $0.from == Constants.currencyUSD && $0.to == targetCurrency }.flatMap { Double($0.rate) } ?? 1.0
        
        return transactions.compactMap { transaction in
            // Пытаемся конвертировать напрямую в целевую валюту
            if let rate = ratesDict[transaction.currency] {
                let convertedAmount = transaction.amount * rate
                return TransactionsModel(currency: transaction.currency, amount: transaction.amount, convertedGBP: convertedAmount)
            }
            // Если прямой курс не найден, конвертируем через USD
            else if let usdRate = usdRatesDict[transaction.currency], targetRateFromUSD != 0 {
                let amountInUSD = transaction.amount * usdRate
                let convertedAmount = amountInUSD * targetRateFromUSD
                return TransactionsModel(currency: transaction.currency, amount: transaction.amount, convertedGBP: convertedAmount)
            }
            // Если ни один из курсов не найден, пропускаем транзакцию
            else {
                print("Курс для валюты \(transaction.currency) не найден для конвертации в \(targetCurrency) (включая конвертацию через \(Constants.currencyUSD))")
                return nil
            }
        }
    }
    
    func getSum(model: [TransactionsModel]) -> Double {
        let sum = model.map { $0.convertedGBP }.reduce(0, +)
        return sum
    }
}

private extension RestService {
     enum Constants {
         static let fileNameTransactions: String = "transactions"
         static let fileNameRates: String = "rates"
         static let fileExtension: String = "plist"
         static let currencyUSD: String = "USD"
         static let targetCurrency: String = "GBP"
    }
}
