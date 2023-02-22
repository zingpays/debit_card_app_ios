//
//  AuthDownloadCollectionViewCell.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/21.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

struct AuthDownloadCollectionViewCellModel {
    var icon: UIImage?
    var title: String
    var store: String
}

class AuthDownloadCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var platformLabel: UILabel! {
        didSet {
            platformLabel.text = R.string.localizable.patternAuthDownloadFrom()
        }
    }
    @IBOutlet weak var storeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(data: AuthDownloadCollectionViewCellModel) {
        iconImageView.image = data.icon
        titleLabel.text = data.title
        storeLabel.text = data.store
    }

}
