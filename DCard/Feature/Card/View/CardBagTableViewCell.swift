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
    @IBOutlet weak var transitView: UIView!
    @IBOutlet weak var cardTitleLabel: UILabel!
    @IBOutlet weak var fundsInTransitLabel: UILabel!
    @IBOutlet weak var fundsInTransitValueLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var balanceTitleLabel: UILabel!
    @IBOutlet weak var depositItemLabel: UILabel!
    @IBOutlet weak var statementItemLabel: UILabel!
    @IBOutlet weak var cardDetailItemLabel: UILabel!
    
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
        transitView.backgroundColor = R.color.fwFAFAFA()?.withAlphaComponent(0.1)
        let transitMaskLayer = CAShapeLayer()
        transitMaskLayer.frame = .init(origin: .zero,
                                size: .init(width: SCREENWIDTH-64, height: 36))
        transitMaskLayer.path = UIBezierPath(roundedRect: .init(origin: .zero, size: transitMaskLayer.frame.size),
                                      byRoundingCorners: [.topLeft, .topRight],
                                      cornerRadii: .init(width: 12, height: 12)).cgPath
        transitView.layer.mask = transitMaskLayer
        cardTitleLabel.backgroundColor = R.color.fwFAFAFA()?.withAlphaComponent(0.2)
        let cardTitleLayer = CAShapeLayer()
        cardTitleLayer.frame = .init(origin: .zero,
                                size: .init(width: 140, height: 24))
        cardTitleLayer.path = UIBezierPath(roundedRect: .init(origin: .zero, size: cardTitleLayer.frame.size),
                                      byRoundingCorners: [.bottomRight],
                                      cornerRadii: .init(width: 8, height: 8)).cgPath
        cardTitleLabel.layer.mask = cardTitleLayer
        balanceTitleLabel.text = R.string.localizable.availableBanlance()
        fundsInTransitLabel.text = R.string.localizable.fundsInTransit()
        depositItemLabel.text = R.string.localizable.deposit()
        statementItemLabel.text = R.string.localizable.statemant()
        cardDetailItemLabel.text = R.string.localizable.cardDetail()
    }
    
//    @IBAction func cashbackInfoAction(_ sender: Any) {
//        delegate?.didSelectedCashbackInfo(self)
//    }
    
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
    
    func update(data: CardModel?) {
        guard let data = data else { return }
        cardTitleLabel.text = data.cardName
        if let availableBalance = data.availableBalance {
            balanceLabel.text = "$\(availableBalance)"
        }
        if let transitAmount = data.transitAmount {
            fundsInTransitValueLabel.text = "$\(transitAmount)"
        }
    }
    
}
