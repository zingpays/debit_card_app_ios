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
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        view.backgroundColor = .white
        setupGradientBackground()
        setupRightItem()
        
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
    
    private func setupRightItem() {
        self.gk_navLeftBarButtonItem = nil
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
