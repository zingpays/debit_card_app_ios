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
    
    override func setupNavBar() {}
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        phoneTextField.becomeFirstResponder()
    }

    // MARK: - Private
    
    private func setupUI() {
        setupSubviews()
    }
    
    private func setupSubviews() {
        titleLabel.font = UIFont.fw.font28(weight: .bold)
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT + 26)
        }
        subTitleLabel.font = UIFont.fw.font16()
        infoLabell.font = .fw.font14()
        phoneTextField.addTarget(self, action: #selector(phoneNumValueChangeAction), for: .editingChanged)
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
        let datas = [ChooseRegionModel(title: "China", subTitle: "+86"), ChooseRegionModel(title: "Singpore", subTitle: "+65")]
        vc.pageTitle = "choose your country"
        vc.datasource = datas
        vc.didSelectedCompletion = { data in
            self.phoneRegionLabel.text = data.subTitle
        }
        self.present(vc, animated: true)
    }
    
    @IBAction func sendVerifyCode(_ sender: Any) {
        let vc = VerificationCodeViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
