//
//  KYCUnAvailableViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/29.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class KYCUnAvailableViewController: BaseViewController {
    
    var source: VerifyYourIdentitySource = .home
    
    var kycStatus: KycStatus = .notStarted
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var toVerifyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Private
    
    private func setupUI() {
        titleLabel.text = R.string.localizable.featureIsNotAvailableYet()
        subTitleLabel.text = R.string.localizable.featureIsNotAvailableYetTips()
        toVerifyButton.setTitle(R.string.localizable.toVerify(), for: .normal)
    }
    
    // MARK: - Actions

    @IBAction func toVerifyAction(_ sender: Any) {
        switch kycStatus {
        case .notStarted, .start, .inProgress:
            let vc = VerifyYourIdentityGuideViewController()
            vc.source = source
            navigationController?.pushViewController(vc, animated: true)
        case .submitted, .inReview:
            let vc = KYCFinishViewController()
            navigationController?.pushViewController(vc, animated: true)
        case .approved:
            // 不会到这个页面
            break
        case .rejected:
            let alert = UIAlertController(title: "Tips", message: R.string.localizable.featureIsNotAvailableRejectTips(), preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Got It", style: .cancel)
            alert.addAction(cancelAction)
            self.present(alert, animated: true)
        case .resubmitted:
            let vc = KYCFillInNameAndNationalViewController()
            vc.kycStatus = kycStatus
            vc.source = source
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
