//
//  LocationAlways.swift
//  OYPermission
//
//  Created by osmanyildirim
//

import MapKit

/// Add the corresponding string with `NSLocationAlwaysAndWhenInUseUsageDescription` and `NSLocationWhenInUseUsageDescription` keys to your Info.plist that describes a purpose of your access requests.
public final class LocationAlways: OYLocationBase {
    /// Status of LocationAlways Permission
    ///
    /// `.authorized`
    /// - authorized to LocationAlways.
    ///
    /// `.denied`
    /// -  not authorized to LocationAlways.
    /// -  authorized to LocationWhenInUse.
    /// -  application is not authorized to access the service (restricted).
    ///
    /// `.notDetermined`
    /// - has not been asked for access yet.
    ///
    /// `.unknown`
    /// - unknown status.
    public var status: Status {
        getStatus()
    }

    /// Permission's Usage Description Key(s) in Info.plist
    public var descriptionKeys: [String] { ["NSLocationAlwaysAndWhenInUseUsageDescription", "NSLocationWhenInUseUsageDescription"] }

    /// Asks to user for access the LocationAlways
    /// - Parameter closure: closure handler with granted and optional error
    public func request(closure: ((_ granted: Bool, _ error: Error?) -> Void)?) {
        let result = checkPrivacyDescription()
        guard result == nil else {
            closure?(false, result)
            return
        }

        guard status == .notDetermined || status == .authorizedWhenInUse else { return }

        LocationManager.shared.request(whenInUseOnly: false) { status in
            closure?(status == .authorizedAlways, nil)
        }
    }

    /// Fetch status of the LocationAlways
    /// - Returns: authorization status
    private func getStatus() -> Status {
        let status: CLAuthorizationStatus = {
            let locationManager = CLLocationManager()
            if #available(iOS 14.0, tvOS 14.0, *) {
                return locationManager.authorizationStatus
            } else {
                return CLLocationManager.authorizationStatus()
            }
        }()

        switch status {
        case .authorized, .authorizedAlways:
            return .authorized
        case .authorizedWhenInUse:
            return .authorizedWhenInUse
        case .denied, .restricted:
            return .denied
        case .notDetermined:
            return .notDetermined
        @unknown default:
            return .unknown
        }
    }
}
