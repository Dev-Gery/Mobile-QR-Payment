//
//  TrxDetailViewController.swift
//  QR Payment
//
//  Created by admin on 6/21/24.
//

import UIKit

class TrxReceiptViewController: UIViewController {

    @IBOutlet weak var timestampValLabel: UILabel!
    @IBOutlet weak var sourceAccValLabel: UILabel!
    @IBOutlet weak var targetBankValLabel: UILabel!
    @IBOutlet weak var extTrxIDValLabel: UILabel!
    @IBOutlet weak var merchantNameLabel: UILabel!
    @IBOutlet weak var totalPaidValLabel: UILabel!
    var timestampVal, sourceAccVal, targetBankVal, extTrxIDVal, merchantNameVal, totalPaidVal : String?
    var previousViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if previousViewController is BillViewController {
            navigationItem.hidesBackButton = true
        }
        timestampValLabel.text = timestampVal
        sourceAccValLabel.text = sourceAccVal
        targetBankValLabel.text = targetBankVal
        extTrxIDValLabel.text = extTrxIDVal
        merchantNameLabel.text = merchantNameVal
        totalPaidValLabel.text = totalPaidVal
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    

}
