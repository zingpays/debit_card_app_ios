//
//  VerifyYourIdentityGuideViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/28.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class VerifyYourIdentityGuideViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        self.gk_navLeftBarButtonItem = nil
    }

    // MARK: - Actions
    
    @IBAction func verifyNowAction(_ sender: Any) {
        let vc = KYCFillInNameAndNationalViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
