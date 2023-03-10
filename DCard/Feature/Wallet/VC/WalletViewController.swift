//
//  WalletViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/29.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit
import JFPopup

class WalletViewController: BaseViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var walletTableView: UITableView!
    @IBOutlet weak var backgroundView: UIView! {
        didSet {
            let bgLayer = CAGradientLayer()
            bgLayer.colors = [R.color.fw00A8BB()!.cgColor,
                              R.color.fw0E7BFF()!.cgColor]
            bgLayer.locations = [0, 1]
            bgLayer.frame = CGRect(origin: .zero, size: CGSize(width: SCREENWIDTH, height: 370))
            bgLayer.startPoint = .zero
            bgLayer.endPoint = CGPoint(x: 1, y: 1)
            bgLayer.opacity = 0.8
            backgroundView.layer.insertSublayer(bgLayer, at: 0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func setupNavBar() {
        self.gk_navigationBar.isHidden = true
    }
    
    // MARK: - Private
    
    private func setupUI() {
        titleLabel.font = UIFont.fw.font20(weight: .bold)
        walletTableView.fw.registerCellNib(WalletCardTableViewCell.self)
        walletTableView.fw.registerCellNib(WalletCryptoTableViewCell.self)
    }
    
}

extension WalletViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 200
        }
        return 83*4 + 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 1 {
            let cell = tableView.fw.dequeueReusableCell(withIdentifier: WalletCryptoTableViewCell.description()) as! WalletCryptoTableViewCell
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        }
        let cell = tableView.fw.dequeueReusableCell(withIdentifier: WalletCardTableViewCell.description()) as! WalletCardTableViewCell
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
}

extension WalletViewController: WalletCryptoTableViewCellDelegate, WalletCardTableViewCellDelegate {
    func didSelectedDeposit(_ cell: WalletCardTableViewCell) {
        popup.bottomSheet {
            let v = DepositFromView.loadFromNib()
            v.identifier = "Deposit"
            v.titleLabel.text = "Deposit"
            v.subTitleLabel.text = "Choose a crypto to deposit"
            v.frame = CGRect(origin: .zero, size: CGSize(width: SCREENWIDTH, height: 368 + TOUCHBARHEIGHT))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = .init(origin: .zero,
                                    size: .init(width: SCREENWIDTH, height: 368 + TOUCHBARHEIGHT))
            maskLayer.path = UIBezierPath(roundedRect: .init(origin: .zero, size: maskLayer.frame.size),
                                          byRoundingCorners: [.topLeft, .topRight],
                                          cornerRadii: .init(width: 32, height: 32)).cgPath
             v.layer.mask = maskLayer
            v.delegate = self
            return v
        }
    }
    
    func didSelectedWithdraw(_ cell: WalletCardTableViewCell) {
        popup.bottomSheet {
            let v = DepositFromView.loadFromNib()
            v.identifier = "Withdraw"
            v.titleLabel.text = "Withdraw"
            v.subTitleLabel.text = "Choose a crypto to withdraw"
            v.frame = CGRect(origin: .zero, size: CGSize(width: SCREENWIDTH, height: 368 + TOUCHBARHEIGHT))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = .init(origin: .zero,
                                    size: .init(width: SCREENWIDTH, height: 368 + TOUCHBARHEIGHT))
            maskLayer.path = UIBezierPath(roundedRect: .init(origin: .zero, size: maskLayer.frame.size),
                                          byRoundingCorners: [.topLeft, .topRight],
                                          cornerRadii: .init(width: 32, height: 32)).cgPath
             v.layer.mask = maskLayer
            v.delegate = self
            return v
        }
    }
    
    func didSelectItemAt(_ cell: WalletCryptoTableViewCell) {
        let vc = CryptoWalletDetailViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension WalletViewController: DepositFromViewDelegate {
    func didSelectedRecord(_ view: DepositFromView) {
        popup.dismissPopup()
        let vc = WalletTransactionsViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didSelectedDepositItem(_ view: DepositFromView) {
        popup.dismissPopup()
        if view.identifier == "Withdraw" {
            let vc = WithdrawViewController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
        if view.identifier == "Deposit" {
            let vc = DepositViewController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
