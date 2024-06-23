//
//  Transaction.swift
//  QR Payment
//
//  Created by admin on 6/23/24.
//

import Foundation

struct Transaction {
    var timestampUID: String
    var userAccount: String
    var targetBank, extTrxId: String
    var merchant: String
    var amount: Double
}
