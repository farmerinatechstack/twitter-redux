//
//  TweetViewController.swift
//  Twitter
//
//  Created by Hassan Karaouni on 4/27/15.
//  Copyright (c) 2015 Hassan Karaouni. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var userProfileView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tweetButton: UIButton!
    
    var username: String!
    var screenname: String!
    var profileImageURL: String!
    
    var reply: Bool?
    var replyAt: String?
    var id: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.userLabel!.text = username
        self.screennameLabel!.text = "@\(screenname)"
        
        var url = NSURL(string: self.profileImageURL)
        var data = NSData(contentsOfURL: url!)
        userProfileView.image = UIImage(data: data!)
        
        tweetButton.enabled = false
        
        textView.delegate = self
        textView.becomeFirstResponder()
        
        if reply == true {
            textView.text = replyAt! as String
        }
    }
    
    @IBAction func exit(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidChange(textView: UITextView) {
        var tweet = textView.text!
        var cnt = count(tweet)
        
        if (cnt == 0 || cnt > 140) {
            tweetButton.enabled = false
        } else {
            tweetButton.enabled = true
        }
    }
    
    @IBAction func sendTweet(sender: AnyObject) {
        var params: NSMutableDictionary = NSMutableDictionary()
        var tweet = textView.text!
        params.setObject(tweet, forKey: "status")
        
        if reply == true {
            params.setObject(id!, forKey:"in_reply_to_status_id")
        }
        
        TwitterClient.sharedInstance.postTweet(params, completion: {
            (error) -> () in
            if error == nil {
                println("Tweeted!")
            } else {
                println("Failed to post tweet")
                println(error)
            }
        })
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
    */

}
