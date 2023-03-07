//
//  HomeViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/3.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit
import LocalAuthentication

class HomeViewController: BaseViewController {

    @IBOutlet weak var homeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func setupNavBar() {
        self.gk_navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserManager.shared.isExpireToken() {
            UIApplication.shared.keyWindow()?.rootViewController = nil
            let vc = LoginViewController()
            let loginNavVC = UINavigationController(rootViewController: vc)
            UIApplication.shared.keyWindow()?.rootViewController = loginNavVC
        } else {
            if LocalAuthenManager.shared.isAvailable {
                if LocalAuthenManager.shared.isBind {
                    if !LocalAuthenManager.shared.isAuthorized {
                        let lockScreenVC = BiometricsViewController()
                        lockScreenVC.isHasChangeToOtherLoginMethod = true
                        let navVC = UINavigationController(rootViewController: lockScreenVC)
                        navVC.modalPresentationStyle = .fullScreen
                        self.present(navVC, animated: false)
                    }
                } else {
                    if !LocalAuthenManager.shared.isSkiped {
                        let lockScreenVC = BiometricsViewController()
                        lockScreenVC.isGuide = true
                        lockScreenVC.isHasChangeToOtherLoginMethod = false
                        let navVC = UINavigationController(rootViewController: lockScreenVC)
                        navVC.modalPresentationStyle = .fullScreen
                        self.present(navVC, animated: false)
                    }
                }
            } else {
                if !LocalAuthenManager.shared.isAuthorized {
                    let vc = PasswordLoginViewController()
                    vc.isHasChangeToOtherLoginMethod = true
                    let navVC = UINavigationController(rootViewController: vc)
                    navVC.modalPresentationStyle = .fullScreen
                    self.present(navVC, animated: false)
                }
            }
        }
    }
    
    // MARK: - Private
    
    private func setupUI() {
        homeTableView.fw.registerCellNib(HomeOverviewTableViewCell.self)
        homeTableView.fw.registerCellNib(HomeMarketTableViewCell.self)
        homeTableView.fw.registerCellNib(HomeRecentTransactionsTableViewCell.self)
    }
    
    private func verifyKycAction() {
        indicator.startAnimating()
        KYCRequest.info { isSuccess, message, data in
            self.indicator.stopAnimating()
            if isSuccess {
                let vc = KYCUnAvailableViewController()
                vc.hidesBottomBarWhenPushed = true
                vc.source = .home
                vc.kycStatus = data?.kycStatus ?? .notStarted
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = KYCUnAvailableViewController()
                vc.hidesBottomBarWhenPushed = true
                vc.source = .home
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func personalCenterAction(_ sender: Any) {
        let vc = UserCenterViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return HomeOverviewTableViewCell.height()
        }
        if indexPath.row == 1 {
            return HomeMarketTableViewCell.height()
        }
        return HomeRecentTransactionsTableViewCell.height()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.fw.dequeue(cellType: HomeOverviewTableViewCell.self, for: indexPath)
            cell.delegate = self
            return cell
        }
        if indexPath.row == 1 {
            let cell = tableView.fw.dequeue(cellType: HomeMarketTableViewCell.self, for: indexPath)
            return cell
        }
        let cell = tableView.fw.dequeue(cellType: HomeRecentTransactionsTableViewCell.self, for: indexPath)
        cell.delegate = self
        return cell
    }
    
}

extension HomeViewController: HomeOverviewTableViewCellDelegate, HomeRecentTransactionsTableViewCellDelegate {
    func didSelectedViewTheAll(_ cell: HomeRecentTransactionsTableViewCell) {
        let vc = HomeTransactionsViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didSelectedVerify(_ cell: HomeOverviewTableViewCell) {
        verifyKycAction()
    }
    
    func didSelectedAddCard(_ cell: HomeOverviewTableViewCell) {
        let vc = ApplyCardViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didSelectedWallet(_ cell: HomeOverviewTableViewCell) {
        navigationController?.tabBarController?.selectedIndex = 1
    }
    
    func didSelectedTopup(_ cell: HomeOverviewTableViewCell) {
        let vc = SellCryptoViewController ()
        vc.hidesBottomBarWhenPushed = true
        vc.source = .home
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

