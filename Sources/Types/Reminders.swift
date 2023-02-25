//
//  Reminders.swift
//  OYPermission
//
//  Created by osmanyildirim
//

import EventKit

/// Add the corresponding string with `NSRemindersUsageDescription` key to your Info.plist that describes a purpose of your access requests.
public final class Reminders: OYBaseRequestable {
    /// Status of Reminders Permission
    ///
    /// `.authorized`
    /// - authorized to Reminders.
    ///
    /// `.denied`
    /// -  not authorized to Reminders.
    /// -  application is not authorized to access the service (restricted).
    ///
    /// `.notDetermined`
    /// - has not been asked for access yet.
    ///
    /// `.unknown`
    /// - unknown status.
    public var status: Status {
        switch getStatus() {
        case .authorized:
            return .authorized
        case .denied, .restricted:
            return .denied
        case .notDetermined:
            return .notDetermined
        @unknown default:
            return .unknown
        }
    }

    /// Permission's Usage Description Key(s) in Info.plist
    public var descriptionKeys: [String] { ["NSRemindersUsageDescription"] }

    /// Asks to user for access the Reminders
    /// - Parameter closure: closure handler with granted and optional error
    public func request(closure: ((_ granted: Bool, _ error: Error?) -> Void)?) {
        let result = checkPrivacyDescription()
        guard result == nil else {
            closure?(false, result)
            return
        }

        let eventStore = EKEventStore()
        eventStore.requestAccess(to: EKEntityType.reminder, completion: { granted, error in
            DispatchQueue.main.async {
                closure?(granted, error)
            }
        })
    }

    /// Fetch status of the Reminders
    /// - Returns: authorization status
    private func getStatus() -> EKAuthorizationStatus {
        EKEventStore.authorizationStatus(for: .reminder)
    }
}
