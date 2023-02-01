//
//  CardViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/29.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

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
    
    // MARK: - Private
    
    private func setupUI() {
        titleLabel.font = UIFont.fw.font20(weight: .bold)
        cardTableView.fw.registerCellNib(EmptyCardTableViewCell.self)
    }
    
    private func setupData() {
        
    }
    
    // MARK: - Action
    
    @IBAction func addCardAction(_ sender: Any) {
        
    }
    
}

extension CardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 417
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
