//
//  Date.swift
//  Twitter
//
//  Created by anegrete on 10/30/16.
//  Copyright © 2016 Alejandra Negrete. All rights reserved.
//

import UIKit

extension Date {

	static func dateFrom(string: String) -> Date {
		let formatter = DateFormatter()
		formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
		return formatter.date(from: string)!
	}

	static func shortDescription(date: Date) -> String {

		let componentsList:Set<Calendar.Component> =
			[Calendar.Component.year,
			 Calendar.Component.month,
			 Calendar.Component.weekOfYear,
			 Calendar.Component.hour,
			 Calendar.Component.minute,
			 Calendar.Component.second]

		let dateComponents = Calendar.current.dateComponents(componentsList, from: date, to: Date())

		let years = dateComponents.year!
		let months = dateComponents.month!
		let weeks = dateComponents.weekOfYear!
		let hours = dateComponents.hour!
		let minutes = dateComponents.minute!
		let seconds = dateComponents.second!

		if years > 0 {
			return "\(years)y"
		}
		if months > 0 {
			return "\(months)m"
		}
		if weeks > 0 {
			return "\(weeks)w"
		}
		if hours > 0 {
			return "\(hours)h"
		}
		if minutes > 0 {
			return "\(minutes)m"
		}
		if seconds > 0 {
			return "\(seconds)s"
		}

		return ""
	}

	static func longDescription(date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "MM/dd/yy, HH:mm"
		return formatter.string(from: date)
	}
}
