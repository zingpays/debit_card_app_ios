//
//  CryptoWalletDetailViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/6.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class CryptoWalletDetailViewController: BaseViewController {

    @IBOutlet weak var cryptoTableView: UITableView! {
        didSet {
            let bgLayer = CAGradientLayer()
            bgLayer.colors = [R.color.fw008999()!.cgColor,
                              R.color.fw004396()!.cgColor]
            bgLayer.locations = [0, 1]
            bgLayer.frame = cryptoTableView.bounds
            bgLayer.startPoint = .zero
            bgLayer.endPoint = CGPoint(x: 0.79, y: 0.79)
            bgLayer.opacity = 0.1
            cryptoTableView.layer.insertSublayer(bgLayer, at: 0)
        }
    }
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
        cryptoTableHeaderView.frame = CGRect(origin: .zero, size: CGSize(width: SCREENWIDTH-32, height: 265))
    }
    
    // MARK: - Private
    
    private func setupUI() {
        cryptoTableView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT+10)
        }
        cryptoTableView.tableHeaderView = cryptoTableHeaderView
        cryptoTableView.fw.registerCellNib(WalletCryptoItemTableViewCell.self)
    }

}

extension CryptoWalletDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.fw.dequeue(cellType: WalletCryptoItemTableViewCell.self, for: indexPath)
        return cell
    }
    
}
