//
//  ApplyCardSuccessViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/1.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class ApplyCardSuccessViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupNavBar() {}

    @IBAction func applyCardSuccessAction(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(APPLYCARDSUCCESS), object: nil)
        navigationController?.popToRootViewController(animated: true)
    }
}
