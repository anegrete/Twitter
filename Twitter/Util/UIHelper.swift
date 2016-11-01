//
//  UIHelper.swift
//  Twitter
//
//  Created by anegrete on 10/30/16.
//  Copyright © 2016 Alejandra Negrete. All rights reserved.
//

import UIKit

enum Color {
	static let blue = UIColor(colorLiteralRed: 29/255, green: 142/255, blue: 238/255, alpha: 1) //1D8EEE
	static let darkGray = UIColor(colorLiteralRed: 101/255, green: 119/255, blue: 134/255, alpha: 1)
	static let lightGray = UIColor(colorLiteralRed: 154/255, green: 169/255, blue: 180/255, alpha: 1)
	static let black = UIColor(colorLiteralRed: 20/255, green: 23/255, blue: 26/255, alpha: 1)
	static let red = UIColor(colorLiteralRed: 223/255, green: 0/255, blue: 62/255, alpha: 1)
	static let green = UIColor(colorLiteralRed: 33/255, green: 195/255, blue: 112/255, alpha: 1)
}

class UIHelper: NSObject {

	class func showError(message: String) {
		let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
		let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
		alertController.addAction(okAction)

		UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
	}

	class func showNoNetwork() {
		let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
		let alertController = UIAlertController(title: "No Network Error", message: "Please check your internet connection", preferredStyle: .alert)
		alertController.addAction(okAction)

		UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
	}
}
