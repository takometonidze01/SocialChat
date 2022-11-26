//
//  GlobalFunctions.swift
//  SocialChat
//
//  Created by codergirlTM on 26.11.22.
//

import Foundation


func fileNameFrom(fileUrl: String) -> String {
    let name = ((fileUrl.components(separatedBy: "_").last)?.components(separatedBy: "?").first!)?.components(separatedBy: ".").first!
    
    return name!
}
