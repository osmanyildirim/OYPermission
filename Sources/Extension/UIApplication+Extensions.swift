//
//  UIApplication+Extensions.swift
//  OYPermission
//
//  Created by osmanyildirim
//

import Foundation

extension UIApplication {
    /// Key window of Application
    public var window: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes.filter { $0.activationState == .foregroundActive }
                                                       .first(where: { $0 is UIWindowScene })
                                                       .flatMap({ $0 as? UIWindowScene })?.windows
                                                       .first(where: \.isKeyWindow)
        } else {
            return UIApplication.shared.keyWindow
        }
    }

    /// Top UIViewController of key window
    public var topViewController: UIViewController? {
        let window = window

        if var rootViewController = window?.rootViewController {
            while let presentedViewController = rootViewController.presentedViewController {
                rootViewController = presentedViewController
            }
            return rootViewController
        }
        return nil
    }
}
