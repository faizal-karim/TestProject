//
//  ViewController.swift
//  TestProject
//
//  Created by Faizal on 02/06/2022.
//  Copyright (c) 2022 Faizal. All rights reserved.
//

import UIKit
import TestProject

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func kycProcess(_ sender: Any) {
        let kycVC = IntroductionViewController()
        let nav = UINavigationController(rootViewController: kycVC)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
}

