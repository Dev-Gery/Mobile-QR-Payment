//
//  HistoryViewController.swift
//  QR Payment
//
//  Created by admin on 6/21/24.
//

import UIKit

class TrxHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var transactions: [Transaction]!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellIdentifier")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let timestamp = transactions?[indexPath.row].timestampUID
        let amount = (transactions?[indexPath.row].amount)!
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        cell.textLabel?.text = {
            let inputFormatter = DateFormatter()
            inputFormatter.locale = Locale.current
            inputFormatter.timeZone = TimeZone.current
            inputFormatter.dateFormat = "yyyyMMddHHmmssSSS"
            let date = inputFormatter.date(from: timestamp!)
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
            let localeDateString = dateFormatter.string(from: date!)
            
            let thousandSeparator = "."
            let decimalSeparator = ","
            var amountIDR = ""
            let amountStr = String(format: "%.0f", amount)
            if amountStr.count <= 3 {
                amountIDR = "Rp\(amountStr)\(decimalSeparator)00"
            } else {
                let amountInThousands = amountStr.replacing(/[0-9](?=(?:[0-9]{3})+$)/, with: { matched in
                    return "\(matched.output)\(thousandSeparator)"
                })
                amountIDR = "Rp\(amountInThousands)\(decimalSeparator)00"
            }
            
            return "\(indexPath.row + 1))\t\(localeDateString)\t\(amountIDR)"
        }()
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        performSegue(withIdentifier: "HistoryToReceipt", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HistoryToReceipt" {
            let destinationVC = segue.destination as! TrxReceiptViewController
            let indexPath = sender as! IndexPath
            let trx = transactions[indexPath.row]
            destinationVC.sourceAccVal = trx.userAccount
            destinationVC.targetBankVal = trx.targetBank
            destinationVC.extTrxIDVal = trx.extTrxId
            destinationVC.merchantNameVal = trx.merchant
            destinationVC.timestampVal = {
                let cell = tableView.cellForRow(at: indexPath)
                return String((cell?.textLabel?.text?.split(separator: "\t")[1])!)
            }()
            
            destinationVC.totalPaidVal = { totalPaidStr -> String in
                if totalPaidStr.count <= 3 {
                    return totalPaidStr
                }
                let thousandSeparator = "."
                let decimalSeparator = ","
                let balanceInThousands = totalPaidStr.replacing(/[0-9](?=(?:[0-9]{3})+$)/, with: { matched in
                    return "\(matched.output)\(thousandSeparator)"
                })
                return "Rp\(balanceInThousands)\(decimalSeparator)00"
            }( String(format: "%.0f", transactions[indexPath.row].amount ) )
            
            destinationVC.previousViewController = self
        }
          
    }
}
