//
//  UIFont+Extension.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/9.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

extension UIFont: Compatible {}

// 中文/英文：PingFangSC（字重：Regular）
public enum KYFontWeight: String {
    case regular = "Regular"
    case medium = "Medium"
    case light = "Light"
    case bold = "Bold"
}

// 数字：DINAlternate（字重：Bold）
public enum KYFontType {
    /// 系统样式
    case system
    /// 平方样式
    case pingFang
    /// Roboto
    case roboto
    /// 数字样式
    case DIN
}

public extension Wrapper where Base: UIFont {
    static func font8(type: KYFontType = .pingFang, weight: KYFontWeight = .regular) -> UIFont {
        return UIFont.font(type: type, fontWeight: weight, size: 8)
    }
    
    static func font10(type: KYFontType = .pingFang, weight: KYFontWeight = .regular) -> UIFont {
        return UIFont.font(type: type, fontWeight: weight, size: 10)
    }
    
    static func font11(type: KYFontType = .pingFang, weight: KYFontWeight = .regular) -> UIFont {
        return UIFont.font(type: type, fontWeight: weight, size: 11)
    }
    
    static func font12(type: KYFontType = .pingFang, weight: KYFontWeight = .regular) -> UIFont {
        return UIFont.font(type: type, fontWeight: weight, size: 12)
    }
    
    static func font13(type: KYFontType = .pingFang, weight: KYFontWeight = .regular) -> UIFont {
        return UIFont.font(type: type, fontWeight: weight, size: 13)
    }
    
    static func font14(type: KYFontType = .pingFang, weight: KYFontWeight = .regular) -> UIFont {
        return UIFont.font(type: type, fontWeight: weight, size: 14)
    }
    
    static func font15(type: KYFontType = .pingFang, weight: KYFontWeight = .regular) -> UIFont {
        return UIFont.font(type: type, fontWeight: weight, size: 15)
    }
    
    static func font16(type: KYFontType = .pingFang, weight: KYFontWeight = .regular) -> UIFont {
        return UIFont.font(type: type, fontWeight: weight, size: 16)
    }
    
    static func font18(type: KYFontType = .pingFang, weight: KYFontWeight = .regular) -> UIFont {
        return UIFont.font(type: type, fontWeight: weight, size: 18)
    }
    
    static func font20(type: KYFontType = .pingFang, weight: KYFontWeight = .regular) -> UIFont {
        return UIFont.font(type: type, fontWeight: weight, size: 20)
    }
    
    static func font22(type: KYFontType = .pingFang, weight: KYFontWeight = .regular) -> UIFont {
        return UIFont.font(type: type, fontWeight: weight, size: 22)
    }
    
    static func font24(type: KYFontType = .pingFang, weight: KYFontWeight = .regular) -> UIFont {
        return UIFont.font(type: type, fontWeight: weight, size: 24)
    }
    
    static func font26(type: KYFontType = .pingFang, weight: KYFontWeight = .regular) -> UIFont {
        return UIFont.font(type: type, fontWeight: weight, size: 26)
    }
    
    static func font28(type: KYFontType = .pingFang, weight: KYFontWeight = .regular) -> UIFont {
        return UIFont.font(type: type, fontWeight: weight, size: 28)
    }
    
    static func font30(type: KYFontType = .pingFang, weight: KYFontWeight = .regular) -> UIFont {
        return UIFont.font(type: type, fontWeight: weight, size: 30)
    }
    
    static func font32(type: KYFontType = .pingFang, weight: KYFontWeight = .regular) -> UIFont {
        return UIFont.font(type: type, fontWeight: weight, size: 32)
    }
    
    static func font34(type: KYFontType = .pingFang, weight: KYFontWeight = .regular) -> UIFont {
        return UIFont.font(type: type, fontWeight: weight, size: 34)
    }
    
    static func font36(type: KYFontType = .pingFang, weight: KYFontWeight = .regular) -> UIFont {
        return UIFont.font(type: type, fontWeight: weight, size: 36)
    }
}

// MARK: -

public extension Wrapper where Base: UIFont {
    static func pingFangFont(weight: KYFontWeight, size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-" + weight.rawValue, size: size) ?? UIFont.systemFont(fontWeight: weight, size: size)
    }
    
    static func DINFont(weight: KYFontWeight, size: CGFloat) -> UIFont {
        return UIFont(name: "DINA-" + weight.rawValue, size: size) ?? UIFont.systemFont(fontWeight: weight, size: size)
    }
    
    static func robotoFont(weight: KYFontWeight, size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-" + weight.rawValue, size: size) ?? UIFont.systemFont(fontWeight: weight, size: size)
    }
    
}

// MARK: - Private

private extension UIFont {
    static func font(type: KYFontType, fontWeight: KYFontWeight, size: CGFloat) -> UIFont {
        switch type {
        case .system:
            return UIFont.systemFont(fontWeight: fontWeight, size: size)
        case .pingFang:
            return UIFont.fw.pingFangFont(weight: fontWeight, size: size)
        case .DIN:
            return UIFont.fw.DINFont(weight: fontWeight, size: size)
        case .roboto:
            return UIFont.fw.robotoFont(weight: fontWeight, size: size)
        }
    }
    
    static func systemFont(fontWeight: KYFontWeight, size: CGFloat) -> UIFont {
        let weight: UIFont.Weight
        switch fontWeight {
        case .regular:
            weight = .regular
        case .medium:
            weight = .medium
        case .light:
            weight = .light
        case .bold:
            weight = .bold
        }
        return UIFont.systemFont(ofSize: size, weight: weight)
    }
}
