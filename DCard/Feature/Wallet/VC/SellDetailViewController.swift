//
//  SellDetailViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/8.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class SellDetailViewController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sellTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT + 20)
        }
        sellTableView.fw.registerCellNib(SellDetailItemTableViewCell.self)
        sellTableView.fw.registerCellNib(SellDetailOrderTableViewCell.self)
    }
    
}

extension SellDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 44*4 + 28
        }
        if indexPath.row == 0 {
            return 75
        }
        return 124
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.fw.dequeue(cellType: SellDetailOrderTableViewCell.self, for: indexPath)
            cell.selectionStyle = .none
            return cell
        }
        let cell = tableView.fw.dequeue(cellType: SellDetailItemTableViewCell.self, for: indexPath)
        cell.selectionStyle = .none
        if indexPath.row == 0 {
            cell.updateData(type: .contentWithIcon, status: .doing, isLastItem: false)
        } else {
            cell.updateData(type: .contentWithDesc, status: .done, isLastItem: true)
        }
        return cell
    }
    
}
