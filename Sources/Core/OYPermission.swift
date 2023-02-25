//
//  OYPermission.swift
//  OYPermission
//
//  Created by osmanyildirim
//

import Foundation

/// OYPermission singleton variables/functions
public final class OYPermission {
    /// `OYPermission.bluetooth`
    public static var bluetooth = Bluetooth()

    /// `OYPermission.calendar`
    public static var calendar = Calendar()

    /// `OYPermission.camera`
    public static var camera = Camera()

    /// `OYPermission.contacts`
    public static var contacts = Contacts()

    /// `OYPermission.faceID`
    public static var faceID = FaceID()

    /// `OYPermission.health`
    public static var health = Health()

    /// `OYPermission.mediaLibrary`
    public static var mediaLibrary = MediaLibrary()

    /// `OYPermission.microphone`
    public static var microphone = Microphone()

    /// `OYPermission.bluetooth`
    public static var motion = Motion()

    /// `OYPermission.notifications`
    public static var notifications = Notifications()

    /// `OYPermission.photos`
    public static var photos = Photos()

    /// `OYPermission.reminders`
    public static var reminders = Reminders()

    /// `OYPermission.siri`
    public static var siri = Siri()

    /// `OYPermission.speechRecognition`
    public static var speechRecognition = SpeechRecognition()

    /// `OYPermission.tracking`
    /// @available on iOS 14.0
    @available(iOS 14, *) public static var tracking = Tracking()

    /// `OYPermission.location(.always)` or `OYPermission.location(.whenInUse)`
    public static func location(_ type: Location) -> OYLocationBase {
        if type == .always {
            return LocationAlways()
        } else {
            return LocationWhenInUse()
        }
    }
    
}
