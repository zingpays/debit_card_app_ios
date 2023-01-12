//
//  BindPhoneViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/12.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class BindPhoneViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var phoneInputView: UIView!
    @IBOutlet weak var infoLabell: UILabel!
    @IBOutlet weak var phoneRegionLabel: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Private
    
    private func setupUI() {
        setupGradientBackground()
        setupSubviews()
    }
    
    private func setupGradientBackground() {
        let bgLayer = CAGradientLayer()
        bgLayer.colors = [R.color.fw008999()!.cgColor,
                          R.color.fw004396()!.cgColor]
        bgLayer.locations = [0, 1]
        bgLayer.frame = UIScreen.main.bounds
        bgLayer.startPoint = .zero
        bgLayer.endPoint = CGPoint(x: 0.79, y: 0.79)
        bgLayer.opacity = 0.1
        view.layer.insertSublayer(bgLayer, at: 0)
    }
    
    private func setupSubviews() {
        titleLabel.font = UIFont.fw.font28(weight: .bold)
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT + 26)
        }
        subTitleLabel.font = UIFont.fw.font16()
        infoLabell.font = .fw.font14()
        phoneTextField.addTarget(self, action: #selector(phoneNumValueChangeAction), for: .editingChanged)
        phoneTextField.becomeFirstResponder()
    }
    
    @objc private func phoneNumValueChangeAction() {
        if let text = phoneTextField.text, !text.isEmpty {
            sendButton.alpha = 1
        } else {
            sendButton.alpha = 0.4
        }
    }
    
    // MARK: - Actions
    
    @IBAction func selectPhoneRegionAction(_ sender: Any) {
        phoneTextField.resignFirstResponder()
        let vc = ChooseRegionViewController()
        vc.didSelectedCompletion = { code in
            self.phoneRegionLabel.text = code
        }
        self.present(vc, animated: true)
    }
    
    @IBAction func sendVerifyCode(_ sender: Any) {
        
    }
    
}
