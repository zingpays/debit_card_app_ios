//
//  CardDetailViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/3.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class CardDetailViewController: BaseViewController {
    
    @IBOutlet weak var cardTableView: UITableView!
    
    private var cardList: [CardModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    override func backAction() {
        if let vc = navigationController?.viewControllers.filter({ subVC in
            if subVC.isMember(of: CardViewController.self) {
                return true
            } else {
                return false
            }
        }).first {
            navigationController?.popToViewController(vc, animated: true)
        }
    }
    
    // MAEK: - Private
    
    private func setupUI() {
        cardTableView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT + 26)
        }
        cardTableView.fw.registerCellNib(CardTableViewCell.self)
        gk_navTitle = R.string.localizable.cardDetail()
    }
    
    private func setupData() {
        requestCardList()
    }

    // MARK: - Network
    
    private func requestCardList() {
        indicator.startAnimating()
        CardRequest.list { [weak self] isSuccess, message, list in
            guard let this = self else { return }
            this.indicator.stopAnimating()
            if isSuccess {
                if let list = list, !list.isEmpty {
                    this.cardList = list
                    this.cardTableView.reloadData()
                }
            } else {
                this.view.makeToast(message, position: .center)
            }
        }
    }
}

extension CardDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cardList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.fw.dequeue(cellType: CardTableViewCell.self, for: indexPath)
        cell.selectionStyle = .none
        let data = cardList[indexPath.row]
        cell.update(data: data)
        return cell
    }
    
}
