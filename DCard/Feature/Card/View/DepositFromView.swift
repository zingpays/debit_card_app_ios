//
//  DepositFromView.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/2.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

protocol DepositFromViewDelegate: NSObject {
    func didSelectedDepositItem()
}

class DepositFromView: UIView, NibLoadable {
    
    @IBOutlet weak var fromTableView: UITableView! {
        didSet {
            fromTableView.delegate = self
            fromTableView.dataSource = self
        }
    }
    
    weak var delegate: DepositFromViewDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        fromTableView.fw.registerCellNib(DepositFromTableViewCell.self)
    }
}

extension DepositFromView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.fw.dequeueReusableCell(withIdentifier: DepositFromTableViewCell.description()) as! DepositFromTableViewCell
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectedDepositItem()
    }
    
}
