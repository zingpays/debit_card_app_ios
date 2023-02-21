//
//  QuickUnlockViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/20.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class QuickUnlockViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = R.string.localizable.quickUnlockTitle()
        }
    }
    
    @IBOutlet weak var infoLabel: UILabel! {
        didSet {
            infoLabel.text = R.string.localizable.quickUnlockInfo()
        }
    }
    
    @IBOutlet weak var bioIcon: UIImageView! {
        didSet {
            if LocalAuthenManager.shared.type == .faceID {
                bioIcon.image = R.image.iconQuFaceId()
            }
            if LocalAuthenManager.shared.type == .touchID {
                bioIcon.image = R.image.iconQuTouchId()
            }
        }
    }
    
    @IBOutlet weak var bioTitleLabel: UILabel! {
        didSet {
            if LocalAuthenManager.shared.type == .faceID {
                bioTitleLabel.text = R.string.localizable.quickUnlockFaceID()
            }
            if LocalAuthenManager.shared.type == .touchID {
                bioTitleLabel.text = R.string.localizable.quickUnlockTouchID()
            }
        }
    }
    
    @IBOutlet weak var bioSwitch: UISwitch! {
        didSet {
            bioSwitch.isOn = LocalAuthenManager.shared.isBind
        }
    }
    
    @IBOutlet weak var patternLabel: UILabel! {
        didSet {
            patternLabel.text = R.string.localizable.quickUnlockPattern()
        }
    }
    
    @IBOutlet weak var patternContentLabel: UILabel! {
        didSet {
            patternContentLabel.text = R.string.localizable.quickUnlockChange()
            patternContentLabel.isHidden = PatternManager.shared.password?.isEmpty ?? true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private
    
    private func setupUI() {
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT + 26)
        }
    }
    
    private func setupData() {
        setupNotification()
    }

    private func setupNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(patternSetupSuccess),
                                               name: Notification.Name(SETUPPATTERNSUCCESS),
                                               object: nil)
    }
    
    // MARK: - Actions
    
    @objc func patternSetupSuccess() {
        patternContentLabel.isHidden = false
    }
    
    @IBAction func patternAction(_ sender: Any) {
        let vc = NineGraphLockScreenViewController()
        if patternContentLabel.isHidden {
            vc.style = .set
            vc.patternTitle = R.string.localizable.patternSet()
            vc.tips = R.string.localizable.patternSetTips()
        } else {
            vc.style = .change
            vc.patternTitle = R.string.localizable.patternChange()
            vc.tips = R.string.localizable.patternChangeTips()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func bioAction(_ sender: UIButton) {
        if bioSwitch.isOn {
            LocalAuthenManager.shared.isBind = false
            bioSwitch.isOn = false
        } else {
            if LocalAuthenManager.shared.isAvailable {
                LocalAuthenManager.shared.evaluate { isSuccess, errCode in
                    if isSuccess {
                        LocalAuthenManager.shared.isBind = true
                        DispatchQueue.main.async {
                            self.bioSwitch.isOn = true
                        }
                    } else {
                        DLog.info(errCode)
                    }
                }
            } else {
                DLog.info(LocalAuthenManager.shared.errorCode)
            }
        }
    }
    
}
