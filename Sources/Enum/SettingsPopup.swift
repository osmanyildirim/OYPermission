//
//  SettingsPopup.swift
//  OYPermission
//
//  Created by osmanyildirim
//

import Foundation

public enum SettingsPopup {
    /// Settings popup doesn't show
    case noPopup

    /// Settings popup show with title and message
    case withPopup(title: String, message: String)
}
