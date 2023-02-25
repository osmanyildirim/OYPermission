//
//  Microphone.swift
//  OYPermission
//
//  Created by osmanyildirim
//

import AVFoundation

/// Add the corresponding string with `NSMicrophoneUsageDescription` key to your Info.plist that describes a purpose of your access requests.
public final class Microphone: OYBaseRequestable {
    /// Status of Microphone Permission
    ///
    /// `.authorized`
    /// - authorized to Microphone.
    ///
    /// `.denied`
    /// -  not authorized to Microphone.
    /// -  application is not authorized to access the service (restricted).
    ///
    /// `.notDetermined`
    /// - has not been asked for access yet.
    ///
    /// `.unknown`
    /// - unknown status.
    public var status: Status {
        switch getStatus() {
        case .granted:
            return .authorized
        case .denied:
            return .denied
        case .undetermined:
            return .notDetermined
        @unknown default:
            return .unknown
        }
    }

    /// Permission's Usage Description Key(s) in Info.plist
    public var descriptionKeys: [String] { ["NSMicrophoneUsageDescription"] }

    /// Asks to user for access the Microphone
    /// - Parameter closure: closure handler with granted and optional error
    public func request(closure: ((_ granted: Bool, _ error: Error?) -> Void)?) {
        let result = checkPrivacyDescription()
        guard result == nil else {
            closure?(false, result)
            return
        }

        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                closure?(granted, nil)
            }
        }
    }

    /// Fetch status of the Microphone
    /// - Returns: authorization status
    private func getStatus() -> AVAudioSession.RecordPermission {
        AVAudioSession.sharedInstance().recordPermission
    }
}
