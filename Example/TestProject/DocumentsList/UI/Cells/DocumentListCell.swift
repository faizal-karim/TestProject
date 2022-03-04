//
//  DocumentListCell.swift
//  TestProject_Example
//
//  Created by Faizal on 3/4/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class DocumentListCell: UICollectionViewCell {
    // MARK: Properties
    enum CellType {
        case document, addNew
    }
    
    // MARK: Outlets
    let imageView: UIImageView = {
       let imageView = UIImageView()
       return imageView
    }()
    
    let bgImage: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "cell_background")
       return imageView
    }()
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureView(for type: CellType) {
        backgroundColor = UIColor.init(hexString: "F4F7FF")
        setCornerRadius(10)
        addSubViews(views: [bgImage, imageView])
        configureConstrains(type)
    }
    
    func configureConstrains(_ type: CellType) {
        let isAddNew = type == .addNew
        let padding = CGFloat(27)
        NSLayoutConstraint.activate([
            bgImage.topAnchor.constraint(equalTo: topAnchor),
            bgImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            bgImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            bgImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: isAddNew ? padding : 1),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: isAddNew ? padding : 1),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: isAddNew ? -padding : -1),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: isAddNew ? -padding : -1)
        ])
    }
    
    func configureUI(with image: UIImage) {
        imageView.image = image
    }
}
