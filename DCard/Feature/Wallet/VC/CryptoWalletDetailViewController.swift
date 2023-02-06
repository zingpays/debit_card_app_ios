//
//  CryptoWalletDetailViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/6.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class CryptoWalletDetailViewController: BaseViewController {

    @IBOutlet weak var cryptoTableView: UITableView!
    var cryptoTableHeaderView: UIView = {
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
            make.top.equalToSuperview().offset(NAVBARHEIGHT+10)
        }
        cryptoTableView.tableHeaderView = cryptoTableHeaderView
        cryptoTableView.fw.registerCellNib(TransactionItemTableViewCell.self)
    }

}

extension CryptoWalletDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
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
        let label = UILabel()
        v.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        label.text = "View the all"
        label.textColor = R.color.fw000000()?.withAlphaComponent(0.5)
        label.font = UIFont.fw.font14()
        let imgV = UIImageView()
        v.addSubview(imgV)
        imgV.image = R.image.iconRightArrowGray()
        imgV.snp.makeConstraints { make in
            make.left.equalTo(label.snp.right).offset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(8)
        }
        v.backgroundColor = .white
        return v
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.fw.dequeue(cellType: TransactionItemTableViewCell.self, for: indexPath)
        cell.updateData(style: .content)
        return cell
    }
    
}
