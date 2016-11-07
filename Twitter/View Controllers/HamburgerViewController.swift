//
//  HamburgerViewController.swift
//  Twitter
//
//  Created by anegrete on 11/5/16.
//  Copyright © 2016 Alejandra Negrete. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

	// Views

	@IBOutlet weak var menuView: UIView!
	@IBOutlet weak var contentView: UIView!

	// Constraints

	@IBOutlet weak var contentViewLeadingConstraint: NSLayoutConstraint!
	var originalContentViewLeadingConstant: CGFloat!

	var panGestureRecognizer: UIPanGestureRecognizer!

	// View Controllers

	var menuViewController: MenuViewController! {
		didSet(oldMenuViewController) {
			view.layoutIfNeeded()

			if oldMenuViewController != nil {
				oldMenuViewController.willMove(toParentViewController: nil)
				oldMenuViewController.view.removeFromSuperview()
				oldMenuViewController.didMove(toParentViewController: nil)
			}

			menuViewController.willMove(toParentViewController: self)
			menuView.addSubview(menuViewController.view)
			menuViewController.didMove(toParentViewController: self)
		}
	}

	var contentViewController: UIViewController! {
		didSet(oldContentViewController) {
			view.layoutIfNeeded()

			if oldContentViewController != nil {
				oldContentViewController.willMove(toParentViewController: nil)
				oldContentViewController.view.removeFromSuperview()
				oldContentViewController.didMove(toParentViewController: nil)
			}

			addMenuButton()
			addComposeButton()

			contentViewController.willMove(toParentViewController: self)
			contentView.addSubview(contentViewController.view)

			addPanGesture()

			contentViewController.didMove(toParentViewController: self)
			UIView.animate(withDuration: 0.2) {
				self.contentViewLeadingConstraint.constant = 0
				self.view.layoutIfNeeded()
			}
		}
	}

	func addPanGesture() {
		panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onPanGesture))
		contentView.isUserInteractionEnabled = true
//		panGestureRecognizer.delegate = self
		contentView.addGestureRecognizer(panGestureRecognizer)
	}

	func removePanGesture() {
		self.contentView.removeGestureRecognizer(panGestureRecognizer)
	}

	// MARK: - Menu button

	func addMenuButton() {
		let topViewController = (contentViewController as! UINavigationController).topViewController
		topViewController?.navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: UIImage(named: "Menu-icon"), style: .plain,
			target: self, action: #selector(didTapMenuButton))
		topViewController?.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
	}

	func didTapMenuButton() {
		showMenu(show: menuIsHidden())
	}

	func addComposeButton() {
		let topViewController = (contentViewController as! UINavigationController).topViewController
		topViewController?.navigationItem.rightBarButtonItem =
			UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.compose, target: self, action: #selector(didTapComposeButton))
		topViewController?.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
	}

	func didTapComposeButton() {
		UIStoryboard.presentComposeViewControllerWith(tweet: nil)
	}

	// MARK: - Gestures

	@IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {

		let translation = sender.translation(in: view)
		let velocity = sender.velocity(in: view)

		switch(sender.state) {

		case .began:
			originalContentViewLeadingConstant = contentViewLeadingConstraint.constant

		case .changed:
			contentViewLeadingConstraint.constant = originalContentViewLeadingConstant + translation.x
		case .ended:
			self.showMenu(show: velocity.x > 0)

		default:
			break
		}
	}

	// MARK: - Utils

	func menuIsHidden() -> Bool {
		return self.contentViewLeadingConstraint.constant == 0
	}

	func showMenu(show: Bool) {
		UIView.animate(withDuration: 0.3, animations: {
			self.contentViewLeadingConstraint.constant = show ? self.view.frame.size.width - 65 : 0
			self.view.layoutIfNeeded()
		})
	}
}
