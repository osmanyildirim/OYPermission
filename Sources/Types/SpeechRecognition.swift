//
//  SpeechRecognition.swift
//  OYPermission
//
//  Created by osmanyildirim
//

import Speech

/// Add the corresponding string with `NSSpeechRecognitionUsageDescription` key to your Info.plist that describes a purpose of your access requests.
public final class SpeechRecognition: OYBaseRequestable {
    /// Status of Speech Recognition Permission
    ///
    /// `.authorized`
    /// - authorized to Speech Recognition.
    ///
    /// `.denied`
    /// -  not authorized to Speech Recognition.
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
    public var descriptionKeys: [String] { ["NSSpeechRecognitionUsageDescription"] }

    /// Asks to user for access the Speech Recognition
    /// - Parameter closure: closure handler with granted and optional error
    public func request(closure: ((_ granted: Bool, _ error: Error?) -> Void)?) {
        let result = checkPrivacyDescription()
        guard result == nil else {
            closure?(false, result)
            return
        }

        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                closure?(status == .authorized, nil)
            }
        }
    }

    /// Fetch status of the Speech Recognition
    /// - Returns: authorization status
    private func getStatus() -> SFSpeechRecognizerAuthorizationStatus {
        SFSpeechRecognizer.authorizationStatus()
    }
}
