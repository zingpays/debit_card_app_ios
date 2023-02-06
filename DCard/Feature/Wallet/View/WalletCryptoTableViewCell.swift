//
//  WalletCryptoTableViewCell.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/6.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

protocol WalletCryptoTableViewCellDelegate: NSObject {
    func didSelectItemAt(_ cell: WalletCryptoTableViewCell)
}

class WalletCryptoTableViewCell: UITableViewCell {

    @IBOutlet weak var cardContentView: UIView!
    @IBOutlet weak var cardContentShadowView: UIView!
    @IBOutlet weak var cryptoTableView: UITableView! {
        didSet {
            cryptoTableView.delegate = self
            cryptoTableView.dataSource = self
        }
    }
    weak var delegate: WalletCryptoTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupSubviews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupSubviews() {
        cardContentView.layer.masksToBounds = true
        cardContentShadowView.layer.masksToBounds = false
        cardContentShadowView.layer.shadowColor = R.color.fw005960()?.withAlphaComponent(0.16).cgColor
        cryptoTableView.fw.registerCellNib(WalletCryptoItemTableViewCell.self)
    }
    
}

extension WalletCryptoTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 91
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.fw.dequeueReusableCell(withIdentifier: WalletCryptoItemTableViewCell.description()) as! WalletCryptoItemTableViewCell
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectItemAt(self)
    }
    
}
