//
//  QRScannerDelegate.swift
//  QRCodeScanner
//
//  Created by Yunus Emre Taşdemir on 26.09.2023.
//

import SwiftUI
import AVKit

class QRScannerDelegate:  NSObject, ObservableObject, AVCaptureMetadataOutputObjectsDelegate {
    @Published var scannedCode: String?
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection:
                        AVCaptureConnection) {
        if let metaObject = metadataObjects.first {
            guard let readableObject = metaObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let code = readableObject.stringValue else { return }
            print(code)
            scannedCode = code
        }
    }
}
