//
//  Calendar.swift
//  OYPermission
//
//  Created by osmanyildirim
//

import EventKit

/// Add the corresponding string with `NSCalendarsUsageDescription` key to your Info.plist that describes a purpose of your access requests.
public final class Calendar: OYBaseRequestable {
    /// Status of Calendar Permission
    ///
    /// `.authorized`
    /// - authorized to Calendar.
    ///
    /// `.denied`
    /// -  not authorized to Calendar.
    /// -  application is not authorized to access the service (restricted).
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
    public var descriptionKeys: [String] { ["NSCalendarsUsageDescription"] }

    /// Asks to user for access the Calendar
    /// - Parameter closure: closure handler with granted and optional error
    public func request(closure: ((_ granted: Bool, _ error: Error?) -> Void)?) {
        let result = checkPrivacyDescription()
        guard result == nil else {
            closure?(false, result)
            return
        }

        let eventStore = EKEventStore()
        eventStore.requestAccess(to: EKEntityType.event, completion: { granted, error in
            DispatchQueue.main.async {
                closure?(granted, error)
            }
        })
    }

    /// Fetch status of the Calendar
    /// - Returns: optional authorization status
    private func getStatus() -> EKAuthorizationStatus? {
        EKEventStore.authorizationStatus(for: EKEntityType.event)
    }
}
