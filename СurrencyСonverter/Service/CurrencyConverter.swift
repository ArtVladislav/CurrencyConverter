//
//  CurrencyConverter.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 19.03.2025.
//
import UIKit

protocol CurrencyConverterProtocol {
    func getDomainLayerTransactions(transactions: [TransactionsProduct], rates: [RatesDataLayer], completion: @escaping (Result<[TransactionsDomainLayer], CustomError>) -> ())
    func getSum(model: [TransactionsDomainLayer]) -> Double
}

final class CurrencyConverter: CurrencyConverterProtocol {
    
    func getDomainLayerTransactions(transactions: [TransactionsProduct], rates: [RatesDataLayer], completion: @escaping (Result<[TransactionsDomainLayer], CustomError>) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let model = self.getConvert(transactions: transactions, rates: rates, targetCurrency: Constants.targetCurrency) else {
                DispatchQueue.main.async {
                    completion(.failure(.calculationError))
                }
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion(.success(model))
            }
        }
    }
    
    func getSum(model: [TransactionsDomainLayer]) -> Double {
        let sum = model.map { $0.finalTargetCurrency }.reduce(0, +)
        return sum
    }
}

private extension CurrencyConverter {
    
    private func getConvert(transactions: [TransactionsProduct], rates: [RatesDataLayer], targetCurrency: String) -> [TransactionsDomainLayer]? {
        let filteredRates = rates.filter { $0.to == targetCurrency }
        let ratesDict = Dictionary(uniqueKeysWithValues: filteredRates.map { ($0.from, Double($0.rate) ?? 1.0) })
        // Создаем словарь для конвертации через USD
        let usdRatesDict = Dictionary(uniqueKeysWithValues: rates.filter { $0.to == Constants.currencyUSD }.map { ($0.from, Double($0.rate) ?? 1.0) })
        let targetRateFromUSD = rates.first { $0.from == Constants.currencyUSD && $0.to == targetCurrency }.flatMap { Double($0.rate) } ?? 1.0
            
        return transactions.compactMap { transaction in
            if transaction.currency == targetCurrency {
                return TransactionsDomainLayer(currency: transaction.currency, amount: transaction.amount, finalTargetCurrency: transaction.amount)
            }
            // Пытаемся конвертировать напрямую в целевую валюту
            if let rate = ratesDict[transaction.currency] {
                let convertedAmount = transaction.amount * rate
                return TransactionsDomainLayer(currency: transaction.currency, amount: transaction.amount, finalTargetCurrency: convertedAmount)
            }
            // Если прямой курс не найден, конвертируем через USD
            else if let usdRate = usdRatesDict[transaction.currency], targetRateFromUSD != 0 {
                let amountInUSD = transaction.amount * usdRate
                let convertedAmount = amountInUSD * targetRateFromUSD
                return TransactionsDomainLayer(currency: transaction.currency, amount: transaction.amount, finalTargetCurrency: convertedAmount)
            } else {
                print("Курс для валюты \(transaction.currency) не найден для конвертации в \(targetCurrency) (включая конвертацию через \(Constants.currencyUSD))")
                return nil
            }
        }
    }
    
     enum Constants {
         static let currencyUSD: String = "USD"
         static let targetCurrency: String = "GBP"
    }
}
