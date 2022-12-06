//
//  FirebaseMessageListener.swift
//  SocialChat
//
//  Created by codergirlTM on 07.12.22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class FirebaseMessageListener {
    
    static let shared = FirebaseMessageListener()
    
    private init() { }
    
    //MARK: - Add, update, delete
    
    func addMessage(_ message: LocalMessage, memberId: String) {
        
        do {
            let _ = try firebaseReference(.Messages).document(memberId).collection(message.chatRoomId).document(message.id).setData(from: message)
        } catch {
            print("error saving message", error.localizedDescription)
        }
    }
}
