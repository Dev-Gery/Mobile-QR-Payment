//
//  User.swift
//  QR Payment
//
//  Created by admin on 6/21/24.
//

import Foundation

class User {
    let account, name: String
    var balance: Double
    init(account: String, name: String, balance: Double) {
        self.account = account
        self.name = name
        self.balance = balance
    }
}




