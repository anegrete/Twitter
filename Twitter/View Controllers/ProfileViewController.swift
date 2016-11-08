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
	@IBOutlet weak var taglineLabel: UILabel!
	@IBOutlet weak var locationLabel: UILabel!

	@IBOutlet weak var backgroundContainerView: UIView!
	@IBOutlet weak var topSpaceConstraint: NSLayoutConstraint!
	@IBOutlet weak var bottomSpaceConstraint: NSLayoutConstraint!


	var user: User!

	// MARK: - View Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		if user == nil {
			user = User.currentUser
		}

		initLabels()
		initProfileImage()
		self.automaticallyAdjustsScrollViewInsets = false
		tweetsTableView.contentInset = UIEdgeInsets.init(top: 20, left: 0, bottom: 0, right: 0);
	}

	override var prefersStatusBarHidden: Bool {
		return true
	}

	// MARK: - Initializations

	override func customizeNavigationBar() {
		UIHelper.transparentNavigationBarFor(viewController: self)
	}

	func initLabels() {
		screennameLabel.text = "@" + user.screenname!
		usernameLabel.text = user.name!
		followingLabel.text = user.followingCount!.longDescription()
		followersLabel.text = user.followersCount!.longDescription()
		tweetsCountLabel.text = user.tweetsCount!.longDescription()
		taglineLabel.text = user.tagline!
		locationLabel.text = user.location!
	}

	func initProfileImage() {
		profileImageView.setImageWith((user?.profileUrl)!)
		profileImageView.layer.cornerRadius = 4
		profileImageView.layer.borderColor = UIColor.white.cgColor
		profileImageView.layer.borderWidth = 3
		profileImageView.clipsToBounds = true

		backgroundProfileImageView.setImageWith((user?.profileBackgroundUrl)!)
	}

	// MARK: - Tweets

	override func retrieveTweets(maxId: String?) {

		if user == nil {
			user = User.currentUser
		}

		TwitterClient.shared?.userTimeline(
			maxId: maxId,
			screenname: user.screenname!,
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


	// MARK: - UIScrollViewDelegate

	override func scrollViewDidScroll(_ scrollView: UIScrollView) {

		if scrollView.contentOffset.y >= 0 {
			// scrolling down
			backgroundContainerView.clipsToBounds = true
			bottomSpaceConstraint?.constant = -scrollView.contentOffset.y / 2
			topSpaceConstraint?.constant = scrollView.contentOffset.y / 2

			let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
			let blurEffectView = UIVisualEffectView(effect: blurEffect)
			blurEffectView.frame = view.bounds
			blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
			profileImageView.addSubview(blurEffectView)
		}
		else {
			// scrolling up
			topSpaceConstraint?.constant = scrollView.contentOffset.y
			backgroundContainerView.clipsToBounds = false
		}
	}
}

