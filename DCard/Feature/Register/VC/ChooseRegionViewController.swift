//
//  ChooseRegionViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/12.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

enum ChooseRegionStyle {
    case code
    case noCode
}

class ChooseRegionViewController: UIViewController {

    /// selected callback
    var didSelectedCompletion: ((RegionModel) -> Void)? = nil
    /// page title
    var pageTitle: String? = nil
    /// data source
    var datasource: [RegionModel] = []
    var datasourceOld: [RegionModel] = []
    
    var style: ChooseRegionStyle = .code
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.placeholder = R.string.localizable.chooseYourCountryInputPlaceholder()
        }
    }
    @IBOutlet weak var resultTableview: UITableView!
    
    // MARK: - Init
    
    init(style: ChooseRegionStyle) {
        self.style = style
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        titleLabel.font = .fw.font20(weight: .bold)
        titleLabel.text = pageTitle
        resultTableview.fw.registerCellNib(ChooseRegionTableViewCell.self)
        searchBar.becomeFirstResponder()
        datasourceOld = datasource
    }

}

// MARK: - UITableViewDelegate && UITableViewDataSource

extension ChooseRegionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.fw.dequeue(cellType: ChooseRegionTableViewCell.self, for: indexPath)
        let data = datasource[indexPath.row]
        let text = {
            var value = LocalizationManager.shared.currentLanguage() == .zh ? data.nameZh ?? "" : data.nameEn ?? ""
            if value.isEmpty { value = data.nameEn ?? "" }
            return value
        }()
        cell.countryLabel.text = text
        cell.codeLabel.text = style == .noCode ? "" : data.phoneCode
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = datasource[indexPath.row]
        didSelectedCompletion?(data)
        self.dismiss(animated: true)
    }
}

extension ChooseRegionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var datas: [RegionModel] = []
        datas = datasourceOld.filter({ region in
            if searchText.isEmpty { return true }
            if let phoneCode = region.phoneCode, searchText.isDigits {
                return phoneCode.contains(searchText)
            }
            if LocalizationManager.shared.currentLanguage() == .zh {
                if let name = region.nameZh {
                    return name.contains(searchText)
                }
            } else {
                if let name = region.nameEn {
                    return name.contains(searchText)
                }
            }
            return false
        })
        datasource = datas
        resultTableview.reloadData()
    }
}
