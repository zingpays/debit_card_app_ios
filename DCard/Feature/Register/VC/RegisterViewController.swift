//
//  RegisterViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/10.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        setupGradientBackground()
    }
    
    private func setupGradientBackground() {
        let bgLayer = CAGradientLayer()
        bgLayer.colors = [R.color.color008999()!.cgColor,
                          R.color.color004396()!.cgColor]
        bgLayer.locations = [0, 1]
        bgLayer.frame = UIScreen.main.bounds
        bgLayer.startPoint = .zero
        bgLayer.endPoint = CGPoint(x: 0.79, y: 0.79)
        bgLayer.opacity = 0.3
        view.layer.insertSublayer(bgLayer, at: 0)
    }

}
