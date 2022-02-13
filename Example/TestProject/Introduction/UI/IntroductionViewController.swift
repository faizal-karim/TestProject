//
//  IntroductionViewController.swift
//  TestProject_Example
//
//  Created by Faizal on 2/11/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class IntroductionViewController: BaseViewController {
    
    // MARK: Initi Methods
    override init() {
        super.init()
    }
    
    override func loadView() {
        let view = IntroductionView(
            viewModel: prepareVM(),
            frame: UIScreen.main.bounds)
        view.delegate = self
        self.view = view
    }
    
    func prepareVM() -> IntroductionViewModel{
        IntroductionViewModel(title: "How to use", body: """
Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's.
Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's.
""")
    }
}

extension IntroductionViewController: IntroductionViewDelegate {
    func didPressContinue() {
        let scanVC = ScanViewController(type: .signature)
        self.navigationController?.pushViewController(scanVC, animated: true)
    }
}
