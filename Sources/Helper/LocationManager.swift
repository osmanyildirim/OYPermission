//
//  LocationManager.swift
//  OYPermission
//
//  Created by osmanyildirim
//

import MapKit

/// Location helper class for LocationAlways and LocationWhenInUse Permissions
final class LocationManager: NSObject, CLLocationManagerDelegate {
    /// Location Services Manager
    private var locationManager: CLLocationManager?

    /// Closure of LocationManager
    private var closure: ((CLAuthorizationStatus) -> Void)?

    /// Singleton value of LocationManager
    static let shared = LocationManager()

    /// Request for LocationAlways and LocationWhenInUse authorization status
    /// - Parameters:
    ///   - whenInUseOnly: if that is true requestWhenInUseAuthorization
    ///   - closure: closure handler with authorization status
    func request(whenInUseOnly: Bool, closure: ((CLAuthorizationStatus) -> Void)?) {
        self.closure = closure

        locationManager = CLLocationManager()
        locationManager?.delegate = self

        if whenInUseOnly {
            locationManager?.requestWhenInUseAuthorization()
        } else {
            locationManager?.requestAlwaysAuthorization()
        }
    }

    /// Invoked when either the authorizationStatus or accuracyAuthorization properties change.
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            didChangeAuthorizationStatus(manager.authorizationStatus)
        }
    }
    /// Invoked when the authorization status changes for this application.
    /// for iOS 13 or lower
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        didChangeAuthorizationStatus(status)
    }

    deinit {
        locationManager?.delegate = nil
    }
}

extension LocationManager {
    /// Handle authorization status with closure
    /// - Parameter status: authorization status
    private func didChangeAuthorizationStatus(_ status: CLAuthorizationStatus) {
        guard status != .notDetermined else { return }
        closure?(status)
    }
}
