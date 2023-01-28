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
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Gesture Login"
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
        btn.setTitle("Password Login", for: .normal)
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
        setupGradientBackground()
        self.gk_navLeftBarButtonItem = nil
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(98)
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
            options.outerStrokeColor = R.color.fw00A8BB() ?? .white
            options.innerSelectedColor = R.color.fw00A8BB() ?? .white
            options.innerNormalColor = .red
            options.outerNormalColor = R.color.fw007481()?.withAlphaComponent(0.1) ?? .white
            options.outerSelectedColor = R.color.fwD3E9F0() ?? .white
            options.connectLineStart = .border
            options.normalstyle = .outerStroke
            options.isDrawTriangle = false
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
        
        view.addSubview(loginStatckView)
        
        loginStatckView.addArrangedSubview(passwordButton)
        passwordButton.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(160)
        }
        
        var statckViewWidth = 160
        if LocalAuthenManager.shared.isBind {
            statckViewWidth += 100
            loginStatckView.addArrangedSubview(biometricsButton)
            biometricsButton.snp.makeConstraints { make in
                make.height.equalTo(30)
                make.width.equalTo(100)
            }
        }
        
        loginStatckView.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(statckViewWidth)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-(24+TOUCHBARHEIGHT))
        }
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
    
    private func setupData() {
        guard LocalAuthenManager.shared.isBind && LocalAuthenManager.shared.isAvailable else {
            return
        }
        if LocalAuthenManager.shared.type == .faceID {
            biometricsButton.setTitle("Face ID", for: .normal)
        }
        if LocalAuthenManager.shared.type == .touchID {
            biometricsButton.setTitle("Touch ID", for: .normal)
        }
    }
    
    // MARK: - Actions
    
    @objc private func passwordLogin() {
        let vc = PasswordLoginViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func biometricsLogin() {
        // TODO: - 待定
    }

}

// MARK: - GPasswordEventDelegate

extension NineGraphLockScreenViewController: GPasswordEventDelegate {
    func sendTouchPoint(with tag: String) {
        print(tag)
    }
    
    func touchesEnded() {
        UIApplication.shared.keyWindow()?.makeToast("解锁成功", duration: 0.5, position: .top)
        navigationController?.topViewController?.dismiss(animated: false)
    }
    
}
