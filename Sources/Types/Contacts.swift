//
//  Contacts.swift
//  OYPermission
//
//  Created by osmanyildirim
//

import Contacts

/// Add the corresponding string with `NSContactsUsageDescription` key to your Info.plist that describes a purpose of your access requests.
public final class Contacts: OYBaseRequestable {
    /// Status of Contacts Permission
    ///
    /// `.authorized`
    /// - authorized to Contacts.
    ///
    /// `.denied`
    /// -  not authorized to Contacts.
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
    public var descriptionKeys: [String] { ["NSContactsUsageDescription"] }

    /// Asks to user for access the Contacts
    /// - Parameter closure: closure handler with granted and optional error
    public func request(closure: ((_ granted: Bool, _ error: Error?) -> Void)?) {
        let result = checkPrivacyDescription()
        guard result == nil else {
            closure?(false, result)
            return
        }

        let store = CNContactStore()
        store.requestAccess(for: .contacts, completionHandler: { granted, error in
            DispatchQueue.main.async {
                closure?(granted, error)
            }
        })
    }

    /// Fetch status of the Contacts
    /// - Returns: optional authorization status
    private func getStatus() -> CNAuthorizationStatus? {
        CNContactStore.authorizationStatus(for: .contacts)
    }
}
