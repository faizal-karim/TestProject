//
//  IntroductionView.swift
//  TestProject_Example
//
//  Created by Faizal on 2/11/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class IntroductionView: BaseView {
    // MARK: Helper Types
    
    private struct Constants {
        static let buttonTitle = "Next"
        static let backgroundImage = "introductionBackground"
    }
    
    // MARK: Properties
    let viewModel: IntroductionViewModel
    
    let titleLabel: UILabel = {
       let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        title.textColor = .black
        title.textAlignment = .center
        return title
    }()
    
    let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage.init(named: Constants.backgroundImage)
        return imageView
    }()
    
    let bodyLabel: UILabel = {
        let body = UILabel()
        body.numberOfLines = 0
        body.textColor =  UIColor(hexString: "6D6D6D")
        return body
    }()
    
    let continueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hexString: "61AF2B")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        return button
    }()
    
    // MARK: Init Methods
    init(viewModel: IntroductionViewModel, frame: CGRect) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    override func constructSubviewHierarchy() {
        addSubViews(views: [titleLabel, bodyLabel, imageView, continueButton])
    }
    
    override func constructSubviewConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 65),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 24),
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 60),
            imageView.widthAnchor.constraint(equalToConstant: 230),
            imageView.heightAnchor.constraint(equalToConstant: 190),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            bodyLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            bodyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            bodyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            bodyLabel.bottomAnchor.constraint(lessThanOrEqualTo: continueButton.topAnchor, constant: 20),
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            continueButton.heightAnchor.constraint(equalToConstant: 56),
            continueButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    override func configureView() {
        titleLabel.text = viewModel.title
        bodyLabel.text = viewModel.body
        continueButton.setTitle(Constants.buttonTitle, for: .normal)
    }
    
    // MARK: Button Action
    @objc func nextAction() {
        
    }
}
