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
        UserManager.shared.formatMail()
        setupData()
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
            // 首先检测是否解锁
            // 没解锁
            // 先检测是否绑定生物识别，然后检测师傅绑定手势
            // 如果绑定了，就展示对应的锁屏页面
            // 如果没有绑定，就展示密码锁屏
            // 解除锁屏后，检测是否展示过引导页
            // 如果没有展示过引导页，先检测生物识别是否可用，可用展示生物识别的引导，否则展示手势引导
            // 如果展示过，就展示首页
            
            if LocalAuthenManager.shared.isAuthorized {
                // 已解锁
                if !LocalAuthenManager.shared.isSkiped {
                    if LocalAuthenManager.shared.isAvailable && !LocalAuthenManager.shared.isBind {
                        // 生物识别引导
                        let lockScreenVC = BiometricsViewController()
                        lockScreenVC.isGuide = true
                        lockScreenVC.isHasChangeToOtherLoginMethod = false
                        let navVC = UINavigationController(rootViewController: lockScreenVC)
                        navVC.modalPresentationStyle = .fullScreen
                        self.present(navVC, animated: false)
                    } else if LockScreenManager.shared.password == nil && !LocalAuthenManager.shared.isAvailable {
                        // 手势引导
                        let vc = NineGraphLockScreenViewController()
                        vc.isGuide = true
                        vc.style = .set
                        vc.isHasChangeToOtherLoginMethod = false
                        vc.patternTitle = R.string.localizable.guidePatternTitle()
                        vc.tips = R.string.localizable.patternForgotTips()
                        let navVC = UINavigationController(rootViewController: vc)
                        navVC.modalPresentationStyle = .fullScreen
                        self.present(navVC, animated: false)
                    }
                }
            } else {
                // 未解锁
                if LocalAuthenManager.shared.isAvailable && LocalAuthenManager.shared.isBind {
                    let lockScreenVC = BiometricsViewController()
                    lockScreenVC.isHasChangeToOtherLoginMethod = true
                    let navVC = UINavigationController(rootViewController: lockScreenVC)
                    navVC.modalPresentationStyle = .fullScreen
                    self.present(navVC, animated: false)
                } else if (LockScreenManager.shared.password?.count ?? 0) > 0 {
                    let vc = NineGraphLockScreenViewController()
                    vc.patternTitle = R.string.localizable.patternLogin()
                    vc.style = .verify
                    vc.isHasChangeToOtherLoginMethod = true
                    let navVC = UINavigationController(rootViewController: vc)
                    navVC.modalPresentationStyle = .fullScreen
                    self.present(navVC, animated: false)
                } else {
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
    
    private func setupData() {
        requestUserStatus()
    }
    
    // MARK: - Network
    
    private func requestUserStatus() {
        KYCRequest.status { isSuccess, _, data in
            if isSuccess {
                UserManager.shared.status = data
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
        // resubmitted状态点击的时候才会有跳转
        let vc = KYCFillInNameAndNationalViewController()
        vc.kycStatus = .resubmitted
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didSelectedAddCard(_ cell: HomeOverviewTableViewCell) {
        guard let kycStatus = UserManager.shared.status?.kycStatus else { return }
        switch kycStatus {
        case .notStarted, .start, .inProgress:
            let vc = VerifyYourIdentityGuideViewController()
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

