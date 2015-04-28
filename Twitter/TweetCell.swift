//
//  tweetCell.swift
//  Twitter
//
//  Created by Hassan Karaouni on 4/26/15.
//  Copyright (c) 2015 Hassan Karaouni. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    var tweetID: String!
    var imgURL: String!
    
    @IBOutlet weak var userImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.usernameLabel.preferredMaxLayoutWidth = self.usernameLabel.frame.width
        self.screennameLabel.preferredMaxLayoutWidth = self.screennameLabel.frame.width
        self.timeLabel.preferredMaxLayoutWidth = self.timeLabel.frame.width
        self.tweetLabel.preferredMaxLayoutWidth = self.tweetLabel.frame.width
        self.retweetLabel.preferredMaxLayoutWidth = self.retweetLabel.frame.width
        self.favoriteLabel.preferredMaxLayoutWidth = self.favoriteLabel.frame.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.usernameLabel.preferredMaxLayoutWidth = self.usernameLabel.frame.width
        self.screennameLabel.preferredMaxLayoutWidth = self.screennameLabel.frame.width
        self.timeLabel.preferredMaxLayoutWidth = self.timeLabel.frame.width
        self.tweetLabel.preferredMaxLayoutWidth = self.tweetLabel.frame.width
        self.retweetLabel.preferredMaxLayoutWidth = self.retweetLabel.frame.width
        self.favoriteLabel.preferredMaxLayoutWidth = self.favoriteLabel.frame.width
    }
}
