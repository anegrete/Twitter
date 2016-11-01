//
//  User.swift
//  Twitter
//
//  Created by anegrete on 10/29/16.
//  Copyright © 2016 Alejandra Negrete. All rights reserved.
//

import UIKit

class User: NSObject {

	var name: String?
	var screenname: String?
	var profileUrl: URL?
	var tagline: String?
	var dictionary: NSDictionary?

	init(dictionary: NSDictionary) {
		self.dictionary = dictionary

		name = dictionary["name"] as? String

		let profileUrlString = dictionary["profile_image_url_https"] as? String
		if let profileUrlString = profileUrlString {
			profileUrl = URL(string: profileUrlString)
		}

		tagline = dictionary["description"] as? String
		screenname = dictionary["screen_name"] as? String
	}

	static var _currentUser: User?

	class var currentUser: User? {
		get {
			if _currentUser == nil {

				if let userData = UserDefaultsManager.currentUser()  {
					print(userData)
					let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
					_currentUser = User(dictionary: dictionary)
				}
			}

			return _currentUser
		}

		set(user) {
			_currentUser = user

			var data:Data? = nil
			if let user = user {
				data = try! JSONSerialization.data(withJSONObject: user.dictionary!,
				                                   options: [])
			}

			UserDefaultsManager.saveCurrentUser(data: data)
		}
	}
}
