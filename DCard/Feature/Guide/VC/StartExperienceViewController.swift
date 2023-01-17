//
//  StartExperienceViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/9.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class StartExperienceViewController: BaseViewController {

    // MARK: - Init
    
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
        bgLayer.colors = [R.color.fw008999()!.cgColor,
                          R.color.fw004396()!.cgColor]
        bgLayer.locations = [0, 1]
        bgLayer.frame = UIScreen.main.bounds
        bgLayer.startPoint = .zero
        bgLayer.endPoint = CGPoint(x: 0.79, y: 0.79)
        bgLayer.opacity = 0.1
        view.layer.insertSublayer(bgLayer, at: 0)
    }
    
    internal override func setupNavBar() {
        super.setupNavBar()
        self.gk_navLineHidden = false
        self.gk_navLeftBarButtonItem = nil
    }
    
    // MARK: - Action
    
    @IBAction func startExperience(_ sender: Any) {
        // TODO: - go to home page
    }
    
}
