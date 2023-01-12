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
    var didSelectedCompletion: ((String) -> Void)? = nil
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        titleLabel.font = .fw.font20(weight: .bold)
        resultTableview.fw.registerCellNib(ChooseRegionTableViewCell.self)
        searchBar.becomeFirstResponder()
    }

}

// MARK: - UITableViewDelegate && UITableViewDataSource

extension ChooseRegionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.fw.dequeue(cellType: ChooseRegionTableViewCell.self, for: indexPath)
        cell.countryLabel.text = "China"
        cell.codeLabel.text = "\(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectedCompletion?("\(indexPath.row)")
        self.dismiss(animated: true)
    }
}
