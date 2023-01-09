//
//  GuideViewController.swift
//  Flashwire
//
//  Created by Fei Zhang on 2022/12/30.
//  Copyright © 2022 Zing Tech. All rights reserved.
//

import UIKit
import FSPagerView

class GuideViewController: UIViewController {
    @IBOutlet weak var guidePagerView: FSPagerView! {
        didSet {
            guidePagerView.register(UINib(nibName: "GuidePagerViewCell", bundle: nil), forCellWithReuseIdentifier: "GuidePagerViewCell")
            guidePagerView.backgroundColor = .clear
        }
    }
    @IBOutlet weak var pageControl: FSPageControl! {
        didSet {
            pageControl.interitemSpacing = 18
            pageControl.setFillColor(R.color.color00A9B5()?.withAlphaComponent(0.14), for: .normal)
            pageControl.setFillColor(R.color.color00A9B5(), for: .selected)
            pageControl.setPath(UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 18, height: 4), cornerRadius: 6), for: .selected)
            pageControl.setPath(UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 18, height: 4), cornerRadius: 6), for: .normal)
        }
    }
    @IBOutlet weak var registerButton: UIButton! {
        didSet {
            registerButton.setTitleColor(R.color.colorFFFFFF()?.withAlphaComponent(0.2), for: .normal)
            registerButton.tintColor = R.color.colorFFFFFF()?.withAlphaComponent(0.2)
            registerButton.backgroundColor = R.color.colorFFFFFF()?.withAlphaComponent(0.12)
        }
    }
    @IBOutlet weak var loginButton: UIButton!
    /// collection view data source
    private var guideDatas: [GuideCollectionModel] = []
    /// index of page displayed
    var selectedIndex: Int = 0
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        navigationController?.navigationBar.isHidden = true
        setupGradientBackground()
        pageControl.numberOfPages = guideDatas.count
    }
    
    private func setupData() {
        let guideData1 = GuideCollectionModel(title: "Your debit card, Cashback", imageName: "guide_bg_intro_1", desc: "Up to 2% cashback on spending on your AURO debit card.")
        let guideData2 = GuideCollectionModel(title: "Meet your global payment needs", imageName: "guide_bg_intro_2", desc: "With AURO credit card, you can pay easily include Online purchases.")
        let guideData3 = GuideCollectionModel(title: "Your international travel, Easily", imageName: "guide_bg_intro_3", desc: "Travel the world with one card, no need to exchange currency, can easily support your travel expenses.")
        let guideData4 = GuideCollectionModel(title: "Your Crypto, Pay for Everything", imageName: "guide_bg_intro_4", desc: "You can sell crypto to the money in the debit card for consumption.")
        guideDatas = [guideData1, guideData2, guideData3, guideData4]
    }
    
    private func setupGradientBackground() {
        let bgLayer = CAGradientLayer()
        bgLayer.colors = [R.color.color008999()!.cgColor, R.color.color004396()!.cgColor]
        bgLayer.locations = [0, 1]
        bgLayer.frame = UIScreen.main.bounds
        bgLayer.startPoint = CGPoint(x: 0, y: 0)
        bgLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(bgLayer, at: 0)
    }
    
    // MARK: - Actions
    
    @IBAction func registerActon(_ sender: Any) {
//        let vc = RegisterViewController()
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func loginAction(_ sender: Any) {
//        let vc = LoginViewController()
//        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - FSPagerViewDataSource && FSPagerViewDelegate

extension GuideViewController: FSPagerViewDataSource, FSPagerViewDelegate {
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return guideDatas.count
    }
        
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "GuidePagerViewCell", at: index)
        cell.contentView.layer.shadowColor = UIColor.clear.cgColor
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        if let guideCell = cell as? GuidePagerViewCell {
            let data = guideDatas[index]
            guideCell.guideImageView?.image = UIImage(named: data.imageName)
            guideCell.titleLabel?.text = data.title
            guideCell.descLabel?.text = data.desc
        }
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        pageControl.currentPage = pagerView.currentIndex
    }
}
