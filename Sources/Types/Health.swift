//
//  Health.swift
//  OYPermission
//
//  Created by osmanyildirim
//

import HealthKit

/// Add string for `reading` data with `NSHealthUpdateUsageDescription` key to your Info.plist that describes a purpose of your access requests.
/// Add string for `writing` data with `NSHealthShareUsageDescription` key to your Info.plist that describes a purpose of your access requests.
public final class Health: OYHealthKitRequestable {
    /// Status of Health Permission
    ///
    /// `.authorized`
    /// - sharing authorized to Health.
    ///
    /// `.denied`
    /// -  sharing not authorized to Health.
    ///
    /// `.notDetermined`
    /// - has not been asked for access yet.
    ///
    /// `.unknown`
    /// - unknown status.
    public func status(for type: HKObjectType) -> Status {
        switch HKHealthStore().authorizationStatus(for: type) {
        case .sharingAuthorized:
            return .authorized
        case .sharingDenied:
            return .denied
        case .notDetermined:
            return .notDetermined
        @unknown default:
            return .unknown
        }
    }

    /// Permission's Usage Description Key(s) in Info.plist
    public var descriptionKeys: [String] { ["NSHealthUpdateUsageDescription, NSHealthShareUsageDescription"] }

    /// Asks to user for access the Health
    /// - Parameters:
    ///   - shareTypes: sharing Health types
    ///   - readTypes: reading Health types
    ///   - closure: closure handler with granted and optional error
    ///
    /// Usage:
    ///
    ///         let shareTypes: Set<HKSampleType> = [.workoutType()]
    ///         let readTypes: Set<HKSampleType> = [.workoutType()]
    ///
    ///         OYPermission.health.request(shareTypes: shareTypes, readTypes: readTypes) { granted, error in
    ///
    ///         }
    public func request(shareTypes: Set<HKSampleType>, readTypes: Set<HKObjectType>, closure: ((_ granted: Bool, _ error: Error?) -> Void)?) {
        let result = checkPrivacyDescription()
        guard result == nil else {
            closure?(false, result)
            return
        }

        HKHealthStore().requestAuthorization(toShare: shareTypes, read: readTypes) { granted, error in
            DispatchQueue.main.async {
                closure?(granted, error)
            }
        }
    }
}
