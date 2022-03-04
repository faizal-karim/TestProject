//
//  ScanView+View.swift
//  TestProject_Example
//
//  Created by Faizal on 2/14/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

extension ScanView {
    static func prepareCameraButton(type: ButtonType) -> UIButton{
        let size = 70.0
        let baseButton = UIButton(frame: CGRect(x: 0, y: 0, width: size, height: size))
        baseButton.translatesAutoresizingMaskIntoConstraints = false
        baseButton.setCornerRadius(size / 2)
        switch type {
        case .capture:
            baseButton.setImage(UIImage(named: "capture"), for: .normal)
            baseButton.backgroundColor = .clear
        case .retake:
            baseButton.setImage(UIImage(named: "retake"), for: .normal)
            baseButton.backgroundColor = UIColor(hexString: "C1C1C1")
        case .save:
            baseButton.setImage(UIImage(named: "save"), for: .normal)
            baseButton.backgroundColor = UIColor(hexString: "00C953")
        }
        return baseButton
    }
    
    static func prepareView() -> UIView {
        let view = UIView()
        view.frame = UIScreen.main.bounds
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
