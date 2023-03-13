//
//  ChooseDateView.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/3.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

protocol ChooseDateViewDelegate: NSObject {
    func didSelectedOK(_ view: ChooseDateView, date: Date)
}

class ChooseDateView: UIView, NibLoadable {

    @IBOutlet weak var datePickerView: UIDatePicker!
    var viewId: Int = 0
    
    weak var delegate: ChooseDateViewDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @IBAction func okAction(_ sender: Any) {
        delegate?.didSelectedOK(self, date: datePickerView.date)
    }
    
}
