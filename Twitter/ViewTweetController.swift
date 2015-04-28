//
//  ViewTweetController.swift
//  Twitter
//
//  Created by Hassan Karaouni on 4/28/15.
//  Copyright (c) 2015 Hassan Karaouni. All rights reserved.
//

import UIKit

class ViewTweetController: UIViewController {

    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    
    var username: String!
    var screenname: String!
    var userImgURL: String!
    var time: String!
    var tweet: String!
    
    var tweetID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        usernameLabel.text! = username
        screennameLabel.text! = screenname
        timeLabel.text! = time
        tweetLabel.text! = tweet
        
        
        let url = NSURL(string: userImgURL!)
        let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
        profileImageView.image = UIImage(data: data!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func exitView(sender: UIButton) {
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
