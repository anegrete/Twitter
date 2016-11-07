//
//  ProfileViewController.swift
//  Twitter
//
//  Created by anegrete on 11/5/16.
//  Copyright © 2016 Alejandra Negrete. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class ProfileViewController: TweetsViewController {

	@IBOutlet weak var profileImageView: UIImageView!
	@IBOutlet weak var backgroundProfileImageView: UIImageView!
	@IBOutlet weak var usernameLabel: UILabel!
	@IBOutlet weak var screennameLabel: UILabel!
	@IBOutlet weak var followingLabel: UILabel!
	@IBOutlet weak var followersLabel: UILabel!
	@IBOutlet weak var tweetsCountLabel: UILabel!
	@IBOutlet weak var page1: UIView!
	@IBOutlet weak var page2: UIView!
	@IBOutlet weak var taglineLabel: UILabel!
	@IBOutlet weak var locationLabel: UILabel!

	@IBOutlet weak var pageControl: UIPageControl!

	var user: User!

	override func viewDidLoad() {
		super.viewDidLoad()

		if user == nil {
			user = User.currentUser
		}

		initLabels()
		initProfileImage()
		initGestures()
	}

	func initLabels() {
		screennameLabel.text = "@" + user.screenname!
		usernameLabel.text = user.name!
		followingLabel.text = String(user.followingCount!)
		followersLabel.text = String(user.followersCount!)
		tweetsCountLabel.text = String(user.tweetsCount!)
		taglineLabel.text = user.tagline!
		locationLabel.text = user.location!
	}

	func initProfileImage() {
		profileImageView.setImageWith((user?.profileUrl)!)
		profileImageView.layer.cornerRadius = 3
		profileImageView.clipsToBounds = true
		backgroundProfileImageView.setImageWith((user?.profileBackgroundUrl)!)
	}

	func initGestures() {
		let swipeGestureRecognizerLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipePage1))
		swipeGestureRecognizerLeft.direction = .left
//		swipeGestureRecognizerLeft.delegate = self
		page1.isUserInteractionEnabled = true
		page1.addGestureRecognizer(swipeGestureRecognizerLeft)

		let swipeGestureRecognizerRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipePage2))
		swipeGestureRecognizerRight.direction = .right
//		swipeGestureRecognizerRight.delegate = self
		page2.isUserInteractionEnabled = true
		page2.addGestureRecognizer(swipeGestureRecognizerRight)
	}

	@IBAction func pageControlValueChanged(_ sender: UIPageControl) {
		NSLog("changed!")
	}

	@IBAction func didSwipePage1(_ sender: UISwipeGestureRecognizer) {
		NSLog("Swiping page 1")
		pageControl.currentPage = 1
		page2.isHidden = false
		page1.isHidden = true
	}

	@IBAction func didSwipePage2(_ sender: UISwipeGestureRecognizer) {
		NSLog("Swiping page 2")
		pageControl.currentPage = 0
		page1.isHidden = false
		page2.isHidden = true
	}


	// MARK: - Tweets

	override func retrieveTweets(maxId: String?) {
		TwitterClient.shared?.userTimeline(
			maxId: maxId,
			screenname: self.user.screenname!,
			success: { (newTweets: [Tweet]) in
				if maxId != nil {
					self.loading = false
					self.loadingMoreView!.stopAnimating()
					self.tweets?.append(contentsOf: newTweets)
				}
				else {
					self.refreshControl.endRefreshing()
					self.tweets = newTweets
				}

				self.tweetsTableView.reloadData()
			},
			failure: { (error: Error) in
				UIHelper.showError(message: "Can't get tweets right now. Please try again later")
				self.refreshControl.endRefreshing()
		})
	}

}
