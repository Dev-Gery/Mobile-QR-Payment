//
//  TransactionManager.swift
//  QR Payment
//
//  Created by admin on 6/21/24.
//

import UIKit

struct QRManager {
    var qrData: QR?
    
    mutating func scanQRCode(from image: UIImage) -> Bool? {
        guard let ciImage = CIImage(image: image) else {
            print("ciImage is null: couldn't get QR code from the image")
            return nil
        }
        print(ciImage)
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        
        if let features = detector?.features(in: ciImage) {
            if features.isEmpty {
                print("features is empty")
                return nil
            }
            for feature in features as! [CIQRCodeFeature] {
                print("looping feeatures")
                if let qrString = feature.messageString {
                    print("QR Code String: \(qrString)")
                    let qrStringSplit : [String] = qrString.split(separator: ".").map{$0.trimmingCharacters(in: .whitespaces)}
                    print(qrStringSplit)
                    if let amount = Double(qrStringSplit[3]) {
                        qrData = QR(qrString: qrString, sourceBank: qrStringSplit[0], trxId: qrStringSplit[1], merchant: qrStringSplit[2], amount: amount)
                    } else {
                        print("Amount not found!")
                        return false
                    }
                    return true
                } else {
                    print("QR Code Not Found!")
                }
            }
        } else {
            print("features is nill")
        }
        
        print("Scan ended")
        return nil
    }
    
    
}
