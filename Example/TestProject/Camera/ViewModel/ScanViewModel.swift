//
//  ScanViewModel.swift
//  TestProject_Example
//
//  Created by Faizal on 2/11/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation

typealias ScanType = ScanViewModel.CaptureType

struct ScanViewModel {
    // MARK: Properties
    var title: String = ""
    var subTitle: String = ""
    let scanType: ScanType
    
    enum CaptureType: Int {
        case selfie, signature, document, liveness
    }
    
    init(type: ScanType) {
        self.scanType = type
    }
    
    private init(title: String, subTitle: String,  scanType: ScanType) {
        self.title = title
        self.subTitle = subTitle
        self.scanType = scanType
    }
    
    func prepareVM() -> ScanViewModel{
        switch scanType {
        case .selfie :
            return ScanViewModel(title: "Capture your photo", subTitle: "Capture your photo.  Lorem Ipsum has been the industry's.", scanType: scanType)
        case .signature:
            return ScanViewModel(title: "Scan your Signature", subTitle: "Capture your photo.  Lorem Ipsum has been the industry's.", scanType: scanType)
        case .document:
            return ScanViewModel(title: "Scan your Identity Documents", subTitle: "Capture your photo.  Lorem Ipsum has been the industry's.", scanType: scanType)
        case .liveness:
            return ScanViewModel(title: "Liveness Detection", subTitle: "Type 4 digit number that will send your.", scanType: scanType)

        }
    }
    
    
}
