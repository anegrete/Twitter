//
//  Tweet.swift
//  Twitter
//
//  Created by anegrete on 10/29/16.
//  Copyright © 2016 Alejandra Negrete. All rights reserved.
//

import UIKit

class Tweet: NSObject {

	var id_str: String?
	var text: String?
	var timestamp: Date?
	var retweetCount: Int = 0
	var favoriteCount: Int = 0
	var isFavorited = false
	var isRetweeted = false
	var user: User?
	var mediaUrl: URL?
	var retweetedStatus: Tweet?

	init(dictionary:NSDictionary) {
		id_str = dictionary["id_str"] as? String
		text = dictionary["text"] as? String
		retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
		favoriteCount = (dictionary["favorite_count"] as? Int) ?? 0

		if let timestampString = dictionary["created_at"] as? String {
			timestamp = Date.dateFrom(string: timestampString)
		}

		isFavorited = (dictionary["favorited"] as? Bool)!
		isRetweeted = (dictionary["retweeted"] as? Bool)!
		user = User(dictionary: (dictionary["user"] as? NSDictionary)!)

		if let extendedEntities = dictionary["extended_entities"] as? NSDictionary,
			let mediaList = extendedEntities["media"] as? [NSDictionary] {
			mediaUrl = URL(string: mediaList[0]["media_url"] as! String)
		}

		if let retweetDictionary = dictionary["retweeted_status"] as? NSDictionary {
			retweetedStatus = Tweet(dictionary: retweetDictionary)
		}
		print(dictionary)
	}

	class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
		var tweets = [Tweet]()

		for dictionary in dictionaries {
			let tweet = Tweet(dictionary: dictionary)
			tweets.append(tweet)
		}

		return tweets
	}
}
