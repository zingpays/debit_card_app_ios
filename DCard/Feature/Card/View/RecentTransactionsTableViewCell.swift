//
//  RecentTransactionsTableViewCell.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/1.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

protocol RecentTransactionsTableViewCellDelegate: NSObject {
    func didSelectedViewTheAll(_ cell: RecentTransactionsTableViewCell)
}

class RecentTransactionsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cardContentView: UIView!
    @IBOutlet weak var cardContentShadowView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var transactionsTableview: UITableView! {
        didSet {
            transactionsTableview.delegate = self
            transactionsTableview.dataSource = self
        }
    }
    private var transactions: [TransactionItemModel] = []
    
    weak var delegate: RecentTransactionsTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupSubviews()
    }
    
    static func height(transactions: Int) -> CGFloat {
        return CGFloat(transactions * 71 + 48 + 53 + 20)
        // 71*3=213 213 + 48 = 261  261 + 53 = 314
    }
    
    // MARK: - Private
    
    private func setupSubviews() {
        cardContentView.layer.masksToBounds = true
        cardContentShadowView.layer.masksToBounds = false
        cardContentShadowView.layer.shadowColor = R.color.fw005960()?.withAlphaComponent(0.16).cgColor
        transactionsTableview.fw.registerCellNib(TransactionItemTableViewCell.self)
        titleLabel.text = R.string.localizable.recentTransactions()
    }
    
    // MARK: - Action
    @objc private func viewTheAllAction() {
        delegate?.didSelectedViewTheAll(self)
    }
}

extension RecentTransactionsTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 71
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
        label.text = R.string.localizable.viewTheAll()
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
        let cell = tableView.fw.dequeueReusableCell(withIdentifier: TransactionItemTableViewCell.description()) as! TransactionItemTableViewCell
        cell.selectionStyle = .none
        let data = transactions[indexPath.row]
        let style: TransactionItemTableViewCellStyle = data.type == .consume ? .withFlag : .content
        cell.update(style: style, data: data)
        return cell
    }
    
    func update(data: [TransactionItemModel]?) {
        guard let data = data else { return }
        transactions = data
        transactionsTableview.reloadData()
    }
    
}
