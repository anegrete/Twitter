//
//  AppDelegate.swift
//  Twitter
//
//  Created by anegrete on 10/28/16.
//  Copyright © 2016 Alejandra Negrete. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

		UIApplication.shared.statusBarStyle = .lightContent

		initialize()

		return true
	}

	func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
		TwitterClient.shared?.handleOpenUrl(url: url)
		return true
	}

	// MARK: - Navigation

	func initialize() {

		if User.currentUser != nil {
			show(viewController: homeViewController())
		}

		self.addLogoutObserver()

		// Init reachability to start monitoring network changes
		self.setupReachability()
	}

	func loginViewController() -> UIViewController {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		return storyboard.instantiateInitialViewController()!
	}

	func homeViewController() -> UIViewController {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		return storyboard.instantiateViewController(withIdentifier: "HomeNavigationController")
	}

	func detailViewController() -> UIViewController {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		return storyboard.instantiateViewController(withIdentifier: "TweetDetailViewController")
	}

	func show(viewController: UIViewController) {
		self.window?.rootViewController = viewController
	}


	// MARK: - Observers

	func addLogoutObserver() {
		NotificationCenter.default.addObserver(
			forName: NSNotification.Name(rawValue: NotificationName.userDidLogout),
			object: nil,
			queue: OperationQueue.main) {
				(notification: Notification) in
				self.show(viewController: self.loginViewController())
		}
	}

	// MARK: - Reachability

	func setupReachability() {

		// Start monitoring reachability status changes
		let reachabilityManager = AFNetworkReachabilityManager.shared()
		reachabilityManager.startMonitoring()
		reachabilityManager.setReachabilityStatusChange { (AFNetworkReachabilityStatus) in

			switch(AFNetworkReachabilityStatus) {

			case .unknown, .notReachable:
				print("Not reachable")
				UIHelper.showNoNetwork()

			case .reachableViaWiFi, .reachableViaWWAN:
				print("Reachable")
			}
		}
	}
}

