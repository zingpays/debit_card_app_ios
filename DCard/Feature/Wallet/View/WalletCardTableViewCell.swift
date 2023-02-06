//
//  WalletCardTableViewCell.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/3.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class WalletCardTableViewCell: UITableViewCell {

    @IBOutlet weak var cardContentView: UIView!
    @IBOutlet weak var cardContentShadowView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var actionView: UIView!
    @IBOutlet weak var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupSubviews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupSubviews() {
        cardContentView.layer.masksToBounds = true
        cardContentShadowView.layer.masksToBounds = false
        cardContentShadowView.layer.shadowColor = R.color.fw005960()?.withAlphaComponent(0.16).cgColor
        let bgLayer = CAGradientLayer()
        bgLayer.colors = [R.color.fw00C0B3()!.cgColor,
                          R.color.fw095CAB()!.cgColor]
        bgLayer.locations = [0, 1]
        bgLayer.frame = CGRect(origin: .zero, size: CGSize(width: SCREENWIDTH-64, height: 176))
        bgLayer.startPoint = .zero
        bgLayer.endPoint = CGPoint(x: 0.79, y: 0.79)
        cardView.layer.insertSublayer(bgLayer, at: 0)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = .init(origin: .zero,
                                size: .init(width: SCREENWIDTH-64, height: 176))
        maskLayer.path = UIBezierPath(roundedRect: .init(origin: .zero, size: maskLayer.frame.size),
                                      byRoundingCorners: [.topLeft, .topRight],
                                      cornerRadii: .init(width: 20, height: 20)).cgPath
        cardView.layer.mask = maskLayer
        actionView.layer.shadowColor = R.color.fw001214()?.withAlphaComponent(0.2).cgColor
        tagLabel.backgroundColor = R.color.fwF5F5F7()?.withAlphaComponent(0.2)
        tagLabel.textColor = R.color.fwFFFFFF()?.withAlphaComponent(0.7)
    }
    
    
}
