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
        setupNavBar()
    }
    
    internal override func setupNavBar() {
        super.setupNavBar()
        self.gk_navLineHidden = false
        self.gk_navLeftBarButtonItem = nil
    }
    
    // MARK: - Action
    
    @IBAction func startExperience(_ sender: Any) {
        let expireDate: Date = Date(timeIntervalSinceNow: 60*60*24*7)
        // save user token
        UserManager.shared.saveToken("test", expireDate: expireDate)
        // change application root viewController to tabbar viewController
        UIApplication.shared.keyWindow()?.rootViewController = nil
        UIApplication.shared.keyWindow()?.rootViewController = TabBarController()
    }
    
}
