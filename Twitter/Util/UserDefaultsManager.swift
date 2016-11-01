//
//  UserDefaultsManager.swift
//  Twitter
//
//  Created by anegrete on 10/30/16.
//  Copyright © 2016 Alejandra Negrete. All rights reserved.
//

import UIKit

enum Defaults {
	static let currentUser = "currentUser"
	static let draft = "draft"
}

class UserDefaultsManager: NSObject {

	// MARK: - Current User

	class func currentUser() -> Data? {
		let defaults = UserDefaults.standard
		return defaults.object(forKey: Defaults.currentUser) as? Data
	}

	class func saveCurrentUser(data: Data?) {
		let defaults = UserDefaults.standard

		if let newData = data {
			defaults.set(newData, forKey: Defaults.currentUser)
			defaults.synchronize()
		}
		else {
			defaults.removeObject(forKey: Defaults.currentUser)
		}
	}

	// MARK: - Draft

	class func draft() -> String? {
		let defaults = UserDefaults.standard
		return defaults.object(forKey: Defaults.draft) as? String
	}

	class func saveDraft(draft: String?) {
		let defaults = UserDefaults.standard
		defaults.set(draft, forKey: Defaults.draft)
		defaults.synchronize()
	}
}
