//
//  KYCFinishViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/29.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class KYCFinishViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        titleLabel.font = UIFont.fw.font24(weight: .bold)
        subTitleLabel.font = UIFont.fw.font15(weight: .light)
    }
    
    // MARK: - Actions

    @IBAction func gotItAction(_ sender: Any) {
        
    }
}
