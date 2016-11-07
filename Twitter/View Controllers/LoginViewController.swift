//
//  LoginViewController.swift
//  Twitter
//
//  Created by anegrete on 10/28/16.
//  Copyright © 2016 Alejandra Negrete. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

	// MARK: UI Actions

	@IBAction func didTapLoginButton(_ sender: UIButton) {
		TwitterClient.shared?.login(
			success: {
				UIStoryboard.showMenu()
			},
			failure: { (error: Error) in
				UIHelper.showError(message: "Can't sign in right now. Please try again later")
		})
	}
}
