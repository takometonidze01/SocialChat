//
//  MKMessage.swift
//  SocialChat
//
//  Created by codergirlTM on 28.11.22.
//

import Foundation
import MessageKit
import CoreLocation

class MKMessage: NSObject, MessageType {
    
    var messageId: String = ""
    var kind: MessageKit.MessageKind
    var sentDate: Date
    var incoming: Bool
    var mkSender: MKSender
    var sender: MessageKit.SenderType {return mkSender}
    var senderInitials: String
        
    var status: String
    var readDate: Date
    
    init(message: LocalMessage) {
        self.messageId = message.id
        self.mkSender = MKSender(senderId: message.senderId, displayName: message.senderName)
        self.status = message.status
        self.kind = MessageKind.text(message.message)
        
//        switch message.type {
//        case
//        }
        
        self.senderInitials = message.senderInitials
        self.sentDate = message.date
        self.readDate = message.readDate
        self.incoming = User.currentId != mkSender.senderId
    }
    
}
