//
//  AppManager.swift
//  Flashwire
//
//  Created by Fei Zhang on 2022/12/2.
//  Copyright © 2022 Zing Tech. All rights reserved.
//

import Foundation

/// App info manager
public class AppManager {

    public static let shared: AppManager = AppManager()

    fileprivate let infoDictionary = Bundle.main.infoDictionary

    /// App version number without build number
    /// The value of CFBundleShortVersionString
    public var shortVersion: String? {
        guard let infoDictionary = self.infoDictionary else {
            return nil
        }
        guard let version = infoDictionary["CFBundleShortVersionString"] as? String else {
            return nil
        }
        return version
    }

    /// App build number
    /// The value of CFBundleVersion
    public var build: String? {
        guard let infoDictionary = self.infoDictionary else {
            return nil
        }
        guard let build = infoDictionary["CFBundleVersion"] as? String else {
            return nil
        }
        return build
    }

    /// shortVersion + build
    /// App version contains short version and build numbers. Example: 1.0.1 (1)
    public var version: String? {
        guard let shortVersion = shortVersion else {
            return nil
        }
        guard let build = build else {
            return nil
        }
        return "\(shortVersion)(\(build))"
    }

    /// app name
    public var appName: String? {
        guard let infoDictionary = self.infoDictionary else {
            return nil
        }
        guard let name = infoDictionary["CFBundleName"] as? String else {
            return nil
        }

        return name
    }

    /// bundle id
    public var identifier: String? {
        guard let infoDictionary = self.infoDictionary else {
            return nil
        }
        guard let name = infoDictionary["CFBundleIdentifier"] as? String else {
            return nil
        }

        return name
    }

    /// urltypes
    public var urlTypes: [[String: Any]]? {
        guard let urlTypes = Bundle.main.infoDictionary?["CFBundleURLTypes"] as? [[String: Any]] else {
            return nil
        }
        return urlTypes
    }
}
