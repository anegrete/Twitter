//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by anegrete on 10/29/16.
//  Copyright © 2016 Alejandra Negrete. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

	@IBOutlet weak var tweetTextLabel: UILabel!
	@IBOutlet weak var profileImageView: UIImageView!
	@IBOutlet weak var screennameLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var createdAtLabel: UILabel!
	@IBOutlet weak var replyButton: UIButton!
	@IBOutlet weak var retweetButton: UIButton!
	@IBOutlet weak var favoriteButton: UIButton!
	@IBOutlet weak var retweetAndFavoriteCountLabel: UILabel!
	@IBOutlet weak var mediaImageView: UIImageView!
	@IBOutlet weak var mediaImageViewHeightConstraint: NSLayoutConstraint!

	var tweet: Tweet!

	// MARK: - View Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		initTweet()
		initNavigationItem()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		UIHelper.blueNavigationBarFor(viewController: self)
	}

	// MARK: - Initializations

	func initTweet() {
		initLabels()
		initProfileImage()
		initMediaImage()
		initRetweetViews()
		initFavoriteViews()
	}

	func initLabels() {
		tweetTextLabel.text = tweet.text!
		screennameLabel.text = "@" + (tweet.user?.screenname)!
		nameLabel.text = tweet.user?.name!
		createdAtLabel.text = Date.longDescription(date: tweet.timestamp!)
		createdAtLabel.textColor = Color.darkGray
	}

	func initProfileImage() {
		profileImageView.setImageWith((tweet.user?.profileUrl)!)
		profileImageView.layer.cornerRadius = 3
		profileImageView.clipsToBounds = true
		addProfileImageViewTapGesture()
	}

	func initMediaImage() {
		if let media = tweet.mediaUrl {
			mediaImageView.setImageWith(media)
			mediaImageViewHeightConstraint.constant = 270
		}
		else {
			mediaImageView.image = nil
			mediaImageViewHeightConstraint.constant = 0
		}
		mediaImageView.layer.cornerRadius = 3
		mediaImageView.clipsToBounds = true
	}

	func initRetweetViews() {
		retweetAndFavoriteCountLabel.text = String(tweet.retweetCount) + " RETWEETS   " + String(tweet.favoriteCount) + " LIKES"
		retweetButton.isSelected = tweet.isRetweeted
	}

	func initFavoriteViews() {
		favoriteButton.isSelected = tweet.isFavorited
	}

	func initNavigationItem() {
		self.navigationItem.title = "Tweet"
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
					self.initTweet()
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
					self.initTweet()
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
					self.initTweet()
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
					self.initTweet()
				},
				failure: { (error: Error) in
					print(error.localizedDescription)
					UIHelper.showError(message: "Can't favorite right now. Please try again later")
			})
		}
	}

	// MARK: - Gestures

	func addProfileImageViewTapGesture() {
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapProfileImageView))
		profileImageView.isUserInteractionEnabled = true
		profileImageView.addGestureRecognizer(tapGestureRecognizer)
	}

	@IBAction func didTapProfileImageView(_ sender: UITapGestureRecognizer) {
		UIStoryboard.showProfileViewControllerWith(user: tweet.user!)
	}
}
