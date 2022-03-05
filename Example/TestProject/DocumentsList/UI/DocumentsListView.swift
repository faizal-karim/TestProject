//
//  DocumentsListView.swift
//  TestProject_Example
//
//  Created by Faizal on 3/4/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

protocol DocumentsListViewDelegate: AnyObject {
    func didPressContinue()
    func didClickNewDocument()
}

class DocumentsListView: BaseView {
    // MARK: Helper Types
    
    private struct Constants {
        static let buttonTitle = "Continue"
        static let padding = CGFloat(15)
    }
    
    var collectionView: UICollectionView!
    let titleLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        title.textColor = .black
        title.textAlignment = .center
        return title
    }()
    
    let subTitleLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        title.textColor = UIColor.init(hexString: "6D6D6D")
        title.textAlignment = .center
        title.numberOfLines = 3
        return title
    }()
    
    let continueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hexString: "61AF2B")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        return button
    }()

    
    
    // MARK: Properties
    let viewModel: DocumentsListViewModel
    weak var delegate: DocumentsListViewDelegate?
    
    // MARK: Init Methods
    init(viewModel: DocumentsListViewModel, frame: CGRect) {
        self.viewModel = viewModel
        super.init(frame: frame)
    }
    
    override func constructSubviewHierarchy() {
        addSubViews(views: [titleLabel, subTitleLabel, collectionView, continueButton])
    }
    
    override func constructSubviewConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeTopAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),

            collectionView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.padding),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.padding),
            collectionView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: 20),
            
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            continueButton.heightAnchor.constraint(equalToConstant: 56),
            continueButton.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -40)

            
        ])
    }
    
    override func configureView() {
        backgroundColor = .white
        configureCollectionView()
        titleLabel.text = "Uploaded Files"
        subTitleLabel.text = "Capture your photo.  Lorem Ipsum has been the industry's."
        continueButton.setTitle(Constants.buttonTitle, for: .normal)
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: frame, collectionViewLayout: makeLayout())
        collectionView.register(DocumentListCell.self, forCellWithReuseIdentifier: "DocumentListCell")
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func makeLayout() -> UICollectionViewFlowLayout {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        let totalSpace = layout.sectionInset.left
            + layout.sectionInset.right
            + (layout.minimumInteritemSpacing * CGFloat(3 - 1))
        let size = (bounds.width - totalSpace - (Constants.padding*2) ) / CGFloat(3)
        layout.itemSize = CGSize(width: size, height: size)
        return layout
    }
    
    // MARK: Button Action
    @objc func nextAction() {
        self.delegate?.didPressContinue()
    }
}



extension DocumentsListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getDataSourceCount() + 1 // One Additional Row
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DocumentListCell", for: indexPath) as? DocumentListCell else  {
            return UICollectionViewCell()
        }
        
        if viewModel.getDataSourceCount() != indexPath.row  {
            cell.configureView(for: .document)
            let image = viewModel.getItem(for: indexPath.row)
            cell.configureUI(with: image)
            return cell
        }else {
            cell.configureView(for: .addNew)
            cell.configureUI(with: addNew!)
            return cell
        }
    }
}

extension DocumentsListView: UICollectionViewDelegate {
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if viewModel.getDataSourceCount() == indexPath.row {
            delegate?.didClickNewDocument()
        }
    }
}
