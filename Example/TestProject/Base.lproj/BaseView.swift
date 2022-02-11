//
//  BaseView.swift
//  TestProject_Example
//
//  Created by Faizal on 2/9/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//
import UIKit

class BaseView: UIView, Constructible {
    // MARK: - Properties
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        construct()
        print("Created \(type(of: self))")
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("Destroyed \(type(of: self))")
    }
    
    // MARK: - Construction
    func configureView() {}
    func configureSubviews() {}
    func constructSublayerHierarchy() {}
    func constructSubviewHierarchy() {}
    func constructSubviewConstraints() {}
    func setSublayerFrames() {}
    // MARK: - Layout
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        // `layoutSublayers` is called for each sublayer of the view.
        // Checking that the `layer` is the view's backing layer prevents
        // redundant updates to the sublayer layout.
        if layer === self.layer {
            setSublayerFrames()
        }
    }
}


