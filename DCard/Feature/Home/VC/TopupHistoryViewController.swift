//
//  TopupHistoryViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/23.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class TopupHistoryViewController: BaseViewController {
    
    private lazy var rightItem: UIBarButtonItem = {
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 4, width: 36, height: 36)
        btn.layer.cornerRadius = 18
        btn.setImage(R.image.iconFilterButtonNormal(), for: .normal)
        btn.addTarget(self, action: #selector(filterAction), for: .touchUpInside)
        return UIBarButtonItem(customView: btn)
    }()
    @IBOutlet weak var topupTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Private
    
    private func setupUI() {
        topupTableView.delegate = self
        topupTableView.dataSource = self
        topupTableView.fw.registerCellNib(TopUpHistoryItemTableViewCell.self)
        topupTableView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT + 26)
        }
    }
    
    override func setupNavBar() {
        super.setupNavBar()
        self.gk_navTitle = R.string.localizable.topupHistory()
        self.gk_navTitleFont = UIFont.fw.font18(weight: .bold)
        self.gk_navTitleColor = R.color.fw001214()
        setupRightItem()
    }
    
    private func setupRightItem() {
        self.gk_navRightBarButtonItem = rightItem
        self.gk_navItemRightSpace = 16
    }
    
    // MARK: - Actions
    
    @objc private func filterAction() {
        let vc = TransactionsFilterViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}

extension TopupHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TopUpHistoryItemTableViewCell.height()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let maskLayer = CAShapeLayer()
            maskLayer.frame = .init(origin: CGPoint(x: 0, y: 0), size: CGSize(width: SCREENWIDTH-32, height: TopUpHistoryItemTableViewCell.height()))
            maskLayer.path = UIBezierPath(roundedRect: .init(origin: .zero, size: maskLayer.frame.size),
                                          byRoundingCorners: [.topLeft, .topRight],
                                          cornerRadii: .init(width: 20, height: 20)).cgPath
            cell.layer.mask = maskLayer
        }
        
        if indexPath.row == 4 {
            let maskLayer = CAShapeLayer()
            maskLayer.frame = .init(origin: CGPoint(x: 0, y: 0), size: CGSize(width: SCREENWIDTH-32, height: TopUpHistoryItemTableViewCell.height()))
            maskLayer.path = UIBezierPath(roundedRect: .init(origin: .zero, size: maskLayer.frame.size),
                                          byRoundingCorners: [.bottomLeft, .bottomRight],
                                          cornerRadii: .init(width: 20, height: 20)).cgPath
            cell.layer.mask = maskLayer
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.fw.dequeue(cellType: TopUpHistoryItemTableViewCell.self, for: indexPath)
        cell.selectionStyle = .none
        return cell
    }

}
