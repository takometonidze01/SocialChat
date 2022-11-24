//
//  FirebaseUserListener.swift
//  SocialChat
//
//  Created by codergirlTM on 24.11.22.
//

import Foundation
import Firebase

class FirebaseUserListener {
    
    static let shared = FirebaseUserListener()
    
    private init () {}
    
    //MARK: - Login
    
    func loginUserWithEmail(email: String, password: String, completion: @escaping (_ error: Error?, _ isEmailVerified: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (AuthDataResult, error) in
            if error == nil && AuthDataResult!.user.isEmailVerified {
                
                FirebaseUserListener.shared.downloadUserFromFirebase(userId: AuthDataResult!.user.uid, email: email)
                completion(error, true)
            } else {
                print("email is not verified")
                completion(error, false)
            }
        }
    }
    
    //MARK: - Register
    
    func registerUserWith(email: String, password: String, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { authDataResult, error in
            completion(error)
            
            if error == nil {
                authDataResult!.user.sendEmailVerification{ (error) in
                    print("auth email sent error: ", error?.localizedDescription)
                }
                
                //create user and save it
                
                if authDataResult?.user != nil {
                    let user = User(id: authDataResult!.user.uid, username: email, email: email, pushId: "", avatarLink: "", status: "Hey there I'm using SocialChat")
                    saveUserLocally(user)
                    self.saveUserToFirestore(user)
                }
            }
        }
    }
    
    func resetPasswordFor(email: String, completion: @escaping(_ error: Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
    
    //MARK: - Save users
    func saveUserToFirestore(_ user: User) {
        do {
            try firebaseReference(.User).document(user.id).setData(from: user)
        } catch {
            print(error.localizedDescription, "Adding user")
        }
    }
    
    //MARK: - Resend link methods
    func resendVerificationEmail(email: String, completion: @escaping(_ error: Error?) -> Void) {
        Auth.auth().currentUser?.reload(completion: { error in
            Auth.auth().currentUser?.sendEmailVerification(completion: { error in
                completion(error)
            })
        })
    }
    
    //MARK: - Download
    
    func downloadUserFromFirebase(userId: String, email: String? = nil) {
        firebaseReference(.User).document(userId).getDocument { querySnapshot, error in
            guard let document = querySnapshot else {
                print("no document for user")
                return
            }
            
            let result = Result {
                try? document.data(as: User.self)
            }
            
            switch result {
            case .success(let userObject):
                if let user = userObject {
                    saveUserLocally(user)
                } else {
                    print(" Document does not exist")
                }
            case .failure(let error):
                print("error decoding user ", error)
            }
        }
    }
}
