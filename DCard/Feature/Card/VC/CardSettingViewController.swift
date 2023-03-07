//
//  CardSettingViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/3.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class CardSettingViewController: BaseViewController {

    @IBOutlet weak var cardTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // , R.string.localizable.writeOffCard() 卡注销暂时隐藏
    var titles = [R.string.localizable.freezeCard()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT + 26)
        }
        titleLabel.text = R.string.localizable.cardSetting()
        cardTableView.fw.registerCellNib(CardSettingTableViewCell.self)
    }

}

extension CardSettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.fw.dequeue(cellType: CardSettingTableViewCell.self, for: indexPath)
//        if indexPath.row == 2 {
//            cell.updateData(type: .content)
//        }
        cell.titleLabel.text = titles[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 || indexPath.row == 1 {
            let title: String = {
                if indexPath.row == 0 {
                    return R.string.localizable.cardSettingFreezeCardTitle()
                }
                if indexPath.row == 1 {
                    return R.string.localizable.cardSettingWriteOffCardTitle()
                }
                return ""
            }()
            let subTitle: String = {
                if indexPath.row == 0 {
                    return R.string.localizable.cardSettingFreezeCardDesc()
                }
                if indexPath.row == 1 {
                    return R.string.localizable.cardSettingWriteOffCardDesc()
                }
                return ""
            }()
            let sureActionText: String = {
                if indexPath.row == 0 {
                    return R.string.localizable.sureToFreeze()
                }
                if indexPath.row == 1 {
                    return R.string.localizable.sureToWriteOff()
                }
                return ""
            }()
            let alert = UIAlertController(title: title, message: subTitle, preferredStyle: .alert)
            let toFreezeAction = UIAlertAction(title: sureActionText, style: .default) { action in
                let vc = FreezeSuccessViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            let cancelAction = UIAlertAction(title: R.string.localizable.cancel(), style: .cancel)
            alert.addAction(cancelAction)
            alert.addAction(toFreezeAction)
            self.present(alert, animated: true)
        }
    }
}
