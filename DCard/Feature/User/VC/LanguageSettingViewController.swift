//
//  LanguageSettingViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/17.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class LanguageSettingViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = R.string.localizable.language()
        }
    }
    @IBOutlet weak var languageTableView: UITableView! {
        didSet {
            languageTableView.delegate = self
            languageTableView.dataSource = self
        }
    }
    private var datasource: [LanguageModel] = {
        let isSelected = LocalizationManager.shared.currentLanguage() == .en
        return [LanguageModel(title: "English", isSelected: isSelected),
                LanguageModel(title: "简体中文", isSelected: !isSelected)]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT + 20)
        }
        languageTableView.fw.registerCellNib(LanguageTableViewCell.self)
    }
    
}

extension LanguageSettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for item in datasource {
            item.isSelected = false
        }
        let data = datasource[indexPath.row]
        data.isSelected = true
        tableView.reloadData()
        if indexPath.row == 0 {
            LocalizationManager.shared.setupLanguage(.en)
            UIApplication.shared.delegate?.rebootApplication()
        } else {
            LocalizationManager.shared.setupLanguage(.zh)
            UIApplication.shared.delegate?.rebootApplication()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.fw.dequeue(cellType: LanguageTableViewCell.self, for: indexPath)
        cell.selectionStyle = .none
        cell.updateData(data: datasource[indexPath.row])
        return cell
    }
    
    
}
