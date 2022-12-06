//
//  FCollectionReference.swift
//  SocialChat
//
//  Created by codergirlTM on 24.11.22.
//

import Foundation
import FirebaseFirestore


enum fCollectionReference: String {
    case User
    case Recent
    case Messages
}

func firebaseReference(_ collectionReference: fCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}
