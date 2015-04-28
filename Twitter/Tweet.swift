//
//  Tweet.swift
//  Twitter
//
//  Created by Hassan Karaouni on 4/24/15.
//  Copyright (c) 2015 Hassan Karaouni. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var numRetweets: String?
    var numFavorites: String?
    var tweetID: String?
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        
        var retweets = dictionary["retweet_count"] as! Int
        numRetweets = "\(retweets)"
        var faves = dictionary["favorite_count"] as! Int
        numFavorites = "\(faves)"
        
        tweetID = dictionary["id_str"] as? String
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            //println("Original Tweet:")
            //println(dictionary)
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }
}
