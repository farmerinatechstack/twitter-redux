//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Hassan Karaouni on 5/6/15.
//  Copyright (c) 2015 Hassan Karaouni. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var numTweetsLabel: UILabel!
    
    @IBOutlet weak var numFollowersLabel: UILabel!
    
    @IBOutlet weak var numFollowingLabel: UILabel!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
                
        println(user)
        
        var url = NSURL(string: user.profileImageURL!)
        var data = NSData(contentsOfURL: url!)
        profileImage.image = UIImage(data: data!)
        
        numTweetsLabel.text! = "Total Tweets \(user.numTweets)"
        numFollowersLabel.text! = "Followed by \(user.followers)"
        numFollowingLabel.text! = "Following \(user.following)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
