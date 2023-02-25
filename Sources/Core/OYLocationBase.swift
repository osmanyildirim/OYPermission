//
//  OYLocationBase.swift
//  OYPermission
//
//  Created by osmanyildirim
//

import UIKit

/// `LocationAlways` and `LocationWhenInUse` requestable protocol
public protocol OYLocationBase: OYBaseRequestable { }

extension OYPermission {
    /// Check `LocationAlways` and `LocationWhenInUse` permissions
    /// - Returns: `.notDetermined`, `.authorizedAlways`, `.authorizedWhenInUse` or `.denied`
    ///
    /// `.notDetermined`
    /// - not determined LocationAlways and LocationWhenInUse
    ///
    /// `.authorizedAlways`
    /// - authorized to LocationAlways.
    ///
    /// `.authorizedWhenInUse`
    /// - authorized to LocationWhenInUse.
    ///
    /// `.denied`
    /// - denied LocationAlways and LocationWhenInUse
    public static var locationStatus: Status {
        let always = LocationAlways()
        let whenInUse = LocationWhenInUse()
        let notDetermined = [always.status, whenInUse.status].allSatisfy { $0 == .notDetermined }

        if notDetermined {
            return .notDetermined
        } else if always.isAuthorized {
            return .authorizedAlways
        } else if whenInUse.isAuthorized {
            return .authorizedWhenInUse
        }
        return .denied
    }
}
