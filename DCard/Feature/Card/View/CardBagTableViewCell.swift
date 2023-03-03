//
//  CardBagTableViewCell.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/1.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

protocol CardBagTableViewCellDelegate: NSObject {
    func didSelectedCashbackInfo(_ cell: CardBagTableViewCell)
    func didSelectedTransitInfo(_ cell: CardBagTableViewCell)
    func didSelectedDeposit(_ cell: CardBagTableViewCell)
    func didSelectedStatement(_ cell: CardBagTableViewCell)
    func didSelectedCardDetail(_ cell: CardBagTableViewCell)
}

class CardBagTableViewCell: UITableViewCell {

    @IBOutlet weak var cardContentView: UIView!
    @IBOutlet weak var cardContentShadowView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cashbackView: UIView!
    @IBOutlet weak var transitView: UIView!
    weak var delegate: CardBagTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupSubviews()
    }

    static func height() -> CGFloat {
        return 282 + 10
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
    }
    
    @IBAction func cashbackInfoAction(_ sender: Any) {
        delegate?.didSelectedCashbackInfo(self)
    }
    
    @IBAction func transitInfoAction(_ sender: Any) {
        delegate?.didSelectedTransitInfo(self)
    }
    
    @IBAction func depositAction(_ sender: Any) {
        delegate?.didSelectedDeposit(self)
    }
    
    @IBAction func statementAction(_ sender: Any) {
        delegate?.didSelectedStatement(self)
    }
    
    @IBAction func cardDetailAction(_ sender: Any) {
        delegate?.didSelectedCardDetail(self)
    }
    
}
