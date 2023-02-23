//
//  HomeMarketTableViewCell.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/23.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class HomeMarketTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cardContentView: UIView!
    @IBOutlet weak var cardContentShadowView: UIView!
    @IBOutlet weak var marketTableview: UITableView!
    @IBOutlet weak var marketLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    static func height() -> CGFloat {
        return 233
    }
    
    private func setupUI() {
        cardContentView.layer.masksToBounds = true
        cardContentShadowView.layer.masksToBounds = false
        cardContentShadowView.layer.shadowColor = R.color.fw005960()?.withAlphaComponent(0.16).cgColor
        marketTableview.delegate = self
        marketTableview.dataSource = self
        marketTableview.fw.registerCellNib(MarketItemTableViewCell.self)
        marketLabel.text = R.string.localizable.market()
    }
    
}

extension HomeMarketTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MarketItemTableViewCell.height()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.fw.dequeue(cellType: MarketItemTableViewCell.self, for: indexPath)
        return cell
    }
    
}
