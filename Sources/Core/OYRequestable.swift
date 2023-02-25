//
//  OYRequestable.swift
//  OYPermission
//
//  Created by osmanyildirim
//

import CoreMotion
import HealthKit

public typealias OYBaseRequestable = OYBase & OYBaseRequest
public typealias OYHealthKitRequestable = OYBase & OYHealthKitRequest
public typealias OYCoreMotionRequestable = OYBase & OYCoreMotionRequest

public protocol OYBaseRequest {
    /// Request for permission authorization except `HealthKit` and `CoreMotion`
    /// - Parameter closure: closure handler with granted and optional error
    func request(closure: ((_ granted: Bool, _ error: Error?) -> Void)?)
}

public protocol OYHealthKitRequest {
    /// Request for `HealthKit` permission authorization
    /// - Parameters:
    ///   - shareTypes: sharing Health types
    ///   - readTypes: reading Health types
    ///   - closure: closure handler with granted and optional error
    func request(shareTypes: Set<HKSampleType>, readTypes: Set<HKObjectType>, closure: ((_ granted: Bool, _ error: Error?) -> Void)?)
}

public protocol OYCoreMotionRequest {
    /// Request for `CoreMotion` permission authorization
    /// - Parameter closure: closure handler with activities and optional error
    func request(closure: ((_ activities: [CMMotionActivity]?, _ error: Error?) -> Void)?)
}
