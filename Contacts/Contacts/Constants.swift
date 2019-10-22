//
//  Constants.swift
//  Contacts
//
//  Created by Uzair Dhada on 19/10/19.
//  Copyright © 2019 Go Jek. All rights reserved.
//

import Foundation
import UIKit

enum ConstantStrings:String {
    case contactID
    case Gallery
    case Camera
    case Remove
    case Cancel
    case invalidPhoneNumber = "Kindly Enter proper mobile number."
}

class Constants: NSObject {
    struct Screen
    {
        static let storyboard = UIStoryboard(name: "Main", bundle: nil)
    }
}
