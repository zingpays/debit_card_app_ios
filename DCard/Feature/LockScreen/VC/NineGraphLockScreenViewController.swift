//
//  NineGraphLockScreenViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/5.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit
import GPassword
import Toast_Swift

class NineGraphLockScreenViewController: BaseViewController {
    
    // MARK: - Properies
    
    var source: LockScreenSource = .none
    
    /// 是否有存在切换其他方式的按钮
    var isHasChangeToOtherLoginMethod: Bool = false
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.patternLogin()
        label.font = UIFont.fw.font20(weight: .bold)
        return label
    }()
    
    private lazy var errorTips: UILabel = {
        let label = UILabel()
        label.font = UIFont.fw.font16()
        label.textColor = R.color.fwED4949()
        return label
    }()
    
    private lazy var passwordBox: Box = {
        let box = Box(frame: CGRect(x: 55, y: 200, width: UIScreen.main.bounds.width - 2 * 55, height: 400))
        box.delegate = self
        box.backgroundColor = .clear
        return box
    }()
    
    private lazy var loginStatckView: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.spacing = 12
        v.alignment = .center
        return v
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
    
    private lazy var biometricsButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = R.color.fw00A8BB()?.withAlphaComponent(0.1)
        btn.titleLabel?.font = UIFont.fw.font16()
        btn.setTitleColor(R.color.fw00A8BB(), for: .normal)
        btn.layer.cornerRadius = 15
        btn.addTarget(self, action: #selector(biometricsLogin), for: .touchUpInside)
        if LocalAuthenManager.shared.type == .faceID {
            btn.setTitle(R.string.localizable.faceID(), for: .normal)
        }
        if LocalAuthenManager.shared.type == .touchID {
            btn.setTitle(R.string.localizable.touchID(), for: .normal)
        }
        return btn
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        view.backgroundColor = .white
        self.gk_navLeftBarButtonItem = nil
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(98+STATUSBARHEIGHT)
            make.centerX.equalToSuperview()
            make.height.equalTo(23)
        }
        
        view.addSubview(errorTips)
        errorTips.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(36)
            make.centerX.equalToSuperview()
            make.height.equalTo(19)
        }
        
        GPassword.config { (options) in
            options.connectLineColor = R.color.fw00A8BB() ?? .white
            options.outerStrokeColor = .clear
            options.innerSelectedColor = R.color.fw00A8BB() ?? .white
            options.outerNormalColor = R.color.fw007481()?.withAlphaComponent(0.1) ?? .white
            options.outerSelectedColor = R.color.fwD3E9F0() ?? .white
            options.connectLineStart = .border
            options.normalstyle = .outerStroke
            options.isDrawTriangle = false
            options.isInnerStroke = true
            options.connectLineWidth = 2
            options.matrixNum = 3
            options.keySuffix = "dcard"
        }
        view.addSubview(passwordBox)
        passwordBox.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width - 2 * 55)
            make.height.equalTo(300)
            make.center.equalToSuperview()
        }
        
        if isHasChangeToOtherLoginMethod {
            view.addSubview(loginStatckView)
            
            loginStatckView.addArrangedSubview(passwordButton)
            passwordButton.snp.makeConstraints { make in
                make.height.equalTo(30)
                make.width.equalTo(120)
            }
            
            var statckViewWidth = 120 + 12
            if LocalAuthenManager.shared.isBind {
                statckViewWidth += 120
                loginStatckView.addArrangedSubview(biometricsButton)
                biometricsButton.snp.makeConstraints { make in
                    make.height.equalTo(30)
                    make.width.equalTo(120)
                }
            }
            
            loginStatckView.snp.makeConstraints { make in
                make.height.equalTo(30)
                make.width.equalTo(statckViewWidth)
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(-(24+TOUCHBARHEIGHT))
            }
        }
    }
    
    private func setupData() {
    
    }
    
    // MARK: - Actions
    
    @objc private func passwordLogin() {
        switch source {
        case .password:
            navigationController?.popViewController()
        case .pattern:
            break
        case .biometrics, .none:
            let vc = PasswordLoginViewController()
            vc.source = .pattern
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc private func biometricsLogin() {
        switch source {
        case .biometrics:
            navigationController?.popViewController()
        case .pattern:
            break
        case .password, .none:
            let vc = PasswordLoginViewController()
            vc.source = .pattern
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

// MARK: - GPasswordEventDelegate

extension NineGraphLockScreenViewController: GPasswordEventDelegate {
    func sendTouchPoint(with tag: String) {
        print(tag)
    }
    
    func touchesEnded() {
        LocalAuthenManager.shared.isAuthorized = true
        NotificationCenter.default.post(name: NSNotification.Name(UNLOCKSUCCESS), object: nil)
    }
    
}
