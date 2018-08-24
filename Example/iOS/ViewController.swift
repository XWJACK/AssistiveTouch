//
//  ViewController.swift
//  iOS
//
//  Created by Jack on 04/07/2017.
//  Copyright © 2017 XWJACK. All rights reserved.
//

import UIKit
import AssistiveTouch

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .red
        AssistiveTouch.default.show()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

