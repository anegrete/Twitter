//
//  MentionsViewController.swift
//  Twitter
//
//  Created by anegrete on 11/5/16.
//  Copyright © 2016 Alejandra Negrete. All rights reserved.
//

import UIKit

class MentionsViewController: TweetsViewController {

	// MARK: - Tweets

	override func retrieveTweets(maxId: String) {
		TwitterClient.shared?.mentions(
			maxId: maxId,
			success: { (newTweets: [Tweet]) in
				if maxId != "" {
					self.loading = false
					self.loadingMoreView!.stopAnimating()

					for tweet in newTweets {
						if !(self.tweets?.contains(where: { tweetId in tweet.id_str == tweet.id_str }))! {
							self.tweets?.append(tweet)
						}
					}
				}
				else {
					self.refreshControl.endRefreshing()
					self.tweets = newTweets
				}

				self.tweetsTableView.reloadData()
			},
			failure: { (error: Error) in
				UIHelper.showError(message: "Can't get tweets right now. Please try again later")
				self.refreshControl.endRefreshing()
		})
	}
}
