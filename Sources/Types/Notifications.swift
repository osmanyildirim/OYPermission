//
//  Notifications.swift
//  OYPermission
//
//  Created by osmanyildirim
//

import Foundation
import UserNotifications

/// Add the corresponding string with `NSUserNotificationsUsageDescription` key to your Info.plist that describes a purpose of your access requests.
public final class Notifications: OYBaseRequestable {
    /// Status of Notifications Permission
    ///
    /// `.authorized`
    /// - authorized to `user notifications`.
    /// - authorized to `post non-interruptive` notifications.
    /// - authorized to `temporarily` notifications (Only available for app clips).
    ///
    /// `.denied`
    /// -  not authorized to user notifications.
    ///
    /// `.notDetermined`
    /// - has not been asked for access yet.
    ///
    /// `.unknown`
    /// - unknown status.
    public var status: Status {
        guard let status = getStatus() else {
            return .notDetermined
        }

        switch status {
        case .authorized, .provisional, .ephemeral:
            return .authorized
        case .denied:
            return .denied
        case .notDetermined:
            return .notDetermined
        @unknown default:
            return .unknown
        }
    }

    /// Permission's Usage Description Key(s) in Info.plist
    public var descriptionKeys: [String] { ["NSUserNotificationsUsageDescription"] }

    /// Asks to user for access the Notifications
    /// - Parameter closure: closure handler with granted and optional error
    public func request(closure: ((_ granted: Bool, _ error: Error?) -> Void)?) {
        let result = checkPrivacyDescription()
        guard result == nil else {
            closure?(false, result)
            return
        }

        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .alert, .sound]) { granted, error in
            DispatchQueue.main.async {
                closure?(granted, error)
            }
        }
    }

    /// Fetch status of the Notifications
    /// - Returns: optional authorization status
    private func getStatus() -> UNAuthorizationStatus? {
        var notificationSettings: UNNotificationSettings?
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            UNUserNotificationCenter.current().getNotificationSettings { setttings in
                notificationSettings = setttings
                semaphore.signal()
            }
        }
        semaphore.wait()
        return notificationSettings?.authorizationStatus
    }
}
