//
//  IncomingMessage.swift
//  SocialChat
//
//  Created by codergirlTM on 07.12.22.
//

import Foundation
import MessageKit
import CoreLocation

class IncomingMessage {
    
    var messagesCollectionView: MessagesCollectionView
    
    init(_collectionView: MessagesCollectionView) {
        messagesCollectionView = _collectionView
    }
    
    //MARK: - CreateMessage
    
    func createMessage(localMessage: LocalMessage) -> MKMessage? {
        let mkMessage = MKMessage(message: localMessage)
        
        return mkMessage
    }
}
