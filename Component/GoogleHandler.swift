//
//  GoogleHandler.swift
//  GoogleIntegration
//
//  Created by Pravin on 28/09/16.
//  Copyright © 2016 com.perennial. All rights reserved.
//

import Foundation

private let CLIENT_KEY = "715137184019-qmcqpkplldj4u3ls07a5sjgiod6njn9o.apps.googleusercontent.com"
private let imageDimention  : UInt = 120

protocol GoogleHandlerDelegate {
    
    func googleLoginSuccess(userModel : UserModel)
    func googleLoginFailed(error : NSError)
}

class GoogleHandler: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
 
    var delegate : GoogleHandlerDelegate?
    
    func signIn() {
        GIDSignIn.sharedInstance().clientID = CLIENT_KEY;
        GIDSignIn.sharedInstance().delegate = self;
       GIDSignIn.sharedInstance().uiDelegate = self;
        GIDSignIn.sharedInstance().shouldFetchBasicProfile = true;
        GIDSignIn.sharedInstance().signIn();
    }
    
    func signOut()  {
       GIDSignIn.sharedInstance().signOut();
    }
    
    //MARK: - GoogleHandler delegate method
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if (error == nil) {
            
            let userModel = UserModel()
            userModel.userFullName = user.profile.name
           userModel.socialId = user.userID
            userModel.emailId = user.profile.email
            userModel.profilePicUrl = user.profile.imageURLWithDimension(imageDimention)
            userModel.socilaAccessToken = user.authentication.accessToken
            delegate?.googleLoginSuccess(userModel)
    
        } else {
            print("\(error.localizedDescription)")
            delegate?.googleLoginFailed(error)
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        
       delegate?.googleLoginFailed(error)
    }
}
