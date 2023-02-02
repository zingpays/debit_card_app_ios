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
    
    @IBOutlet weak var cardTableView: UITableView! {
        didSet {
            cardTableView.bounces = false
            cardTableView.showsVerticalScrollIndicator = false
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    override func setupNavBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserManager.shared.isExpireToken() {
            UIApplication.shared.keyWindow()?.rootViewController = nil
            let vc = LoginViewController()
            let loginNavVC = UINavigationController(rootViewController: vc)
            UIApplication.shared.keyWindow()?.rootViewController = loginNavVC
        } else {
//            if !LocalAuthenManager.shared.isAuthorized {
//                let lockScreenVC = BiometricsViewController()
//                let navVC = UINavigationController(rootViewController: lockScreenVC)
//                navVC.modalPresentationStyle = .fullScreen
//                self.present(navVC, animated: false)
//            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private
    
    private func setupUI() {
        titleLabel.font = UIFont.fw.font20(weight: .bold)
        cardTableView.fw.registerCellNib(EmptyCardTableViewCell.self)
        cardTableView.fw.registerCellNib(CardBagTableViewCell.self)
        cardTableView.fw.registerCellNib(RecentTransactionsTableViewCell.self)
    }
    
    private func setupData() {
        
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applyCardSuccess),
                                               name: Notification.Name(APPLYCARDSUCCESS),
                                               object: nil)
    }
    
    // MARK: - Action
    
    @objc private func applyCardSuccess() {
        
    }
    
}

extension CardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 { return 314 + 20 }
        if indexPath.row == 0 { return 282 + 10}
        return 417
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.fw.dequeueReusableCell(withIdentifier: CardBagTableViewCell.description()) as! CardBagTableViewCell
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        }
        if indexPath.row == 1 {
            let cell = tableView.fw.dequeueReusableCell(withIdentifier: RecentTransactionsTableViewCell.description()) as! RecentTransactionsTableViewCell
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        }
        let cell = tableView.fw.dequeueReusableCell(withIdentifier: EmptyCardTableViewCell.description()) as! EmptyCardTableViewCell
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
}

extension CardViewController: EmptyCardTableViewCellDelegate {
    func didSelectedAddCard(_ cell: EmptyCardTableViewCell) {
        let vc = ApplyCardViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
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
        
    }
    
    func didSelectedCardDetail(_ cell: CardBagTableViewCell) {
        
    }
}

extension CardViewController: RecentTransactionsTableViewCellDelegate {
    func didSelectedViewTheAll(_ cell: RecentTransactionsTableViewCell) {
        
    }
}

extension CardViewController: DepositFromViewDelegate {
    func didSelectedDepositItem() {
        
    }
}
