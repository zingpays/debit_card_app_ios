//
//  CardViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/29.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit
import JFPopup

class CardViewController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cardTableView: UITableView!
    /// 卡片类型数据
    private var cardTypeData: SuppportCardInfoModel?
    
    private var numberOfRowsInTable: Int = 0
    
    private var cardInfo: CardModel?
    
    private var transactionsData: TransactionsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    override func setupNavBar() {
        self.gk_navigationBar.isHidden = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private
    
    private func setupUI() {
        titleLabel.font = UIFont.fw.font20(weight: .bold)
        titleLabel.text = R.string.localizable.debitCard()
        cardTableView.fw.registerCellNib(EmptyCardTableViewCell.self)
        cardTableView.fw.registerCellNib(CardBagTableViewCell.self)
        cardTableView.fw.registerCellNib(RecentTransactionsTableViewCell.self)
    }
    
    private func setupData() {
        requestCardInfo()
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applyCardSuccess),
                                               name: Notification.Name(APPLYCARDSUCCESS),
                                               object: nil)
    }
    
    // MARK: - Action
    
    @objc private func applyCardSuccess() {
        requestCardInfo()
    }
    
    @IBAction func cardSettingAction(_ sender: Any) {
        let vc = CardSettingViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Request
    
    private func requestCardSupportType() {
        indicator.startAnimating()
        CardRequest.supportType { [weak self] isSuccess, message, datas in
            guard let this = self else { return }
            this.indicator.stopAnimating()
            if isSuccess, let datas = datas {
                this.cardTypeData = datas.first
                this.cardTableView.reloadData()
            }
        }
    }
    
    private func requestCardInfo() {
        indicator.startAnimating()
        CardRequest.info { [weak self] isSuccess, message, data in
            guard let this = self else { return }
            this.indicator.stopAnimating()
            if isSuccess {
                if let data = data {
                    this.cardInfo = data
                    this.requestTransationsData()
                    this.cardTableView.reloadData()
                } else {
                    this.requestCardSupportType()
                }
            } else {
                this.view.makeToast(message, position: .center)
            }
        }
    }
    
    private func requestTransationsData() {
        indicator.startAnimating()
        CardRequest.transations(page: 2, per: 5) { [weak self] isSuccess, message, data in
            guard let this = self else { return }
            this.indicator.stopAnimating()
            if isSuccess {
                if let data = data {
                    this.transactionsData = data
                    this.cardTableView.reloadData()
                }
            }
        }
    }
    
}

extension CardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cardInfo != nil {
            if transactionsData != nil, transactionsData?.list?.count ?? 0 > 0 {
                return 2
            } else {
                return 1
            }
        } else {
            return cardTypeData == nil ? 0 : 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            if cardInfo == nil {
                return EmptyCardTableViewCell.height()
            } else {
                return CardBagTableViewCell.height()
            }
        } else {
            return RecentTransactionsTableViewCell.height(transactions: transactionsData?.list?.count ?? 0)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if cardInfo == nil {
                let cell = tableView.fw.dequeue(cellType: EmptyCardTableViewCell.self, for: indexPath)
                cell.selectionStyle = .none
                cell.delegate = self
                cell.update(currency: cardTypeData?.currency)
                return cell
            } else {
                let cell = tableView.fw.dequeue(cellType: CardBagTableViewCell.self, for: indexPath)
                cell.selectionStyle = .none
                cell.delegate = self
                cell.update(data: cardInfo)
                return cell
            }
        } else {
            let cell = tableView.fw.dequeue(cellType: RecentTransactionsTableViewCell.self, for: indexPath)
            cell.selectionStyle = .none
            cell.delegate = self
            cell.update(data: transactionsData?.list)
            return cell
        }
    }
}

extension CardViewController: EmptyCardTableViewCellDelegate {
    func didSelectedAddCard(_ cell: EmptyCardTableViewCell) {
        guard let kycStatus = UserManager.shared.status?.kycStatus else { return }
        switch kycStatus {
        case .notStarted, .start, .inProgress:
            let vc = KYCUnAvailableViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.source = .home
            self.navigationController?.pushViewController(vc, animated: true)
        case .submitted, .inReview:
            let alert = UIAlertController(title: R.string.localizable.sorry(),
                                          message: R.string.localizable.homeKycInreviewTips(),
                                          preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: R.string.localizable.gotIt(),
                                             style: .cancel)
            alert.addAction(cancelAction)
            self.present(alert, animated: true)
        case .approved:
            let vc = ApplyCardViewController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case .rejected:
            let alert = UIAlertController(title: R.string.localizable.sorry(),
                                          message: R.string.localizable.homeKycRejectTips(),
                                          preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: R.string.localizable.gotIt(),
                                             style: .cancel)
            alert.addAction(cancelAction)
            self.present(alert, animated: true)
        case .resubmitted:
            let alert = UIAlertController(title: R.string.localizable.sorry(),
                                          message: R.string.localizable.homeKycResubmitTips(),
                                          preferredStyle: .alert)
            let continuneAction = UIAlertAction(title: R.string.localizable.toVerify(),
                                                style: .default) { action in
                let vc = KYCFillInNameAndNationalViewController()
                vc.kycStatus = .resubmitted
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            let cancelAction = UIAlertAction(title: R.string.localizable.cancel(),
                                             style: .cancel)
            alert.addAction(cancelAction)
            alert.addAction(continuneAction)
            self.present(alert, animated: true)
        }
    }
}

extension CardViewController: CardBagTableViewCellDelegate {
    func didSelectedTransitInfo(_ cell: CardBagTableViewCell) {
        let alert = UIAlertController(title: "Tips", message: "Because the Deposit needs to be processed by the debit card system, part of the funds have not yet arrived, and they are on the way.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Got It", style: .cancel)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    func didSelectedCashbackInfo(_ cell: CardBagTableViewCell) {
        let alert = UIAlertController(title: "Tips", message: "This is the total accumulated cashback amount. The cashback will be given for the consumption in the previous month between the 1st and 10th of each month. We will notify you every time the cashback arrives.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Got It", style: .cancel)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    func didSelectedDeposit(_ cell: CardBagTableViewCell) {
        popup.bottomSheet {
            let v = DepositFromView.loadFromNib()
            v.recordButton.isHidden = true
            v.frame = CGRect(origin: .zero, size: CGSize(width: SCREENWIDTH, height: 368 + TOUCHBARHEIGHT))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = .init(origin: .zero,
                                    size: .init(width: SCREENWIDTH, height: 368 + TOUCHBARHEIGHT))
            maskLayer.path = UIBezierPath(roundedRect: .init(origin: .zero, size: maskLayer.frame.size),
                                          byRoundingCorners: [.topLeft, .topRight],
                                          cornerRadii: .init(width: 32, height: 32)).cgPath
             v.layer.mask = maskLayer
            v.delegate = self
            return v
        }
    }
    
    func didSelectedStatement(_ cell: CardBagTableViewCell) {
        let vc = TransactionsViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didSelectedCardDetail(_ cell: CardBagTableViewCell) {
        let vc = CardDetailViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CardViewController: RecentTransactionsTableViewCellDelegate {
    func didSelectedViewTheAll(_ cell: RecentTransactionsTableViewCell) {
        let vc = TransactionsViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CardViewController: DepositFromViewDelegate {
    func didSelectedRecord(_ view: DepositFromView) {}
    
    func didSelectedDepositItem(_ view: DepositFromView) {
        popup.dismissPopup()
    }
}
