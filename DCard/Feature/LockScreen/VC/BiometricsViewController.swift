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
    /// 是否是引导用户设置
    var isGuide: Bool = false
    
    @IBOutlet weak var iconButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var guideTitleLabel: UILabel!
    @IBOutlet weak var guideSubtitleLabel: UILabel!
    
    @IBOutlet weak var guideTipsButton: UIButton! {
        didSet {
            guideTipsButton.setImage(R.image.iconCheckBoxOff(), for: .normal)
            guideTipsButton.setImage(R.image.iconCheckBoxOn(), for: .selected)
            guideTipsButton.isHidden = !self.isGuide
        }
    }
    @IBOutlet weak var guideTipsLabel: UILabel! {
        didSet {
            guideTipsLabel.textColor = R.color.fw000000()?.withAlphaComponent(0.5)
            guideTipsLabel.isHidden = !self.isGuide
        }
    }
    
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
    
    private lazy var rightItem: UIBarButtonItem = {
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 4, width: 36, height: 36)
        btn.setTitle(R.string.localizable.skip(), for: .normal)
        btn.backgroundColor = .clear
        btn.setTitleColor(R.color.fw00A8BB(), for: .normal)
        btn.addTarget(self, action: #selector(skipAction), for: .touchUpInside)
        return UIBarButtonItem(customView: btn)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if !isGuide {
            startAuth()
        } else {
            gk_navItemRightSpace = 16
            gk_navRightBarButtonItem = rightItem
        }
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
        let image = LocalAuthenManager.shared.type == .faceID ? R.image.iconFaceid() : R.image.iconTouchid()
        iconButton.setImage(image, for: .normal)
        let title: String = {
            if isGuide {
                return LocalAuthenManager.shared.type == .faceID ? R.string.localizable.clickToFaceIdTips() :  R.string.localizable.clickToTouchIdTips()
            } else {
                return LocalAuthenManager.shared.type == .faceID ? R.string.localizable.faceIdLogin() :  R.string.localizable.touchIdLogin()
            }
        }()
        let subtitle = LocalAuthenManager.shared.type == .faceID ? R.string.localizable.faceIDLoginSubTitle() :  R.string.localizable.touchIDLoginSubTitle()
        titleLabel.text = title
        subTitleLabel.text = subtitle
        guideTitleLabel.isHidden = !isGuide
        guideSubtitleLabel.isHidden = !isGuide
        titleLabel.isHidden = isGuide
        subTitleLabel.textColor = isGuide ? R.color.fw00A8BB() : R.color.fw001214()
        guideTitleLabel.text = LocalAuthenManager.shared.type == .faceID ? R.string.localizable.guideFaceIDTitle() : R.string.localizable.guideTouchIDTitle()
        guideSubtitleLabel.text = LocalAuthenManager.shared.type == .faceID ? R.string.localizable.guideFaceIDSubTitle() : R.string.localizable.guideTouchIDSubTitle()
        guideTipsLabel.text = R.string.localizable.guideDonotRemindAgain()
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
                    LocalAuthenManager.shared.isBind = true
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
    
    @IBAction func againFaceId(_ sender: Any) {
        startAuth()
    }
    
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
    
    @objc private func skipAction() {
        LocalAuthenManager.shared.isSkiped = true
        self.dismiss(animated: true)
    }

    @IBAction func remindCheckAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let color = sender.isSelected ? R.color.fw00A8BB() : R.color.fw000000()?.withAlphaComponent(0.5)
        guideTipsLabel.textColor = color
    }
    
}
