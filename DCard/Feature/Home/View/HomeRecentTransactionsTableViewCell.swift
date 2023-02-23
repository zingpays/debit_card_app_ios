//
//  HomeRecentTransactionsTableViewCell.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/23.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

protocol HomeRecentTransactionsTableViewCellDelegate {
    func didSelectedViewTheAll(_ cell: HomeRecentTransactionsTableViewCell)
}

class HomeRecentTransactionsTableViewCell: UITableViewCell {

    var delegate: HomeRecentTransactionsTableViewCellDelegate?
    @IBOutlet weak var cardContentView: UIView!
    @IBOutlet weak var cardContentShadowView: UIView!
    @IBOutlet weak var transactionTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    static func height() -> CGFloat {
        return 432
    }
 
    private func setupUI() {
        cardContentView.layer.masksToBounds = true
        cardContentShadowView.layer.masksToBounds = false
        cardContentShadowView.layer.shadowColor = R.color.fw005960()?.withAlphaComponent(0.16).cgColor
        transactionTableView.delegate = self
        transactionTableView.dataSource = self
        transactionTableView.fw.registerCellNib(TransactionTableViewCell.self)
        titleLabel.text = R.string.localizable.recentTransactions()
    }
    
    // MARK: - Action
    @objc private func viewTheAllAction() {
        delegate?.didSelectedViewTheAll(self)
    }
}

extension HomeRecentTransactionsTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView()
        let btn = UIButton()
        v.addSubview(btn)
        btn.addTarget(self, action: #selector(viewTheAllAction), for: .touchUpInside)
        btn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        let label = UILabel()
        v.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        label.text = "View the all"
        label.textColor = R.color.fw000000()?.withAlphaComponent(0.5)
        label.font = UIFont.fw.font14()
        let imageV = UIImageView()
        imageV.image = R.image.iconRightArrowGray()
        v.addSubview(imageV)
        imageV.snp.makeConstraints { make in
            make.left.equalTo(label.snp.right).offset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(8)
        }
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.fw.dequeue(cellType: TransactionTableViewCell.self, for: indexPath)
        cell.selectionStyle = .none
        return cell
    }
    
}
