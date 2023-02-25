//
//  BluetoothManager.swift
//  OYPermission
//
//  Created by osmanyildirim
//

import CoreBluetooth

/// Bluetooth helper class for Bluetooth Permission
final class BluetoothManager: NSObject, CBCentralManagerDelegate {
    /// Core Bluetooth Central Manager
    private var centralManager: CBCentralManager?

    /// Closure of BluetoothManager
    private var closure: ((Status) -> Void)?

    /// Singleton value of BluetoothManager
    static let shared = BluetoothManager()

    /// Request for Bluetooth authorization status
    /// - Parameter closure: closure handler with Status
    func request(closure: ((Status) -> Void)?) {
        if centralManager == nil {
            centralManager = CBCentralManager(delegate: self, queue: nil)
        }
        self.closure = closure
    }

    /// Invoked whenever the Core Bluetooth Central Manager's state has been updated.
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if #available(iOS 13.0, tvOS 13, *) {
            switch central.authorization {
            case .allowedAlways:
                closure?(.authorized)
            case .denied, .restricted:
                closure?(.denied)
            case .notDetermined:
                closure?(.notDetermined)
            @unknown default:
                closure?(.unknown)
            }
        } else {
            switch CBPeripheralManager.authorizationStatus() {
            case .authorized:
                closure?(.authorized)
            case .denied, .restricted:
                closure?(.denied)
            case .notDetermined:
                closure?(.notDetermined)
            @unknown default:
                closure?(.unknown)
            }
        }
    }

    deinit {
        centralManager?.delegate = nil
    }
}
