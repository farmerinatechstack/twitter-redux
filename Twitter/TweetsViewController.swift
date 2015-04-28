//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Hassan Karaouni on 4/26/15.
//  Copyright (c) 2015 Hassan Karaouni. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    var tweets: [Tweet]? = []
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160.0
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "fetchTweets", forControlEvents: UIControlEvents.ValueChanged)
        
        let dummyTableVC = UITableViewController()
        dummyTableVC.tableView = tableView
        dummyTableVC.refreshControl = refreshControl
        
        fetchTweets()
    }
    
    
    func fetchTweets() {
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: {
                (tweets, error) -> () in
                if error == nil {
                    println("Retrieved Tweets")
                    self.tweets = tweets
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                } else {
                    println(error)
                }
            })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        var tweet = tweets![indexPath.row] as Tweet
        
        cell.usernameLabel.text = tweet.user!.name
        cell.tweetLabel.text = tweet.text
        var screenname = tweet.user!.screenname
        cell.screennameLabel.text = "@\(screenname!)"
        
        var timeAgo = getTimeAgo(tweet)
        cell.timeLabel.text = timeAgo
        
        cell.retweetLabel.text = tweet.numRetweets
        cell.favoriteLabel.text = tweet.numFavorites
        
        let url = NSURL(string: tweet.user!.profileImageURL!)
        let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
        cell.userImage.image = UIImage(data: data!)
        
        cell.tweetID = tweet.tweetID!
        cell.imgURL = tweet.user!.profileImageURL
        
        return cell
    }
    
    func getTimeAgo(tweet: Tweet) -> String {
        var createdAt = tweet.createdAt!
        let timeAgo = Int(createdAt.timeIntervalSinceNow * -1.0)
        
        if (timeAgo < 120) {
            return "1 m"
        }
            
        var minsAgo = timeAgo/60
        if (minsAgo < 60) {
            return "\(minsAgo) m"
        }
        
        var hoursAgo = minsAgo/60
        if (hoursAgo < 24) {
            return "\(hoursAgo) h"
        }

        var daysAgo = hoursAgo/24
        return "\(daysAgo) d"
    }
    
    @IBAction func retweetTouched(sender: UIButton) {
        println("Retweeting")
        var button = sender
        var content = button.superview! as UIView
        
        var cell = content.superview as! TweetCell
        var numRetweets = cell.retweetLabel.text!
        var intRetweets = numRetweets.toInt()!
        cell.retweetLabel.text! = "\(intRetweets+1)"
        
        TwitterClient.sharedInstance.retweet(cell.tweetID, completion: {
            (error) -> () in
            if error == nil {
                println("Retweeted!")
            } else {
                println("Failed to retweet")
                println(error)
            }
        })
    }
    
    @IBAction func favoriteTouched(sender: UIButton) {
        println("Favoriting")
        var button = sender
        var content = button.superview! as UIView
        
        var cell = content.superview as! TweetCell
        var numFaves = cell.favoriteLabel.text!
        var intFaves = numFaves.toInt()!
        cell.favoriteLabel.text! = "\(intFaves+1)"
        
        var params: NSMutableDictionary = NSMutableDictionary()
        params.setObject(cell.tweetID, forKey: "id")
        
        TwitterClient.sharedInstance.favoriteTweet(params, completion: {
            (error) -> () in
            if error == nil {
                println("Retweeted!")
            } else {
                println("Failed to retweet")
                println(error)
            }
        })
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    
        if (segue.identifier! == "TweetSegue") {
            println("Navigating to Tweet View")
            var tweetView = segue.destinationViewController as! TweetViewController
            tweetView.username = User.currentUser!.name
            tweetView.screenname = User.currentUser!.screenname
            tweetView.profileImageURL = User.currentUser!.profileImageURL
        } else if (segue.identifier! == "ReplySegue") {
            println("Navigating to Tweet View for reply")
            var button = sender as! UIButton
            var content = button.superview! as UIView
            
            var cell = content.superview as! TweetCell
            
            var tweetView = segue.destinationViewController as! TweetViewController
            tweetView.username = User.currentUser!.name
            tweetView.screenname = User.currentUser!.screenname
            tweetView.profileImageURL = User.currentUser!.profileImageURL
            tweetView.reply = true
            var screenname = cell.screennameLabel.text! as String
            tweetView.replyAt = "\(screenname) "
            tweetView.id = cell.tweetID
        } else {
            var cell = sender as! TweetCell
            
            var tweetVC = segue.destinationViewController as! ViewTweetController
            
            tweetVC.tweetID = cell.tweetID!
            tweetVC.username = cell.usernameLabel.text!
            tweetVC.screenname = cell.screennameLabel.text!
            tweetVC.time = cell.timeLabel.text!
            tweetVC.userImgURL = cell.imgURL
            tweetVC.tweet = cell.tweetLabel.text!
        }
    }
}
