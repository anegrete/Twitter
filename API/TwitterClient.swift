//
//  TwitterClient.swift
//  Twitter
//
//  Created by anegrete on 10/29/16.
//  Copyright © 2016 Alejandra Negrete. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

enum NotificationName {
	static let userDidLogout  = "UserDidLogout"
	static let userDidTweet = "UserDidTweet"
}

class TwitterClient: BDBOAuth1SessionManager  {

	static let shared = TwitterClient(
		baseURL: URL(string: "https://api.twitter.com")!,
		consumerKey: "oJ10Doq6rXxye8kRV7ppom9XH",
		consumerSecret: "FDCEVDvpvniK5gv5VaynxRZJNBJIzHgbAHbjwr3CUguoVfm8NW")

	var loginSuccess: (() -> ())?
	var loginFailure: ((Error) -> ())?

	// MARK: - Login

	// API Request Token

	func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
		loginSuccess = success
		loginFailure = failure

		deauthorize()
		fetchRequestToken(
			withPath: "oauth/request_token",
			method: "GET",
			callbackURL: URL(string: "twitterapp://oauth"),
			scope: nil,
			success: { (requestToken: BDBOAuth1Credential?) in
				let token = requestToken!.token!
				let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)")
				UIApplication.shared.open(url!, options: [:], completionHandler: nil)

			}, failure: { (error: Error?) in
				print("error: \(error?.localizedDescription)")
				self.loginFailure!(error!)
			}
		)
	}

	// API Access Token

	func handleOpenUrl(url: URL) {
		let requestToken = BDBOAuth1Credential(queryString: url.query)

		fetchAccessToken(
			withPath: "oauth/access_token",
			method: "POST",
			requestToken: requestToken,
			success: { (accessToken: BDBOAuth1Credential?) in
				self.currentAccount(
					success: { (user: User) in
						User.currentUser = user
						self.loginSuccess?()
					},
					failure: { (error: Error?) in
						self.loginFailure!(error!)
					}
				)

		}) { (error:Error?) in
			print("error: \(error?.localizedDescription)")
			self.loginFailure!(error!)
		}
	}

	// MARK: - Logout

	func logout() {
		User.currentUser = nil
		deauthorize()
		postLogoutNotification()
	}

	func postLogoutNotification() {
		NotificationCenter.default.post(
			name: NSNotification.Name(rawValue: NotificationName.userDidLogout),
			object: nil)
	}

	// MARK: - Account

	// API Verify Credentials

	func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
		get("1.1/account/verify_credentials.json",
			parameters: nil,
			progress: nil,
			success: { (task: URLSessionDataTask, response: Any?) in
				let userDictionary = response as! NSDictionary
				let user = User(dictionary: userDictionary)
				success(user)
			},
			failure: { (task: URLSessionDataTask?, error: Error) in
				failure(error)
				print("Error: \(error.localizedDescription)")
		})
	}

	// MARK: - Tweets

	// Timeline

	func homeTimeline(maxId: String, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {

		var parameters:[String:String]? = nil

		if maxId != "" {
			parameters = ["max_id" : maxId]
		}

		get("1.1/statuses/home_timeline.json",
			parameters: parameters,
			progress: nil,
			success: { (task: URLSessionDataTask, response: Any?) in
				let dictionaries = response as! [NSDictionary]
				let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
				success(tweets)
			},
			failure: { (task: URLSessionDataTask?, error: Error) in
				failure(error)
				print("Error: \(error.localizedDescription)")
		})
	}

	// Mentions

	func mentions(maxId: String, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {

		var parameters:[String:String]? = nil

		if maxId != "" {
			parameters = ["max_id" : maxId]
		}

		get("1.1/statuses/mentions_timeline.json",
		    parameters: parameters,
		    progress: nil,
		    success: { (task: URLSessionDataTask, response: Any?) in
				let dictionaries = response as! [NSDictionary]
				let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
				success(tweets)
			},
		    failure: { (task: URLSessionDataTask?, error: Error) in
				failure(error)
				print("Error: \(error.localizedDescription)")
		})
	}

	// Retweet

	func retweet(tweet: Tweet, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
		let retweetUrl = "1.1/statuses/retweet/" + tweet.id_str! + ".json"
		post(retweetUrl,
		     parameters: nil,
		     progress: nil,
		     success: { (task: URLSessionDataTask, response: Any?) in
				print(response)
				let dictionary = response as? NSDictionary
				let tweet = Tweet(dictionary: dictionary!)
				success(tweet)
			},
		     failure: { (task: URLSessionDataTask?, error: Error) in
				print("Error: \(error.localizedDescription)")
				failure(error)
		})
	}

	func deleteRetweet(tweet: Tweet, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
		let retweetUrl = "1.1/statuses/unretweet/" + tweet.id_str! + ".json"
		post(retweetUrl,
		     parameters: nil,
		     progress: nil,
		     success: { (task: URLSessionDataTask, response: Any?) in
				print(response)
				let dictionary = response as? NSDictionary
				let tweet = Tweet(dictionary: dictionary!)
				success(tweet)
			},
		     failure: { (task: URLSessionDataTask?, error: Error) in
				print("Error: \(error.localizedDescription)")
				failure(error)
		})
	}

	// Favorite

	func favorite(tweet: Tweet, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
		let favoriteUrl = "1.1/favorites/create.json?id=" + tweet.id_str!
		post(favoriteUrl,
		     parameters: nil,
		     progress: nil,
		     success: { (task: URLSessionDataTask, response: Any?) in
				print(response)
				let dictionary = response as? NSDictionary
				let tweet = Tweet(dictionary: dictionary!)
				success(tweet)
			},
		     failure: { (task: URLSessionDataTask?, error: Error) in
				print("Error: \(error.localizedDescription)")
				failure(error)
		})
	}

	func unFavorite(tweet: Tweet, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
		let favoriteUrl = "1.1/favorites/destroy.json"
		post(favoriteUrl,
		     parameters: ["id" : tweet.id_str!],
		     progress: nil,
		     success: { (task: URLSessionDataTask, response: Any?) in
				print(response)
				let dictionary = response as? NSDictionary
				let tweet = Tweet(dictionary: dictionary!)
				success(tweet)
			},
		     failure: { (task: URLSessionDataTask?, error: Error) in
				print("Error: \(error.localizedDescription)")
				failure(error)
		})
	}

	// Post a tweet

	func postTweet(params: Any?, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
		let postTweetUrl = "1.1/statuses/update.json"
		post(postTweetUrl,
		     parameters:params,
		     progress: nil,
		     success: { (task: URLSessionDataTask, response: Any?) in
				print(response)
				let dictionary = response as? NSDictionary
				let newTweet = Tweet(dictionary: dictionary!)
				self.postDidTweetNotification(tweet: newTweet)
				success(newTweet)
			},
		     failure: { (task: URLSessionDataTask?, error: Error) in
				failure(error)
				print("Error: \(error.localizedDescription)")
		})
	}


	func compose(text: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
		postTweet(params: ["status" : text], success: success, failure: failure)
	}

	func postDidTweetNotification(tweet: Tweet) {
		let didTweetNotification = NSNotification(name: NSNotification.Name(rawValue: NotificationName.userDidTweet), object: nil, userInfo: ["tweet" : tweet])

		NotificationCenter.default.post(didTweetNotification as Notification)
	}

	// Reply

	func reply(tweet:Tweet, text: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
		postTweet(params: ["status" : text,
			              "in_reply_to_status_id" : tweet.id_str], success: success, failure: failure)
	}
}
