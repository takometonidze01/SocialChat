//
//  Date + Extension.swift
//  SocialChat
//
//  Created by codergirlTM on 27.11.22.
//

import UIKit

extension Date {
    
    func longDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
