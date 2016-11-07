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
	var profileBackgroundUrl: URL?
	var tagline: String?
	var dictionary: NSDictionary?
	var followingCount: Int?
	var followersCount: Int?
	var location: String?
	var tweetsCount: Int?

	init(dictionary: NSDictionary) {
		self.dictionary = dictionary
		print(dictionary)
		name = dictionary["name"] as? String

		let profileUrlString = dictionary["profile_image_url_https"] as? String
		if let profileUrlString = profileUrlString {
			profileUrl = URL(string: profileUrlString)
		}

		let profileBackgroundUrlString = dictionary["profile_background_image_url_https"] as? String
		if let profileBackgroundUrlString = profileBackgroundUrlString {
			profileBackgroundUrl = URL(string: profileBackgroundUrlString)
		}

		tagline = dictionary["description"] as? String
		screenname = dictionary["screen_name"] as? String
		followingCount = dictionary["friends_count"] as? Int
		followersCount = dictionary["followers_count"] as? Int
		tweetsCount = dictionary["statuses_count"] as? Int
		location = dictionary["location"] as? String
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
