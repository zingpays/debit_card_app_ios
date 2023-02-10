//
//  ChooseCryptoNetworkView.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/10.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

protocol ChooseCryptoNetworkViewDelegate: NSObject {
    func didSelectedNetworkItem(_ view: ChooseCryptoNetworkView)
}

class ChooseCryptoNetworkView: UIView, NibLoadable {

    @IBOutlet weak var reminderView: UIView!
    @IBOutlet weak var networkTableView: UITableView! {
        didSet {
            networkTableView.delegate = self
            networkTableView.dataSource = self
        }
    }
    
    weak var delegate: ChooseCryptoNetworkViewDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        reminderView.backgroundColor = R.color.fw00A8BB()?.withAlphaComponent(0.1)
        networkTableView.fw.registerCellNib(CryptoNetworkItemTableViewCell.self)
    }
    
}

extension ChooseCryptoNetworkView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.fw.dequeue(cellType: CryptoNetworkItemTableViewCell.self, for: indexPath)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectedNetworkItem(self)
    }
    
}
