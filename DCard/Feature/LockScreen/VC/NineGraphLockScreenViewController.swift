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

class NineGraphLockScreenViewController: UIViewController {

    // MARK: - Properies
    
    private lazy var passwordBox: Box = {
        let box = Box(frame: CGRect(x: 50, y: 200, width: UIScreen.main.bounds.width - 2 * 50, height: 400))
        box.delegate = self
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
        GPassword.config { (options) in
            options.connectLineColor = .blue
            options.outerStrokeColor = .blue
            options.innerSelectedColor = .systemPink
            options.connectLineStart = .border
            options.normalstyle = .outerStroke
            options.isDrawTriangle = false
            options.connectLineWidth = 4
            options.matrixNum = 3
            options.keySuffix = "dcard"
        }
        view.addSubview(passwordBox)
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
