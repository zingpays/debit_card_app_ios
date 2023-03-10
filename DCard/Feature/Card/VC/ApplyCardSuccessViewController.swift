//
//  ApplyCardSuccessViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/1.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class ApplyCardSuccessViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = R.string.localizable.applyCardSuccessTitle()
        subtitleLabel.text = R.string.localizable.applyCardSuccessSubTitle()
        finishButton.setTitle(R.string.localizable.applyCardSuccessFinish(), for: .normal)
    }
    
    override func setupNavBar() {}

    @IBAction func applyCardSuccessAction(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(APPLYCARDSUCCESS), object: nil)
        navigationController?.popToRootViewController(animated: true)
    }
}
