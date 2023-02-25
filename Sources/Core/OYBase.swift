//
//  OYBase.swift
//  OYPermission
//
//  Created by osmanyildirim
//

import UIKit

public protocol OYBase {
    /// Check permission's usage description key(s) in Info.plist
    /// - Returns: optional OYError
    func checkPrivacyDescription() -> OYError?

    /// Status of Permission
    var status: Status { get }

    /// Authorized status of Permission
    var isAuthorized: Bool { get }

    /// Denied status of Permission
    var isDenied: Bool { get }

    /// Not Determined status of Permission
    var isNotDetermined: Bool { get }

    /// Permission's Usage Description Key(s) in Info.plist
    var descriptionKeys: [String] { get }
}

// MARK: - Default Implementations
extension OYBase {
    /// Default value is `status == .authorized`
    public var isAuthorized: Bool { status == .authorized }

    /// Default value is `status == .denied`
    public var isDenied: Bool { status == .denied }

    /// Default value is `status == .notDetermined`
    public var isNotDetermined: Bool { status == .notDetermined }

    /// Default value is `.unknown`
    public var status: Status { .unknown }
}

// MARK: - Helper Functions
extension OYBase {
    /// Check Info.plist privacy descriptions for permission's usage description key(s)
    /// This method doesn't override, all permission types uses this method
    /// - Returns: optional OYError, if there is null then permission will request
    public func checkPrivacyDescription() -> OYError? {
        let result = PrivacyDescriptionManager.contains(keys: descriptionKeys)
        guard result != nil else { return nil }
        return OYError.missingDescription(description: result)
    }
}
