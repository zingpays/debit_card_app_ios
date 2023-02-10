//
//  CryptoWalletDetailViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/6.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit
import JFPopup

class CryptoWalletDetailViewController: BaseViewController {

    @IBOutlet weak var cryptoTableView: UITableView!
    var cryptoTableHeaderView: CryptoWalletCardView = {
        let v = CryptoWalletCardView.loadFromNib()
        v.backgroundColor = .clear
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cryptoTableHeaderView.frame = CGRect(origin: .zero, size: CGSize(width: SCREENWIDTH-32, height: 245))
    }
    
    // MARK: - Private
    
    private func setupUI() {
        gk_navTitle = "BTC Wallet"
        cryptoTableView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT+20)
        }
        cryptoTableView.tableHeaderView = cryptoTableHeaderView
        cryptoTableHeaderView.delegate = self
        cryptoTableView.fw.registerCellNib(TransactionItemTableViewCell.self)
    }

    // MARK: - Actions
    
    @objc private func viewTheAllAction() {
        let vc = WalletTransactionsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CryptoWalletDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 51
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 47
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 71
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        let label = UILabel()
        v.addSubview(label)
        label.text = "Recent Transactions"
        label.textColor = R.color.fw000000()?.withAlphaComponent(0.87)
        label.font = UIFont.fw.font20(weight: .bold)
        label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.right.top.bottom.equalToSuperview()
        }
        v.backgroundColor = .white
        let maskLayer = CAShapeLayer()
        maskLayer.frame = .init(origin: .zero,
                                size: .init(width: SCREENWIDTH-32, height: 51))
        maskLayer.path = UIBezierPath(roundedRect: .init(origin: .zero, size: maskLayer.frame.size),
                                      byRoundingCorners: [.topLeft, .topRight],
                                      cornerRadii: .init(width: 20, height: 20)).cgPath
        v.layer.mask = maskLayer
        return v
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView()
        let btn = UIButton()
        v.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        btn.addTarget(self, action: #selector(viewTheAllAction), for: .touchUpInside)
        btn.setTitle("View the all", for: .normal)
        btn.setTitleColor(R.color.fw000000()?.withAlphaComponent(0.5), for: .normal)
        btn.titleLabel?.font = UIFont.fw.font14()
        let imgV = UIImageView()
        v.addSubview(imgV)
        imgV.image = R.image.iconRightArrowGray()
        imgV.snp.makeConstraints { make in
            make.left.equalTo(btn.snp.right).offset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(8)
        }
        v.backgroundColor = .white
        let maskLayer = CAShapeLayer()
        maskLayer.frame = .init(origin: .zero,
                                size: .init(width: SCREENWIDTH-32, height: 47))
        maskLayer.path = UIBezierPath(roundedRect: .init(origin: .zero, size: maskLayer.frame.size),
                                      byRoundingCorners: [.bottomLeft, .bottomRight],
                                      cornerRadii: .init(width: 20, height: 20)).cgPath
        v.layer.mask = maskLayer
        return v
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.fw.dequeue(cellType: TransactionItemTableViewCell.self, for: indexPath)
        cell.updateData(style: .content)
        cell.selectionStyle = .none
        return cell
    }
    
}

extension CryptoWalletDetailViewController: CryptoWalletCardViewDelegate {
    func didSelectedSell(_ view: CryptoWalletCardView) {
        let vc = SellCryptoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didSelectedDeposit(_ view: CryptoWalletCardView) {
        popup.bottomSheet {
            let v = DepositFromView.loadFromNib()
            v.identifier = "Deposit"
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
    
    func didSelectedWithdraw(_ view: CryptoWalletCardView) {
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
    
}

extension CryptoWalletDetailViewController: DepositFromViewDelegate {
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
            let vc = SellCryptoViewController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
