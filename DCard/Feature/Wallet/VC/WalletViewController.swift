//
//  WalletViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/29.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class WalletViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var walletTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func setupNavBar() {}
    
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
            return 233
        }
        return 51+91*3+20
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
//        cell.delegate = self
        return cell
    }
}

extension WalletViewController: WalletCryptoTableViewCellDelegate {
    func didSelectItemAt(_ cell: WalletCryptoTableViewCell) {
        let vc = CryptoWalletDetailViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
