//
//  WalletTransactionsViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/7.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit
import JXSegmentedView

class WalletTransactionsViewController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var filterBoardView: UIView! {
        didSet {
            let bgLayer = CAGradientLayer()
            bgLayer.colors = [R.color.fw008999()!.cgColor,
                              R.color.fw004396()!.cgColor]
            bgLayer.locations = [0, 1]
            bgLayer.frame = CGRect(origin: .zero, size: CGSize(width: SCREENWIDTH, height: 84))
            bgLayer.startPoint = .zero
            bgLayer.endPoint = CGPoint(x: 0.79, y: 0.79)
            bgLayer.opacity = 1
            filterBoardView.layer.insertSublayer(bgLayer, at: 0)
        }
    }
    
    private lazy var rightItem: UIBarButtonItem = {
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 4, width: 36, height: 36)
        btn.layer.cornerRadius = 18
        btn.setImage(R.image.iconFilterButtonNormal(), for: .normal)
        btn.addTarget(self, action: #selector(filterAction), for: .touchUpInside)
        return UIBarButtonItem(customView: btn)
    }()
    
    private lazy var segmentedDataSource: JXSegmentedTitleDataSource = {
        let source = JXSegmentedTitleDataSource()
        source.titles = ["Deposits", "Withdrawals", "Sell"]
        source.titleNormalFont = UIFont.fw.font18()
        source.titleSelectedFont = UIFont.fw.font18(weight: .bold)
        source.titleNormalColor = R.color.fw000000()?.withAlphaComponent(0.4) ?? .black
        source.titleSelectedColor = R.color.fw00A8BB() ?? .black
        source.itemSpacing = 0
        source.itemWidth = SCREENWIDTH * 0.3
        return source
    }()
    
    private lazy var indecator: JXSegmentedIndicatorLineView = {
        let view = JXSegmentedIndicatorLineView()
        view.indicatorColor = R.color.fw00A8BB() ?? .white
        view.indicatorHeight = 4
        view.lineStyle = .lengthen
        view.lineScrollOffsetX = -10
        view.indicatorWidth = 20
        view.indicatorCornerRadius = 2
        return view
    }()
    
    private lazy var segmentedView: JXSegmentedView = {
        let view = JXSegmentedView()
        view.clipsToBounds = false
        view.dataSource = segmentedDataSource
        view.listContainer = listContainerView
        view.delegate = self
        view.indicators = [indecator]
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var listContainerView: JXSegmentedListContainerView = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        setupRightItem()
        filterBoardView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT + 20)
        }
        view.addSubview(segmentedView)
        segmentedView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.height.equalTo(44)
        }
        view.addSubview(listContainerView)
        listContainerView.snp.makeConstraints { make in
            make.top.equalTo(segmentedView.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
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

extension WalletTransactionsViewController: JXSegmentedListContainerViewDataSource, JXSegmentedViewDelegate {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return 3
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        let vc = WalletTransactionsContentViewController()
        return vc
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, didScrollSelectedItemAt index: Int) {
        
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: CGFloat) {
        
    }

}
