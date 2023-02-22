//
//  Constant.swift
//  Flashwire
//
//  Created by Fei Zhang on 2022/11/15.
//  Copyright © 2022 Zing Tech. All rights reserved.
//

import UIKit
import ObjectMapper

// MARK: - Constant

/// 屏幕宽度
let SCREENWIDTH: CGFloat = UIScreen.main.bounds.size.width
/// 屏幕高度
let SCREENHEIGHT: CGFloat = UIScreen.main.bounds.size.height
/// Navbar Content高度
let NAVCONTENTBARHEIGHT: CGFloat = 44.0
/// 状态栏高度
let STATUSBARHEIGHT: CGFloat = ISNOTCH() == true ? 44.0 : 20.0
/// Navbar高度
let NAVBARHEIGHT: CGFloat = ISNOTCH() == true ? 88.0 : 64.0
/// Tab Bar高度
let TABBARHEIGHT: CGFloat = ISNOTCH() == true ? 83.0 : 49.0
/// Touch Bar高度
let TOUCHBARHEIGHT: CGFloat = ISNOTCH() == true ? 34.0 : 0.0

// MARK: - Method

/// 是否是刘海屏
public func ISNOTCH() -> Bool {
    return SCREENHEIGHT >= 812.0
}

// MARK: - Closure

typealias ResponseNormalCompletion = ((Bool, String) -> Void)

// MARK: - String

let NETWORKERRORMESSAGE = "Data parse fail!"

// MARK: - Notification
let APPISSHOWGUIDEKEY = "APPISSHOWGUIDEKEY"
let APPLYCARDSUCCESS = "APPLYCARDSUCCESS"
let UNLOCKSUCCESS = "UNLOCKSUCCESS"
let SETUPPATTERNSUCCESS = "SETUPPATTERNSUCCESS"
let SETUPAUTHSUCCESS = "SETUPAUTHSUCCESS"
