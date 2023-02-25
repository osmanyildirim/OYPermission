//
//  Location.swift
//  OYPermission
//
//  Created by osmanyildirim
//

import Foundation

public enum Location {
    /// User has granted authorization to use their location at any time.  Your app may be launched into the background by monitoring APIs such as visit monitoring, region monitoring, and significant location change monitoring.
    case always

    /// User has granted authorization to use their location only while they are using your app.
    case whenInUse
}
