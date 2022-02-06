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

    @IBOutlet var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        image.circleImageView(borderColor: .blue, borderWidth: 2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

