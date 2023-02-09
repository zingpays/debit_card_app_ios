//
//  SellDetailOrderTableViewCell.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/9.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class SellDetailOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var cardTableView: UITableView! {
        didSet {
            cardTableView.delegate = self
            cardTableView.dataSource = self
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        cardTableView.fw.registerCellNib(SellDetailOrderItemTableViewCell.self)
        cardTableView.delegate = self
        cardTableView.dataSource = self
    }
    
}

extension SellDetailOrderTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.fw.dequeue(cellType: SellDetailOrderItemTableViewCell.self, for: indexPath)
        cell.selectionStyle = .none
        return cell
    }
    
}
