//
//  MenuViewController.swift
//  Twitter
//
//  Created by Hassan Karaouni on 5/6/15.
//  Copyright (c) 2015 Hassan Karaouni. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    var hamburgerVC: HamburgerViewController?
    
    var tweetsVC: TweetsViewController!
    var profileVC: ProfileViewController!
    var mentionsVC: MentionsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tweetsVC = storyboard?.instantiateViewControllerWithIdentifier("TweetsViewController") as! TweetsViewController
        tweetsVC.hamburgerVC = self.hamburgerVC
        
        self.profileVC = storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
        
        self.mentionsVC = storyboard?.instantiateViewControllerWithIdentifier("MentionsViewController") as! MentionsViewController
        mentionsVC.hamburgerVC = self.hamburgerVC
    }
    
    @IBAction func profileButtonBressed(sender: UIButton) {
        println("Switching to Profile")
        profileVC.user = User.currentUser!
        hamburgerVC?.contentViewController = profileVC
    }
    

    @IBAction func homeButtonPressed(sender: UIButton) {
        println("Switching to Home")
        hamburgerVC?.contentViewController = tweetsVC
    }
    
    @IBAction func mentionsButtonPressed(sender: UIButton) {
        println("Switching to Mentions")
        hamburgerVC?.contentViewController = mentionsVC
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
