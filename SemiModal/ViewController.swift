//
//  ViewController.swift
//  SemiModal
//
//  Created by kuro on 2020/04/09.
//  Copyright © 2020 shukuro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func secretButtonTap(_ sender: Any) {
        let vc = SemiModalViewController.make()
        present(vc, animated: true)
    }
    
}

