//
//  Siri.swift
//  OYPermission
//
//  Created by osmanyildirim
//

import Intents

/// Add the corresponding string with `NSSiriUsageDescription` key to your Info.plist that describes a purpose of your access requests.
public final class Siri: OYBaseRequestable {
    /// Status of Siri Permission
    ///
    /// `.authorized`
    /// - authorized to Siri.
    ///
    /// `.denied`
    /// -  not authorized to Siri.
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
        case .denied, .restricted, .none:
            return .denied
        case .notDetermined:
            return .notDetermined
        @unknown default:
            return .unknown
        }
    }

    /// Permission's Usage Description Key(s) in Info.plist
    public var descriptionKeys: [String] { ["NSSiriUsageDescription"] }

    /// Asks to user for access the Siri
    /// - Parameter closure: closure handler with granted and optional error
    public func request(closure: ((_ granted: Bool, _ error: Error?) -> Void)?) {
        let result = checkPrivacyDescription()
        guard result == nil else {
            closure?(false, result)
            return
        }

        INPreferences.requestSiriAuthorization { status in
            DispatchQueue.main.async {
                closure?(status == .authorized, nil)
            }
        }
    }

    /// Fetch status of the Siri
    /// - Returns: optional authorization status
    private func getStatus() -> INSiriAuthorizationStatus? {
        INPreferences.siriAuthorizationStatus()
    }
}
