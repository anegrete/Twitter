//
//  Int+Format.swift
//  Twitter
//
//  Created by anegrete on 11/7/16.
//  Copyright © 2016 Alejandra Negrete. All rights reserved.
//

import UIKit

extension Int {

	func longDescription() -> String {
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .decimal
		return numberFormatter.string(from: NSNumber(value: self))!
	}

	func shortDescription() -> String {
		let numberFormatter = NumberFormatter()
		if self > 1 * 1000 * 1000 {
			numberFormatter.positiveFormat = "0M"
			numberFormatter.multiplier = NSNumber(value: 0.000001)
		}
		else if self > 1 * 1000 {
			numberFormatter.positiveFormat = "0K"
			numberFormatter.multiplier = NSNumber(value: 0.0001)
		}
		else {
			numberFormatter.positiveFormat = "0"
			numberFormatter.multiplier = NSNumber(value: 1)
		}

		return numberFormatter.string(from: NSNumber(value: self))!
	}
}
