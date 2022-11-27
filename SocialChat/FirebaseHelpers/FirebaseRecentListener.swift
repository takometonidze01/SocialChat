//
//  FirebaseRecentListener.swift
//  SocialChat
//
//  Created by codergirlTM on 27.11.22.
//

import Foundation
import Firebase

class FirebaseRecentListener {
    
    static let shared = FirebaseRecentListener()
    
    private init() {}
    
    func downloadRecentChatsFromFireStore(completion: @escaping (_ allRecents: [RecentChat]) -> Void) {
        
        firebaseReference(.Recent).whereField(kSENDERID, isEqualTo: User.currentId).addSnapshotListener { (querySnapshot, error) in
            var recentChats: [RecentChat] = []
            
            guard let documents = querySnapshot?.documents else {
                print("no Documents for recent chats")
                return
            }
            
            let allRecents = documents.compactMap { (queryDocumentSnapshot) -> RecentChat? in
                return try? queryDocumentSnapshot.data(as: RecentChat.self)
            }
            
            for recent in allRecents {
                if recent.lastMessage != "" {
                    recentChats.append(recent)
                }
            }
            
            recentChats.sorted(by: { $0.date! > $1.date! })
            completion(recentChats)
            
        }
    }
    
    func resetRecentCounter(chatRoomId: String) {
        firebaseReference(.Recent).whereField(kCHATROOMID, isEqualTo: chatRoomId).whereField(kSENDERID, isEqualTo: User.currentId).getDocuments { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("no documents for recent")
                return
            }
            
            let allRecents = documents.compactMap {  (queryDocumentSnapshot) -> RecentChat? in
                return try? queryDocumentSnapshot.data(as: RecentChat.self)
            }
            
            if allRecents.count > 0 {
                self.clearUnreadConuter(recent: allRecents.first!)
            }
        }
    }
    
    func clearUnreadConuter(recent: RecentChat) {
        var newRecent = recent
        newRecent.unreadCounter = 0
        self.saveRecent(recent)
    }
    
    func saveRecent(_ recent: RecentChat) {
        do {
            try firebaseReference(.Recent).document(recent.id).setData(from: recent)
        } catch {
            print("Error Saving Recent Chat", error.localizedDescription)
        }
    }
    
    func deleteRecent(_ recent: RecentChat) {
        firebaseReference(.Recent).document(recent.id)
    }
}
