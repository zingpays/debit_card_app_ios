//
//  AuthSettingGuideViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/21.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class AuthSettingGuideViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = R.string.localizable.patternAuthGuideTitle()
        }
    }
    
    @IBOutlet weak var subTitleLabel: UILabel! {
        didSet {
            subTitleLabel.text = R.string.localizable.patternAuthGuideSubTitle()
        }
    }
    
    @IBOutlet weak var downloadCollectionView: UICollectionView! {
        didSet {
            downloadCollectionView.collectionViewLayout = flowLayout
        }
    }
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var downloadCollectionViewHeight: NSLayoutConstraint!
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        let width = (SCREENWIDTH-32-12)*0.5
        layout.itemSize = CGSize(width: width, height: width)
        return layout
    }()
    
    private lazy var datasource: [AuthDownloadCollectionViewCellModel] = [AuthDownloadCollectionViewCellModel(icon: R.image.iconAppleStore(),title: "iOS", store: R.string.localizable.patternAuthAppStore()), AuthDownloadCollectionViewCellModel(icon: R.image.iconGooglePlay(),title: "Android", store: R.string.localizable.patternAuthGooglePlay())]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Private
    
    private func setupUI() {
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT + 26)
        }
        downloadCollectionView.fw.registerCellNib(AuthDownloadCollectionViewCell.self)
        downloadCollectionViewHeight.constant = (SCREENWIDTH-32-12)*0.5
        nextButton.setTitle(R.string.localizable.patternAuthNext(), for: .normal)
    }
    
    // MARK: - Actions
    
    @IBAction func nextAction(_ sender: Any) {
        let vc = AuthSettingQRCodeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension AuthSettingGuideViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.fw.dequeue(cellType: AuthDownloadCollectionViewCell.self, for: indexPath)
        let data = datasource[indexPath.row]
        cell.update(data: data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = URL(string: "itms-apps://itunes.apple.com/app/id388497605")
        guard UIApplication.shared.canOpenURL(url!) else { return }
        UIApplication.shared.open(url!)
    }
    
}
