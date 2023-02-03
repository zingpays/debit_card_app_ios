//
//  UICollection+Extension.swift
//  DCard
//
//  Created by Fei Zhang on 2023/2/2.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

extension UICollectionView: Compatible {}
public extension Wrapper where Base: UICollectionView {
    
    func registerCellClass(_ cellClass: Swift.AnyClass) -> () {
        base.register(cellClass, forCellWithReuseIdentifier: NSStringFromClass(cellClass))
    }
    
    func registerCellNib(_ cellClass: Swift.AnyClass) -> () {
        let classString = NSStringFromClass(cellClass)
        guard let nib = loadCellNib(cellClass, classString: classString) else { assert(false, "没有找到对应的nib"); return }
        base.register(nib, forCellWithReuseIdentifier: classString)
    }
    
    func registerHeaderClass(_ cellClass: Swift.AnyClass) -> () {
        base.register(cellClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NSStringFromClass(cellClass))
    }
    
    func registerHeaderNib(_ cellClass: Swift.AnyClass) -> () {
        let classString = NSStringFromClass(cellClass)
        guard let nib = loadCellNib(cellClass, classString: classString) else { assert(false, "没有找到对应的nib"); return }
        base.register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: classString)
    }
    
    func registerFooterClass(_ cellClass: Swift.AnyClass) -> () {
        base.register(cellClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: NSStringFromClass(cellClass))
    }
    
    func registerFooterNib(_ cellClass: Swift.AnyClass) -> () {
        let classString = NSStringFromClass(cellClass)
        guard let nib = loadCellNib(cellClass, classString: classString) else { assert(false, "没有找到对应的nib"); return }
        base.register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: classString)
    }
    
    func dequeue<T: UICollectionViewCell>(cellType: T.Type, for indexPath: IndexPath) -> T {
        base.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(cellType), for: indexPath) as! T
    }
    
    func dequeHeader<T: UICollectionReusableView>(viewType: T.Type, indexPath: IndexPath) -> T {
        base.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NSStringFromClass(viewType), for: indexPath) as! T
    }
    
    func dequeFooter<T: UICollectionReusableView>(viewType: T.Type, indexPath: IndexPath) -> T {
        base.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: NSStringFromClass(viewType), for: indexPath) as! T
    }
    
    private func loadCellNib(_ cellClass: Swift.AnyClass, classString: String) -> UINib? {
        guard let className =  classString.components(separatedBy:".").last else { return nil }
        return UINib.init(nibName: className , bundle: nil)
    }
}

