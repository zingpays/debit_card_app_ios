//
//  ChooseDateView.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/3.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

protocol ChooseDateViewDelegate: NSObject {
    func didSelectedOK(_ date: Date)
}

class ChooseDateView: UIView, NibLoadable {

    @IBOutlet weak var datePickerView: UIDatePicker!
    
    weak var delegate: ChooseDateViewDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @IBAction func okAction(_ sender: Any) {
        delegate?.didSelectedOK(datePickerView.date)
    }
    
}
