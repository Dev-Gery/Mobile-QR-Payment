//
//  TransactionManager.swift
//  QR Payment
//
//  Created by admin on 6/23/24.
//

import Foundation

class TransactionManager {
    var transactions: [Transaction] = []
    func newTrx(currentDate: Date, userAccount: String, targetBank: String, extTrxId: String, merchant: String, amount: Double) {
        let UID: String = {
            // Create a Calendar instance
            let calendar = Calendar.current

            // Extract components from the current date
            let twoDigitFixer: (Int) -> String = { num in
                return (num < 10) ? ("0" + String(num)) : String(num)
            }
            let YYYY = String(calendar.component(.year, from: currentDate))
            let MM = twoDigitFixer(calendar.component(.month, from: currentDate))
            let DD = twoDigitFixer(calendar.component(.day, from: currentDate))
            let hh = twoDigitFixer(calendar.component(.hour, from: currentDate))
            let mm = twoDigitFixer(calendar.component(.minute, from: currentDate))
            let ss = twoDigitFixer(calendar.component(.second, from: currentDate))
            let nanosecond = String(calendar.component(.nanosecond, from: currentDate))
            let fff = String(nanosecond.prefix(3))

            return YYYY + MM + DD + hh + mm + ss + fff
        }()
        transactions.append(Transaction(timestampUID: UID, userAccount: userAccount, targetBank: targetBank, extTrxId: extTrxId, merchant: merchant, amount: amount))
    }
}
