//
//  ScanViewController.swift
//  TestProject_Example
//
//  Created by Faizal on 2/11/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class ScanViewController: BaseViewController {
    // MARK: Properties
    let type: ScanType
    var rootView: ScanView { view as! ScanView}
    
    // MARK: Initi Methods
    init(type: ScanType) {
        self.type = type
        super.init()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func loadView() {
        let view = ScanView(
            viewModel: ScanViewModel(type: type).prepareVM(),
            frame: UIScreen.main.bounds)
        view.delegate = self
        self.view = view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rootView.willAppear()
    }
}

extension ScanViewController: ScanViewDelegate {
    func saveAndContinue(toNext type: ScanType) {
        let scanVC = ScanViewController(type: type)
        self.navigationController?.pushViewController(scanVC, animated: true)
    }
    
    func moveToNextScreen(scene: Scene) {
        switch scene {
        case .documentList:
            let vc = DocumentsListViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .profile:
            let vc = ProfileViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
}
