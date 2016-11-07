	//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by anegrete on 10/29/16.
//  Copyright © 2016 Alejandra Negrete. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import MediaPlayer

class TweetTableViewCell: UITableViewCell {

	@IBOutlet weak var profileImageView: UIImageView!
	@IBOutlet weak var tweetTextLabel: TTTAttributedLabel!
	@IBOutlet weak var screennameLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var createdAtLabel: UILabel!
	@IBOutlet weak var retweetButton: UIButton!
	@IBOutlet weak var favoriteButton: UIButton!
	@IBOutlet weak var retweetCountLabel: UILabel!
	@IBOutlet weak var favoriteCountLabel: UILabel!
	@IBOutlet weak var mediaImageView: UIImageView!
	@IBOutlet weak var mediaHeightConstraint: NSLayoutConstraint!

	var originalTweet: Tweet!

	var tweet: Tweet! {
		didSet {

			if let retweet = tweet.retweetedStatus {
				tweet = retweet
			}

			tweetTextLabel.text = tweet.text!

			profileImageView.setImageWith((tweet.user?.profileUrl)!)
			let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapProfileImageView))
			profileImageView.isUserInteractionEnabled = true
			tapGestureRecognizer.delegate = self
			profileImageView.addGestureRecognizer(tapGestureRecognizer)
			screennameLabel.text = "@" + (tweet.user?.screenname)!
			nameLabel.text = tweet.user?.name!
			createdAtLabel.text = Date.shortDescription(date: tweet.timestamp!)

			// Retweet
			retweetCountLabel.text = String(tweet.retweetCount)
			retweetCountLabel.textColor = tweet.isRetweeted ? Color.green : Color.lightGray
			retweetButton.isSelected = tweet.isRetweeted

			// Favorite
			favoriteCountLabel.text = String(tweet.favoriteCount)
			favoriteCountLabel.textColor = tweet.isFavorited ? Color.red : Color.lightGray
			favoriteButton.isSelected = tweet.isFavorited

			if let media = tweet.mediaUrl {
				mediaImageView.setImageWith(media)
				mediaHeightConstraint.constant = 170
			}
			else {
				mediaImageView.image = nil
				mediaHeightConstraint.constant = 0
			}
		}
	}

	// MARK: - View Lifecycle

	override func awakeFromNib() {
		super.awakeFromNib()

		profileImageView.layer.cornerRadius = 3
		profileImageView.clipsToBounds = true

		mediaImageView.layer.cornerRadius = 3
		mediaImageView.clipsToBounds = true
	}

	// MARK: - Twitter Actions

	@IBAction func didTapReplyButton(_ sender: UIButton) {
		UIStoryboard.presentComposeViewControllerWith(tweet: tweet)
	}

	@IBAction func didTapRetweetButton(_ sender: UIButton) {
		if tweet.isRetweeted {
			TwitterClient.shared?.deleteRetweet(
				tweet: tweet,
				success: { (updatedTweet: Tweet) in
					self.tweet = updatedTweet
				},
				failure: { (error: Error) in
					UIHelper.showError(message: "Can't delete retweet right now. Please try again later")
			})
		}
		else {
			TwitterClient.shared?.retweet(
				tweet: tweet,
				success: { (updatedTweet: Tweet) in
					self.tweet = updatedTweet
				},
				failure: { (error: Error) in
					print(error.localizedDescription)
					UIHelper.showError(message: "Can't retweet right now. Please try again later")
			})
		}
	}

	@IBAction func didTapFavoriteButton(_ sender: UIButton) {

		if tweet.isFavorited {
			TwitterClient.shared?.unFavorite(
				tweet: tweet,
				success: { (updatedTweet: Tweet) in
					self.tweet = updatedTweet
				},
				failure: { (error: Error) in
					print(error.localizedDescription)
					UIHelper.showError(message: "Can't unfavorite right now. Please try again later")
			})
		}
		else {
			TwitterClient.shared?.favorite(
				tweet: tweet,
				success: { (updatedTweet: Tweet) in
					self.tweet = updatedTweet
				},
				failure: { (error: Error) in
					print(error.localizedDescription)
					UIHelper.showError(message: "Can't favorite right now. Please try again later")
			})
		}
	}

	// MARK: - Gestures

	@IBAction func didTapProfileImageView(_ sender: UITapGestureRecognizer) {
		UIStoryboard.showProfileViewControllerWith(user: tweet.user!)
	}

	override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
}
