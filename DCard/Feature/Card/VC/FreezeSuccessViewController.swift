//
//  FreezeSuccessViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/3.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class FreezeSuccessViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func setupNavBar() {}
    
    @IBAction func doneAction(_ sender: Any) {
        navigationController?.popViewController()
    }
}
