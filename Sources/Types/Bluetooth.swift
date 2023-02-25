//
//  Bluetooth.swift
//  OYPermission
//
//  Created by osmanyildirim
//

import CoreBluetooth

/// Add the corresponding string with `NSBluetoothAlwaysUsageDescription` and `NSBluetoothPeripheralUsageDescription` keys to your Info.plist that describes a purpose of your access requests.
public final class Bluetooth: OYBaseRequestable {
    /// Status of Bluetooth Permission
    ///
    /// `.authorized`
    /// - authorized to Bluetooth.
    ///
    /// `.denied`
    /// -  not authorized to Bluetooth.
    /// -  application is not authorized to access the service (restricted).
    ///
    /// `.notDetermined`
    /// - has not been asked for access yet.
    ///
    /// `.unknown`
    /// - unknown status.
    public var status: Status {
        getStatus()
    }

    /// Permission's Usage Description Key(s) in Info.plist
    public var descriptionKeys: [String] { ["NSBluetoothAlwaysUsageDescription", "NSBluetoothPeripheralUsageDescription"] }

    /// Asks to user for access the Bluetooth
    /// - Parameter closure: closure handler with granted and optional error
    public func request(closure: ((_ granted: Bool, _ error: Error?) -> Void)?) {
        let result = checkPrivacyDescription()
        guard result == nil else {
            closure?(false, result)
            return
        }

        BluetoothManager.shared.request { status in
            closure?(status == .authorized, nil)
        }
    }

    /// Fetch status of the Bluetooth
    /// - Returns: authorization status
    private func getStatus() -> Status {
        if #available(iOS 13.0, tvOS 13.0, *) {
            switch CBCentralManager().authorization {
            case .allowedAlways:
                return .authorized
            case .denied, .restricted:
                return .denied
            case .notDetermined:
                return .notDetermined
            @unknown default:
                return .unknown
            }
        } else {
            switch CBPeripheralManager.authorizationStatus() {
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
    }
}
