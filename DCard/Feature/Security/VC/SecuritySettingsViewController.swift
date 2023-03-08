//
//  SecuritySettingsViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/20.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class SecuritySettingsViewController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = R.string.localizable.securitySettingsTitle()
        }
    }
    
    @IBOutlet weak var subtitleLabel: UILabel! {
        didSet {
            subtitleLabel.text = R.string.localizable.securitySettingsSubTitle()
        }
    }
    
    @IBOutlet weak var infoLabel: UILabel! {
        didSet {
            infoLabel.text = R.string.localizable.securitySettingsInfo()
        }
    }
    
    @IBOutlet weak var securityCollectionView: UICollectionView! {
        didSet {
            securityCollectionView.collectionViewLayout = flowLayout
        }
    }
    
    @IBOutlet weak var changePasswordLabel: UILabel! {
        didSet {
            changePasswordLabel.text = R.string.localizable.securitySettingsChangePassword()
        }
    }
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.itemSize = CGSize(width: (SCREENWIDTH-32-12)*0.5, height: 130)
        return layout
    }()
    
    private lazy var datasource: [SecurityCollectionViewCellModel] = {
        let bioStatus = LocalAuthenManager.shared.isBind && !(LockScreenManager.shared.password?.isEmpty ?? true)
        let bioIcon = bioStatus ? R.image.iconBiometrics() : R.image.iconBiometricsNotActivated()
        let bioItem = SecurityCollectionViewCellModel(icon: bioIcon,
                                                      title: R.string.localizable.securitySettingsQuickUnlock(),
                                                      status: bioStatus)
        
        return [bioItem]
    }()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestStatusData()
        updateQuickUnlock()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT + 26)
        }
        securityCollectionView.fw.registerCellNib(SecurityCollectionViewCell.self)
    }
    
    private func updateQuickUnlock() {
        var unlockData = datasource.first
        if LocalAuthenManager.shared.isBind || !(LockScreenManager.shared.password?.isEmpty ?? true) {
            unlockData?.status = true
            unlockData?.icon = R.image.iconBiometrics()
        } else {
            unlockData?.status = false
            unlockData?.icon = R.image.iconBiometricsNotActivated()
        }
        if let data = unlockData {
            datasource[0] = data
        }
        securityCollectionView.reloadData()
    }
    
    private func updateAuthStatus() {
        var authData = datasource[1]
        if LockScreenManager.shared.isOn {
            authData.status = true
            authData.icon = R.image.iconSecurityGa()
        } else {
            authData.status = false
            authData.icon = R.image.iconBiometricsNotActivated()
        }
        datasource[1] = authData
        securityCollectionView.reloadData()
    }
    
    private func handleSecurityData(_ data: SecurityStatusModel?) {
        if let data = data {
            LockScreenManager.shared.isOn = data.twoFa?.status ?? false
            let authStatus = data.twoFa?.status ?? false
            let authIcon = authStatus ? R.image.iconSecurityGa() : R.image.iconSecurityGaNotActivated()
            let authItem = SecurityCollectionViewCellModel(icon: authIcon,
                                                           title: R.string.localizable.securitySettingsAuth(),
                                                           status: authStatus)
            datasource.append(authItem)
            let emailStatus = data.email?.status ?? false
            let emailIcon = emailStatus ? R.image.iconSecurityEmail() : R.image.iconSecurityEmailNotActivated()
            let emailTitle = "\(R.string.localizable.securitySettingsEmail()) \(data.email?.value ?? "")"
            let emailItem = SecurityCollectionViewCellModel(icon: emailIcon,
                                                            title: emailTitle,
                                                            status: emailStatus)
            datasource.append(emailItem)
            let smsStatus = data.phone?.status ?? false
            let smsIcon = smsStatus ? R.image.iconSecuritySms() : R.image.iconSecuritySmsNotActivated()
            let smsTitle = "\(R.string.localizable.securitySettingsSms()) \(data.phone?.value ?? "")"
            let smsItem = SecurityCollectionViewCellModel(icon: smsIcon,
                                                          title: smsTitle,
                                                          status: smsStatus,
                                                          isAccess: false)
            datasource.append(smsItem)
            securityCollectionView.reloadData()
        } else {
            //...
        }
    }
    
    // MARK: - Network
    
    private func requestStatusData() {
        indicator.startAnimating()
        UserRequest.securityStatus { [weak self] isSuccess, message, data in
            guard let this = self else { return }
            this.indicator.stopAnimating()
            if isSuccess {
                this.handleSecurityData(data)
            } else {
                this.view.makeToast(message, position: .center)
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func changePasswordAction(_ sender: Any) {
        let vc = ChangePasswordViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension SecuritySettingsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.fw.dequeue(cellType: SecurityCollectionViewCell.self, for: indexPath)
        let data = datasource[indexPath.row]
        cell.update(data: data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = QuickUnlockViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.row == 1 {
            let vc = AuthSettingViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.row == 2 {
            let vc = AuthEmailViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
