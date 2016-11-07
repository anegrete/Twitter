//
//  ProfileViewController.swift
//  Twitter
//
//  Created by anegrete on 11/5/16.
//  Copyright © 2016 Alejandra Negrete. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class ProfileViewController: UIViewController {

	@IBOutlet weak var profileImageView: UIImageView!
//	@IBOutlet weak var backgroundImageView: UIImageView!
	@IBOutlet weak var usernameLabel: UILabel!
	@IBOutlet weak var screennameLabel: UILabel!
	@IBOutlet weak var followingLabel: UILabel!
	@IBOutlet weak var followersLabel: UILabel!

	var user: User!

	override func viewDidLoad() {
		super.viewDidLoad()

		if user == nil {
			user = User.currentUser
		}

		initLabels()
		initProfileImage()
	}

	func initLabels() {
		screennameLabel.text = "@" + user.screenname!
		usernameLabel.text = user.name!
		followingLabel.text = String(user.followingCount!) + " FOLLOWING"
		followersLabel.text = String(user.followersCount!) + " FOLLOWERS"
	}

	func initProfileImage() {
		profileImageView.setImageWith((user?.profileUrl)!)
		profileImageView.layer.cornerRadius = 3
		profileImageView.clipsToBounds = true
	}
}
