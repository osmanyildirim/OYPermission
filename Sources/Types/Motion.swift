//
//  Motion.swift
//  OYPermission
//
//  Created by osmanyildirim
//

import CoreMotion

/// Add the corresponding string with `NSMotionUsageDescription` key to your Info.plist that describes a purpose of your access requests.
public final class Motion: OYCoreMotionRequestable {
    /// Status of Motion Permission
    ///
    /// `.authorized`
    /// - authorized to Motion.
    ///
    /// `.denied`
    /// -  not authorized to Motion.
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
    public var descriptionKeys: [String] { ["NSMotionUsageDescription"] }

    /// Asks to user for access the Motion
    /// - Parameter closure: closure handler with activities and optional error
    public func request(closure: ((_ activities: [CMMotionActivity]?, _ error: Error?) -> Void)?) {
        let result = checkPrivacyDescription()
        guard result == nil else {
            closure?(nil, result)
            return
        }

        let manager = CMMotionActivityManager()
        manager.queryActivityStarting(from: Date(), to: Date(), to: .main) { activities, error in
            closure?(activities, error)
            manager.stopActivityUpdates()
        }
    }

    /// Fetch status of the Motion
    /// - Returns: authorization status
    private func getStatus() -> CMAuthorizationStatus {
        CMMotionActivityManager.authorizationStatus()
    }
}
