//
//  UIStoryboard.swift
//  Twitter
//
//  Created by anegrete on 11/5/16.
//  Copyright © 2016 Alejandra Negrete. All rights reserved.
//

import UIKit

extension UIStoryboard {

	static func main() -> UIStoryboard {
		return UIStoryboard(name: "Main", bundle: nil)
	}

	static func menu() -> UIStoryboard {
		return UIStoryboard(name: "Menu", bundle: nil)
	}

	static func loginViewController() -> UIViewController {
		return menu().instantiateViewController(withIdentifier: "LoginViewController")
	}

	static func homeViewController() -> UIViewController {
		return main().instantiateViewController(withIdentifier: "HomeNavigationController")
	}

	static func profileViewController() -> UIViewController {
		return main().instantiateViewController(withIdentifier: "ProfileNavigationController")
	}

	static func mentionsViewController() -> UIViewController {
		return main().instantiateViewController(withIdentifier: "MentionsNavigationController")
	}

	static func detailViewController() -> TweetDetailViewController {
		return main().instantiateViewController(withIdentifier: "TweetDetailViewController") as! TweetDetailViewController
	}

	static func menuViewController() -> MenuViewController {
		return menu().instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
	}

	static func hamburgerViewController() -> HamburgerViewController {
		let hamburgerViewController = menu().instantiateViewController(withIdentifier: "HamburgerViewController") as! HamburgerViewController
		let menuViewController = UIStoryboard.menuViewController()
		menuViewController.hamburgerViewController = hamburgerViewController
		hamburgerViewController.menuViewController = menuViewController
		return hamburgerViewController
	}
}
