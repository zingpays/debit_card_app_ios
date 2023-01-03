//
//  Wrapper.swift
//  Flashwire
//
//  Created by Fei Zhang on 2022/12/1.
//  Copyright © 2022 Zing Tech. All rights reserved.
//

import UIKit

// swiftlint:disable identifier_name unused_setter_value
/// 新增命名空间方法实现，类似：UIColor.z.background，参考：https://github.com/onevcat/Kingfisher/blob/master/Sources/General/Kingfisher.swift
public struct Wrapper<Base> {
    public var base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol Compatible { }

/// 扩展项目的命名空间
public extension Compatible {
    var fw: Wrapper<Self> {
        get {return Wrapper(self)}
        set {}
    }

    static var fw: Wrapper<Self>.Type {
        get { Wrapper<Self>.self}
        set {}
    }
}
