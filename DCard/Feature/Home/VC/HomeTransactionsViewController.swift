//
//  HomeTransactionsViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/23.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class HomeTransactionsViewController: BaseViewController {
    
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
        filterBtn.setImage(R.image.iconFilterButtonNormal(), for: .normal)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func setupNavBar() {
        super.setupNavBar()
        self.gk_navTitle = R.string.localizable.transactions()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        setupRightItem()
        setupSubviews()
    }
    
    private func setupRightItem() {
        self.gk_navRightBarButtonItem = rightItem
        self.gk_navItemRightSpace = 16
    }
    
    private func setupSubviews() {
        let bgLayer = CAGradientLayer()
        bgLayer.colors = [R.color.fw008999()!.cgColor,
                          R.color.fw004396()!.cgColor]
        bgLayer.locations = [0, 1]
        bgLayer.frame = CGRect(origin: .zero, size: CGSize(width: SCREENWIDTH, height: 84))
        bgLayer.startPoint = .zero
        bgLayer.endPoint = CGPoint(x: 0.79, y: 0.79)
        bgLayer.opacity = 1
        filterBoardView.layer.insertSublayer(bgLayer, at: 0)
        filterBoardView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT+20)
        }
        transactionTableView.delegate = self
        transactionTableView.dataSource = self
        transactionTableView.fw.registerCellNib(TransactionTableViewCell.self)
    }
    
    // MARK: - Actions
    
    @objc private func filterAction() {
        let vc = TransactionsFilterViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @objc private func shareAction() {
        let activity = UIActivity()
        
        let address = ""
        let date = ""
        let content = ""
        
        let activityItems = NSMutableArray.init(objects: address, date, content)
        //activityItems.addObjects(from: imgArray as! [Any])
    
        let activities = [activity]
        //初始化UIActivityViewController
        let activityController = UIActivityViewController(activityItems: activityItems as! [Any], applicationActivities: activities)
       
        //iphone中为模式跳转
        present(activityController, animated: true, completion: nil)
    }
}
 
extension HomeTransactionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let maskLayer = CAShapeLayer()
            maskLayer.frame = .init(origin: .zero, size: CGSize(width: SCREENWIDTH-32, height: 78))
            maskLayer.path = UIBezierPath(roundedRect: .init(origin: .zero, size: maskLayer.frame.size),
                                          byRoundingCorners: [.topLeft, .topRight],
                                          cornerRadii: .init(width: 20, height: 20)).cgPath
            cell.layer.mask = maskLayer
        }
        
        if indexPath.row == 9 {
            let maskLayer = CAShapeLayer()
            maskLayer.frame = .init(origin: .zero, size: CGSize(width: SCREENWIDTH-32, height: 78))
            maskLayer.path = UIBezierPath(roundedRect: .init(origin: .zero, size: maskLayer.frame.size),
                                          byRoundingCorners: [.bottomLeft, .bottomRight],
                                          cornerRadii: .init(width: 20, height: 20)).cgPath
            cell.layer.mask = maskLayer
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.fw.dequeue(cellType: TransactionTableViewCell.self, for: indexPath)
        cell.selectionStyle = .none
        return cell
    }
    
}

