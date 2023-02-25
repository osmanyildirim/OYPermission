//
//  Camera.swift
//  OYPermission
//
//  Created by osmanyildirim
//

import AVFoundation

/// Add the corresponding string with `NSCameraUsageDescription` key to your Info.plist that describes a purpose of your access requests.
public final class Camera: OYBaseRequestable {
    /// Status of Camera Permission
    ///
    /// `.authorized`
    /// - authorized to Camera.
    ///
    /// `.denied`
    /// -  not authorized to Camera.
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
            return .denied
        }
    }

    /// Permission's Usage Description Key(s) in Info.plist
    public var descriptionKeys: [String] { ["NSCameraUsageDescription"] }

    /// Asks to user for access the Camera
    /// - Parameter closure: closure handler with granted and optional error
    public func request(closure: ((_ granted: Bool, _ error: Error?) -> Void)?) {
        let result = checkPrivacyDescription()
        guard result == nil else {
            closure?(false, result)
            return
        }

        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { granted in
            DispatchQueue.main.async {
                closure?(granted, nil)
            }
        })
    }

    /// Fetch status of the Camera
    /// - Returns: optional authorization status
    private func getStatus() -> AVAuthorizationStatus? {
        AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
    }
}
