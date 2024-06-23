//
//  UserManager.swift
//  QR Payment
//
//  Created by admin on 6/21/24.
//

import Foundation

class UserManager {
    var data: User
    init(name: String = "Gery", acc: String = "438028503", bal: Double = 1_000_000) {
        data = User(account: acc, name: name, balance: bal)
    }
}
