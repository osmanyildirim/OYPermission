//
//  Status.swift
//  OYPermission
//
//  Created by osmanyildirim
//

import Foundation

public enum Status {
    /// User grants access
    case authorized

    /// User grants access to location when in use
    case authorizedWhenInUse

    /// User grants access to location always
    case authorizedAlways

    /// User denies access
    case denied

    /// User has not been asked for access yet
    case notDetermined

    /// Unsupported this permission
    case notSupported

    /// Access is restricted by the system
    case restrictedBySystem

    /// Unknown status of permission
    case unknown
}
