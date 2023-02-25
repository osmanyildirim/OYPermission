//
//  OYError.swift
//  OYPermission
//
//  Created by osmanyildirim
//

import Foundation

public enum OYError: Error, CustomStringConvertible {
    /// Permission's usage description key(s) is missing in Info.plist
    case missingDescription(description: String?)

    /// FaceID is unavailable
    case faceIdUnavailable

    /// Usage description key(s) missing description
    public var description: String {
        switch self {
        case .missingDescription(let message): return message ?? ""
        default: return localizedDescription
        }
    }
}
