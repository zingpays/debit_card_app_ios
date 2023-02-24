//
//  SellCryptoViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/7.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit
import JFPopup

enum SellCryptoSource {
    case home
    case wallet
}

class SellCryptoViewController: BaseViewController {
    
    var source: SellCryptoSource = .wallet
    
    private lazy var rightItem: UIBarButtonItem = {
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 4, width: 36, height: 36)
        btn.layer.cornerRadius = 18
        btn.setImage(R.image.iconRecordBtn(), for: .normal)
        btn.addTarget(self, action: #selector(recordAction), for: .touchUpInside)
        return UIBarButtonItem(customView: btn)
    }()
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var inputContentView: UIView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceTagLabel: UILabel!
    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var balanceView: UIView!
    @IBOutlet weak var balanceNumLabel: UILabel!
    @IBOutlet weak var depositView: UIView!
    @IBOutlet weak var depositInfoLabel: UILabel!
    @IBOutlet weak var cryptoBalanceLabel: UILabel!
    @IBOutlet weak var makeDepositButton: UIButton!
    @IBOutlet weak var inputUsdtLabel: UILabel!
    @IBOutlet weak var topUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        self.gk_navTitle = R.string.localizable.topUpDebitCard()
        setupRightItem()
        boardView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(NAVBARHEIGHT + 26)
        }
        statusLabel.textColor = R.color.fw000000()?.withAlphaComponent(0.4)
        inputTextField.textColor = R.color.fw000000()?.withAlphaComponent(0.3)
        priceLabel.textColor = R.color.fw000000()?.withAlphaComponent(0.3)
        priceTagLabel.textColor = R.color.fw000000()?.withAlphaComponent(0.3)
        line.backgroundColor = R.color.fw000000()?.withAlphaComponent(0.05)
        balanceNumLabel.textColor = R.color.fw000000()?.withAlphaComponent(0.3)
        depositInfoLabel.textColor = R.color.fw000000()?.withAlphaComponent(0.6)
        cryptoBalanceLabel.text = R.string.localizable.cryptoBalance()
        makeDepositButton.setTitle(R.string.localizable.makeADeposit(), for: .normal)
        depositInfoLabel.text = R.string.localizable.makeDepositInfo()
        inputUsdtLabel.textColor = R.color.fw000000()?.withAlphaComponent(0.3)
        topUpButton.backgroundColor = R.color.fw00A8BB()?.withAlphaComponent(0.4)
    }
    
    private func setupRightItem() {
        self.gk_navRightBarButtonItem = rightItem
        self.gk_navItemRightSpace = 16
    }
    
    private func inputBeginEditing() {
        inputContentView.layer.borderColor = R.color.fw00A8BB()?.cgColor
        inputContentView.layer.borderWidth = 2
        line.backgroundColor = R.color.fw00A8BB()?.withAlphaComponent(0.3)
    }
    
    private func inputViewEndEditing() {
        inputContentView.layer.borderWidth = 0
        line.backgroundColor = R.color.fw000000()?.withAlphaComponent(0.05)
    }

    // MARK: - Actions
    
    @IBAction func filterAction(_ sender: Any) {
        popup.bottomSheet {
            let v = DepositFromView.loadFromNib()
            v.frame = CGRect(origin: .zero, size: CGSize(width: SCREENWIDTH, height: 368 + TOUCHBARHEIGHT))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = .init(origin: .zero,
                                    size: .init(width: SCREENWIDTH, height: 368 + TOUCHBARHEIGHT))
            maskLayer.path = UIBezierPath(roundedRect: .init(origin: .zero, size: maskLayer.frame.size),
                                          byRoundingCorners: [.topLeft, .topRight],
                                          cornerRadii: .init(width: 32, height: 32)).cgPath
             v.layer.mask = maskLayer
            v.delegate = self
            return v
        }
    }
    
    @objc private func recordAction() {
        switch source {
        case .home:
            let vc = TopupHistoryViewController()
            navigationController?.pushViewController(vc, animated: true)
        case .wallet:
            let vc = WalletTransactionsViewController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func sellCryptoAction(_ sender: Any) {
        popup.bottomSheet {
            let v = SellCryptoConfirmView.loadFromNib()
            v.frame = CGRect(origin: .zero, size: CGSize(width: SCREENWIDTH, height: 447 + TOUCHBARHEIGHT))
            let bgLayer = CAGradientLayer()
            bgLayer.colors = [R.color.fw008999()!.cgColor,
                              R.color.fw004396()!.cgColor]
            bgLayer.locations = [0, 1]
            bgLayer.frame = v.bounds
            bgLayer.startPoint = .zero
            bgLayer.endPoint = CGPoint(x: 0.79, y: 0.79)
            bgLayer.opacity = 0.1
            v.layer.insertSublayer(bgLayer, at: 0)
            let maskLayer = CAShapeLayer()
            maskLayer.frame = .init(origin: .zero,
                                    size: .init(width: SCREENWIDTH, height: 447+TOUCHBARHEIGHT))
            maskLayer.path = UIBezierPath(roundedRect: .init(origin: .zero, size: maskLayer.frame.size),
                                          byRoundingCorners: [.topLeft, .topRight],
                                          cornerRadii: .init(width: 32, height: 32)).cgPath
             v.layer.mask = maskLayer
            v.delegate = self
            return v
        }
    }
    
    @IBAction func makeDepositAction(_ sender: Any) {
        popup.bottomSheet {
            let v = DepositFromView.loadFromNib()
            v.identifier = "Deposit"
            v.titleLabel.text = "Deposit"
            v.subTitleLabel.text = "Choose a crypto to deposit"
            v.frame = CGRect(origin: .zero, size: CGSize(width: SCREENWIDTH, height: 368 + TOUCHBARHEIGHT))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = .init(origin: .zero,
                                    size: .init(width: SCREENWIDTH, height: 368 + TOUCHBARHEIGHT))
            maskLayer.path = UIBezierPath(roundedRect: .init(origin: .zero, size: maskLayer.frame.size),
                                          byRoundingCorners: [.topLeft, .topRight],
                                          cornerRadii: .init(width: 32, height: 32)).cgPath
             v.layer.mask = maskLayer
            v.delegate = self
            return v
        }
    }
    
}

extension SellCryptoViewController: DepositFromViewDelegate {
    func didSelectedRecord(_ view: DepositFromView) {}
    
    func didSelectedDepositItem(_ view: DepositFromView) {
        popup.dismissPopup()
    }
}

extension SellCryptoViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        inputBeginEditing()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        inputViewEndEditing()
    }
}

extension SellCryptoViewController: SellCryptoConfirmViewDelegate {
    func didSelectedContinue() {
        popup.dismissPopup()
        switch source {
        case .home:
            let vc = TransactionsDetailViewController()
            navigationController?.pushViewController(vc, animated: true)
        case .wallet:
            print("")
        }
    }
    
}
