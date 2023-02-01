//
//  ApplyCardViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/1.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class ApplyCardViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT + 26)
        }
        
    }

    // MARK: - Actions
    
    @IBAction func continueAction(_ sender: Any) {
        
    }
    
}
