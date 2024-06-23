//
//  BillViewController.swift
//  QR Payment
//
//  Created by admin on 6/21/24.
//

import UIKit
import AVFoundation

class BillViewController: UIViewController {
    
    @IBOutlet weak var merchantLabel: UILabel!
    @IBOutlet weak var trxIDLabel: UILabel!
    @IBOutlet weak var trxAmountLabel: UILabel!
    var targetBank: String!
    var merchantName: String!
    var trxID: String!
    var trxAmount: Double!
    var trxMgr : TransactionManager!
    var userData : User!
    var currentDate: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        merchantLabel.text = merchantName ?? "N/A"
        trxIDLabel.text = trxID ?? "N/A"
        if let amount = trxAmount {
            trxAmountLabel.text = { trxAmountStr -> String in
                if trxAmountStr.count <= 3 {
                    return trxAmountStr
                }
                let thousandSeparator = "."
                let decimalSeparator = ","
                let balanceInThousands = trxAmountStr.replacing(/[0-9](?=(?:[0-9]{3})+$)/, with: { matched in
                    return "\(matched.output)\(thousandSeparator)"
                })
                return "Rp\(balanceInThousands)\(decimalSeparator)00"
            }( String(format: "%.0f", amount) )
        } else {
            trxAmountLabel.text = "N/A"
        }
        
    }
    
    @IBAction func payButtonPressed(_ sender: UIButton) {
        if let user = userData, let payAmount = trxAmount {
            if user.balance > payAmount {
                user.balance -= payAmount
                currentDate = Date()
                trxMgr.newTrx(currentDate: currentDate, userAccount: userData.account, targetBank: targetBank, extTrxId: trxID, merchant: merchantName, amount: trxAmount)
                print(trxMgr.transactions)
                self.performSegue(withIdentifier: "BillToReceipt", sender: self)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BillToReceipt" {
            let destinationVC = segue.destination as! TrxReceiptViewController
            
            destinationVC.timestampVal = {
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale.current
                dateFormatter.timeZone = TimeZone.current
                dateFormatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
                let localeDateString = dateFormatter.string(from: currentDate)
                return localeDateString
            }()
            
            destinationVC.sourceAccVal = userData.account
            destinationVC.targetBankVal = targetBank
            destinationVC.extTrxIDVal = trxID
            destinationVC.merchantNameVal = merchantName
            destinationVC.totalPaidVal = trxAmountLabel.text
            destinationVC.previousViewController = self
           
        }
    }
    
}
