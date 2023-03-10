//
//  TransactionsFilterViewController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/2.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit
import JFPopup

protocol TransactionsFilterViewControllerDelegate: NSObject {
    func didSelected(cardType: FilterTypeModel, date: FilterDateModel)
}

class TransactionsFilterViewController: BaseViewController {
    
    weak var delegate: TransactionsFilterViewControllerDelegate? = nil
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    private let headerTitle: Array = [R.string.localizable.cardType(), R.string.localizable.type(), R.string.localizable.date()]
    private let cardTypeDatas: [FilterTypeModel] = [FilterTypeModel(type: .card, isSelected: true)]
    private let typeDatas: [FilterTypeModel] = [FilterTypeModel(type: .all, isSelected: true),
                                                FilterTypeModel(type: .deposit),
                                                FilterTypeModel(type: .consume),
                                                FilterTypeModel(type: .consumeRefund),
                                                FilterTypeModel(type: .rebate)]
    private let dateDatas: [FilterDateModel] = [FilterDateModel()]
    
    
    private lazy var closeItem: UIBarButtonItem = {
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 4, width: 36, height: 36)
        btn.backgroundColor = ISNOTCH() ? .white : .clear
        btn.layer.cornerRadius = 12
        btn.setImage(R.image.iconCloseButton(), for: .normal)
        btn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        return UIBarButtonItem(customView: btn)
    }()
    
    private lazy var rightItem: UIBarButtonItem = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 4, width: 84, height: 36)
        let refreshBtn = UIButton()
        v.addSubview(refreshBtn)
        refreshBtn.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(36)
        }
        refreshBtn.setImage(R.image.iconRefreshButton(), for: .normal)
        refreshBtn.addTarget(self, action: #selector(refreshAction), for: .touchUpInside)
        refreshBtn.backgroundColor = R.color.fw00A8BB()
        refreshBtn.layer.cornerRadius = 12
        let exactitudeBtn = UIButton()
        v.addSubview(exactitudeBtn)
        exactitudeBtn.snp.makeConstraints { make in
            make.left.equalTo(refreshBtn.snp.right).offset(12)
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(36)
        }
        exactitudeBtn.layer.cornerRadius = 12
        exactitudeBtn.addTarget(self, action: #selector(exactitudeAction), for: .touchUpInside)
        exactitudeBtn.backgroundColor = R.color.fwFAFAFA()
        exactitudeBtn.setImage(R.image.iconExactitudeButton(), for: .normal)
        return UIBarButtonItem(customView: v)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func setupNavBar() {
        super.setupNavBar()
        self.gk_navLeftBarButtonItem = closeItem
        self.gk_navRightBarButtonItem = rightItem
        self.gk_navItemRightSpace = 16
    }
    
    // MARK: - Private
    
    private func setupUI() {
        setupSubviews()
    }

    private func setupSubviews() {
        let bgLayer = CAGradientLayer()
        bgLayer.colors = [R.color.fw008999()!.cgColor,
                          R.color.fw004396()!.cgColor]
        bgLayer.locations = [0, 1]
        bgLayer.frame = CGRect(origin: .zero, size: CGSize(width: SCREENWIDTH, height: SCREENHEIGHT))
        bgLayer.startPoint = .zero
        bgLayer.endPoint = CGPoint(x: 0.79, y: 0.79)
        bgLayer.opacity = 1
        backgroundView.layer.insertSublayer(bgLayer, at: 0)
        backgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(NAVBARHEIGHT+20)
        }
        filterCollectionView.fw.registerCellNib(TransactionsFilterCollectionViewCell.self)
        filterCollectionView.fw.registerCellNib(TransactionsFilterDateCollectionViewCell.self)
        filterCollectionView.register(TransactionsFilterCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TransactionsFilterCollectionHeaderView")

    }
    
    // MARK: - Actions
    
    @objc private func refreshAction() {
        
    }
    
    @objc private func exactitudeAction() {
        let cardType = typeDatas.filter { item in
            return item.isSelected
        }.first
        if let cardType = cardType, let date = dateDatas.first {
            delegate?.didSelected(cardType: cardType, date: date)
            self.dismiss(animated: true)
        }
    }
    
    @objc private func closeAction() {
        self.dismiss(animated: true)
    }
}

extension TransactionsFilterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if section == 2 {
            return 1
        }
        return typeDatas.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 2 {
            let cell = collectionView.fw.dequeue(cellType: TransactionsFilterDateCollectionViewCell.self, for: indexPath)
            cell.layer.cornerRadius = 12
            cell.delegate = self
            cell.update(data: dateDatas[indexPath.row])
            return cell
        }
        let cell = collectionView.fw.dequeue(cellType: TransactionsFilterCollectionViewCell.self, for: indexPath)
        cell.layer.cornerRadius = 12
        if indexPath.section == 0 {
            cell.update(data: cardTypeDatas[indexPath.row])
        } else {
            cell.update(data: typeDatas[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 100, height: 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableview: TransactionsFilterCollectionHeaderView!
        if kind == UICollectionView.elementKindSectionHeader {
            reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TransactionsFilterCollectionHeaderView", for: indexPath) as? TransactionsFilterCollectionHeaderView
            reusableview.backgroundColor = .clear
            reusableview.content.text = headerTitle[indexPath.section]
        }
        return reusableview
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 2 {
            return CGSize(width: collectionView.width-16, height: 40)
        }
        let str: String = {
            if indexPath.row == 0 {
                return cardTypeDatas[indexPath.row].type.formatName()
            } else {
                return typeDatas[indexPath.row].type.formatName()
            }
        }()
        let dic = [NSAttributedString.Key.font: UIFont.fw.font16()]
        let size = CGSize(width: CGFloat(MAXFLOAT), height: 19)
        let width = str.boundingRect(with: size,
                                     options: .usesLineFragmentOrigin,
                                     attributes: dic,
                                     context: nil).size.width
        return CGSize(width: width+40, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            for data in typeDatas {
                if data.type == typeDatas[indexPath.row].type {
                    data.isSelected = true
                } else {
                    data.isSelected = false
                }
            }
            collectionView.reloadData()
        }
    }
    
}

extension TransactionsFilterViewController: TransactionsFilterDateCollectionViewCellDelegate {
    func didSelectedStartDate() {
        popup.bottomSheet {
            let v = ChooseDateView.loadFromNib()
            v.viewId = 100
            v.frame = CGRect(origin: .zero, size: CGSize(width: SCREENWIDTH, height: 292 + TOUCHBARHEIGHT))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = .init(origin: .zero,
                                    size: .init(width: SCREENWIDTH, height: 292 + TOUCHBARHEIGHT))
            maskLayer.path = UIBezierPath(roundedRect: .init(origin: .zero, size: maskLayer.frame.size),
                                          byRoundingCorners: [.topLeft, .topRight],
                                          cornerRadii: .init(width: 32, height: 32)).cgPath
             v.layer.mask = maskLayer
            v.delegate = self
            return v
        }
    }
    
    func didSelectedEndDate() {
        popup.bottomSheet {
            let v = ChooseDateView.loadFromNib()
            v.viewId = 200
            v.frame = CGRect(origin: .zero, size: CGSize(width: SCREENWIDTH, height: 292 + TOUCHBARHEIGHT))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = .init(origin: .zero,
                                    size: .init(width: SCREENWIDTH, height: 292 + TOUCHBARHEIGHT))
            maskLayer.path = UIBezierPath(roundedRect: .init(origin: .zero, size: maskLayer.frame.size),
                                          byRoundingCorners: [.topLeft, .topRight],
                                          cornerRadii: .init(width: 32, height: 32)).cgPath
             v.layer.mask = maskLayer
            v.delegate = self
            return v
        }
    }
    
}

extension TransactionsFilterViewController: ChooseDateViewDelegate {
    func didSelectedOK(_ view: ChooseDateView, date: Date) {
        popup.dismissPopup()
        if view.viewId == 100 {
            dateDatas.first?.from = date
        }
        if view.viewId == 200 {
            dateDatas.first?.to = date
        }
        filterCollectionView.reloadData()
    }
}

