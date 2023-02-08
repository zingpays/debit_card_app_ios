//
//  WalletTransactionsContentBaseViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/8.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit
import JXSegmentedView

class WalletTransactionsContentBaseViewController: BaseViewController {

    @IBOutlet weak var recordListView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func setupNavBar() {}
    
    // MARK: - Private
    
    private func setupUI() {
        recordListView.fw.registerCellNib(CryptoTransactionTableViewCell.self)
    }
}

extension WalletTransactionsContentBaseViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}

extension WalletTransactionsContentBaseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let maskLayer = CAShapeLayer()
            maskLayer.frame = .init(origin: CGPoint(x: 0, y: 0), size: CGSize(width: SCREENWIDTH-32, height: 101))
            maskLayer.path = UIBezierPath(roundedRect: .init(origin: .zero, size: maskLayer.frame.size),
                                          byRoundingCorners: [.topLeft, .topRight],
                                          cornerRadii: .init(width: 20, height: 20)).cgPath
            cell.layer.mask = maskLayer
        }
        
        if indexPath.row == 3 {
            let maskLayer = CAShapeLayer()
            maskLayer.frame = .init(origin: CGPoint(x: 0, y: 0), size: CGSize(width: SCREENWIDTH-32, height: 101))
            maskLayer.path = UIBezierPath(roundedRect: .init(origin: .zero, size: maskLayer.frame.size),
                                          byRoundingCorners: [.bottomLeft, .bottomRight],
                                          cornerRadii: .init(width: 20, height: 20)).cgPath
            cell.layer.mask = maskLayer
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 101
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.fw.dequeue(cellType: CryptoTransactionTableViewCell.self, for: indexPath)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SellDetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
