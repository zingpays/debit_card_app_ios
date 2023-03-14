//
//  TransactionsViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/2.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit
import MJRefresh

class TransactionsViewController: BaseViewController {
    
    @IBOutlet weak var transactionTableView: UITableView!
    @IBOutlet weak var filterBoardView: UIView!
    private var transactionsData: TransactionsModel?
    
    private lazy var rightItem: UIBarButtonItem = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 4, width: 36, height: 36)
        let filterBtn = UIButton()
        v.addSubview(filterBtn)
        filterBtn.snp.makeConstraints { make in
            make.left.top.bottom.right.equalToSuperview()
            make.width.equalTo(36)
        }
        filterBtn.setImage(R.image.iconFilterButtonNormal(), for: .normal)
        filterBtn.addTarget(self, action: #selector(filterAction), for: .touchUpInside)
        filterBtn.backgroundColor = R.color.fw00A8BB()
        filterBtn.layer.cornerRadius = 12
        return UIBarButtonItem(customView: v)
    }()

    @IBOutlet weak var cardTypeLabel: UILabel!
    @IBOutlet weak var cardValueLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var typeValueLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateValueLabel: UILabel!
    @IBOutlet weak var filterBoardViewHeight: NSLayoutConstraint!
    
    private let partnerName: String
    
    private var currPage: Int = 1
    
    private lazy var refreshNormalHeader: MJRefreshNormalHeader? = {
        let header = MJRefreshNormalHeader(refreshingTarget:self, refreshingAction: #selector(headerRefresh))
        header.lastUpdatedTimeLabel?.isHidden = true
        header.stateLabel?.isHidden = true
        return header
    }()
    
    private lazy var refreshNormalfooter: MJRefreshAutoFooter? = {
        let footer = MJRefreshAutoFooter(refreshingTarget:self, refreshingAction: #selector(footerRefrsh))
        footer.isAutomaticallyRefresh = false
        return footer
    }()
    
    init(partnerName: String) {
        self.partnerName = partnerName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
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
        bgLayer.frame = CGRect(origin: .zero, size: CGSize(width: SCREENWIDTH, height: 84))
        bgLayer.startPoint = .zero
        bgLayer.endPoint = CGPoint(x: 0.79, y: 0.79)
        bgLayer.opacity = 1
        filterBoardView.layer.insertSublayer(bgLayer, at: 0)
        filterBoardView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT+20)
        }
        updateFilterBoardView(isShow: false)
        transactionTableView.fw.registerCellNib(TransactionItemTableViewCell.self)
    }
    
    private func setupRightItem() {
        self.gk_navRightBarButtonItem = rightItem
        self.gk_navItemRightSpace = 16
        self.gk_navTitle = R.string.localizable.transactions()
    }
    
    private func setupData() {
        requestTransationsData()
        transactionTableView.mj_header = refreshNormalHeader
        transactionTableView.mj_footer = refreshNormalfooter
    }
    
    private func requestTransationsData(type: String? = nil,
                                        dateForm: String? = nil,
                                        dateTo: String? = nil,
                                        per: Int = 15,
                                        isNeedLoading: Bool = true,
                                        isLoadMore: Bool = false) {
        if isNeedLoading {
            indicator.startAnimating()
        }
        CardRequest.transations(type: type, dateTo: dateTo, dateForm: dateForm, page: currPage, per: per, partnerName: partnerName) { [weak self] isSuccess, message, data in
            guard let this = self else { return }
            this.indicator.stopAnimating()
            this.transactionTableView.mj_header?.endRefreshing()
            this.transactionTableView.mj_footer?.endRefreshing()
            if isSuccess {
                if let data = data {
                    if isLoadMore {
                        this.currPage += 1
                    }
                    this.transactionsData = data
                    this.transactionTableView.reloadData()
                }
            }
        }
    }
    
    private func updateFilterBoardView(cardType: FilterTypeModel? = nil, date: FilterDateModel? = nil, isShow: Bool) {
        if isShow {
            filterBoardViewHeight.constant = 84
            filterBoardView.isHidden = false
            typeValueLabel.text = cardType?.type.formatName()
            cardValueLabel.text = R.string.localizable.virtualCard()
            if let from = date?.from, let to = date?.to {
                dateValueLabel.text = "\(from.toFormat("YYYY/MM/D")) - \(to.toFormat("YYYY/MM/DD"))"
            }
        } else {
            filterBoardViewHeight.constant = 0 //84
            filterBoardView.isHidden = true
        }
    }
    
    // MARK: - Actions
    
    @objc private func headerRefresh() {
        currPage = 1
        requestTransationsData(isNeedLoading: false)
    }
    
    @objc private func footerRefrsh() {
        requestTransationsData(isNeedLoading: false, isLoadMore: true)
    }
    
    @objc private func filterAction() {
        let vc = TransactionsFilterViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
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

extension TransactionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionsData?.list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 71
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let count = transactionsData?.list?.count, count > 0 {
            if indexPath.row == 0 {
                let maskLayer = CAShapeLayer()
                maskLayer.frame = .init(origin: CGPoint(x: 0, y: 0), size: CGSize(width: SCREENWIDTH-32, height: 71))
                maskLayer.path = UIBezierPath(roundedRect: .init(origin: .zero, size: maskLayer.frame.size),
                                              byRoundingCorners: [.topLeft, .topRight],
                                              cornerRadii: .init(width: 20, height: 20)).cgPath
                cell.layer.mask = maskLayer
            } else if indexPath.row == count - 1 {
                let maskLayer = CAShapeLayer()
                maskLayer.frame = .init(origin: CGPoint(x: 0, y: 0), size: CGSize(width: SCREENWIDTH-32, height: 71))
                maskLayer.path = UIBezierPath(roundedRect: .init(origin: .zero, size: maskLayer.frame.size),
                                              byRoundingCorners: [.bottomLeft, .bottomRight],
                                              cornerRadii: .init(width: 20, height: 20)).cgPath
                cell.layer.mask = maskLayer
            } else {
                let maskLayer = CAShapeLayer()
                maskLayer.frame = .init(origin: CGPoint(x: 0, y: 0), size: CGSize(width: SCREENWIDTH-32, height: 71))
                maskLayer.path = UIBezierPath(roundedRect: .init(origin: .zero, size: maskLayer.frame.size),
                                              byRoundingCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight],
                                              cornerRadii: .init(width: 0, height: 0)).cgPath
                cell.layer.mask = maskLayer
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.fw.dequeueReusableCell(withIdentifier: TransactionItemTableViewCell.description()) as! TransactionItemTableViewCell
        if let data = transactionsData?.list?[indexPath.row] {
            let style: TransactionItemTableViewCellStyle = data.type == .consume ? .withFlag : .content
            cell.update(style: style, data: data)
        }
        return cell
    }
    
}

extension TransactionsViewController: TransactionsFilterViewControllerDelegate {
    func didSelected(cardType: FilterTypeModel, date: FilterDateModel) {
        requestTransationsData(type: cardType.type.rawValue,
                               dateForm: date.from?.iso8601String,
                               dateTo: date.to?.iso8601String)
        updateFilterBoardView(cardType: cardType, date: date, isShow: true)
    }
}
