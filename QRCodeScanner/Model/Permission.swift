//
//  Permission.swift
//  QRCodeScanner
//
//  Created by Yunus Emre Taşdemir on 26.09.2023.
//

import SwiftUI

// Camera Permission Enum 
enum Permission: String {
    case idle = "Not Determined"
    case approved = "Access Granted"
    case denied = "Access Denied"
}
