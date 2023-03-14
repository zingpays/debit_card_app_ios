//
//  OpenCardSuccessAlertView.swift
//  DCard
//
//  Created by Fei Zhang on 2023/3/14.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit
import Lottie

class OpenCardSuccessAlertView: UIView, NibLoadable {

    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var lodingView: UIView!
    
    @IBOutlet weak var applyingLabel: UILabel!
    
    @IBOutlet weak var applyTipsLabel: UILabel!
    
    private lazy var animation: LottieAnimationView = {
        let v = LottieAnimationView(name: "card-applying.json")
        v.frame = CGRect(origin: .zero, size: CGSize(width: 80, height: 80))
        v.loopMode = .loop
        return v
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyingLabel.text = R.string.localizable.applying()
        applyTipsLabel.text = R.string.localizable.applyingTips()
        backgroundView.backgroundColor = R.color.fw031315()?.withAlphaComponent(0.5)
        lodingView.addSubview(animation)
        animation.play()
    }
}
