//
//  CryptoWalletCardView.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/6.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit
import Charts

protocol CryptoWalletCardViewDelegate: NSObject {
    func didSelectedSell(_ view: CryptoWalletCardView)
    func didSelectedDeposit(_ view: CryptoWalletCardView)
    func didSelectedWithdraw(_ view: CryptoWalletCardView)
}

class CryptoWalletCardView: UIView, NibLoadable {
    
    @IBOutlet weak var cardView: UIView! {
        didSet {
            cardView.insertSubview(lineChartView, at: 1)
            lineChartView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.bottom.equalToSuperview().offset(10)
                make.left.equalToSuperview().offset(-10)
                make.right.equalToSuperview().offset(10)
            }
        }
    }
    
    private lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        var entries = [ChartDataEntry]()
        for i in 0...15 {
            let entry = ChartDataEntry(x: Double(i), y: Double(arc4random_uniform(50)) + 10)
            entries.append(entry)
        }
        let set = LineChartDataSet(entries: entries, label: "")
        let data = LineChartData(dataSet: set)
        chartView.data = data
        set.drawFilledEnabled = true
        set.fillAlpha = 0.2
        set.fillColor = .white.withAlphaComponent(0.3)
        set.lineCapType = .round
        set.lineWidth = 3
        set.drawCirclesEnabled = false
        set.mode = .cubicBezier
        set.form = .empty
        set.colors = [.white.withAlphaComponent(0.2)]
        chartView.maxVisibleCount = 0
        chartView.legend.enabled = false
        chartView.xAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.dragEnabled = false
        return chartView
    }()
    
    var delegate: CryptoWalletCardViewDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupGradientBackground()
    }
    
    private func setupGradientBackground() {
        let bgLayer = CAGradientLayer()
        bgLayer.colors = [R.color.fw00C0B3()!.cgColor,
                          R.color.fw095CAB()!.cgColor]
        bgLayer.locations = [0, 1]
        bgLayer.frame = cardView.bounds
        bgLayer.startPoint = .zero
        bgLayer.endPoint = CGPoint(x: 1, y: 0)
        bgLayer.opacity = 0.8
        cardView.layer.insertSublayer(bgLayer, at: 0)
    }
    
    @IBAction func sellAction(_ sender: Any) {
        delegate?.didSelectedSell(self)
    }
    
    @IBAction func depositAction(_ sender: Any) {
        delegate?.didSelectedDeposit(self)
    }
    
    @IBAction func withdrawAction(_ sender: Any) {
        delegate?.didSelectedWithdraw(self)
    }
    
}
