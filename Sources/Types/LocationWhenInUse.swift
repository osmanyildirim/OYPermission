//
//  LocationWhenInUse.swift
//  OYPermission
//
//  Created by osmanyildirim
//

import MapKit

/// Add the corresponding string with `NSLocationAlwaysAndWhenInUseUsageDescription` key to your Info.plist that describes a purpose of your access requests.
public final class LocationWhenInUse: OYLocationBase {
    /// Status of LocationWhenInUse Permission
    ///
    /// `.authorized`
    /// - authorized to LocationWhenInUse.
    ///
    /// `.denied`
    /// -  not authorized to LocationWhenInUse.
    /// -  authorized to LocationAlways.
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
    public var descriptionKeys: [String] { ["NSLocationAlwaysAndWhenInUseUsageDescription"] }

    /// Asks to user for access the LocationWhenInUse
    /// - Parameter closure: closure handler with granted and optional error
    public func request(closure: ((_ granted: Bool, _ error: Error?) -> Void)?) {
        let result = checkPrivacyDescription()
        guard result == nil else {
            closure?(false, result)
            return
        }

        guard status != .authorized else { return }

        LocationManager.shared.request(whenInUseOnly: true) { status in
            closure?(status == .authorizedWhenInUse, nil)
        }
    }

    /// Fetch status of the LocationWhenInUse
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
        case .authorized, .authorizedWhenInUse, .authorizedAlways:
            return .authorized
        case .denied, .restricted:
            return .denied
        case .notDetermined:
            return .notDetermined
        @unknown default:
            return .unknown
        }
    }
}
