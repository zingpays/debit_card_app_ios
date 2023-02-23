//
//  BaseViewController.swift
//  Flashwire
//
//  Created by Fei Zhang on 2022/12/13.
//  Copyright © 2022 Zing Tech. All rights reserved.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    /// Loading indicator
    let indicator = UIActivityIndicatorView(style: .large)
    /// Back item
    private lazy var backItem: UIBarButtonItem = {
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 4, width: 36, height: 36)
        btn.backgroundColor = ISNOTCH() ? .white : .clear
        btn.layer.cornerRadius = 12
        btn.setImage(R.image.iconBack(), for: .normal)
        btn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        return UIBarButtonItem(customView: btn)
    }()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        setupGradientBackground()
        setupNavBar()
        view.addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func setupNavBar() {
        self.gk_navTitleColor = R.color.fw001214()
        self.gk_navTitleFont = UIFont.fw.font18(weight: .bold)
        self.gk_navBackgroundColor = .clear
        self.gk_navLineHidden = false
        self.gk_navLeftBarButtonItem = backItem
        self.gk_navItemLeftSpace = ISNOTCH() ? 16 : 4
    }
    
    func textFiledLeftView() -> UIView {
        return UIView(frame: CGRect(origin: .zero,
                                    size: CGSize(width: 16, height: 50)))
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
    
    // MARK: - Actions
    
    @objc private func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}
