//
//  DLog.swift
//  Flashwire
//
//  Created by Fei Zhang on 2022/11/15.
//  Copyright © 2022 Zing Tech. All rights reserved.
//

import Foundation

struct DLog {
    /// 打印普通信息
    static func info(_ items: Any..., separator: String = " ", terminator: String = "\n", file: String = #fileID, line: Int = #line, function: String = #function) {
        #if DEBUG
        let info = "DI-> time: \(NSDate()), file: \(file), line: \(line), method: \(function), message: \n \(items)"
        print(info, separator: separator, terminator: terminator)
        #endif
    }

    /// 打印错误信息
    static func error(_ items: Any..., separator: String = " ", terminator: String = "\n", file: String = #fileID, line: Int = #line, function: String = #function) {
        #if DEBUG
        let info = "DE-> time: \(NSDate()), file: \(file), line: \(line), method: \(function), message: \(items)"
        print(info, separator: separator, terminator: terminator)
        #endif
    }
}
