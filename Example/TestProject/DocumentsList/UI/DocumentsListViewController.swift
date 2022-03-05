//
//  DocumentsListViewController.swift
//  TestProject_Example
//
//  Created by Faizal on 3/4/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
let testImage = UIImage(named: "document_placeHolder")
let addNew = UIImage(named: "add_new")

class DocumentsListViewController: BaseViewController {
    
    // MARK: Initi Methods
    override init() {
        super.init()
    }
    
    override func loadView() {
        //TODO: Change here
        let view = DocumentsListView(
            viewModel: DocumentsListViewModel(model: KYCModel(selfie: testImage!, signature: testImage!, documents: [testImage!, testImage!])),
            frame: UIScreen.main.bounds)
        view.delegate = self
        self.view = view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.backBarButtonItem?.title = ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
}

extension DocumentsListViewController: DocumentsListViewDelegate {
    func didClickNewDocument() {
        let scanVC = ScanViewController(type: .document)
        self.navigationController?.pushViewController(scanVC, animated: true)
    }
    
    func didPressContinue() {
        let scanVC = ScanViewController(type: .liveness)
        self.navigationController?.pushViewController(scanVC, animated: true)
    }
}
