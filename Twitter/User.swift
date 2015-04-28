//
//  User.swift
//  Twitter
//
//  Created by Hassan Karaouni on 4/24/15.
//  Copyright (c) 2015 Hassan Karaouni. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "curUserKey"
let userDidLoginNotification = "userDidLogin"
let userDidLogoutNotification = "userDidLogout"

class User: NSObject {
    var name: String?
    var screenname: String?
    var profileImageURL: String?
    var tagline: String?
    
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        profileImageURL = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                var data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data != nil {
                    var dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser

        }
        set(user) {
            _currentUser = user
            
            // persist the user using JSON and NSUserDefaults
            if _currentUser != nil {
                var data = NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: nil, error: nil)
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                NSUserDefaults.standardUserDefaults().synchronize()
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}
