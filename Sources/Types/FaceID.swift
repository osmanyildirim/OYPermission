//
//  FaceID.swift
//  OYPermission
//
//  Created by osmanyildirim
//

import Combine
import LocalAuthentication

/// Add the corresponding string with `NSFaceIDUsageDescription` key to your Info.plist that describes a purpose of your access requests.
public final class FaceID: OYBaseRequestable {
    /// Status of FaceID Permission
    ///
    /// `.authorized`
    /// - authorized to FaceID.
    ///
    /// `.notSupported`
    /// - not supported FaceID for this device.
    ///
    /// `.denied`
    /// -  not authorized to FaceID.
    /// -  application is not authorized to access the service (restricted).
    ///
    /// `.notDetermined`
    /// - has not been asked for access yet.
    ///
    /// `.unknown`
    /// - unknown status.
    public var status: Status {
        guard let result = getStatus() else {
            return .notDetermined
        }

        guard result.0.biometryType == .faceID else {
            return .notSupported
        }

        switch result.1?.code {
        case nil where result.2:
            return .notDetermined
        case LAError.biometryNotAvailable.rawValue:
            return .denied
        case LAError.biometryNotEnrolled.rawValue:
            return .notSupported
        default:
            return .unknown
        }
    }

    /// Permission's Usage Description Key(s) in Info.plist
    public var descriptionKeys: [String] { ["NSFaceIDUsageDescription"] }

    /// Asks to user for access the FaceID
    /// - Parameter closure: closure handler with granted and optional error
    public func request(closure: ((_ granted: Bool, _ error: Error?) -> Void)?) {
        let result = checkPrivacyDescription()
        guard result == nil else {
            closure?(false, result)
            return
        }

        if #available(iOS 13.0, *) {
            let publisher = Future<Void, Error> { promise in
                LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: " ") { result, error in
                    result ? promise(.success(Void())) : promise(.failure(error ?? OYError.faceIdUnavailable))
                }
            }

            publisher.receive(on: DispatchQueue.main).sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    closure?(false, error)
                case .finished:
                    closure?(true, nil)
                }
            }, receiveValue: { _ in }).store(in: &Cancellable.cancellables)
        } else {
            LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: " ") { granted, error in
                DispatchQueue.main.async {
                    closure?(granted, error)
                }
            }
        }
    }

    /// Fetch status of the FaceID
    private func getStatus() -> (LAContext, NSError?, Bool)? {
        let context = LAContext()
        var error: NSError?
        let isReady = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)

        return (context, error, isReady)
    }
}

extension FaceID {
    /// Private cancellable for Combine
    private struct Cancellable {
        @available(iOS 13.0, *)
        static var cancellables = Set<AnyCancellable>()
    }
}
