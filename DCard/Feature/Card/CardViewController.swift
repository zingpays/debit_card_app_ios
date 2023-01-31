//
//  CardViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/29.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class CardViewController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardContentView: UIView!
    @IBOutlet weak var cardContentShadowView: UIView!
    @IBOutlet weak var applyCardLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    override func setupNavBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserManager.shared.isExpireToken() {
            UIApplication.shared.keyWindow()?.rootViewController = nil
            let vc = LoginViewController()
            let loginNavVC = UINavigationController(rootViewController: vc)
            UIApplication.shared.keyWindow()?.rootViewController = loginNavVC
        } else {
            if !LocalAuthenManager.shared.isAuthorized {
                let lockScreenVC = BiometricsViewController()
                let navVC = UINavigationController(rootViewController: lockScreenVC)
                navVC.modalPresentationStyle = .fullScreen
                self.present(navVC, animated: false)
            }
        }
    }
    
    // MARK: - Private
    
    private func setupUI() {
        titleLabel.font = UIFont.fw.font20(weight: .bold)
        cardContentView.layer.masksToBounds = true
        cardContentShadowView.layer.masksToBounds = false
        cardContentShadowView.layer.shadowColor = R.color.fw005960()?.withAlphaComponent(0.16).cgColor
        let bgLayer = CAGradientLayer()
        bgLayer.colors = [R.color.fw00C0B3()!.cgColor,
                          R.color.fw095CAB()!.cgColor]
        bgLayer.locations = [0, 1]
        bgLayer.frame = cardView.bounds
        bgLayer.startPoint = .zero
        bgLayer.endPoint = CGPoint(x: 0.79, y: 0.79)
        cardView.layer.insertSublayer(bgLayer, at: 0)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = .init(origin: .zero,
                                size: .init(width: cardView.width, height: cardView.height))
        maskLayer.path = UIBezierPath(roundedRect: .init(origin: .zero, size: maskLayer.frame.size),
                                      byRoundingCorners: [.topLeft, .topRight],
                                      cornerRadii: .init(width: 20, height: 20)).cgPath
        cardView.layer.mask = maskLayer
        applyCardLabel.textColor = R.color.fwFFFFFF()?.withAlphaComponent(0.4)
    }
    
    private func setupData() {
        
    }
    
    // MARK: - Action
    
    @IBAction func addCardAction(_ sender: Any) {
        
    }
    
}
