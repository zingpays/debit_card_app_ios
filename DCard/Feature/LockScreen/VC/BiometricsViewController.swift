//
//  BiometricsViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/19.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class BiometricsViewController: BaseViewController {
    var source: LockScreenSource = .none
    /// 是否有存在切换其他方式的按钮
    var isHasChangeToOtherLoginMethod: Bool = false

    private lazy var loginStatckView: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.spacing = 12
        v.alignment = .center
        return v
    }()
    
    private lazy var gestureButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = R.color.fw00A8BB()?.withAlphaComponent(0.1)
        btn.setTitle(R.string.localizable.patternLogin(), for: .normal)
        btn.titleLabel?.font = UIFont.fw.font16()
        btn.setTitleColor(R.color.fw00A8BB(), for: .normal)
        btn.layer.cornerRadius = 15
        btn.addTarget(self, action: #selector(gestureLogin), for: .touchUpInside)
        return btn
    }()
    
    private lazy var passwordButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = R.color.fw00A8BB()?.withAlphaComponent(0.1)
        btn.setTitle(R.string.localizable.passwordLogin(), for: .normal)
        btn.titleLabel?.font = UIFont.fw.font16()
        btn.setTitleColor(R.color.fw00A8BB(), for: .normal)
        btn.layer.cornerRadius = 15
        btn.addTarget(self, action: #selector(passwordLogin), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startAuth()
        if source == .none {
            setupNotification()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private
    
    private func setupUI() {
        self.gk_navLeftBarButtonItem = nil
        if isHasChangeToOtherLoginMethod {
            view.addSubview(loginStatckView)
            loginStatckView.addArrangedSubview(gestureButton)
            gestureButton.snp.makeConstraints { make in
                make.height.equalTo(30)
                make.width.equalTo(120)
            }
            var statckViewWidth = 120 + 12
            if LocalAuthenManager.shared.isBind {
                statckViewWidth += 120
                loginStatckView.addArrangedSubview(passwordButton)
                passwordButton.snp.makeConstraints { make in
                    make.height.equalTo(30)
                    make.width.equalTo(120)
                }
            }
            loginStatckView.snp.remakeConstraints { make in
                make.height.equalTo(30)
                make.width.equalTo(statckViewWidth)
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(-(24+TOUCHBARHEIGHT))
            }
        }
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(screenUnlockSuccess),
                                               name: Notification.Name(UNLOCKSUCCESS),
                                               object: nil)
    }
    
    private func startAuth() {
        if LocalAuthenManager.shared.isAvailable {
            LocalAuthenManager.shared.evaluate { isSuccess, errCode in
                if isSuccess {
                    LocalAuthenManager.shared.isAuthorized = true
                    if self.source != .none {
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: NSNotification.Name(UNLOCKSUCCESS), object: nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.dismiss(animated: false)
                        }
                    }
                    
                } else {
                    DLog.info(errCode)
                }
            }
        } else {
            DLog.info(LocalAuthenManager.shared.errorCode)
        }
    }
    
    // MARK: - Actions
    
    @objc private func screenUnlockSuccess() {
        self.dismiss(animated: true)
    }
    
    @objc private func gestureLogin() {
        switch source {
        case .pattern:
            navigationController?.popViewController()
        case .biometrics:
            break
        case .password, .none:
            let vc = NineGraphLockScreenViewController()
            vc.source = .password
            vc.isHasChangeToOtherLoginMethod = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc private func passwordLogin() {
        switch source {
        case .password:
            navigationController?.popViewController()
        case .biometrics:
            break
        case .pattern, .none:
            let vc = PasswordLoginViewController()
            vc.source = .password
            vc.isHasChangeToOtherLoginMethod = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}
