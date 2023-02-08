//
//  TransactionsFilterBoardView.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/8.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class TransactionsFilterBoardView: UIView, NibLoadable {
    
    @IBOutlet weak var contentView: UIView! {
        didSet {
            let bgLayer = CAGradientLayer()
            bgLayer.colors = [R.color.fw008999()!.cgColor,
                              R.color.fw004396()!.cgColor]
            bgLayer.locations = [0, 1]
            bgLayer.frame = contentView.bounds
            bgLayer.startPoint = .zero
            bgLayer.endPoint = CGPoint(x: 0.79, y: 0.79)
            bgLayer.opacity = 1
            contentView.layer.insertSublayer(bgLayer, at: 0)
        }
    }
    
}
