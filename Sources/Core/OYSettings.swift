//
//  OYSettings.swift
//  OYPermission
//
//  Created by Osman Yıldırım on 24.02.2023.
//

import Foundation

protocol OYSettings {
    /// Static app's open settings method
    /// - Parameters:
    ///   - withPopup
    ///   • noPopup: popup will not show
    ///   • withPopup: popup will show with title and message
    ///   - closure: closure invokes when settings open
    static func openSettings(_ type: SettingsPopup, closure: (() -> Void)?)
}

extension OYPermission: OYSettings {
    public static func openSettings(_ type: SettingsPopup, closure: (() -> Void)?) {
        switch type {
        case .noPopup:
            openSettings()
        case .withPopup(let title, let message):
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
                openSettings()
                closure?()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            UIApplication.shared.topViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    /// Private open app's settings helper method
    private static func openSettings() {
        DispatchQueue.main.async {
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, completionHandler: nil)
            }
        }
    }
}
