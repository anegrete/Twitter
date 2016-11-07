//
//  UIStoryboard.swift
//  Twitter
//
//  Created by anegrete on 11/5/16.
//  Copyright © 2016 Alejandra Negrete. All rights reserved.
//

import UIKit

extension UIStoryboard {

	// MARK: - Storyboards

	static func main() -> UIStoryboard {
		return UIStoryboard(name: "Main", bundle: nil)
	}

	static func menu() -> UIStoryboard {
		return UIStoryboard(name: "Menu", bundle: nil)
	}

	// MARK: - View Controllers

	static func loginViewController() -> UIViewController {
		return menu().instantiateViewController(withIdentifier: "LoginViewController")
	}

	static func homeViewController() -> UIViewController {
		return main().instantiateViewController(withIdentifier: "HomeNavigationController")
	}

	static func profileNavigationController() -> UIViewController {
		return main().instantiateViewController(withIdentifier: "ProfileNavigationController")
	}

	static func profileViewController() -> ProfileViewController {
		return main().instantiateViewController(withIdentifier: "ProfileViewController")
			as! ProfileViewController
	}

	static func mentionsViewController() -> UIViewController {
		return main().instantiateViewController(withIdentifier: "MentionsNavigationController")
	}

	static func detailViewController() -> TweetDetailViewController {
		return main().instantiateViewController(withIdentifier: "TweetDetailViewController")
			as! TweetDetailViewController
	}

	static func composeViewController() -> ComposeTweetViewController {
		return main().instantiateViewController(withIdentifier: "ComposeTweetViewController")
			as! ComposeTweetViewController
	}

	static func presentComposeViewControllerWith(tweet: Tweet) {
		let composeTweetViewController = UIStoryboard.composeViewController()
		composeTweetViewController.replyToTweet = tweet
		present(viewController: composeTweetViewController)
	}

	static func showProfileViewControllerWith(user: User) {
		let profileViewController = UIStoryboard.profileViewController()
		profileViewController.user = user
		show(viewController: profileViewController)
	}

	static func showDetailViewControllerWith(tweet: Tweet) {
		let detailViewController = UIStoryboard.detailViewController()
		detailViewController.tweet = tweet
		show(viewController: detailViewController)
	}

	static func menuViewController() -> MenuViewController {
		return menu().instantiateViewController(withIdentifier: "MenuViewController")
			as! MenuViewController
	}

	static func hamburgerViewController() -> HamburgerViewController {
		let hamburgerViewController = menu().instantiateViewController(withIdentifier: "HamburgerViewController")
			as! HamburgerViewController
		let menuViewController = UIStoryboard.menuViewController()
		menuViewController.hamburgerViewController = hamburgerViewController
		hamburgerViewController.menuViewController = menuViewController
		return hamburgerViewController
	}

	// MARK: - Navigation

	static func present(viewController: UIViewController) {
		window().rootViewController?.present(viewController, animated: true, completion: nil)
	}

	static func show(viewController: UIViewController) {
		let hamburgerViewController = window().rootViewController as! HamburgerViewController
		hamburgerViewController.contentViewController.show(viewController, sender: nil)
	}

	static func window() -> UIWindow {
		return (UIApplication.shared.delegate as! AppDelegate).window!
	}

	static func showLogin() {
		window().rootViewController = loginViewController()
	}

	static func showMenu() {
		window().rootViewController = hamburgerViewController()
	}
}
