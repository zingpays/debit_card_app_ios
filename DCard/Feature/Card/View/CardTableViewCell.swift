//
//  CardTableViewCell.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/3.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class CardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cardContentView: UIView!
    @IBOutlet weak var cardContentShadowView: UIView!
    @IBOutlet weak var cardNumLabel: UILabel!
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var cvcLabel: UILabel!
    @IBOutlet weak var cardHolderLabel: UILabel!
    @IBOutlet weak var vaildityPeriodLabel: UILabel!
    @IBOutlet weak var cvcNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupSubviews()
    }
    
    // MARK: - Private
    
    private func setupSubviews() {
        cardContentView.layer.masksToBounds = true
        cardContentShadowView.layer.masksToBounds = false
        cardContentShadowView.layer.shadowColor = R.color.fw005960()?.withAlphaComponent(0.16).cgColor
        let bgLayer = CAGradientLayer()
        bgLayer.colors = [R.color.fw00C0B3()!.cgColor,
                          R.color.fw095CAB()!.cgColor]
        bgLayer.locations = [0, 1]
        bgLayer.frame = CGRect(origin: .zero, size: CGSize(width: SCREENWIDTH-32, height: 210))
        bgLayer.startPoint = .zero
        bgLayer.cornerRadius = 20
        bgLayer.endPoint = CGPoint(x: 0.79, y: 0.79)
        cardContentView.layer.insertSublayer(bgLayer, at: 0)
        cardHolderLabel.text = R.string.localizable.cardHolder()
        vaildityPeriodLabel.text = R.string.localizable.validityPeriod()
    }
    
    @IBAction func copyCardNameAction(_ sender: Any) {
        UIApplication.shared.keyWindow()?.makeToast(R.string.localizable.copySuccessfully(), position: .center)
        UIPasteboard.general.string = cardNameLabel.text
    }
    
    @IBAction func copyCardNumAction(_ sender: Any) {
        UIApplication.shared.keyWindow()?.makeToast(R.string.localizable.copySuccessfully(), position: .center)
        UIPasteboard.general.string = cardNumLabel.text
    }
    
    @IBAction func periodCopyAction(_ sender: Any) {
        UIApplication.shared.keyWindow()?.makeToast(R.string.localizable.copySuccessfully(), position: .center)
        UIPasteboard.general.string = periodLabel.text
    }
    
    @IBAction func cvcCopyAction(_ sender: Any) {
        UIApplication.shared.keyWindow()?.makeToast(R.string.localizable.copySuccessfully(), position: .center)
        UIPasteboard.general.string = cvcLabel.text
    }
    
    func update(data: CardModel) {
        cardNameLabel.text = data.cardName
        cardNumLabel.text = data.cardNumber
        periodLabel.text = data.expireDate
        cvcLabel.text = data.cardCvc
    }
    
}
