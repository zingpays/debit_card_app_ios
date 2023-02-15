//
//  ChooseRegionViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/12.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class ChooseRegionViewController: UIViewController {

    /// selected callback
    var didSelectedCompletion: ((ChooseRegionModel) -> Void)? = nil
    /// page title
    var pageTitle: String? = nil
    /// data source
    var datasource: [ChooseRegionModel] = []
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.placeholder = R.string.localizable.chooseYourCountryInputPlaceholder()
        }
    }
    @IBOutlet weak var resultTableview: UITableView!
    
    // MARK: - Init
    
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
        cell.countryLabel.text = data.title
        cell.codeLabel.text = data.subTitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = datasource[indexPath.row]
        didSelectedCompletion?(data)
        self.dismiss(animated: true)
    }
}
