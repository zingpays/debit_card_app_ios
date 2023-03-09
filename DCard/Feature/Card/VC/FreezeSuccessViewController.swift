//
//  FreezeSuccessViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/3.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class FreezeSuccessViewController: BaseViewController {

    private var titleText: String
    private var subTitleText: String
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    init(title: String, subTitle: String) {
        titleText = title
        subTitleText = subTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleText
        subtitleLabel.text = subTitleText
    }
    
    override func setupNavBar() {}
    
    @IBAction func doneAction(_ sender: Any) {
        if let vc = navigationController?.viewControllers.filter({ subVC in
            if subVC.isMember(of: CardSettingViewController.self) {
                return true
            } else {
                return false
            }
        }).first {
            navigationController?.popToViewController(vc, animated: true)
        }
    }
}
