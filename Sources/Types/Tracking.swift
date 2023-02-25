//
//  Tracking.swift
//  OYPermission
//
//  Created by osmanyildirim
//

import AppTrackingTransparency

/// Add the corresponding string with `NSUserTrackingUsageDescription` key to your Info.plist that describes a purpose of your access requests.
/// @available on iOS 14.0
@available(iOS 14, *)
public final class Tracking: OYBaseRequestable {
    /// Status of Tracking Permission
    ///
    /// `.authorized`
    /// - authorized to Tracking.
    ///
    /// `.denied`
    /// -  not authorized to Tracking.
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
    public var descriptionKeys: [String] { ["NSUserTrackingUsageDescription"] }

    /// Asks to user for access the Tracking
    /// - Parameter closure: closure handler with granted and optional error
    public func request(closure: ((_ granted: Bool, _ error: Error?) -> Void)?) {
        let result = checkPrivacyDescription()
        guard result == nil else {
            closure?(false, result)
            return
        }

        ATTrackingManager.requestTrackingAuthorization { status in
            DispatchQueue.main.async {
                closure?(status == .authorized, nil)
            }
        }
    }

    /// Fetch status of the Tracking
    /// - Returns: authorization status
    private func getStatus() -> ATTrackingManager.AuthorizationStatus {
        ATTrackingManager.trackingAuthorizationStatus
    }
}
