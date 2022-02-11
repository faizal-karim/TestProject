//
//  Constructible.swift
//  TestProject_Example
//
//  Created by Faizal on 2/11/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation

protocol Constructible {
    /// Entry point for view setup after initialization (if any).
    func configureView()
    /// Entry point for subview setup after initialization (if any).
    func configureSubviews()
    /// Constructs the sub-layer hierarchy (if any).
    func constructSublayerHierarchy()
    /// Constructs the view hierarchy by calling `addSubview` as needed.
    func constructSubviewHierarchy()
    /// Constructs and activates AutoLayout constraints.
    func constructSubviewConstraints()
    /// Updates sub-layer frames (if any).
    func setSublayerFrames()
}
// MARK: -
extension Constructible {
    /// Convenience method that invokes `Constructible` methods in the correct order.
    /// Typically called in the `init` of types that conform to the `Constructible` protocol.
    func construct() {
        configureView()
        configureSubviews()
        constructSublayerHierarchy()
        constructSubviewHierarchy()
        constructSubviewConstraints()
    }
}
