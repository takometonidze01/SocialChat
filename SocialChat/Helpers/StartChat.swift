//
//  StartChat.swift
//  SocialChat
//
//  Created by codergirlTM on 27.11.22.
//

import Foundation
import Firebase


//MARK: - StartChat
func startChat(user1: User, user2: User) -> String {
    let chatRoomId = chatRoomIdFrom(user1Id: user1.id, User2Id: user2.id)
    createRecentItems(chatRoomId: chatRoomId, users: [user1, user2])
    return chatRoomId
}

func createRecentItems(chatRoomId: String, users: [User]) {
    
    var memberIdsToCreateRecent = [users.first!.id, users.last!.id]
    //does user have recent?
    firebaseReference(.Recent).whereField(kCHATROOMID, isEqualTo: chatRoomId).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else { return }
        
        if !snapshot.isEmpty {
            memberIdsToCreateRecent = removeMemberWhoHasRecent(snapshot: snapshot, memberIds: memberIdsToCreateRecent)
        }
        
        for userId in memberIdsToCreateRecent {
            let senderUser = userId == User.currentId ? User.currentUser! : getReceiverFrom(users: users)
            
            let receiverUser = userId == User.currentId ? getReceiverFrom(users: users) : User.currentUser!
            
            let recentObject = RecentChat(id: UUID().uuidString, chatRoomId: chatRoomId, senderId: senderUser.id, senderName: senderUser.username, receiverId: receiverUser.id, receiverName: receiverUser.username, date: Date(), memberIds: [senderUser.id, receiverUser.id], lastMessage: "", unreadCounter: 0, avatarLink: receiverUser.avatarLink)
            
            FirebaseRecentListener.shared.saveRecent(recentObject)
            
        }
    }
    
}

func removeMemberWhoHasRecent(snapshot: QuerySnapshot, memberIds: [String]) -> [String] {
    var memberIdsToCreateRecent = memberIds
    
    for recentDate in snapshot.documents {
        let currentRecent = recentDate.data() as Dictionary
        
        if let currentUserId = currentRecent[kSENDERID] {
            if memberIdsToCreateRecent.contains(currentUserId as! String) {
                memberIdsToCreateRecent.remove(at: memberIdsToCreateRecent.firstIndex(of: currentUserId as! String)!)
            }
        }
    }
    
    return memberIdsToCreateRecent
}

func chatRoomIdFrom(user1Id: String, User2Id: String) -> String {
    var chatRoomId = ""
    
    let value = user1Id.compare(User2Id).rawValue
    
    chatRoomId = value < 0 ? (user1Id + User2Id) : (User2Id + user1Id)
    
    return chatRoomId
}


func getReceiverFrom(users: [User]) -> User {
    
    var allUser = users
    
    return allUser.remove(at: allUser.firstIndex(of: User.currentUser!)!)
}