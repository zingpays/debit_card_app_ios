//
//  SecurityVerificationViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/30.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

enum SecurityVerificationType {
    case all
    case email
    case twofa
    case phone
}

class SecurityVerificationViewController: BaseViewController {

    var style: SecurityVerificationType = .email
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var securityTableView: UITableView!
    
    private var footerView: UIView = {
        let v = UIView()
        v.frame = CGRect(origin: .zero, size: CGSize(width: SCREENWIDTH, height: 56))
        let btn = UIButton()
        v.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.top.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(26)
        }
        btn.layer.cornerRadius = 23
        btn.backgroundColor = R.color.fw00A8BB()
        btn.setTitle(R.string.localizable.submit(), for: .normal)
        return v
    }()
    
    private lazy var emailItem: SecurityVerificationItemModel = {
        let info = LocalizationManager.shared.currentLanguage() == .zh ? "输入6位已经发送到\(UserManager.shared.email ?? "")的验证码" : "Enter the 6-digit code sent to \(UserManager.shared.email ?? "")"
        let item = SecurityVerificationItemModel(title: R.string.localizable.emailVerificationCode(),
                                                      info: info,
                                                      inputPlaceholder: R.string.localizable.emialInputPlaceholder())
        
        return item
    }()
    
    private lazy var phoneNumItem: SecurityVerificationItemModel = {
        let info = LocalizationManager.shared.currentLanguage() == .zh ? "输入6位发送到\(UserManager.shared.phoneNum ?? "")的验证码" : "Enter the 6 digit code sent to \(UserManager.shared.phoneNum ?? "")"
        let item = SecurityVerificationItemModel(title: R.string.localizable.phoneVerificationCode(),
                                                      info: info,
                                                      inputPlaceholder: R.string.localizable.phoneVerificationCodePlaceholder())
        
        return item
    }()
    
    private lazy var authItem: SecurityVerificationItemModel = {
        let item = SecurityVerificationItemModel(title: R.string.localizable.authenticatorCode(),
                                                 info: R.string.localizable.authenticatorCodeInfo(),
                                                 inputPlaceholder: R.string.localizable.authenticatorCodePlaceholder(),
                                                 style: .auth)
        
        return item
    }()
    
    private lazy var datasource: [SecurityVerificationItemModel] = {
        switch style {
        case .all:
            return [emailItem, phoneNumItem, authItem]
        case .email:
            return [emailItem]
        case .twofa:
            return [authItem]
        case .phone:
            return [phoneNumItem]
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }

    // MARK: - Private
    
    private func setupUI() {
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT + 26)
        }
        titleLabel.text = R.string.localizable.securityVerificationTitle()
        securityTableView.fw.registerCellNib(SecurityVerificationItemTableViewCell.self)
        securityTableView.tableFooterView = footerView
    }
    
    private func setupData() {
        if style == .email {
            requestSendEmailCode()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func nextAction(_ sender: Any) {
        if style == .email {
            // TODO: verify email code
        }
        
        if style == .twofa {
            // TODO: verify twofa code
        }
        
        // TODO: other case
//        let vc = SettingNewPasswordViewController()
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Network
    
    private func requestSendEmailCode() {
        // TODO: send email request
    }
    
    private func requestSubmit() {
        // TODO: submit request
    }
    
}

extension SecurityVerificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SecurityVerificationItemTableViewCell.height(style: datasource[indexPath.row].style)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.fw.dequeue(cellType: SecurityVerificationItemTableViewCell.self, for: indexPath)
        cell.upadateData(data: datasource[indexPath.row])
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
    
}

extension SecurityVerificationViewController: SecurityVerificationItemTableViewCellDelegate {
    func didSelectedAuthUnavailable() {
        let alert = UIAlertController(title: R.string.localizable.tips(),
                                      message: R.string.localizable.resetAuthTips(),
                                      preferredStyle: .alert)
        let continuneAction = UIAlertAction(title: R.string.localizable.continue(),
                                            style: .default) { action in
            // TODO: go to reset authenticator
        }
        let cancelAction = UIAlertAction(title: R.string.localizable.cancel(),
                                         style: .cancel)
        alert.addAction(cancelAction)
        alert.addAction(continuneAction)
        self.present(alert, animated: true)
    }
}
