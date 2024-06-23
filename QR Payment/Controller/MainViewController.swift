//
//  ViewController.swift
//  QR Payment
//
//  Created by admin on 6/19/24.
//

import UIKit

class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameValLabel: UILabel!
    @IBOutlet weak var accountNumLabel: UILabel!
    @IBOutlet weak var balanceValLabel: UILabel!
    
    var userMgr = UserManager()
    var qrMgr = QRManager()
    var trxMgr = TransactionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameValLabel.text = userMgr.data.name
        accountNumLabel.text = userMgr.data.account
        balanceValLabel.text = getAccBalance(balanceStr: String(format: "%.0f", userMgr.data.balance))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        balanceValLabel.text = getAccBalance(balanceStr: String(format: "%.0f", userMgr.data.balance))
        print("view will appear")
    }
    
    func getAccBalance(balanceStr: String) -> String {
        if balanceStr.count <= 3 {
            return balanceStr
        }
        let thousandSeparator = "."
        let decimalSeparator = ","
        let balanceInThousands = balanceStr.replacing(/[0-9](?=(?:[0-9]{3})+$)/, with: { matched in
            return "\(matched.output)\(thousandSeparator)"
        })
        return "Rp\(balanceInThousands)\(decimalSeparator)00"
    }

    @IBAction func openCamera(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        } else {
            print("Camera not available on this device.")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            print("image picked.")
            print(pickedImage)
            if qrMgr.scanQRCode(from: pickedImage) != nil {
                picker.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "MainToBill", sender: self)
            }
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func trxHistoryButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "MainToHistory", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MainToBill" {
            let billData = qrMgr.qrData
            let destinationVC = segue.destination as! BillViewController
            destinationVC.targetBank = billData?.sourceBank
            destinationVC.merchantName = billData?.merchant
            destinationVC.trxID = billData?.trxId
            destinationVC.trxAmount = billData?.amount
            destinationVC.userData = userMgr.data
            destinationVC.trxMgr = trxMgr
        }
        
        if segue.identifier == "MainToHistory" {
            let destinationVC = segue.destination as! TrxHistoryViewController
            destinationVC.transactions = trxMgr.transactions
            print(trxMgr)
        }
    }
    
}


