//
//  MarketItemTableViewCell.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/23.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit
import Charts

class MarketItemTableViewCell: UITableViewCell {

    @IBOutlet weak var chartView: UIView! {
        didSet {
            chartView.isUserInteractionEnabled = false
            chartView.insertSubview(lineChartView, at: 1)
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
        set.fillColor = R.color.fw00A8BB()?.withAlphaComponent(0.3) ?? .white
        set.lineCapType = .round
        set.lineWidth = 3
        set.drawCirclesEnabled = false
        set.mode = .cubicBezier
        set.form = .empty
        set.colors = [R.color.fw00A8BB() ?? .white]
        chartView.maxVisibleCount = 0
        chartView.legend.enabled = false
        chartView.xAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.dragEnabled = false
        return chartView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func height() -> CGFloat {
        return 75
    }
    
    func update() {
        
    }
    
}
