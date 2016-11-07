//
//  MenuViewController.swift
//  Twitter
//
//  Created by anegrete on 11/5/16.
//  Copyright © 2016 Alejandra Negrete. All rights reserved.
//

import UIKit

enum Items {
	static let home		= "Home Timeline"
	static let profile	= "Profile"
	static let mentions = "Mentions"
	static let logout	= "Logout"
}

class MenuViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var profileImageView: UIImageView!
	@IBOutlet weak var usernameLabel: UILabel!
	@IBOutlet weak var screennameLabel: UILabel!

	var homeTimelineNavigationController : UIViewController!
	var profileNavigationController: UIViewController!
	var mentionsNavigationController: UIViewController!
	var viewControllers: [UIViewController] = []
	var hamburgerViewController: HamburgerViewController!

	let options = [Items.home, Items.profile, Items.mentions, Items.logout]
	let optionsImage = ["Menu-home", "Menu-profile", "Menu-mentions", "Menu-logout"]

	// MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

		initViewControllers()
		initProfile()
    }

	func initViewControllers() {
		homeTimelineNavigationController = UIStoryboard.homeViewController()
		profileNavigationController = UIStoryboard.profileViewController()
		mentionsNavigationController = UIStoryboard.mentionsViewController()

		viewControllers.append(homeTimelineNavigationController)
		viewControllers.append(profileNavigationController)
		viewControllers.append(mentionsNavigationController)

		hamburgerViewController.contentViewController = homeTimelineNavigationController
	}

	// MARK: - UI Updates

	func initProfile() {
		let user = User.currentUser

		profileImageView.layer.cornerRadius = 3
		profileImageView.clipsToBounds = true
		profileImageView.setImageWith((user?.profileUrl)!	)

		usernameLabel.text = user?.name
		screennameLabel.text = "@" + (user?.screenname)!
	}
}

// MARK: - UITableViewDataSource

extension MenuViewController : UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return options.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuTableViewCell
		cell.menuOptionLabel.text = options[indexPath.row]
		cell.menuOptionImageView.image = UIImage(named: optionsImage[indexPath.row])

		return cell
	}
}

// MARK: - UITableViewDelegate

extension MenuViewController : UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		if indexPath.row == options.index(of: Items.logout) {
			TwitterClient.shared?.logout()
			return
		}

		hamburgerViewController.contentViewController = viewControllers[indexPath.row]
	}
}
