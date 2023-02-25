//
//  PrivacyDescriptionManager.swift
//  OYPermission
//
//  Created by osmanyildirim
//

import Foundation

final class PrivacyDescriptionManager {
    /// App plist (Info.plist) is contains permission's usage description key/keys
    /// - Parameter keys: description key/keys
    /// - Returns: optional Error's string
    static func contains(keys: [String]) -> String? {
        var result: String?
        var missedKeys = [String]()

        for item in keys where Bundle.main.object(forInfoDictionaryKey: item) == nil {
            missedKeys.append(item)
        }

        if #available(iOS 13.0, *) {
            let formatter = ListFormatter()
            formatter.locale = Locale.current

            if !missedKeys.isEmpty {
                result = "You must add a row with the \(missedKeys.count == 1 ? keys.first! : formatter.string(from: missedKeys) ?? "") key\(missedKeys.count == 1 ? "" : "s") to your app‘s plist file."
            }
        } else {
            result = missedKeys.joined(separator: ",")
        }

        return result
    }
}
