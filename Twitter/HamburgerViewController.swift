//
//  HamburgerViewController.swift
//  Twitter
//
//  Created by Hassan Karaouni on 5/5/15.
//  Copyright (c) 2015 Hassan Karaouni. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {
    
    var contentOriginalCenter: CGPoint!
    var contentUnmovedCenterX: CGFloat!
    var contentMovedCenterX: CGFloat!
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    var menuViewController: UIViewController? {
        didSet {
            configureMenuViewController()
        }
    }
    
    var contentViewController: UIViewController? {
        didSet {
            configureContentViewController()
        }
    }
    
    func configureMenuViewController() {
        if menuView != nil {
            menuViewController!.view.frame = menuView.bounds
            for subview in menuView.subviews {
                subview.removeFromSuperview()
            }
            menuView.addSubview(menuViewController!.view)
        }
    }
    
    func configureContentViewController() {
        if contentView != nil {
            contentViewController!.view.frame = contentView.bounds
            for subview in contentView.subviews {
                subview.removeFromSuperview()
            }
            contentView.addSubview(contentViewController!.view)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure vc positions
        contentUnmovedCenterX = contentView.center.x
        contentMovedCenterX = contentView.center.x + 200
        
        // Configure vc's
        configureMenuViewController()
        configureContentViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPanGesture(sender: UIPanGestureRecognizer) {
        var translation = sender.translationInView(view)
        var velocity = sender.velocityInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            
            contentOriginalCenter = contentView.center
            contentView.center = CGPoint(x: contentOriginalCenter.x + translation.x, y: contentOriginalCenter.y)
            sender.setTranslation(CGPointZero, inView: self.view)

        } else if sender.state == UIGestureRecognizerState.Ended {
            if velocity.x > 0 { // snap open
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: nil, animations: { () -> Void in
                    self.contentView.center.x = self.contentMovedCenterX
                    }, completion: { (success: Bool) -> Void in
                        println("finished opening")
                })
            } else { // snap closed
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: nil, animations: { () -> Void in
                    self.contentView.center.x = self.contentUnmovedCenterX
                    }, completion: { (success: Bool) -> Void in
                        println("finished closing")
                })
            }
        } else {
            println("Reached unhandled sender state hamburger pan")
        }
        
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
