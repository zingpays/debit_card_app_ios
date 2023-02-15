//
//  StartExperienceViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/9.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class RegisterSuccessViewController: BaseViewController {
    
    @IBOutlet weak var toVerifyPhoneNumber: UIButton! {
        didSet {
            toVerifyPhoneNumber.setTitle(R.string.localizable.toVerifyPhoneNumber(), for: .normal)
        }
    }
    
    @IBOutlet weak var registerSuccessLabel: UILabel! {
        didSet {
            registerSuccessLabel.text = R.string.localizable.registerSuccessTips()
        }
    }
    @IBOutlet weak var toVerifyPhoneTipsLabel: UILabel! {
        didSet {
            toVerifyPhoneTipsLabel.text = R.string.localizable.toVerifyPhoneNumberTips()
        }
    }
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    // MARK: - Private
    
    private func setupUI() {
        setupNavBar()
    }
    
    internal override func setupNavBar() {
        super.setupNavBar()
        self.gk_navLineHidden = false
        self.gk_navLeftBarButtonItem = nil
    }
    
    // MARK: - Action
    
    @IBAction func toVerifyPhoneNumber(_ sender: Any) {
        let vc = BindPhoneViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
