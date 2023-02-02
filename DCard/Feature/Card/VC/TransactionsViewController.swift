//
//  TransactionsViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/2.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class TransactionsViewController: BaseViewController {
    
    @IBOutlet weak var transactionTableView: UITableView!
    @IBOutlet weak var filterBoardView: UIView!
    
    private lazy var rightItem: UIBarButtonItem = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 4, width: 84, height: 36)
        let filterBtn = UIButton()
        v.addSubview(filterBtn)
        filterBtn.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(36)
        }
        filterBtn.setImage(R.image.iconFilterButton(), for: .normal)
        filterBtn.addTarget(self, action: #selector(filterAction), for: .touchUpInside)
        filterBtn.backgroundColor = R.color.fw00A8BB()
        filterBtn.layer.cornerRadius = 12
        let shareBtn = UIButton()
        v.addSubview(shareBtn)
        shareBtn.snp.makeConstraints { make in
            make.left.equalTo(filterBtn.snp.right).offset(12)
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(36)
        }
        shareBtn.layer.cornerRadius = 12
        shareBtn.addTarget(self, action: #selector(shareAction), for: .touchUpInside)
        shareBtn.backgroundColor = R.color.fwFAFAFA()
        shareBtn.setImage(R.image.iconShareButton(), for: .normal)
        return UIBarButtonItem(customView: v)
    }()
    
    private lazy var tableviewHeaderView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.frame = CGRect(origin: .zero, size: CGSize(width: SCREENWIDTH, height: 73))
        let label = UILabel()
        v.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.bottom.right.left.equalToSuperview()
        }
        label.text = "Transactions"
        label.font = UIFont.fw.font28(weight: .bold)
        label.textColor = R.color.fw000000()
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Private
    
    private func setupUI() {
        setupRightItem()
        setupSubviews()
    }
    
    private func setupSubviews() {
        let bgLayer = CAGradientLayer()
        bgLayer.colors = [R.color.fw008999()!.cgColor,
                          R.color.fw004396()!.cgColor]
        bgLayer.locations = [0, 1]
        bgLayer.frame = filterBoardView.bounds
        bgLayer.startPoint = .zero
        bgLayer.endPoint = CGPoint(x: 0.79, y: 0.79)
        bgLayer.opacity = 1
        filterBoardView.layer.insertSublayer(bgLayer, at: 0)
        filterBoardView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT+20)
        }
        transactionTableView.fw.registerCellNib(TransactionItemTableViewCell.self)
        transactionTableView.tableHeaderView = tableviewHeaderView
    }
    
    private func setupRightItem() {
        self.gk_navRightBarButtonItem = rightItem
        self.gk_navItemRightSpace = 16
    }
    
    // MARK: - Actions
    
    @objc private func filterAction() {
        
    }
    
    @objc private func shareAction() {
        
    }
    
}

extension TransactionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 71
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let maskLayer = CAShapeLayer()
            maskLayer.frame = .init(origin: CGPoint(x: 0, y: 0), size: CGSize(width: SCREENWIDTH-32, height: 71))
            maskLayer.path = UIBezierPath(roundedRect: .init(origin: .zero, size: maskLayer.frame.size),
                                          byRoundingCorners: [.topLeft, .topRight],
                                          cornerRadii: .init(width: 20, height: 20)).cgPath
            cell.layer.mask = maskLayer
        }
        
        if indexPath.row == 9 {
            let maskLayer = CAShapeLayer()
            maskLayer.frame = .init(origin: CGPoint(x: 0, y: 0), size: CGSize(width: SCREENWIDTH-32, height: 71))
            maskLayer.path = UIBezierPath(roundedRect: .init(origin: .zero, size: maskLayer.frame.size),
                                          byRoundingCorners: [.bottomLeft, .bottomRight],
                                          cornerRadii: .init(width: 20, height: 20)).cgPath
            cell.layer.mask = maskLayer
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.fw.dequeueReusableCell(withIdentifier: TransactionItemTableViewCell.description()) as! TransactionItemTableViewCell
        return cell
    }
    
}
