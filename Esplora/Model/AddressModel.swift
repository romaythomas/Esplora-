

import Foundation

// MARK: - AddressModel

struct AddressModel:Codable {
    let address: String
    let chainStats, mempoolStats: Stats

    enum CodingKeys: String, CodingKey {
        case address
        case chainStats = "chain_stats"
        case mempoolStats = "mempool_stats"
    }
}

// MARK: - Stats
struct Stats: Codable {
    let fundedTxoCount, fundedTxoSum, spentTxoCount, spentTxoSum: Int
    let txCount: Int

    enum CodingKeys: String, CodingKey {
        case fundedTxoCount = "funded_txo_count"
        case fundedTxoSum = "funded_txo_sum"
        case spentTxoCount = "spent_txo_count"
        case spentTxoSum = "spent_txo_sum"
        case txCount = "tx_count"
    }
}

