//
//  MediaLibrary.swift
//  OYPermission
//
//  Created by osmanyildirim
//

import MediaPlayer

/// Add the corresponding string with `NSAppleMusicUsageDescription` key to your Info.plist that describes a purpose of your access requests.
public final class MediaLibrary: OYBaseRequestable {
    /// Status of MediaLibrary Permission
    ///
    /// `.authorized`
    /// - authorized to MediaLibrary.
    ///
    /// `.denied`
    /// -  not authorized to MediaLibrary.
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
    public var descriptionKeys: [String] { ["NSAppleMusicUsageDescription"] }

    /// Asks to user for access the MediaLibrary
    /// - Parameter closure: closure handler with granted and optional error
    public func request(closure: ((_ granted: Bool, _ error: Error?) -> Void)?) {
        let result = checkPrivacyDescription()
        guard result == nil else {
            closure?(false, result)
            return
        }

        MPMediaLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                closure?(status == .authorized, nil)
            }
        }
    }

    /// Fetch status of the MediaLibrary
    /// - Returns: optional authorization status
    private func getStatus() -> MPMediaLibraryAuthorizationStatus? {
        MPMediaLibrary.authorizationStatus()
    }
}
