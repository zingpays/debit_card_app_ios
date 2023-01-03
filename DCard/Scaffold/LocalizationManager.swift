//
//  LocalizationManager.swift
//  Flashwire
//
//  Created by Fei Zhang on 2022/11/21.
//  Copyright © 2022 Zing Tech. All rights reserved.
//

import Foundation

/// 语言
enum Language: String {
    // 中文
    case zh = "Zh"
    // 英文
    case en = "En"
}

/// 本地化管理
class LocalizationManager {

    static let shared = LocalizationManager()

    fileprivate let kLanguageSettingKey = "LNGUAGESETTINGKEY"

    // MARK: - Public methods

    func setupLanguage(_ lan: Language) {
        let value = lan == .zh ? "zh-Hans" : "en"
        UserDefaults.standard.set(value, forKey: kLanguageSettingKey)
        UserDefaults.standard.synchronize()
    }

    func languageBundle() -> Bundle? {
        return LocalizationManager.shared.currentLanguageBundle()
    }

    func setupLanguage() {
        Bundle.onLanguage()
    }

    func currentLanguage() -> Language {
        if let currLanguage = UserDefaults.standard.string(forKey: kLanguageSettingKey), currLanguage.count > 0 {
            let value = currLanguage == "zh-Hans" ? "Zh" : "En"
            return Language(rawValue: value) ?? .en
        } else {
            let lan = Locale.preferredLanguages.first ?? ""
            if lan.contains("Hant") || lan.contains("Hans") {
                return .zh
            } else {
                return .en
            }
        }
    }

    private func currentLanguageBundle() -> Bundle? {
        let resource = currentLanguage() == .zh ? "zh-Hans" : "en"
        let path = Bundle.main.path(forResource: resource, ofType: "lproj") ?? ""
        return Bundle(path: path)
    }
}

class LanguageBundle: Bundle {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        if let bundle = LocalizationManager.shared.languageBundle() {
            return bundle.localizedString(forKey: key, value: value, table: tableName)
        } else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
    }
}

private extension Bundle {
    static var onLanguageDispatchOnce: () -> Void = {
        object_setClass(Bundle.main, LanguageBundle.self)
    }

    static func onLanguage() {
        Bundle.onLanguageDispatchOnce()
    }
}
