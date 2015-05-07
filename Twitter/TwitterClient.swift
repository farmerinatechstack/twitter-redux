//
//  TwitterClient.swift
//  Twitter
//
//  Created by Hassan Karaouni on 4/24/15.
//  Copyright (c) 2015 Hassan Karaouni. All rights reserved.
//

import UIKit

let twitterConsumerKey = "NtmDy7bd5mxt5n3ACYxMYLMs2"
let twitterConsumerSecret = "bk3FNtTHYpNtq6tioHXyym0bQRni7xR2PBJj1AV3vsQQWiMWx8"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance =  TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            // println(response)
            var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
        }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Failed to get home timeline")
                self.loginCompletion?(user: nil, error: error)
                completion(tweets: nil, error: error)
        })
    }
    
    func mentionsTimeline(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("https://api.twitter.com/1.1/statuses/mentions_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            // println(response)
            var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Failed to get mentions")
                self.loginCompletion?(user: nil, error: error)
                completion(tweets: nil, error: error)
        })
    }
    
    func postTweet(params: NSDictionary?, completion: (error: NSError?) -> ()) {
        POST("1.1/statuses/update.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                //println(response)
                completion(error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Failed to tweet")
                completion(error: error)
        })
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // Fetch request token and redirect to auth page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL:NSURL(string:"cptwitterdemo://oauth"), scope: nil, success:{
            (requestToken: BDBOAuth1Credential!) -> Void in
                println("Retrieved request token")
                var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                UIApplication.sharedApplication().openURL(authURL!)
            }) {(error: NSError!) -> Void in
                println("Failed to retrieve request token")
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func favoriteTweet(params: NSDictionary?, completion: (error: NSError?) -> ()) {
        POST("1.1/favorites/create.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                //println(response)
                completion(error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Failed to favorite")
                completion(error: error)
        })
    }
    
    func retweet(id: String, completion: (error: NSError?) -> ()) {
        POST("1.1/statuses/retweet/\(id).json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            //println(response)
            completion(error: nil)
        }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println("Failed to retweet")
            completion(error: error)
        })
    }
    
    func openAuthURL(url: NSURL) {
        println("Opening Auth URL")
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
                println("Retrieved access token")
                // save access token
                TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil,
                    success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                        var user = User(dictionary: response as! NSDictionary)
                        println("user: \(user.name)")
                        User.currentUser = user
                        self.loginCompletion?(user: user, error: nil)
                    }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                        println("Error fetching user data")
                        self.loginCompletion?(user: nil, error: error)
                })
            }) { (error: NSError!) -> Void in
                println("Failed to retrieve access token")
                println(error)
        }
    }
}
