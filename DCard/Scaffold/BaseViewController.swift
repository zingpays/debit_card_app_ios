//
//  BaseViewController.swift
//  Flashwire
//
//  Created by Fei Zhang on 2022/12/13.
//  Copyright © 2022 Zing Tech. All rights reserved.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    /// Loading indicator
    let indicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private
    private func setupUI() {
        view.addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
