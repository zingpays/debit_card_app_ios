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
    
    @IBOutlet weak var rightArrowImageView: UIImageView!
    @IBOutlet weak var changeButton: UIButton! {
        didSet {
            changeButton.setTitle(R.string.localizable.quickUnlockChange(), for: .normal)
        }
    }
    
    @IBOutlet weak var line: UIView!
    
    @IBOutlet weak var bioSwitch: UISwitch! {
        didSet {
            bioSwitch.isOn = LocalAuthenManager.shared.isBind
        }
    }
    
    @IBOutlet weak var patternSwitch: UISwitch!
    @IBOutlet weak var patternLabel: UILabel! {
        didSet {
            patternLabel.text = R.string.localizable.quickUnlockPattern()
        }
    }
    
    @IBOutlet weak var patternHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updatePattern()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private
    
    private func setupUI() {
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT + 26)
        }
        line.backgroundColor = R.color.fw000000()?.withAlphaComponent(0.05)
    }
    
    private func updatePattern() {
        if LockScreenManager.shared.password?.count ?? 0 > 0 {
            patternHeightConstraint.constant = 100
            patternSwitch.isOn = true
            rightArrowImageView.isHidden = false
            changeButton.isHidden = false
        } else {
            patternHeightConstraint.constant = 55
            patternSwitch.isOn = false
            rightArrowImageView.isHidden = true
            changeButton.isHidden = true
        }
    }
    
    // MARK: - Actions
    
    @IBAction func patternChangeAction(_ sender: Any) {
        let vc = NineGraphLockScreenViewController()
        vc.style = .change
        vc.patternTitle = R.string.localizable.patternChange()
        vc.tips = R.string.localizable.patternChangeTips()
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
    
    @IBAction func patternSwitchAction(_ sender: UIButton) {
        if patternSwitch.isOn {
            LockScreenManager.shared.password  = nil
            patternSwitch.isOn = false
            patternHeightConstraint.constant = 55
            rightArrowImageView.isHidden = true
            changeButton.isHidden = true
        } else {
            let vc = NineGraphLockScreenViewController()
            vc.style = .set
            vc.patternTitle = R.string.localizable.patternSet()
            vc.tips = R.string.localizable.patternSetTips()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
