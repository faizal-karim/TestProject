//
//  Extentsions.swift
//  TestProject_Example
//
//  Created by Faizal on 2/11/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

// MARK: UIView
extension UIView {
    func setCornerRadius(_ value: CGFloat) {
        layer.cornerRadius = value
        layer.masksToBounds = value > 0
    }
    
    func addToWindow()  {
        let window = UIApplication.shared.keyWindow!
        self.frame = window.bounds
        window.addSubview(self)
    }
    
    func addSubViews(views: [UIView]) {
        views.forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
    
    var safeTopAnchor: NSLayoutYAxisAnchor {
            if #available(iOS 11.0, *) {
                return safeAreaLayoutGuide.topAnchor
            }
            return topAnchor
        }

        var safeBottomAnchor: NSLayoutYAxisAnchor {
            if #available(iOS 11.0, *) {
                return safeAreaLayoutGuide.bottomAnchor
            }
            return bottomAnchor
        }

        var safeLeadingAnchor: NSLayoutXAxisAnchor {
            if #available(iOS 11.0, *) {
                return safeAreaLayoutGuide.leadingAnchor
            }
            return leadingAnchor
        }

        var safeTrailingAnchor: NSLayoutXAxisAnchor {
            if #available(iOS 11.0, *) {
                return safeAreaLayoutGuide.trailingAnchor
            }
            return trailingAnchor
        }

}

// MARK: UIStackView

extension UIStackView {
    func addAddrrangedSubViews(views: [UIView]) {
        views.forEach{ addArrangedSubview($0)}
    }
}

    //MARK: UIColor

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
